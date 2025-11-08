# Guia de Configuração do GameTrack

Este guia detalha todos os passos necessários para configurar o projeto GameTrack do zero.

## Pré-requisitos

- Flutter SDK 3.24.0 ou superior
- Dart SDK 3.8.1 ou superior
- Node.js 18+ (para Cloud Functions)
- Conta Google (para Firebase)
- Android Studio / Xcode (para builds mobile)

## Passo 1: Configurar Firebase

### 1.1 Criar projeto no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Adicionar projeto"
3. Preencha o nome do projeto (ex: "game-track")
4. Ative Google Analytics (opcional)
5. Crie o projeto

### 1.2 Adicionar apps Android/iOS

#### Android:
1. No Firebase Console, clique em "Adicionar app" > Android
2. Registre o package name: `com.example.game_track` (ou o seu)
3. Baixe o arquivo `google-services.json`
4. Coloque em `android/app/google-services.json`

#### iOS:
1. No Firebase Console, clique em "Adicionar app" > iOS
2. Registre o Bundle ID
3. Baixe o arquivo `GoogleService-Info.plist`
4. Coloque em `ios/Runner/GoogleService-Info.plist`

### 1.3 Configurar FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Isso irá gerar automaticamente o arquivo `lib/core/config/firebase_options.dart`.

### 1.4 Habilitar serviços no Firebase

No Firebase Console, habilite:
- **Authentication**: Email/Password e Google
- **Firestore Database**: Criar banco em modo de teste
- **Storage**: Criar bucket
- **Functions**: Habilitar Cloud Functions
- **Analytics**: Já habilitado se você ativou no passo 1.1
- **Crashlytics**: Habilitar no console

## Passo 2: Configurar Autenticação

### 2.1 Email/Password

1. No Firebase Console, vá em Authentication > Sign-in method
2. Habilite "Email/Password"
3. Clique em "Salvar"

### 2.2 Google Sign-In

1. No Firebase Console, vá em Authentication > Sign-in method
2. Habilite "Google"
3. Configure o OAuth consent screen no Google Cloud Console
4. Adicione o SHA-1 do seu app (para Android):
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Adicione o SHA-1 no Firebase Console > Project Settings > Your apps

## Passo 3: Configurar Firestore

### 3.1 Criar banco de dados

1. No Firebase Console, vá em Firestore Database
2. Clique em "Criar banco de dados"
3. Escolha modo de teste (para desenvolvimento)
4. Escolha uma localização (ex: us-central1)

### 3.2 Deploy das regras

```bash
firebase deploy --only firestore:rules
```

As regras estão em `firestore.rules`.

## Passo 4: Configurar Storage

### 4.1 Criar bucket

1. No Firebase Console, vá em Storage
2. Clique em "Começar"
3. Aceite as regras padrão
4. Escolha uma localização

### 4.2 Deploy das regras

```bash
firebase deploy --only storage:rules
```

As regras estão em `storage.rules`.

## Passo 5: Configurar Cloud Functions

### 5.1 Instalar dependências

```bash
cd functions
npm install
```

### 5.2 Compilar TypeScript

```bash
npm run build
```

### 5.3 Deploy das Functions

```bash
npm run deploy
```

Ou use o Firebase CLI:

```bash
firebase deploy --only functions
```

## Passo 6: Configurar o App Flutter

### 6.1 Instalar dependências

```bash
flutter pub get
```

### 6.2 Gerar código (Freezed)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6.3 Configurar Android

Edite `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        // ...
    }
}
```

### 6.4 Configurar iOS

Edite `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

Depois execute:

```bash
cd ios
pod install
```

## Passo 7: Executar o App

### 7.1 Verificar dispositivos

```bash
flutter devices
```

### 7.2 Executar

```bash
flutter run
```

## Passo 8: Configurar Analytics e Crashlytics

### 8.1 Analytics

O Analytics já está configurado automaticamente. Para eventos customizados, use:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics.instance.logEvent(
  name: 'video_uploaded',
  parameters: {'video_id': videoId},
);
```

### 8.2 Crashlytics

1. No Firebase Console, vá em Crashlytics
2. Siga as instruções para configurar
3. O código já está preparado no app

## Passo 9: Testes

### 9.1 Executar testes unitários

```bash
flutter test
```

### 9.2 Executar testes de widget

```bash
flutter test test/widget/
```

### 9.3 Executar testes de integração

```bash
flutter test integration_test/
```

## Passo 10: CI/CD (Opcional)

O GitHub Actions já está configurado em `.github/workflows/ci.yml`.

Para usar:
1. Faça push para o repositório
2. O CI será executado automaticamente

## Troubleshooting

### Erro: "DefaultFirebaseOptions not found"

Execute:
```bash
flutterfire configure
```

### Erro: "Google Sign-In não funciona"

1. Verifique se o SHA-1 está correto no Firebase Console
2. Verifique se o OAuth consent screen está configurado
3. Verifique se o package name/Bundle ID está correto

### Erro: "Firestore permission denied"

1. Verifique se as regras foram deployadas
2. Verifique se o usuário está autenticado
3. Revise as regras em `firestore.rules`

### Erro: "Storage upload failed"

1. Verifique se as regras de Storage foram deployadas
2. Verifique o tamanho do arquivo (máx 100MB)
3. Verifique se o usuário está autenticado

## Próximos Passos

1. Personalize o tema do app
2. Adicione mais funcionalidades
3. Configure notificações push (FCM)
4. Adicione mais testes
5. Configure produção

## Suporte

Para dúvidas, abra uma issue no GitHub.

