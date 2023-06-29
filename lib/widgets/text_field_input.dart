import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final String hintText;
  final TextInputType textInputType;
  final bool isPassword;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    required this.textInputType,
    required this.hintText,
    required this.isPassword,
    required this.labelText,
  });

  @override
  Widget build(context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      obscureText: isPassword,
      keyboardType: textInputType,
    );
  }
}
