import 'package:flutter/material.dart';

class CustomTxtFormField extends StatelessWidget {
  CustomTxtFormField({
    required this.title,
    required this.isObscure,
    required this.controller,
  });
  final String title;
  final bool isObscure;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
