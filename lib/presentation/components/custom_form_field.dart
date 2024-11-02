import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class CustomFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? suffix;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final String? initialValue;

  const CustomFormField({
    this.initialValue,
    this.label,
    this.hint,
    super.key,
    this.suffix,
    this.validator,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              label!,
              style: const TextStyle(fontSize: 16, shadows: []),
            ),
          ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          controller: controller,
          cursorColor: DesignSystem.colors.primary,
          decoration: InputDecoration(
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
            suffix: suffix,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
