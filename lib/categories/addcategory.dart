import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  bool isloaded = false;

  GlobalKey<FormState> formstate = GlobalKey();

  CollectionReference category =
      FirebaseFirestore.instance.collection("category");

  Future<void> addCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isloaded = true;
        DocumentReference response = await category.add({
          "category name": name.text,
          "id": FirebaseAuth.instance.currentUser!.uid
        });
        print("new category added");
        isloaded = false;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (routes) => false);
      } catch (e) {
        print("error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add category"),
      ),
      body: isloaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
    );
  }
}
