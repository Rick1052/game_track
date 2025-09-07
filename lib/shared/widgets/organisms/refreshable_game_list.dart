import 'package:flutter/material.dart';
import '../atoms/loading_indicator.dart';
import '../atoms/custom_text.dart';
import '../molecules/item_list_card.dart';
import '../../../models/game_detail.dart';
import '../../../models/favorite_model.dart';

class RefreshableGameList extends StatelessWidget {
  final List<GameDetail> games;
  final FavoriteGames favorites;
  final Future<void> Function() onRefresh;
  final void Function(GameDetail) onToggleFavorite;
  final bool isLoading;

  const RefreshableGameList({
    super.key,
    required this.games,
    required this.favorites,
    required this.onRefresh,
    required this.onToggleFavorite,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Loading central quando não há jogos carregados
    if (isLoading && games.isEmpty) {
      return const Center(child: LoadingIndicator(size: 50));
    }

    // Lista de jogos com Pull-to-Refresh
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: games.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: CustomText("Nenhum jogo disponível")),
              ],
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                final isFav = favorites.isFavorite(game);

                return ItemListCard(
                  item: game,
                  isFavorite: isFav,
                  onTap: () {},
                  onToggleFavorite: () => onToggleFavorite(game),
                );
              },
            ),
    );
  }
}
