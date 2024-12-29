import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/notes/view.dart';

class AddNote extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const AddNote({super.key, required this.categoryId, required this.categoryName});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController noteTitle = TextEditingController();
  bool isloaded = false;

  GlobalKey<FormState> formstate = GlobalKey();

  Future<void> addCategory() async {
    CollectionReference category =
    FirebaseFirestore.instance.collection("category").doc(widget.categoryId).collection("notes");
    if (formstate.currentState!.validate()) {
      try {
        isloaded = true;
        DocumentReference response = await category.add({
          "note title" : noteTitle.text,
        });
        print("new category added");
        isloaded = false;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => categoryView(
              categoryId: widget.categoryId,
              categoryName: widget.categoryName,
            )));
      } catch (e) {
        print("error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add note"),
      ),
      body: isloaded
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
            children: [
              Container(
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: formstate,
                    child: TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "required";
                        }
                      },
                      maxLines: 1000,
                      minLines: 1,
                      controller: noteTitle,
                      decoration: InputDecoration(
                        labelText: "note",
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))
                      ),
                    )),
                SizedBox(height: 24,),
                MaterialButton(
                  onPressed: () {
                    addCategory();
                  },
                  child: Text("Add"),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                )
              ],
                      ),
                    ),
            ],
          ),
    );
  }
}
