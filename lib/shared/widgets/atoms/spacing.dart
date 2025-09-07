import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final double? width;
  final double? height;

  const Spacing({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
