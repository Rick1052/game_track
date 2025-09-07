import 'dart:ui';
import 'package:flutter/material.dart';
import '../molecules/menu_tile.dart';
import '../../../features/products/presentation/pages/home_app.dart';
import '../../../features/profile/presentation/pages/config.dart';
import '../../../features/products/presentation/pages/favorites_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const CustomAppBar({
    super.key,
    this.title = "GameTrack",
    required this.isDarkMode,
    required this.onThemeChanged,
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
      builder: (_) {
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
                        MenuTile(
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
                        MenuTile(
                          icon: Icons.favorite,
                          label: 'Favoritos',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FavoritesPage()),
                            );
                          },
                        ),
                        MenuTile(
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
                    child: MenuTile(
                      icon: Icons.outbox,
                      label: 'Sair',
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
