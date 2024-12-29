import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'addNote.dart';
import 'editeNote.dart';

class categoryView extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const categoryView(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<categoryView> createState() => _categoryViewState();
}

class _categoryViewState extends State<categoryView> {
  List<QueryDocumentSnapshot> data = [];

  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("category")
        .doc(widget.categoryId)
        .collection("notes")
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (routes) => false);
            },
            icon: Icon(Icons.logout),
          )
        ],
        title: Text(widget.categoryName),
      ),
      body: WillPopScope(
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNote(
                                  categoryId: widget.categoryId,
                                  categoryName: widget.categoryName,
                                  noteId: data[i].id,
                                  note: data[i]["note title"],
                                )));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.rightSlide,
                          title: 'delete?',
                          desc: 'do you really wanna delete this note ?',
                          btnOkText: "delete",
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("category")
                                .doc(widget.categoryId)
                                .collection("notes")
                                .doc(data[i].id)
                                .delete();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => categoryView(
                                      categoryId: widget.categoryId,
                                      categoryName: widget.categoryName,
                                    )));
                            print("note deleted");
                          },
                          btnCancelOnPress: () async {},
                        ).show();
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Center(child: Text("${data[i]["note title"]}",overflow: TextOverflow.ellipsis,)),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                ),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("homepage", (routes) => false);
            return Future.value(false);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(
                    categoryId: widget.categoryId,
                    categoryName: widget.categoryName,
                  )));
        },
        child: Image.asset("images/addnote.png"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
