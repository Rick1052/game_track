import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              // TODO: Implementar edição de perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(l10n.privacy),
            onTap: () {
              // TODO: Implementar configurações de privacidade
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            onTap: () {
              // TODO: Implementar configurações de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            onTap: () {
              // TODO: Implementar seleção de idioma
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(l10n.theme),
            onTap: () {
              // TODO: Implementar seleção de tema
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

