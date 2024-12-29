import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/Widgets/CustomAuthButton.dart';
import 'package:mynotes/Widgets/CustomTextFields.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Widgets/PaswordTextField.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Form(
          key: formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),

              //app icon
              Container(
                height: 300,
                child: Image.asset("images/note.png"),
              ),

              SizedBox(height: 16),

              //signup word
              Text(
                "signup",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),

              //username
              Customtextfields(
                textController: username,
                label: "username",
                icon: Icon(Icons.person),
              ),

              SizedBox(height: 16),

              //email address
              Customtextfields(
                textController: email,
                label: "emall address",
                icon: Icon(Icons.alternate_email),
              ),

              SizedBox(height: 16),

              //password
              // Customtextfields(
              //   textController: password,
              //   label: "password",
              //   icon: Icon(Icons.lock),
              // ),
              PasswordTextField(textController: password,
                label: "password",
                icon: Icon(Icons.lock),),

              SizedBox(height: 16),

              //confirm password
              // Customtextfields(
              //   textController: confirmPassword,
              //   label: "confirm password",
              //   icon: Icon(Icons.lock),
              // ),
              PasswordTextField(textController: confirmPassword,
                label: "confirm password",
                icon: Icon(Icons.lock),),

              SizedBox(height: 16),

              // signup button
              Customauthbutton(
                  onPressed: () async {
                    if (username.text == "" ||
                        email.text == "" ||
                        password.text == "" ||
                        confirmPassword.text == "") {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'required fields are empty',
                        desc: 'please fill all required fields',
                        btnOkOnPress: () {},
                      ).show();
                    } else if (password.text != confirmPassword.text) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'not the same password',
                        desc: 'the confirmation password isn\'t true',
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      if (formstate.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "login", (routes) => false);
                          //FirebaseAuth.instance.currentUser!.sendEmailVerification();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'can\'t signup',
                              desc: 'The password provided is too weak.',
                              btnOkOnPress: () {},
                            ).show();
                          } else if (e.code == 'email-already-in-use') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'can\'t signup',
                              desc:
                                  'The account already exists for that email.',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                      }
                    }
                  },
                  title: "signup"),

              SizedBox(height: 16),

              //login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("have an Account?"),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    child: Text("login", style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("login");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
