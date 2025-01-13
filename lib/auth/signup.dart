import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/component/formfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController user = TextEditingController();
  GlobalKey<FormState> Formstate = GlobalKey();
  bool issecurity = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: Formstate,
      child: Container(
          color: Colors.blue[300],
          child: ListView(children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(70),
                    ),
                    height: 70,
                    width: 70,
                    child: Image.asset("images/note.png"),
                  ),
                ),
                Text(
                  "Note App",
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 30.5,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18.0),
              child: Text(
                "SignUp",
                style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 30.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "SignUp To Continue Using The App",
                style: TextStyle(color: Colors.blue[900], fontSize: 12.5),
              ),
            ),
            FormofField(
              textfield: "Username",
              hinttext: " Enter your username",
              iconfield: Icon(
                Icons.person,
                color: Colors.blue[900],
              ),
              MyController: user,
              validator: (String? val) {
                if (val=="") {
                  return "Can't to be empty";
                }
              },
            ),
            FormofField(
              textfield: "Email",
              hinttext: " Enter your email",
              iconfield: Icon(
                Icons.email,
                color: Colors.blue[900],
              ),
              MyController: email,
              validator: (String? val) {
                if (val=="") {
                  return "Can't to be empty";
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18.0),
              child: Text(
                "Password",
                style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 25.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(right: 18, left: 18),
                child: TextFormField(
                  controller: password,
                  validator: (val) {
                    if (val=="") {
                      return "Can't to be empty";
                    }
                  },
                  obscureText: issecurity,
                  decoration: InputDecoration(
                    fillColor: Colors.blue[200],
                    filled: true,
                    hintText: "Enter Your Password",
                    hintStyle:
                        TextStyle(color: Colors.blue[900], fontSize: 15.5),
                    prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            issecurity = !issecurity;
                          });
                        },
                        icon: issecurity
                            ? Icon(
                                Icons.visibility,
                                color: Colors.blue[900],
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: Colors.blue[900],
                              )),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 40,
                child: MaterialButton(
                  color: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),////SignIn Function
                  onPressed: () async {
                    if (Formstate.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        Navigator.of(context).pushReplacementNamed("Signin");
                        FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Erorr',
                            desc: 'The password provided is too weak.',
                            btnCancelOnPress: () {},

                          )..show();
                        } else if (e.code == 'email-already-in-use') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Erorr',
                            desc: 'The account already exists for that email.',
                            btnCancelOnPress: () {},

                          )..show();
                        }
                      } catch (e) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: "$e",
                          btnCancelOnPress: () {},

                        )..show();
                      }
                    }
                  },
                  child: Text(
                    "SignUp",
                    style: TextStyle(color: Colors.blue[200]),
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("Signin");
                },
                child: Text.rich(TextSpan(
                  children: [
                    TextSpan(
                        text: "Have An Account?  ",
                        style:
                            TextStyle(color: Colors.blue[200], fontSize: 15.2)),
                    TextSpan(
                        text: "SignIn",
                        style:
                            TextStyle(color: Colors.red[400], fontSize: 15.2))
                  ],
                )),
              ),
            ),
          ])),
    ));
  }
}
