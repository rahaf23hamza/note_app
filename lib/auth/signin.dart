import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/component/formfield.dart';
import 'package:note_app/auth/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> Formstate = GlobalKey();
  bool issecurity = true;

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to sign in with Google: $e',
        btnCancelOnPress: () {},
      ).show();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: Formstate,
              child: Container(
                color: Colors.blue[300],
                child: ListView(
                  children: [
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
                        "Signin",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 30.5,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        "Signin To Continue Using The App",
                        style:
                            TextStyle(color: Colors.blue[900], fontSize: 12.5),
                      ),
                    ),
                    FormofField(
                      textfield: "Email",
                      hinttext: "Enter Your Email",
                      iconfield: Icon(
                        Icons.email,
                        color: Colors.blue[900],
                      ),
                      MyController: email,
                      validator: (String? val) {
                        if (val == "") {
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
                            if (val == "") {
                              return "Can't to be empty";
                            }
                          },
                          obscureText: issecurity,
                          decoration: InputDecoration(
                            fillColor: Colors.blue[200],
                            filled: true,
                            hintText: "Enter Your Password",
                            hintStyle: TextStyle(
                                color: Colors.blue[900], fontSize: 15.5),
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
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          isloading = true;
                          setState(() {});
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);
                          isloading = false;
                          setState(() {});
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'Sucess',
                            desc: '',
                            btnOkOnPress: () {},
                          )..show();
                        } catch (e) {
                          if (email.text == "") {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Erorr',
                              desc: 'please enter your email',
                              btnCancelOnPress: () {},
                            )..show();
                            return;
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Erorr',
                              desc: '$e',
                              btnCancelOnPress: () {},
                            )..show();
                            return;
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          textAlign: TextAlign.end,
                          "Forget Password?",
                          style: TextStyle(
                              fontSize: 16.2,
                              color: Colors.blue[200],
                              fontWeight: FontWeight.bold),
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
                              borderRadius: BorderRadius.circular(30)),
                         onPressed: ()async{
                           if (Formstate.currentState!.validate()) {
                             setState(() {
                               isloading = true; // ابدأ التحميل
                             });
                             try {
                               final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                 email: email.text,
                                 password: password.text,
                               );

                               setState(() {
                                 isloading = false; // أوقف التحميل
                               });

                               if (credential.user!.emailVerified) {
                                 Navigator.of(context).pushReplacementNamed("home");
                               } else {
                                 AwesomeDialog(
                                   context: context,
                                   dialogType: DialogType.error,
                                   animType: AnimType.rightSlide,
                                   title: 'Error',
                                   desc: 'Please verify your email',
                                   btnCancelOnPress: () {},
                                 ).show();
                               }
                             } on FirebaseAuthException catch (e) {
                               setState(() {
                                 isloading = false; // أوقف التحميل
                               });
                               String errorMessage;
                               if (e.code == 'user-not-found') {
                                 errorMessage = 'No user found for that email.';
                               } else if (e.code == 'wrong-password') {
                                 errorMessage = 'Wrong password provided for that user.';
                               } else {
                                 errorMessage = e.message ?? 'An error occurred. Please try again.';
                               }
                               AwesomeDialog(
                                 context: context,
                                 dialogType: DialogType.error,
                                 animType: AnimType.rightSlide,
                                 title: 'Error',
                                 desc: errorMessage,
                                 btnCancelOnPress: () {},
                               ).show();
                             }
                           }
                         },
                          child: Text(
                            "SignIn",
                            style: TextStyle(color: Colors.blue[200]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        child: MaterialButton(
                          color: Colors.red[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {
                            signInWithGoogle();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "SignIn  With Google  ",
                                style: TextStyle(color: Colors.blue[200]),
                              ),
                              Image.asset(
                                "images/google.png",
                                width: 25,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed("Signup");
                        },
                        child: Text.rich(TextSpan(
                          children: [
                            TextSpan(
                                text: "Don't Have An Account?  ",
                                style: TextStyle(
                                    color: Colors.blue[200], fontSize: 15.2)),
                            TextSpan(
                                text: "Register",
                                style: TextStyle(
                                    color: Colors.red[400], fontSize: 15.2))
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
