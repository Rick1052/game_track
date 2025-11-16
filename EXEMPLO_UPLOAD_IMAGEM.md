# Exemplo de Uso - Upload de Imagem

## Função Implementada

A função `uploadImage` foi adicionada ao `UserRepository` para fazer upload de imagens (principalmente avatares) para o Firebase Storage.

## Localização

- **Interface**: `lib/domain/repositories/user_repository.dart`
- **Implementação**: `lib/data/repositories/user_repository_impl.dart`
- **Provider**: `lib/core/providers/repository_providers.dart`

## Características

✅ **Validações**:
- Verifica se o usuário está autenticado
- Verifica se o usuário está fazendo upload da própria imagem
- Verifica se o arquivo existe
- Valida tamanho máximo (5MB)
- Valida formato (JPG, JPEG, PNG, WebP)

✅ **Funcionalidades**:
- Upload para Firebase Storage no path `avatars/{userId}.{extensão}`
- Retry logic para obter URL após upload
- Atualização automática do `avatarUrl` no Firestore
- Tratamento de erros completo

## Exemplo de Uso

### 1. Usando ImagePicker para selecionar imagem

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/providers/repository_providers.dart';
import '../../core/providers/auth_providers.dart';

class UploadImageExample extends ConsumerStatefulWidget {
  const UploadImageExample({super.key});

  @override
  ConsumerState<UploadImageExample> createState() => _UploadImageExampleState();
}

class _UploadImageExampleState extends ConsumerState<UploadImageExample> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024, // Opcional: redimensionar
      maxHeight: 1024,
      imageQuality: 85, // Opcional: comprimir
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final repository = ref.read(userRepositoryProvider);
      final imageUrl = await repository.uploadImage(
        _selectedImage!.path,
        currentUser.uid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagem enviada com sucesso! URL: $imageUrl')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload de Imagem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Selecionar Imagem'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadImage,
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Fazer Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Usando em uma página de perfil

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/providers/repository_providers.dart';
import '../../core/providers/auth_providers.dart';

class ProfileImageUpload extends ConsumerStatefulWidget {
  const ProfileImageUpload({super.key});

  @override
  ConsumerState<ProfileImageUpload> createState() => _ProfileImageUploadState();
}

class _ProfileImageUploadState extends ConsumerState<ProfileImageUpload> {
  bool _isUploading = false;

  Future<void> _changeProfileImage() async {
    final picker = ImagePicker();
    
    // Mostrar opções: Câmera ou Galeria
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Imagem'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Câmera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Galeria'),
          ),
        ],
      ),
    );

    if (source == null) return;

    final image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image == null) return;

    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) return;

    setState(() => _isUploading = true);

    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.uploadImage(image.path, currentUser.uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil atualizada!')),
        );
        // Recarregar dados do usuário se necessário
        ref.invalidate(currentUserProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar foto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) => GestureDetector(
        onTap: _isUploading ? null : _changeProfileImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.avatarUrl != null
                  ? NetworkImage(user!.avatarUrl!)
                  : null,
              child: user?.avatarUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            if (_isUploading)
              const Positioned.fill(
                child: CircularProgressIndicator(),
              ),
            if (!_isUploading)
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 15,
                  child: Icon(Icons.camera_alt, size: 20),
                ),
              ),
          ],
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Icon(Icons.error),
    );
  }
}
```

## Parâmetros

### `uploadImage(String filePath, String userId)`

- **filePath**: Caminho local do arquivo de imagem
- **userId**: ID do usuário que está fazendo upload (deve ser o próprio usuário autenticado)

### Retorno

- **String**: URL da imagem no Firebase Storage

## Tratamento de Erros

A função lança exceções em caso de:
- Usuário não autenticado
- Tentativa de fazer upload de imagem de outro usuário
- Arquivo não encontrado
- Imagem muito grande (> 5MB)
- Formato não suportado
- Erro no upload ou ao obter URL

## Storage Path

As imagens são salvas em:
```
avatars/{userId}.{extensão}
```

Exemplo: `avatars/abc123.jpg`

## Regras de Segurança

As regras do Firebase Storage já estão configuradas para permitir:
- ✅ Leitura pública de avatares
- ✅ Escrita apenas pelo próprio usuário
- ✅ Deleção apenas pelo próprio usuário

## Notas

- A função atualiza automaticamente o campo `avatarUrl` no Firestore
- O campo `updatedAt` também é atualizado automaticamente
- A imagem antiga no Storage não é deletada automaticamente (pode ser implementado se necessário)
- O retry logic garante que a URL seja obtida mesmo com pequenos delays do Firebase

