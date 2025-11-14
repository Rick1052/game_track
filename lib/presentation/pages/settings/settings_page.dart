import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import 'package:game_track/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.editProfile),
            onTap: () {
              // Navegar para página de edição de perfil
              // Navigator.of(context).pushNamed('/edit-profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(l10n.privacy),
            onTap: () {
              // Navegar para página de configurações de privacidade
              // Navigator.of(context).pushNamed('/privacy-settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            onTap: () {
              // Navegar para página de configurações de notificações
              // Navigator.of(context).pushNamed('/notification-settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            onTap: () {
              // Navegar para página de seleção de idioma
              // Navigator.of(context).pushNamed('/language-settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(l10n.theme),
            onTap: () {
              // Navegar para página de seleção de tema
              // Navigator.of(context).pushNamed('/theme-settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}

