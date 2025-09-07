import '../models/game_detail.dart';

class GamesCache {
  GamesCache._privateConstructor();
  static final GamesCache instance = GamesCache._privateConstructor();

  List<GameDetail> games = []; // todos os jogos carregados
  int currentPage = 0;         // página atual
  bool hasMore = true;         // se existe próxima página
  Set<int> loadedPages = {};   // páginas já carregadas
}
