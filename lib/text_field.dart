import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    required this.textController,
    required this.fillColor,
    super.key,
  });

  final String hintText;
  final TextEditingController textController;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        filled: true,
        fillColor: fillColor,
      ),
      controller: textController,
    );
  }
}
