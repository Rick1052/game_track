import 'package:flutter/material.dart';
import '../atoms/custom_icon.dart';
import '../atoms/custom_text.dart';

class MenuOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const MenuOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIcon(icon),
      title: CustomText(label, style: TextStyle(fontWeight: FontWeight.w500)),
      tileColor: selected ? Theme.of(context).colorScheme.primary.withAlpha(50) : null,
      onTap: onTap,
    );
  }
}
