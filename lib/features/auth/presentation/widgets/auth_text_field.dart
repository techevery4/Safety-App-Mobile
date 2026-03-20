import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class AuthTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hintText: hintText,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      suffixIcon: suffixIcon,
      keyboardType: keyboardType,
    );
  }
}
