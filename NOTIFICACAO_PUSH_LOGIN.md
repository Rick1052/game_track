# Notificação Push no Login

## Implementação Completa

Foi implementado um sistema de notificação push que envia uma mensagem de boas-vindas quando o usuário faz login no aplicativo.

## Componentes Implementados

### 1. Serviço de Notificação (`lib/services/notification_service.dart`)

Serviço responsável por:
- ✅ Solicitar permissão para notificações
- ✅ Obter token FCM do dispositivo
- ✅ Salvar token no Firestore
- ✅ Remover token ao fazer logout
- ✅ Configurar handlers para notificações

### 2. Integração com Autenticação

O `AuthRepositoryImpl` foi atualizado para:
- ✅ Obter e salvar token FCM após login bem-sucedido
- ✅ Funciona tanto para login com email quanto com Google
- ✅ Remove token ao fazer logout

### 3. Cloud Function (`functions/src/index.ts`)

Função `onUserLogin` que:
- ✅ Monitora atualizações no documento do usuário
- ✅ Detecta quando o `fcmToken` é atualizado (indicando login)
- ✅ Envia notificação de boas-vindas personalizada

### 4. Configuração no App (`lib/main.dart`)

- ✅ Handler para notificações em background
- ✅ Configuração de handlers quando o app inicia

## Como Funciona

### Fluxo de Login:

1. **Usuário faz login** (email/senha ou Google)
2. **Token FCM é obtido** do dispositivo
3. **Token é salvo** no Firestore (`users/{userId}/fcmToken`)
4. **Cloud Function detecta** a atualização do token
5. **Notificação é enviada** automaticamente com mensagem personalizada

### Mensagem da Notificação:

```
Título: "Bem-vindo de volta! 👋"
Corpo: "Olá {nome do usuário}, é bom ter você aqui novamente!"
```

## Arquivos Modificados/Criados

### Novos Arquivos:
- ✅ `lib/services/notification_service.dart` - Serviço de notificações

### Arquivos Modificados:
- ✅ `lib/data/repositories/auth_repository_impl.dart` - Integração com login
- ✅ `lib/core/providers/firebase_providers.dart` - Provider do Firebase Messaging
- ✅ `lib/core/providers/repository_providers.dart` - Provider do NotificationService
- ✅ `lib/main.dart` - Configuração de handlers
- ✅ `functions/src/index.ts` - Cloud Function para enviar notificação

## Configuração Necessária

### 1. Deploy da Cloud Function

Para que a notificação funcione, você precisa fazer deploy da Cloud Function:

```bash
cd functions
npm install
firebase deploy --only functions:onUserLogin
```

### 2. Permissões (Android)

No arquivo `android/app/src/main/AndroidManifest.xml`, certifique-se de ter:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

### 3. Permissões (iOS)

No arquivo `ios/Runner/Info.plist`, adicione:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

## Testando

1. **Faça login** no aplicativo
2. **Permita notificações** quando solicitado
3. **Aguarde alguns segundos** - a notificação deve aparecer automaticamente

## Personalização

### Alterar Mensagem da Notificação

Edite a Cloud Function em `functions/src/index.ts`:

```typescript
const message = {
  notification: {
    title: 'Seu título aqui',
    body: `Sua mensagem aqui ${userDisplayName}`,
  },
  // ...
};
```

### Adicionar Dados Customizados

Você pode adicionar dados customizados na notificação:

```typescript
data: {
  type: 'login',
  userId: userId,
  screen: 'home', // Navegar para tela específica
  // ... outros dados
}
```

## Tratamento de Notificações

O serviço já está configurado para:
- ✅ Receber notificações quando o app está em foreground
- ✅ Abrir o app quando o usuário toca na notificação
- ✅ Processar notificações quando o app está em background

## Próximos Passos (Opcional)

Você pode estender o sistema para:
- Enviar notificações quando recebe like
- Enviar notificações quando recebe novo seguidor
- Enviar notificações sobre novos vídeos de usuários seguidos
- Criar tela de configurações de notificações

## Troubleshooting

### Notificação não aparece:
1. Verifique se as permissões foram concedidas
2. Verifique se a Cloud Function foi deployada
3. Verifique os logs do Firebase Console
4. Verifique se o token FCM foi salvo no Firestore

### Erro ao obter token:
- Verifique se o Firebase Messaging está configurado corretamente
- Verifique se o `google-services.json` está atualizado
- Verifique as permissões do dispositivo

