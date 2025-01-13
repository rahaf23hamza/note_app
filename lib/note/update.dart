import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Categories/Formfieldforadd.dart';
import 'package:note_app/note/view.dart';

class Editnote extends StatefulWidget {
  final  String categorydocid;
  final  String noteid;
  final  String oldnote;
  const Editnote({super.key, required this.categorydocid, required this.noteid, required this.oldnote});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  bool isLoading = false;
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> Formstate = GlobalKey();

  EditNote() async {
    CollectionReference Categories =
    FirebaseFirestore.instance.collection('Categories').doc(widget.categorydocid).collection("note");

    if (Formstate.currentState!.validate()) {
      try {
        isLoading == true;
        setState(() {});
       await Categories.doc(widget.noteid).update(
            {"note": note.text});
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(Categoryid: widget.categorydocid)));
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
   note.text=widget.oldnote;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Note",
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
                textfield: "Edit",
                hinttext: "Enter NewNote",
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
                  width: 100,
                  child: MaterialButton(
                    color: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () {
                      EditNote();
                    },
                    child: Text(
                      "Update",
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
