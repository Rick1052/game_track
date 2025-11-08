# GameTrack - Plataforma de Vídeos de Jogos

GameTrack é uma plataforma estilo TikTok/Instagram Reels focada em vídeos de jogos, permitindo que usuários compartilhem, descubram e interajam com conteúdo de jogos.

## 🚀 Funcionalidades

### Autenticação
- ✅ Login/Registro com email e senha
- ✅ Login com Google
- ✅ Recuperação de senha
- ✅ Persistência de sessão

### Feed de Vídeos
- ✅ Auto-play quando vídeo está visível
- ✅ Paginação infinita
- ✅ Ordenação por data
- ✅ Scroll infinito

### Upload de Vídeos
- ✅ Seleção de arquivo
- ✅ Compressão opcional
- ✅ Upload para Firebase Storage
- ✅ Geração automática de thumbnail
- ✅ Salvamento de metadados no Firestore

### Busca e Social
- ✅ Busca de usuários em tempo real
- ✅ Sistema de seguir/deixar de seguir
- ✅ Sugestões de usuários

### Perfil
- ✅ Grid de vídeos do usuário
- ✅ Estatísticas (seguidores, seguindo, vídeos, pontos)
- ✅ Edição de perfil

### Sistema de Pontuação
- ✅ Pontos por postar vídeos (+10 pontos)
- ✅ Pontos por curtidas (+1 ponto)
- ✅ Pontos por novos seguidores (+5 pontos)
- ✅ Catálogo de vouchers/acessórios
- ✅ Resgate via Cloud Functions com verificação atômica

### Curtidas
- ✅ Um usuário só pode curtir uma vez
- ✅ Contadores atualizados atomicamente (transactions)

### Internacionalização
- ✅ Português (PT-BR)
- ✅ Inglês (EN)

### Acessibilidade
- ✅ Labels semânticos
- ✅ Contraste adequado
- ✅ Suporte a leitores de tela

## 🏗️ Arquitetura

O projeto segue **Clean Architecture** e **Atomic Design**:

```
lib/
├── core/                    # Configurações e constantes
│   ├── constants/
│   ├── config/
│   └── providers/
├── domain/                   # Camada de domínio
│   ├── models/              # Modelos com Freezed
│   └── repositories/        # Interfaces dos repositórios
├── data/                    # Camada de dados
│   └── repositories/        # Implementações dos repositórios
└── presentation/            # Camada de apresentação
    ├── pages/               # Telas
    └── widgets/             # Widgets (Atomic Design)
        ├── atoms/
        ├── molecules/
        ├── organisms/
        └── templates/
```

## 📦 Tecnologias

- **Flutter** 3.24.0+
- **Firebase** (Auth, Firestore, Storage, Functions, Analytics, Crashlytics)
- **Riverpod** para gerenciamento de estado
- **Freezed** para modelos imutáveis
- **Video Player** para reprodução de vídeos
- **Video Compress** para compressão

## 🔧 Configuração

### Pré-requisitos

- Flutter SDK 3.24.0 ou superior
- Dart SDK 3.8.1 ou superior
- Conta Firebase
- Node.js 18+ (para Cloud Functions)

### Passo 1: Clonar o repositório

```bash
git clone https://github.com/seu-usuario/game_track.git
cd game_track
```

### Passo 2: Instalar dependências

```bash
flutter pub get
```

### Passo 3: Configurar Firebase

1. Instale o FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure o Firebase:
```bash
flutterfire configure
```

3. Isso irá gerar o arquivo `lib/core/config/firebase_options.dart` automaticamente.

### Passo 4: Configurar Cloud Functions

```bash
cd functions
npm install
npm run build
```

### Passo 5: Deploy das regras de segurança

```bash
firebase deploy --only firestore:rules,storage:rules
```

### Passo 6: Deploy das Cloud Functions

```bash
cd functions
npm run deploy
```

### Passo 7: Gerar código (Freezed)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Passo 8: Executar o app

```bash
flutter run
```

## 🧪 Testes

### Executar testes unitários

```bash
flutter test
```

### Executar testes de widget

```bash
flutter test test/widget/
```

### Executar testes de integração

```bash
flutter test integration_test/
```

## 📱 Estrutura de Dados (Firestore)

### users/{userId}
```json
{
  "email": "string",
  "username": "string",
  "displayName": "string",
  "avatarUrl": "string?",
  "score": "number",
  "followersCount": "number",
  "followingCount": "number",
  "videosCount": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp?"
}
```

### videos/{videoId}
```json
{
  "ownerId": "string",
  "title": "string",
  "description": "string?",
  "game": "string?",
  "videoUrl": "string",
  "thumbnailUrl": "string",
  "likesCount": "number",
  "commentsCount": "number",
  "viewsCount": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp?"
}
```

### vouchers/{voucherId}
```json
{
  "title": "string",
  "description": "string",
  "type": "string",
  "pointsCost": "number",
  "imageUrl": "string",
  "stock": "number",
  "isActive": "boolean",
  "createdAt": "timestamp",
  "expiresAt": "timestamp?"
}
```

## 🔒 Regras de Segurança

As regras de segurança do Firestore e Storage estão em:
- `firestore.rules`
- `storage.rules`

**Importante**: Sempre revise e ajuste as regras de segurança antes de fazer deploy em produção.

## 🚀 CI/CD

O projeto usa GitHub Actions para CI/CD. O workflow está em `.github/workflows/ci.yml` e executa:
- Linting
- Testes unitários
- Build do app

## 📊 Analytics e Crashlytics

O app está configurado para enviar eventos para Firebase Analytics e Crashlytics. Os eventos principais incluem:
- Login/Registro
- Upload de vídeo
- Curtidas
- Seguir usuários
- Resgate de vouchers

## 🌐 Internacionalização

O app suporta:
- Português (PT-BR) - padrão
- Inglês (EN)

Os arquivos de tradução estão em `lib/l10n/`.

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 📧 Contato

Para dúvidas ou sugestões, abra uma issue no GitHub.

---

Desenvolvido com ❤️ usando Flutter e Firebase
