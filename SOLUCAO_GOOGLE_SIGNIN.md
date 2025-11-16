# 🔧 Solução para o Erro do Google Sign-In (Api10)

O erro `PlatformException(sign_in_failed, com.google.android.gms.common.api.Api10)` ocorre porque o **SHA-1 fingerprint não foi adicionado no Firebase Console** ou o **OAuth não está configurado**.

## ⚠️ Problema Identificado

O arquivo `android/app/google-services.json` está com `"oauth_client": []` vazio, o que significa que o Firebase não tem os clientes OAuth configurados para o Google Sign-In.

## ✅ Solução Passo a Passo

### Passo 1: Obter o SHA-1 Fingerprint

**Opção A - Via Android Studio:**
1. Abra o Android Studio
2. Abra o projeto Flutter
3. No painel lateral direito, clique em "Gradle"
4. Navegue até: `android` > `Tasks` > `android` > `signingReport`
5. Clique duas vezes em `signingReport`
6. Procure na saída por `SHA1:` e copie o valor

**Opção B - Via Terminal (se tiver Java configurado):**
```powershell
cd android
.\gradlew signingReport
```
Procure por `SHA1:` na saída.

**Opção C - Via Flutter:**
```bash
flutter build apk --debug
```
Depois execute:
```powershell
cd android
.\gradlew signingReport
```

### Passo 2: Adicionar SHA-1 no Firebase Console

1. **Acesse o Firebase Console:**
   - https://console.firebase.google.com/project/gametrack-d20a7/settings/general

2. **Role até a seção "Seus apps"**

3. **Clique no app Android** (`com.example.game_track`)

4. **Clique em "Adicionar impressão digital"** (ou "Add fingerprint")

5. **Cole o SHA-1** que você obteve no Passo 1

6. **Clique em "Salvar"**

### Passo 3: Ativar o Google Sign-In no Firebase

1. **Acesse Authentication:**
   - https://console.firebase.google.com/project/gametrack-d20a7/authentication/providers

2. **Clique em "Google"**

3. **Ative o provedor** (toggle para ON)

4. **Configure o email de suporte** (opcional, mas recomendado)

5. **Clique em "Salvar"**

### Passo 4: Baixar o novo google-services.json

1. **Volte para as configurações gerais:**
   - https://console.firebase.google.com/project/gametrack-d20a7/settings/general

2. **Role até "Seus apps"**

3. **Clique no app Android**

4. **Clique em "Baixar google-services.json"** (ícone de download)

5. **Substitua o arquivo** em `android/app/google-services.json`

### Passo 5: Verificar o google-services.json

Após baixar, abra o arquivo e verifique se contém a seção `oauth_client`:

```json
{
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:751895507697:android:2c58ff39f8c5e001462f50",
        "android_client_info": {
          "package_name": "com.example.game_track"
        }
      },
      "oauth_client": [
        {
          "client_id": "XXXXX.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.example.game_track",
            "certificate_hash": "XXXXX"
          }
        },
        {
          "client_id": "XXXXX.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      ...
    }
  ]
}
```

**⚠️ IMPORTANTE:** Se `oauth_client` ainda estiver vazio `[]`, significa que:
- O SHA-1 não foi adicionado corretamente, OU
- O Google Sign-In não foi ativado no Firebase

### Passo 6: Rebuild do App

Após fazer todas as alterações:

```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Verificação Rápida

Para verificar se está tudo configurado:

1. ✅ SHA-1 adicionado no Firebase Console
2. ✅ Google Sign-In ativado no Firebase Authentication
3. ✅ `google-services.json` baixado novamente
4. ✅ `oauth_client` não está vazio no `google-services.json`
5. ✅ App rebuildado após as alterações

## 📝 Notas Importantes

- O SHA-1 é **diferente** para debug e release
- Para desenvolvimento, use o SHA-1 de **debug**
- Para produção, você precisará adicionar o SHA-1 de **release** também
- Após adicionar o SHA-1, pode levar alguns minutos para o Firebase processar

## 🆘 Ainda com Problemas?

Se após seguir todos os passos o erro persistir:

1. Verifique se o `google-services.json` foi realmente substituído
2. Certifique-se de que fez `flutter clean` antes de rebuildar
3. Verifique se o package name está correto: `com.example.game_track`
4. Tente desinstalar o app do dispositivo e reinstalar




