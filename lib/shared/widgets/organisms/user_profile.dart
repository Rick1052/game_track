import 'package:flutter/material.dart';
import '../atoms/custom_text.dart';
import '../atoms/spacing.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final String avatarPath;

  const UserProfile({super.key, required this.name, required this.avatarPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(child: Image.asset(avatarPath, width: 130, height: 130)),
        const Spacing(height: 15),
        CustomText(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Spacing(height: 10),
      ],
    );
  }
}
