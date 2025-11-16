# Como Configurar o Google Sign-In no Firebase

O erro `PlatformException(sign_in_failed, com.google.android.gms.common.api.Api10)` ocorre porque o Google Sign-In não está configurado corretamente no Firebase Console.

## Passos para Configurar:

### 1. Obter o SHA-1 Fingerprint

Execute o seguinte comando no terminal (na pasta do projeto):

**Windows (PowerShell):**
```powershell
cd android
.\gradlew signingReport
```

Procure por "SHA1" na saída. Você verá algo como:
```
Variant: debug
Config: debug
Store: C:\Users\...\.android\debug.keystore
Alias: AndroidDebugKey
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**Ou use o keytool diretamente:**
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### 2. Adicionar SHA-1 no Firebase Console

1. Acesse: https://console.firebase.google.com/project/gametrack-d20a7/settings/general
2. Role até a seção "Seus apps"
3. Clique no app Android (com.example.game_track)
4. Clique em "Adicionar impressão digital"
5. Cole o SHA-1 que você obteve
6. Clique em "Salvar"

### 3. Configurar OAuth no Firebase Console

1. Acesse: https://console.firebase.google.com/project/gametrack-d20a7/authentication/providers
2. Clique em "Google"
3. Ative o provedor
4. Configure o email de suporte (se necessário)
5. Clique em "Salvar"

### 4. Baixar o novo google-services.json

1. Acesse: https://console.firebase.google.com/project/gametrack-d20a7/settings/general
2. Role até a seção "Seus apps"
3. Clique no app Android
4. Clique em "Baixar google-services.json"
5. Substitua o arquivo em `android/app/google-services.json`

### 5. Verificar o google-services.json

Após baixar, o arquivo deve conter uma seção `oauth_client` com os clientes OAuth configurados:

```json
{
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
  ]
}
```

### 6. Rebuild do App

Após fazer as alterações:

```bash
flutter clean
flutter pub get
flutter run
```

## Nota Importante

O SHA-1 é diferente para debug e release. Certifique-se de adicionar ambos:
- SHA-1 de debug (para desenvolvimento)
- SHA-1 de release (para produção)

Para obter o SHA-1 de release, você precisará usar a keystore de release do seu app.




