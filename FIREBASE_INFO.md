# Informações do Projeto Firebase

## Dados do Projeto

- **Nome do Projeto**: gametrack
- **Project ID**: gametrack-d20a7
- **Número do Projeto**: 751895507697
- **Application ID (Android)**: com.example.game_track

## Status da Configuração

### ✅ Configurado
- Project ID: `gametrack-d20a7`
- Messaging Sender ID: `751895507697`
- Storage Bucket: `gametrack-d20a7.firebasestorage.app`
- Web App ID: `1:751895507697:web:5e48e3c44c68faf4462f50`

### ⚠️ Precisa Configurar

1. **Android App ID**: O arquivo `firebase_options.dart` está usando o App ID do Web para Android. Você precisa:
   - Adicionar o app Android no Firebase Console
   - Baixar o arquivo `google-services.json`
   - O App ID correto do Android será algo como: `1:751895507697:android:XXXXXXXXX`

2. **Arquivo google-services.json**: 
   - Baixe do Firebase Console
   - Coloque em: `android/app/google-services.json`

3. **iOS (se necessário)**:
   - Adicionar app iOS no Firebase Console
   - Baixar `GoogleService-Info.plist`

## Próximos Passos

### 1. Adicionar App Android no Firebase Console

1. Acesse: https://console.firebase.google.com/project/gametrack-d20a7
2. Clique em "Adicionar app" > Android
3. Package name: `com.example.game_track`
4. Baixe o arquivo `google-services.json`
5. Coloque em: `android/app/google-services.json`

### 2. Configurar build.gradle.kts

Adicione o plugin do Google Services no arquivo `android/build.gradle.kts` (nível raiz):

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

E no arquivo `android/app/build.gradle.kts`, adicione:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Adicionar esta linha
}
```

### 3. Executar FlutterFire CLI (Recomendado)

```bash
# Adicionar ao PATH temporariamente (Windows PowerShell)
$env:PATH += ";C:\Users\rafin\AppData\Local\Pub\Cache\bin"

# Executar configuração
flutterfire configure
```

Durante a execução:
- Selecione o projeto: `gametrack-d20a7`
- Escolha as plataformas: Android, Web (e iOS se necessário)

Isso irá gerar automaticamente o arquivo `firebase_options.dart` com todas as configurações corretas.

### 4. Habilitar Serviços no Firebase Console

1. **Authentication**:
   - Vá em Authentication > Get started
   - Habilite Email/Password
   - Configure Google Sign-In (adicione SHA-1)

2. **Firestore Database**:
   - Vá em Firestore Database > Create database
   - Escolha Production mode ou Test mode
   - Configure localização

3. **Storage**:
   - Vá em Storage > Get started
   - Configure regras de segurança

## Obter SHA-1 para Google Sign-In

Execute no diretório `android`:

```bash
cd android
gradlew signingReport
```

Procure por `SHA1:` na saída e adicione no Firebase Console:
- Project Settings > Your apps > Android app > Add fingerprint

## Verificar Configuração

Após configurar, execute:

```bash
flutter clean
flutter pub get
flutter run
```

Se tudo estiver correto, o app deve inicializar sem erros relacionados ao Firebase.

