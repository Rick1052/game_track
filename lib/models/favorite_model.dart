import 'indie_model.dart';

class FavoriteGames {
  FavoriteGames._privateConstructor();

  static final FavoriteGames instance = FavoriteGames._privateConstructor();

  final List<Game_Indie> games = [];

  bool isFavorite(Game_Indie game) => games.contains(game);

  void add(Game_Indie game) {
    if (!isFavorite(game)) {
      games.add(game);
    }
  }

  void remove(Game_Indie game) {
    games.remove(game);
  }

  void toggleFavorite(Game_Indie game) {
    if (isFavorite(game)) {
      remove(game);
    } else {
      add(game);
    }
  }
}
