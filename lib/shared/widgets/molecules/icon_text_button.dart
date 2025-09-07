import 'package:flutter/material.dart';
import '../atoms/custom_icon.dart';
import '../atoms/custom_text.dart';
import '../atoms/spacing.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const IconTextButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CustomIcon(icon),
          const Spacing(width: 8),
          CustomText(label),
        ],
      ),
    );
  }
}
