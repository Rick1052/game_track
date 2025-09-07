import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_detail.dart';

class SteamService {
  List<int> _allAppIds = [];
  // int _currentPage = 0;
  final int pageSize = 10;

  int get totalAppIds => _allAppIds.length;

  // 🔹 Buscar todos os AppIDs da Steam (uma vez só)
  Future<void> _fetchAllAppIds() async {
    if (_allAppIds.isNotEmpty) return; // já buscou

    final url = Uri.parse(
      'https://api.steampowered.com/ISteamApps/GetAppList/v2/',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final apps = data['applist']['apps'] as List;
      _allAppIds = apps.map((e) => e['appid'] as int).toList();
    } else {
      throw Exception('Erro ao buscar lista de AppIDs');
    }
  }

  // 🔹 Buscar jogos da página atual
  Future<List<GameDetail>> fetchGamesPage({int page = 0}) async {
    await _fetchAllAppIds();

    final List<GameDetail> pageGames = [];
    int start = page * pageSize;
    int index = start;

    // continua pegando jogos até preencher a página
    while (pageGames.length < pageSize && index < _allAppIds.length) {
      final id = _allAppIds[index];
      final games = await fetchGameDetails([id]); // busca 1 jogo de cada vez

      if (games.isNotEmpty) {
        pageGames.add(games.first);
      }
      index++;
    }

    return pageGames;
  }

  // 🔹 Buscar detalhes de jogos por IDs
  Future<List<GameDetail>> fetchGameDetails(List<int> appIds) async {
    final List<GameDetail> games = [];

    for (final appId in appIds) {
      final url = Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=$appId&l=english',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final data = result['$appId'];
        if (data != null && data['success'] == true) {
          games.add(GameDetail.fromJson(appId, data));
        }
      }
    }

    return games;
  }
}
