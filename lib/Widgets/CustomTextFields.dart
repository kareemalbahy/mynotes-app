import 'package:flutter/material.dart';

class Customtextfields extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final Icon icon;

  const Customtextfields({super.key, required this.textController, required this.label, required this.icon});

  @override
  State<Customtextfields> createState() => _CustomtextfieldsState();
}

class _CustomtextfieldsState extends State<Customtextfields> {

  @override
  Widget build(BuildContext context) {
    return Form(
        child: TextFormField(
          validator: (val) {
            if (val == "") {
              return "required";
            }
          },
          controller: widget.textController,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: widget.icon,
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
          obscureText: false,
        ));
  }
}
