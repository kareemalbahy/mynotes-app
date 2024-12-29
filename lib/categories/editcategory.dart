import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;

  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController name = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey();

  CollectionReference category =
      FirebaseFirestore.instance.collection("category");

  Future<void> editCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        setState(() {});
        await category.doc(widget.docid).update({"category name": name.text});
        print("category updated");
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (routes) => false);
        setState(() {});
      } catch (e) {
        print("error: $e");
      }
    }
  }

  Future<void> setCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        setState(() {});
        await category.doc("12345").set({"category name": name.text});
        print("category updated");
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (routes) => false);
        setState(() {});
      } catch (e) {
        print("error: $e");
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
        title: Text("Add category"),
      ),
      body: Container(
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
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "category name",
                    prefixIcon: Icon(Icons.folder),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                )),
            MaterialButton(
              onPressed: () {
                editCategory();
              },
              child: Text("edit"),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
            MaterialButton(
              onPressed: () {
                setCategory();
              },
              child: Text("set"),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            )
          ],
        ),
      ),
    );
  }
}
