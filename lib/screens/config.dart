import 'package:flutter/material.dart';
import 'package:game_track/widgets/custom_app_bar.dart';

class Config extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Config({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Configuração',
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 50),
          const UserProfile(),
          const Divider(),
          Expanded(
            child: MenuList(
              onThemeChanged: onThemeChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset('assets/images/user.png', width: 130, height: 130),
        ),
        const SizedBox(height: 15),
        const Text(
          'Shaolin Mata Porco',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MenuList extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const MenuList({super.key, required this.onThemeChanged});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.home,
        'label': 'Início',
        'onTap': () => Navigator.pop(context), // volta para HomeApp
      },
      {
        'icon': Icons.supervised_user_circle,
        'label': 'Usuário',
        'onTap': () => print('Usuário'),
      },
      {
        'icon': Icons.password_rounded,
        'label': 'Senhas',
        'onTap': () => print('Senha'),
      },
      {
        'icon': Icons.brightness_6,
        'label': 'Tema',
        'onTap': () => _showThemeDialog(context),
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          leading: Icon(item['icon'] as IconData),
          title: Text(item['label'] as String),
          selected: selectedIndex == index,
          selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(153),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });

            Future.delayed(const Duration(milliseconds: 150), () {
              (item['onTap'] as VoidCallback)();
            });
          },
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Claro'),
              onTap: () {
                widget.onThemeChanged(false); // tema claro
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Escuro'),
              onTap: () {
                widget.onThemeChanged(true); // tema escuro
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('Automático'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Modo automático ainda não implementado'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
