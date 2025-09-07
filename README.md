# game_track

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

# GameTrack - Diário de Jogos

GameTrack é um aplicativo voltado para jogadores que desejam organizar e acompanhar seus jogos de forma prática e visual. Ele funciona como um diário pessoal, permitindo controlar o progresso, adicionar notas e organizar a lista de jogos de acordo com o interesse ou status.

## Funcionalidades

- **Organização por status:** Classifique os jogos em categorias como:
  - Quero jogar
  - Jogando
  - Já zerado
- **Notas e comentários:** Adicione observações ou comentários pessoais sobre cada jogo.
- **Armazenamento de fotos:** Possibilidade de anexar imagens ou screenshots dos jogos.
- **Diário de progresso:** Funciona como um quadro de referência rápido para acompanhar os jogos que você já jogou e os que deseja jogar.
- **Interface visual intuitiva:** Navegação simples e amigável para gerenciamento dos jogos.
- **Favoritos:** Marque seus jogos preferidos para acessá-los rapidamente.
- **Autenticação de Usuário:** Login e registro com validação de campos.
- **Persistência de dados local:** Usuários salvos no SQLite.
- **Configuração de temas:** Alternância entre tema claro, escuro e automático.

## Tecnologias Utilizadas

- Flutter (Dart) para desenvolvimento mobile multiplataforma.
- SQLite via `DBHelper` para persistência local de usuários.
- Widgets personalizados para exibição de forms, botões e indicadores de loading.
- Gerenciamento de estado simples para alternância de telas e temas.

## Estrutura do Projeto

- `lib/screens/` - Telas do aplicativo (Home, Configurações, Favoritos, Login, Registro).
- `lib/features/auth/` - Lógica de autenticação (login, registro, forms).
- `lib/models/` - Modelos de dados dos jogos e usuários.
- `lib/shared/widgets/` - Componentes reutilizáveis como cards, inputs e botões.
- `lib/shared/utils/` - Helpers como `DBHelper` para SQLite.
- `assets/images/` - Imagens dos jogos, ícones e avatar do usuário.

## Como Rodar

1. Clone o repositório:
   ```bash
   git clone https://github.com/Rick1052/game_track.git

2. Instale as dependências:
   ```bash
   flutter pub get

3. Rode o aplicativo:
   ```bash
   flutter run

