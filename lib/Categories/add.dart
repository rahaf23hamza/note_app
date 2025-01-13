import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Categories/Formfieldforadd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> Formstate = GlobalKey();
  CollectionReference Categories =
      FirebaseFirestore.instance.collection('Categories');
  AddCategory() async {
    if (Formstate.currentState!.validate()) {
      try {
        isLoading == true;
        setState(() {});
        DocumentReference response = await Categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } catch (e) {
        isLoading = false;
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Erorr',
          desc: 'please Enter name',
          btnCancelOnPress: () {},
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Category",
          style: TextStyle(fontSize: 20.5),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: Formstate,
              child: Container(
                color: Colors.blue[200],
                child: Column(
                  children: [
                    FormAddfield(
                      textfield: "Add",
                      hinttext: "Enter Name",
                      iconfield: Icon(
                        Icons.note,
                        color: Colors.blue[200],
                      ),
                      MyController: name,
                      validator: (String? val) {
                        if (val == "") {
                          return "Can't to be empty";
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        width: 100,
                        child: MaterialButton(
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            AddCategory();
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.blue[200],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
