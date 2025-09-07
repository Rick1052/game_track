import 'package:game_track/models/game_detail.dart';

class FavoriteGames {
  FavoriteGames._();
  static final FavoriteGames instance = FavoriteGames._();

  final List<GameDetail> _items = [];

  List<GameDetail> get favorites => List.unmodifiable(_items);

  bool isFavorite(GameDetail game) {
    return _items.any((g) => g.appId == game.appId);
  }

  void toggleFavorite(GameDetail game) {
    if (isFavorite(game)) {
      _items.removeWhere((g) => g.appId == game.appId);
    } else {
      _items.add(game);
    }
  }
}
