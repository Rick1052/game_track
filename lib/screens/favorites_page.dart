import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../widgets/custom_app_bar.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // pega a lista de favoritos do singleton
    final favorites = FavoriteGames.instance.games;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Favoritos",
        isDarkMode: false,
        onThemeChanged: _dummyThemeChange,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "Nenhum jogo favorito ainda.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final game = favorites[index];
                return ListTile(
                  leading: game.image.isNotEmpty
                      ? Image.asset(game.image)
                      : const Icon(Icons.videogame_asset),
                  title: Text(game.nome),
                  subtitle: Text(game.descricao),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
                );
              },
            ),
    );
  }

  static void _dummyThemeChange(bool _) {}
}
