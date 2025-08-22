import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:game_track/screens/home_app.dart';
import 'package:game_track/screens/config.dart';
import 'package:game_track/screens/favorites_page.dart';
import 'package:game_track/models/favorite_model.dart';
import 'package:game_track/models/indie_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  // Opcionais
  final FavoriteGames? favorites;
  final List<Game_Indie>? allGames;

  const CustomAppBar({
    super.key,
    this.title = "GameTrack",
    required this.isDarkMode,
    required this.onThemeChanged,
    this.favorites,
    this.allGames,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _showMenuDialog(context),
        ),
      ),
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.black26, Colors.black38],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withAlpha(50)),
              ),
              Column(
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildMenuTile(
                          context,
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeApp(
                                  isDarkMode: isDarkMode,
                                  onThemeChanged: onThemeChanged,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.favorite,
                          label: 'Favoritos',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    FavoritesPage(),
                              ),
                            );
                          },
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.settings,
                          label: 'Configurações',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Config(
                                  isDarkMode: isDarkMode,
                                  onThemeChanged: onThemeChanged,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ListTile(
                      leading: const Icon(Icons.outbox, color: Colors.white),
                      title: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.pop(context); // fecha o menu
        onTap();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
