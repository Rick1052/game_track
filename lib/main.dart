import 'package:flutter/material.dart';
import 'package:game_track/screens/home_app.dart';

void main() {
  runApp(const GameTrackApp());
}

class GameTrackApp extends StatefulWidget {
  const GameTrackApp({super.key});

  @override
  State<GameTrackApp> createState() => _GameTrackAppState();
}

class _GameTrackAppState extends State<GameTrackApp> {
  bool isDarkMode = false; // estado global do tema

  void _handleThemeChanged(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GameTrack',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeApp(
        isDarkMode: isDarkMode,
        onThemeChanged: _handleThemeChanged,
      ),
    );
  }
}
