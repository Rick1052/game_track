import 'package:flutter/material.dart';
import '../../../../shared/widgets/organisms/custom_app_bar.dart';
import '../../../../shared/widgets/organisms/config_body.dart';

class Config extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Config({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Configuração',
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
      ),
      body: ConfigBody(onThemeChanged: onThemeChanged),
    );
  }
}
