import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'categories/editcategory.dart';
import 'notes/view.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];

  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("category")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
              //GoogleSignIn googleSignIn = GoogleSignIn();
              //googleSignIn.disconnect();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (routes) => false);
            },
            icon: Icon(Icons.logout),
          )
        ],
        title: Text("Notes"),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => categoryView(
                              categoryId: data[i].id,
                              categoryName: data[i]["category name"],
                            )));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: data[i]["category name"],
                      desc: 'what do you want to do for this category?',
                      btnOkText: "update name",
                      btnOkOnPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditCategory(
                                  docid: data[i].id,
                                  oldname: data[i]["category name"],
                                )));
                      },
                      btnCancelText: "delete",
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection("category")
                            .doc(data[i].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("homepage");
                        print("category deleted");
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("images/folder3.png"),
                          Text("${data[i]["category name"]}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Image.asset("images/addcategory.png",height: 40,width: 40,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
