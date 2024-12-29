import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/notes/view.dart';

class EditNote extends StatefulWidget {
  final String categoryId;
  final String noteId;
  final String categoryName;
  final String note;
  const EditNote(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.noteId,
      required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController noteTitle = TextEditingController();
  bool isloaded = false;

  GlobalKey<FormState> formstate = GlobalKey();

  Future<void> editNote() async {
    CollectionReference category =
        FirebaseFirestore.instance.collection("category");
    if (formstate.currentState!.validate()) {
      try {
        isloaded = true;
        await category
            .doc(widget.categoryId)
            .collection("notes")
            .doc(widget.noteId)
            .update({"note title": noteTitle.text});
        print("note edited");
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
  void initState() {
    noteTitle.text = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit note"),
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
                            minLines: 1,
                            maxLines: 20,
                            controller: noteTitle,
                            decoration: InputDecoration(
                              labelText: "note",
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))

                            ),
                          )),
                      MaterialButton(
                        onPressed: () {
                          editNote();
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
