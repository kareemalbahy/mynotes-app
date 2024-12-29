import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynotes/Widgets/CustomTextFields.dart';
import 'package:mynotes/Widgets/CustomAuthButton.dart';

import '../Widgets/PaswordTextField.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context)
        .pushNamedAndRemoveUntil("homepage", (routes) => false);
  }

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
              SizedBox(height: 24),

              //app icon
              Container(height: 300, child: Image.asset("images/note.png")),

              SizedBox(height: 16),

              //login word
              Text("login",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),

              SizedBox(height: 16),

              // email address
              Customtextfields(
                textController: email,
                label: "email address",
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
                icon: Icon(Icons.lock)),

              SizedBox(height: 12),

              //if the user forgot the password it will send the password reset email
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Text("forgot password?"),
                    onTap: () {
                      try {
                        // if the user didn't give an email
                        if (email.text == "") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'no email given',
                            desc:
                                'please enter an email to send the password reset mail',
                            btnOkOnPress: () {},
                          ).show();
                          return;
                        }
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'the password reset mail sent ',
                          desc:
                              'please check your gmail for the password reset mail',
                          btnOkOnPress: () {},
                        ).show();
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 12),

              // login button
              Customauthbutton(
                onPressed: () async {
                  if (email.text == "" || password.text == "") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'required fields are empty',
                      desc: 'please fill all required fields',
                      btnOkOnPress: () {},
                    ).show();
                  } else {
                    if (formstate.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "homepage", (routes) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.toString().contains(
                            "The supplied auth credential is incorrect, malformed or has expired.")) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'can\'t login',
                            desc: 'email address or password is incorrect',
                            btnOkOnPress: () {},
                          ).show();
                          print("email address or password is incorrect");
                        } else if (e
                            .toString()
                            .contains("Given String is empty or null")) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'can\'t login',
                            desc:
                                'please enter your email address and password',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();
                          print(e);
                        }
                      }
                    } else {
                      print("empty fields");
                    }
                  }
                },
                title: "login",
              ),

              SizedBox(height: 12),

              //login with google button
              MaterialButton(
                onPressed: () {
                  signInWithGoogle();
                },
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.deepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "login with google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      "images/google.png",
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              //to signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("if you dont have an email"),
                  SizedBox(width: 8),
                  InkWell(
                    child: Text("signup", style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.of(context).pushNamed("signup");
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
