import 'package:flutter/material.dart';
import 'features/auth/auth_page.dart';

void main() {
  runApp(const GameTrackApp());
}

class GameTrackApp extends StatefulWidget {
  const GameTrackApp({super.key});

  @override
  State<GameTrackApp> createState() => _GameTrackAppState();
}

class _GameTrackAppState extends State<GameTrackApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GameTrack',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AuthPage(), // inicia direto na tela de login/cadastro
    );
  }
}
