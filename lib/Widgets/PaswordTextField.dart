import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final Icon icon;

  const PasswordTextField({super.key, required this.textController, required this.label, required this.icon});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool passwordInvisible = true;

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
            suffixIcon: IconButton(icon: Icon(passwordInvisible? Icons.visibility : Icons.visibility_off),onPressed: (){
              setState(() {
                passwordInvisible = !passwordInvisible;
              });
            },)
          ),
          obscureText: passwordInvisible,

        ));
  }
}
