import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/Categories/update.dart';
import 'package:note_app/auth/signin.dart';
import 'package:note_app/note/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  bool isLoading = true;
  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
    isLoading = false;
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          Navigator.of(context).pushNamed("AddCategory");
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
      body: Container(
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(Categoryid: data[index].id)));
                },
                onLongPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.rightSlide,
                    title: 'Edit',
                    desc: 'Do you want to edit the note?',
                    btnOkOnPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditCategory(
                              docid: data[index].id,
                              oldname: data[index]["name"])));
                    },
                  )..show();
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
                          "Note",
                          style: TextStyle(
                              color: Colors.black, fontSize: 20.5),
                        ),
                        subtitle: Text(
                          "${data[index]["name"]}",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("Categories")
                                  .doc(data[index].id)
                                  .delete();
                              Navigator.of(context)
                                  .pushReplacementNamed("home");
                            },
                            icon: Icon(Icons.delete)),
                      )
                    ]),
                  ),
                ),
              );
            },
          )),
    );
  }
}
