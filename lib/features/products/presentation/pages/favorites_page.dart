import 'package:flutter/material.dart';
import 'package:game_track/shared/widgets/organisms/custom_app_bar.dart';
import 'package:game_track/shared/widgets/molecules/item_list_card.dart';
import 'package:game_track/models/favorite_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteGames.instance.favorites;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Favoritos",
        isDarkMode: false,
        onThemeChanged: _dummyThemeChange,
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("Nenhum jogo favorito ainda.", style: TextStyle(fontSize: 16)))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final game = favorites[index];
                return ItemListCard(
                  item: game,
                  isFavorite: true,
                  onTap: () {},
                  onToggleFavorite: () => FavoriteGames.instance.toggleFavorite(game),
                );
              },
            ),
    );
  }

  static void _dummyThemeChange(bool _) {}
}
