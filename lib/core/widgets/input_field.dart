import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final TextInputType keyboardType;
  final int? maxLines;
  final Widget? prefixIcon;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
      ),
      validator: (value) {
        if (isRequired && value!.trim().isEmpty) {
          return "$hintText is required!";
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 20,
        color: AppPallete.darkGreen,
      ),
      maxLines: maxLines,
    );
  }
}
