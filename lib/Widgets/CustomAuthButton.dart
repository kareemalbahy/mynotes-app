import 'package:flutter/material.dart';

class Customauthbutton extends StatefulWidget {
  final void Function() onPressed;
  final String title;

  const Customauthbutton(
      {super.key, required this.onPressed, required this.title});

  @override
  State<Customauthbutton> createState() => _CustomauthbuttonState();
}

class _CustomauthbuttonState extends State<Customauthbutton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      height: 45,
      minWidth: 500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color: Colors.red,
      child: Text(widget.title,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }
}
