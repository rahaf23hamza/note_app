import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/Categories/update.dart';
import 'package:note_app/note/add.dart';
import 'package:note_app/note/update.dart';


class ViewNote extends StatefulWidget {
  final String Categoryid;
  const ViewNote({super.key, required this.Categoryid});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List data = [];
  bool isLoading = true;
  noteview() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Categories").doc(widget.Categoryid).collection("note").get();
    data.addAll(querySnapshot.docs);
    setState(() {});
    isLoading = false;
  }

  @override
  void initState() {
    noteview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Addnote(docid: widget.Categoryid)));
        },
        child: Icon(
          Icons.add,
          color: Colors.blue[200],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Note App",
          style: TextStyle(
            color: Colors.blue[200],
            fontSize: 20.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("Signin", (route) => false);
            },
            icon: Icon(Icons.logout),
            color: Colors.blue[200],
          )
        ],
        backgroundColor: Colors.blue[900],
      ),
      body: PopScope(child:  Container(
         color: Colors.blue[200],
         child: isLoading == true
             ? Center(
           child: CircularProgressIndicator(),
         )
             : ListView.builder(
           itemCount: data.length,
           itemBuilder: (context, index) {
             return InkWell(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Editnote(categorydocid: widget.Categoryid,
                     noteid: data[index].id,
                     oldnote: data[index]["note"])));
               },
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   height: 200,
                   width: 350,
                   decoration: BoxDecoration(
                     color: Colors.blue[500],
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Column(children: [
                     ListTile(
                       title: Text(
                         "${data[index]["note"]}",
                         style: TextStyle(color: Colors.black),
                       ),
                       trailing: IconButton(
                           onPressed: () async {
                             await FirebaseFirestore.instance.collection("Categories").doc(widget.Categoryid).collection("note").doc(data[index].id).delete();
                             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(Categoryid: widget.Categoryid)));
                           },
                           icon: Icon(Icons.delete)),
                     )
                   ]),
                 ),
               ),
             );
           },
         )),
    ));
  }
}
