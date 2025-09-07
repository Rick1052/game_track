import 'package:flutter/material.dart';
import '../atoms/custom_text.dart';

class InputWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator; // <-- adicione isto

  const InputWithLabel({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator, // <-- adicione isto
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator, // <-- use aqui
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
