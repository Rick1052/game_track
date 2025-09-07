import 'package:flutter/material.dart';
import '../molecules/profile_header.dart';
import '../molecules/menu_option_tile.dart';
import 'package:logger/logger.dart';

class ConfigBody extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const ConfigBody({super.key, required this.onThemeChanged});

  @override
  State<ConfigBody> createState() => _ConfigBodyState();
}

class _ConfigBodyState extends State<ConfigBody> {
  int? selectedIndex;
  final Logger logger = Logger(); // <-- Inicializando a instância do Logger

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.brightness_6,
        'label': 'Tema',
        'onTap': () => _showThemeDialog(context)
      },
      {'icon': Icons.supervised_user_circle, 'label': 'Usuário', 'onTap': () => logger.i('Usuário')},
      {'icon': Icons.password_rounded, 'label': 'Senhas', 'onTap': () => logger.i('Senhas')},
    ];

    return Column(
      children: [
        const SizedBox(height: 50),
        const ProfileHeader(
          name: 'Shaolin Mata Porco',
          imagePath: 'assets/images/user.png',
        ),
        const Divider(height: 32),
        Expanded(
          child: ListView.separated(
            itemCount: menuItems.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return MenuOptionTile(
                icon: item['icon'] as IconData,
                label: item['label'] as String,
                onTap: () {
                  setState(() => selectedIndex = index);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    (item['onTap'] as VoidCallback)();
                  });
                },
                selected: selectedIndex == index,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Claro'),
              onTap: () {
                widget.onThemeChanged(false);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Escuro'),
              onTap: () {
                widget.onThemeChanged(true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('Automático'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Modo automático ainda não implementado')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
