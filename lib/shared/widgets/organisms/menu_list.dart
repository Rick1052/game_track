import 'package:flutter/material.dart';
import '../molecules/icon_text_button.dart';
import 'package:logger/logger.dart';

class MenuList extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const MenuList({super.key, required this.onThemeChanged});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  int? selectedIndex;
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': Icons.home, 'label': 'Início', 'onTap': () => Navigator.pop(context)},
      {'icon': Icons.supervised_user_circle, 'label': 'Usuário', 'onTap': () => logger.i('Usuário')},
      {'icon': Icons.password_rounded, 'label': 'Senhas', 'onTap': () => logger.i('Senha')},
      {'icon': Icons.brightness_6, 'label': 'Tema', 'onTap': () => _showThemeDialog(context)},
    ];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return InkWell(
          onTap: () {
            setState(() => selectedIndex = index);
            Future.delayed(const Duration(milliseconds: 150), () {
              (item['onTap'] as VoidCallback)();
            });
          },
          child: IconTextButton(
            icon: item['icon'] as IconData,
            label: item['label'] as String,
            onTap: () {
              // Garante que o clique do botão execute o mesmo do InkWell
              setState(() => selectedIndex = index);
              (item['onTap'] as VoidCallback)();
            },
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
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
      ),
    );
  }
}
