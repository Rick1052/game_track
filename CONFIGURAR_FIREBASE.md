# Guia de Configuração do Firebase

Este guia explica como configurar o Firebase para o projeto GameTrack.

## Pré-requisitos

1. Conta no Google (para acessar o Firebase Console)
2. Flutter instalado e configurado
3. FlutterFire CLI instalado

## Passo 1: Instalar o FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Certifique-se de que o diretório `pub-cache/bin` está no seu PATH.

## Passo 2: Criar um Projeto no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Adicionar projeto" ou selecione um projeto existente
3. Siga o assistente para criar/configurar o projeto
4. Anote o **Project ID** (ex: `gametrack-d20a7`)

## Passo 3: Configurar Firebase para Android

### 3.1. Adicionar App Android no Firebase Console

1. No Firebase Console, clique em "Adicionar app" e selecione **Android**
2. Insira o **Package name**: `com.example.game_track`
   - Você pode encontrar isso em `android/app/build.gradle.kts` na linha `applicationId`
3. Clique em "Registrar app"
4. Baixe o arquivo `google-services.json`
5. Coloque o arquivo em: `android/app/google-services.json`

### 3.2. Configurar build.gradle

O arquivo `android/build.gradle.kts` (nível raiz) deve ter o plugin do Google Services:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

O arquivo `android/app/build.gradle.kts` deve aplicar o plugin:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Adicionar esta linha
}
```

## Passo 4: Configurar Firebase para iOS (Opcional)

### 4.1. Adicionar App iOS no Firebase Console

1. No Firebase Console, clique em "Adicionar app" e selecione **iOS**
2. Insira o **Bundle ID**: `com.example.gameTrack`
   - Você pode encontrar isso em `ios/Runner.xcodeproj`
3. Clique em "Registrar app"
4. Baixe o arquivo `GoogleService-Info.plist`
5. Adicione o arquivo ao projeto Xcode:
   - Abra `ios/Runner.xcworkspace` no Xcode
   - Arraste o arquivo `GoogleService-Info.plist` para a pasta `Runner` no Xcode
   - Certifique-se de que "Copy items if needed" está marcado

## Passo 5: Configurar Firebase para Web (Opcional)

1. No Firebase Console, clique em "Adicionar app" e selecione **Web**
2. Registre o app com um nome (ex: "GameTrack Web")
3. Copie as credenciais de configuração
4. Elas serão usadas no arquivo `firebase_options.dart`

## Passo 6: Executar FlutterFire CLI

Execute o comando para configurar automaticamente o Firebase:

```bash
flutterfire configure
```

Este comando irá:
- Detectar suas plataformas (Android, iOS, Web)
- Conectar ao seu projeto Firebase
- Gerar/atualizar o arquivo `lib/core/config/firebase_options.dart`
- Configurar os arquivos necessários

**Durante a execução:**
1. Selecione seu projeto Firebase
2. Escolha as plataformas que deseja configurar (Android, iOS, Web)
3. O CLI irá gerar automaticamente as configurações

## Passo 7: Habilitar Serviços do Firebase

No Firebase Console, habilite os serviços que você está usando:

### 7.1. Authentication
1. Vá em **Authentication** > **Get started**
2. Habilite os métodos de login:
   - **Email/Password**: Ative
   - **Google**: Configure (adicione SHA-1 para Android)

### 7.2. Firestore Database
1. Vá em **Firestore Database** > **Create database**
2. Escolha o modo:
   - **Production mode** (recomendado para produção)
   - **Test mode** (apenas para desenvolvimento)
3. Escolha a localização do banco de dados
4. Configure as regras de segurança

### 7.3. Storage
1. Vá em **Storage** > **Get started**
2. Configure as regras de segurança
3. Escolha a localização (mesma do Firestore, se possível)

### 7.4. Cloud Functions (Opcional)
1. Vá em **Functions** > **Get started**
2. Siga as instruções para configurar o ambiente

## Passo 8: Configurar Regras de Segurança

### 8.1. Firestore Rules

Exemplo básico (ajuste conforme necessário):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários: apenas o próprio usuário pode ler/escrever
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Vídeos: todos podem ler, apenas o dono pode escrever
    match /videos/{videoId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.ownerId == request.auth.uid;
    }
    
    // Vouchers: todos autenticados podem ler
    match /vouchers/{voucherId} {
      allow read: if request.auth != null;
      allow write: if false; // Apenas via Cloud Functions
    }
    
    // Redemptions: apenas o próprio usuário pode ler
    match /redemptions/{redemptionId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow write: if false; // Apenas via Cloud Functions
    }
  }
}
```

### 8.2. Storage Rules

Exemplo básico:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Vídeos: apenas autenticados podem fazer upload
    match /videos/{videoId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Thumbnails: todos autenticados podem ler
    match /thumbnails/{thumbnailId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Passo 9: Obter SHA-1 para Android (Google Sign-In)

Para habilitar o Google Sign-In no Android, você precisa adicionar o SHA-1 do seu certificado:

### 9.1. Obter SHA-1 do Debug Keystore

```bash
# Windows
cd android
gradlew signingReport

# Linux/Mac
cd android
./gradlew signingReport
```

Procure por `SHA1:` na saída e copie o valor.

### 9.2. Adicionar SHA-1 no Firebase Console

1. Vá em **Project Settings** > **Your apps** > Selecione o app Android
2. Clique em "Add fingerprint"
3. Cole o SHA-1 e salve

## Passo 10: Verificar Configuração

### 10.1. Verificar firebase_options.dart

O arquivo `lib/core/config/firebase_options.dart` deve ter configurações válidas para todas as plataformas:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'SUA_API_KEY',
  appId: '1:751895507697:android:SEU_APP_ID', // Deve ser diferente do web
  messagingSenderId: '751895507697',
  projectId: 'gametrack-d20a7',
  storageBucket: 'gametrack-d20a7.firebasestorage.app',
);
```

### 10.2. Testar a Conexão

Execute o app:

```bash
flutter run
```

Se tudo estiver configurado corretamente, o app deve inicializar sem erros relacionados ao Firebase.

## Solução de Problemas

### Erro: "configuration_not_found"

- Verifique se o arquivo `google-services.json` está em `android/app/`
- Verifique se o `package name` no Firebase Console corresponde ao `applicationId` no `build.gradle.kts`
- Execute `flutter clean` e tente novamente

### Erro: "Google Sign-In não funciona"

- Verifique se o SHA-1 foi adicionado no Firebase Console
- Verifique se o Google Sign-In está habilitado no Firebase Console
- Verifique se o `google-services.json` está atualizado

### Erro: "Permission denied" no Firestore/Storage

- Verifique as regras de segurança no Firebase Console
- Certifique-se de que o usuário está autenticado antes de acessar os dados

## Recursos Adicionais

- [Documentação do Firebase para Flutter](https://firebase.flutter.dev/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- [Firebase Console](https://console.firebase.google.com/)

## Notas Importantes

1. **Nunca commite** arquivos sensíveis como `google-services.json` ou `GoogleService-Info.plist` em repositórios públicos sem usar variáveis de ambiente
2. Mantenha as regras de segurança atualizadas conforme sua aplicação cresce
3. Use diferentes projetos Firebase para desenvolvimento e produção
4. Monitore o uso e custos no Firebase Console

