import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPass;
  final String hint;
  final TextInputType inputType;
  const TextFieldInput({
    super.key,
    required this.controller,
    this.isPass = false,
    required this.hint,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder,
        focusedBorder: InputBorder,
        enabledBorder: InputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: inputType,
      obscureText: isPass,
    );
  }
}
