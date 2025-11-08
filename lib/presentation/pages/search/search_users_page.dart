import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_providers.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../domain/models/user_model.dart';
import '../../widgets/atoms/primary_button.dart';
class SearchUsersPage extends ConsumerStatefulWidget {
  const SearchUsersPage({super.key});

  @override
  ConsumerState<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends ConsumerState<SearchUsersPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(searchUsersProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar usuários',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: _query.isEmpty
          ? const Center(
              child: Text('Buscar usuários'),
            )
          : usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                    child: Text('Nenhum usuário encontrado'),
                  );
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _UserTile(user: user);
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

class _UserTile extends ConsumerWidget {
  final UserModel user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authControllerProvider).value?.id ?? '';
    final isFollowingAsync = ref.watch(isFollowingProvider(
      FollowParams(
        userId: currentUserId,
        targetUserId: user.id,
      ),
    ));

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatarUrl != null
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: user.avatarUrl == null
            ? Text(user.displayName[0].toUpperCase())
            : null,
      ),
      title: Text(user.displayName),
      subtitle: Text('@${user.username}'),
      trailing: isFollowingAsync.when(
        data: (isFollowing) {
          final followController = ref.watch(
            followControllerProvider(user.id),
          );
          return followController.when(
            data: (_) => PrimaryButton(
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
                      userId: currentUserId,
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
              width: 100,
              height: 36,
            ),
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => PrimaryButton(
              text: isFollowing ? 'Seguindo' : 'Seguir',
              onPressed: null,
              width: 100,
              height: 36,
            ),
          );
        },
        loading: () => const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
        error: (_, __) => const SizedBox(),
      ),
      onTap: () {
        Navigator.of(context).pushNamed('/profile', arguments: user.id);
      },
    );
  }
}

