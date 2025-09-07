import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const CustomIcon(this.icon, {super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size);
  }
}
