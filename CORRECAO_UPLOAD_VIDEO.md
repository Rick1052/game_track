# Correção do Upload de Vídeo

## Problema Identificado

Erro: `[firebase_storage/object-not-found] No object exists at the desired reference`

Este erro ocorre quando tentamos obter a URL do vídeo logo após o upload, mas o Firebase Storage ainda não processou o arquivo completamente.

## Correções Implementadas

### 1. Melhor Tratamento de Erros no Upload
- Adicionado try-catch específico para capturar erros durante o upload
- Mensagens de erro mais descritivas

### 2. Delay Inicial Aumentado
- Aumentado de 2 segundos para **3 segundos** antes da primeira tentativa de obter a URL
- O Firebase Storage precisa de tempo para processar arquivos grandes

### 3. Retry Logic Melhorado
- Aumentado número de tentativas de 5 para **8**
- Delay inicial aumentado de 1 segundo para **2 segundos**
- Incremento de delay aumentado de 500ms para **1.5 segundos** a cada tentativa
- Verificação de metadata para confirmar se o arquivo existe

### 4. Verificação de Existência do Arquivo
- Antes de lançar erro final, verifica se o arquivo realmente existe usando `getMetadata()`
- Diferencia entre "arquivo não existe" e "erro ao obter URL"

## Código Atualizado

```dart
// Upload do vídeo
final uploadTask = videoRef.putFile(videoFile);

// Aguardar o upload completar
try {
  await uploadTask;
} catch (uploadError) {
  throw Exception('Erro durante o upload do vídeo: $uploadError');
}

// Aguardar um tempo inicial antes de tentar obter a URL
await Future.delayed(const Duration(milliseconds: 3000));

// Obter a URL com retry melhorado
int retries = 8;
int delayMs = 2000;
Exception? lastError;

while (retries > 0) {
  try {
    videoUrl = await videoRef.getDownloadURL();
    if (videoUrl != null && videoUrl.isNotEmpty) {
      break; // Sucesso!
    }
  } catch (e) {
    lastError = e is Exception ? e : Exception(e.toString());
    retries--;
    
    if (retries == 0) {
      // Verificar se o arquivo existe
      try {
        final metadata = await videoRef.getMetadata();
        throw Exception('Arquivo existe mas não foi possível obter URL. Erro: $lastError');
      } catch (metadataError) {
        throw Exception('Vídeo não encontrado no Storage. Upload pode ter falhado. Erro: $lastError');
      }
    }
    
    await Future.delayed(Duration(milliseconds: delayMs));
    delayMs += 1500;
  }
}
```

## Verificações Adicionais

### 1. Regras de Storage
As regras estão corretas:
```javascript
match /videos/{videoId} {
  allow read: if true;
  allow write: if request.auth != null 
    && request.resource.size < 100 * 1024 * 1024; // Max 100MB
  allow delete: if request.auth != null;
}
```

### 2. Caminho do Storage
O caminho está correto: `videos/{videoId}.mp4`

### 3. Autenticação
O código verifica se o usuário está autenticado antes do upload.

## Possíveis Causas do Erro

1. **Arquivo muito grande**: Vídeos grandes podem levar mais tempo para processar
2. **Conexão lenta**: Upload pode estar completo mas o processamento demora
3. **Regras de segurança**: Verificar se as regras estão deployadas corretamente
4. **Bucket do Storage**: Verificar se o bucket está configurado corretamente

## Soluções Adicionais (se o problema persistir)

### 1. Verificar Regras de Storage no Firebase Console
```bash
firebase deploy --only storage:rules
```

### 2. Verificar Tamanho do Arquivo
Adicionar validação antes do upload:
```dart
final fileSize = await videoFile.length();
const maxSize = 100 * 1024 * 1024; // 100MB
if (fileSize > maxSize) {
  throw Exception('Vídeo muito grande. Tamanho máximo: 100MB');
}
```

### 3. Adicionar Logs para Debug
```dart
print('Iniciando upload do vídeo: $videoFileName');
print('Tamanho do arquivo: ${await videoFile.length()} bytes');
print('Caminho completo: ${videoRef.fullPath}');
```

### 4. Verificar Permissões do Usuário
Certificar-se de que o usuário está autenticado e tem permissão:
```dart
final user = _auth.currentUser;
if (user == null) {
  throw Exception('Usuário não autenticado');
}
print('Usuário autenticado: ${user.uid}');
```

## Teste

Após as correções, teste o upload:

1. Selecione um vídeo pequeno primeiro (< 10MB)
2. Se funcionar, teste com vídeos maiores
3. Monitore os logs para identificar onde está falhando

## Próximos Passos

Se o problema persistir:

1. Verificar logs do Firebase Console
2. Verificar se as regras de storage estão deployadas
3. Testar com um vídeo menor
4. Verificar conexão de internet
5. Verificar se o bucket do Storage está ativo

