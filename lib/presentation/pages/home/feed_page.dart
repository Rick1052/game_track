import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/video_providers.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/video_model.dart';
import '../../widgets/molecules/video_player_widget.dart';
import '../../widgets/molecules/like_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _lastVideoDate;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(
      videosProvider(
        VideoQueryParams(
          limit: 10,
          startAfter: _lastVideoDate,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              Navigator.of(context).pushNamed('/upload');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: videosAsync.when(
        data: (videos) {
          if (videos.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noVideos),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              if (index == videos.length - 1) {
                _lastVideoDate = video.createdAt;
              }
              return _VideoCard(video: video);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erro: $error'),
        ),
      ),
    );
  }
}

class _VideoCard extends ConsumerStatefulWidget {
  final VideoModel video;

  const _VideoCard({required this.video});

  @override
  ConsumerState<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends ConsumerState<_VideoCard> {
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final currentUser = ref.read(authControllerProvider).value;
    if (currentUser == null) return;

    try {
      final repository = ref.read(videoRepositoryProvider);
      final hasLiked = await repository.hasUserLikedVideo(
        widget.video.id,
        currentUser.id,
      );
      if (mounted) {
        setState(() {
          _isLiked = hasLiked;
        });
      }
    } catch (e) {
      // Erro ao verificar like
    }
  }

  Future<void> _handleLike() async {
    if (_isLoading) return;

    final currentUser = ref.read(authControllerProvider).value;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(videoRepositoryProvider);
      if (_isLiked) {
        await repository.unlikeVideo(widget.video.id, currentUser.id);
        if (mounted) {
          setState(() {
            _isLiked = false;
          });
        }
      } else {
        await repository.likeVideo(widget.video.id, currentUser.id);
        if (mounted) {
          setState(() {
            _isLiked = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          VideoPlayerWidget(
            videoUrl: widget.video.videoUrl,
            thumbnailUrl: widget.video.thumbnailUrl,
            autoPlay: true,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                LikeButton(
                  isLiked: _isLiked,
                  likesCount: widget.video.likesCount,
                  onTap: _handleLike,
                ),
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.video.game != null)
                  Text(
                    widget.video.game!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

