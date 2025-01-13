import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Categories/Formfieldforadd.dart';
import 'package:note_app/note/view.dart';

class Addnote extends StatefulWidget {
  final String docid;
  const Addnote({super.key, required this.docid});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  bool isLoading = false;
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> Formstate = GlobalKey();

  Addnote() async {
    CollectionReference Categories =
    FirebaseFirestore.instance.collection('Categories').doc(widget.docid).collection("note");
    if (Formstate.currentState!.validate()) {
      try {
        isLoading == true;
        setState(() {});
        DocumentReference response = await Categories.add({"note":note.text});
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(Categoryid: widget.docid)));
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
          "Add Note",
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
                hinttext: "Enter your note",
                iconfield: Icon(
                  Icons.note,
                  color: Colors.blue[200],
                ),
                MyController: note,
                validator: (String? val) {
                  if (val == "") {
                    return "Can't to be empty";
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  width: 120,
                  child: MaterialButton(
                    color: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70)),
                    onPressed: () {
                      Addnote();
                    },
                    child: Text(
                      "Add Your Note",
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
