import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:note_app/Categories/Formfieldforadd.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> Formstate = GlobalKey();
  CollectionReference Categories =
      FirebaseFirestore.instance.collection('Categories');
  EditCategory() async {
    if (Formstate.currentState!.validate()) {
      try {
        isLoading == true;
        setState(() {});
        await Categories.doc(widget.docid).set({"name": name.text,"id":FirebaseAuth.instance.currentUser!.uid},SetOptions(merge:true));
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
  void initState() {
    name.text = widget.oldname;
    super.initState();
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
                            EditCategory();
                          },
                          child: Text(
                            "Save",
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
