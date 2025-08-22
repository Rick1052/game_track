import 'package:flutter/material.dart';
import 'package:game_track/widgets/item_list_card.dart';
import 'package:game_track/models/indie_model.dart';
import 'package:game_track/models/favorite_model.dart';
import 'package:game_track/widgets/custom_app_bar.dart';

class HomeApp extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeApp({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  static final List<Game_Indie> _itens = [
    Game_Indie(
      id: 1,
      nome: 'Hollow Knight',
      image: 'assets/images/Hollow_Knight.png',
      descricao:
          'Explore um vasto mundo subterrâneo cheio de inimigos e segredos em um metroidvania desafiador.',
      avaliacao: 5,
    ),
    Game_Indie(
      id: 2,
      nome: 'Celeste',
      image: 'assets/images/Celeste.png',
      descricao:
          'Uma emocionante jornada de escalada de montanhas, enfrentando desafios físicos e emocionais.',
      avaliacao: 5,
    ),
    Game_Indie(
      id: 3,
      nome: 'Stardew Valley',
      image: 'assets/images/Stardew_Valley.png',
      descricao:
          'Gerencie sua própria fazenda, plante culturas, cuide de animais e interaja com os moradores da vila.',
      avaliacao: 4,
    ),
    Game_Indie(
      id: 4,
      nome: 'Undertale',
      image: 'assets/images/Undertale.png',
      descricao:
          'Um RPG com escolhas morais, onde suas ações determinam o destino de todos os personagens.',
      avaliacao: 5,
    ),
    Game_Indie(
      id: 5,
      nome: 'Cuphead',
      image: 'assets/images/Cuphead.png',
      descricao:
          'Jogo de plataforma com batalhas contra chefes inspiradas em desenhos animados dos anos 30.',
      avaliacao: 4,
    ),
    Game_Indie(
      id: 6,
      nome: 'Rogue Legacy',
      image: 'assets/images/Rogue_Legacy.jpeg',
      descricao:
          'Um roguelike com geração procedural e mecânica de heranças, onde cada morte traz novas habilidades.',
      avaliacao: 4,
    ),
    Game_Indie(
      id: 7,
      nome: 'Terraria',
      image: 'assets/images/Terraria.jpg',
      descricao:
          'Explore, construa e lute em um mundo 2D cheio de inimigos, chefes e recursos para coletar.',
      avaliacao: 4,
    ),
    Game_Indie(
      id: 8,
      nome: 'Chants of Sennar',
      image: 'assets/images/Chants_of_Sennar.jpeg',
      descricao:
          'Um RPG tático com combates por turnos e exploração de templos antigos.',
      avaliacao: 4,
    ),
    Game_Indie(
      id: 9,
      nome: 'Have a Nice Death',
      image: 'assets/images/Have_a_Nice_Death.jpg',
      descricao:
          'Você é a Morte! Defenda seu império contra criaturas que desafiam a ordem natural.',
      avaliacao: 4,
    ),
    Game_Indie(
      id: 10,
      nome: 'A Short Hike',
      image: 'assets/images/A_Short_Hike.jpg',
      descricao:
          'Explore montanhas e colinas, conheça personagens peculiares e encontre tesouros escondidos.',
      avaliacao: 4,
    ),
  ];

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final FavoriteGames favorites = FavoriteGames.instance; // singleton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Jogos Indie',
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
      body: ListView.builder(
        itemCount: HomeApp._itens.length,
        itemBuilder: (context, index) {
          final item = HomeApp._itens[index];
          final isFav = favorites.isFavorite(item);

          return ItemListCard(
            item: item,
            isFavorite: isFav,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Clicou no jogo: ${item.nome}')),
              );
            },
            onToggleFavorite: () {
              setState(() {
                favorites.toggleFavorite(item);
              });
            },
          );
        },
      ),
    );
  }
}
