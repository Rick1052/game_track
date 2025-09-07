import 'package:flutter/material.dart';
import '../atoms/custom_icon.dart';
import '../atoms/custom_text.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuTile({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIcon(icon, color: Colors.white),
      title: CustomText(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      onTap: onTap,
    );
  }
}
