import 'package:flutter/material.dart';
import '../atoms/custom_text.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String imagePath;

  const ProfileHeader({super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(imagePath, width: 130, height: 130, fit: BoxFit.cover),
        ),
        const SizedBox(height: 15),
        CustomText(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
