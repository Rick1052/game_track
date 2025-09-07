import 'package:flutter/material.dart';
import 'package:game_track/shared/widgets/organisms/custom_app_bar.dart';
import 'package:game_track/shared/widgets/organisms/refreshable_game_list.dart';
import 'package:game_track/shared/widgets/organisms/pagination_controls.dart';
import 'package:game_track/models/games_cache.dart';
// import 'package:game_track/models/game_detail.dart';
import 'package:game_track/models/favorite_model.dart';
import 'package:game_track/services/steam_service.dart';
// import 'package:game_track/shared/widgets/atoms/loading_indicator.dart';

class HomeApp extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeApp({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final FavoriteGames favorites = FavoriteGames.instance;
  final SteamService steamService = SteamService();
  final GamesCache cache = GamesCache.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (cache.games.isEmpty) _loadPage(0);
  }

  Future<void> _loadPage(int page) async {
    if (isLoading || cache.loadedPages.contains(page)) return;

    setState(() => isLoading = true);

    try {
      final newGames = await steamService.fetchGamesPage(page: page);

      if (!mounted) return;

      setState(() {
        cache.games.addAll(newGames);
        cache.loadedPages.add(page);
        cache.currentPage = page;
        cache.hasMore =
            (page + 1) * steamService.pageSize < steamService.totalAppIds;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar jogos: $e')));
    }
  }

  void _nextPage() {
    if (!cache.hasMore) return;

    final nextPage = cache.currentPage + 1;

    // Atualiza página imediatamente
    setState(() {
      cache.currentPage = nextPage;
      isLoading = !cache.loadedPages.contains(nextPage);
    });

    // Carrega dados da próxima página se ainda não tiver
    if (!cache.loadedPages.contains(nextPage)) {
      _loadPage(nextPage);
    }
  }

  void _prevPage() {
    if (cache.currentPage == 0) return;

    setState(() => cache.currentPage -= 1);
  }

  @override
  Widget build(BuildContext context) {
    final startIndex = cache.currentPage * steamService.pageSize;
    final endIndex = (startIndex + steamService.pageSize) > cache.games.length
        ? cache.games.length
        : (startIndex + steamService.pageSize);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Jogos da Steam',
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshableGameList(
              games: cache.games.sublist(startIndex, endIndex),
              favorites: favorites,
              isLoading: isLoading,
              onRefresh: () => _loadPage(cache.currentPage),
              onToggleFavorite: (game) {
                setState(() {
                  favorites.toggleFavorite(game);
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PaginationControls(
              currentPage: cache.currentPage,
              hasPrevious: cache.currentPage > 0,
              hasNext: cache.hasMore,
              onPrev: _prevPage,
              onNext: _nextPage,
            ),
          ),
        ],
      ),
    );
  }
}
