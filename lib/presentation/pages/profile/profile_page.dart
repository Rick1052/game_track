import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_providers.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/video_model.dart';
import '../../widgets/atoms/primary_button.dart';
import 'package:game_track/l10n/app_localizations.dart';

class ProfilePage extends ConsumerWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserAsync = ref.watch(authControllerProvider);
    final currentUser = currentUserAsync.value;
    final profileUserId = userId ?? currentUser?.id ?? '';

    if (profileUserId.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(l10n.error),
        ),
      );
    }

    final userAsync = ref.watch(userProvider(profileUserId));
    final videosAsync = ref.watch(userVideosProvider(profileUserId));
    final isOwnProfile = profileUserId == currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: isOwnProfile
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                ),
              ]
            : null,
      ),
      body: userAsync.when(
        data: (user) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _ProfileHeader(
                  user: user,
                  isOwnProfile: isOwnProfile,
                  currentUser: currentUser,
                ),
                const Divider(),
                _ProfileStats(user: user),
                const Divider(),
                _VideosGrid(videosAsync: videosAsync),
              ],
            ),
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

class _ProfileHeader extends ConsumerWidget {
  final dynamic user;
  final bool isOwnProfile;
  final dynamic currentUser;

  const _ProfileHeader({
    required this.user,
    required this.isOwnProfile,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(user.displayName[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('@${user.username}'),
                if (isOwnProfile)
                  PrimaryButton(
                    text: 'Editar perfil',
                    onPressed: () {
                      // Navegar para página de edição de perfil
                      // Navigator.of(context).pushNamed('/edit-profile');
                    },
                    width: 120,
                    height: 36,
                  )
                else
                  Builder(
                    builder: (context) {
                      final isFollowingAsync = ref.watch(
                        isFollowingProvider(
                          FollowParams(
                            userId: currentUser?.id ?? '',
                            targetUserId: user.id,
                          ),
                        ),
                      );
                      return isFollowingAsync.when(
                        data: (isFollowing) => PrimaryButton(
                          text: isFollowing ? 'Seguindo' : 'Seguir',
                          onPressed: () async {
                            try {
                              if (isFollowing) {
                                await ref.read(
                                  followControllerProvider(user.id).notifier,
                                ).unfollow();
                              } else {
                                await ref.read(
                                  followControllerProvider(user.id).notifier,
                                ).follow();
                              }
                              ref.invalidate(isFollowingProvider(
                                FollowParams(
                                  userId: currentUser?.id ?? '',
                                  targetUserId: user.id,
                                ),
                              ));
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erro: $e')),
                                );
                              }
                            }
                          },
                          width: 120,
                          height: 36,
                        ),
                        loading: () => const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                        error: (_, __) => const SizedBox(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStats extends StatelessWidget {
  final dynamic user;

  const _ProfileStats({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Vídeos', value: user.videosCount.toString()),
          _StatItem(label: 'Seguidores', value: user.followersCount.toString()),
          _StatItem(label: 'Seguindo', value: user.followingCount.toString()),
          _StatItem(label: 'Pontos', value: user.score.toString()),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(label),
      ],
    );
  }
}

class _VideosGrid extends StatelessWidget {
  final AsyncValue<List<VideoModel>> videosAsync;

  const _VideosGrid({required this.videosAsync});

  @override
  Widget build(BuildContext context) {
    return videosAsync.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Text('Nenhum vídeo'),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            if (video.thumbnailUrl != null) {
              return Image.network(
                video.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[800]!);
                },
              );
            } else {
              return Container(
                color: Colors.grey[800],
                child: const Icon(Icons.video_library, color: Colors.white54),
              );
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Erro: $error'),
      ),
    );
  }
}

final userVideosProvider = FutureProvider.family<List<VideoModel>, String>((ref, userId) async {
  final repository = ref.watch(videoRepositoryProvider);
  return await repository.getUserVideos(userId);
});

