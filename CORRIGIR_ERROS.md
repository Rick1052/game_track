# Como Corrigir os Erros

Os erros que você está vendo são porque os arquivos gerados pelo Freezed e pela localização não foram criados ainda.

## Passo 1: Gerar arquivos de localização e Freezed

Execute estes comandos no terminal do projeto (PowerShell):

```powershell
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
```

Ou execute o script que criei:

**Windows:**
```powershell
.\generate_files.bat
```

**Linux/Mac:**
```bash
chmod +x generate_files.sh
./generate_files.sh
```

## Passo 2: Verificar se os arquivos foram gerados

Após executar os comandos, verifique se estes arquivos foram criados:

- `lib/domain/models/user_model.freezed.dart`
- `lib/domain/models/user_model.g.dart`
- `lib/domain/models/video_model.freezed.dart`
- `lib/domain/models/video_model.g.dart`
- `lib/domain/models/voucher_model.freezed.dart`
- `lib/domain/models/voucher_model.g.dart`
- `lib/domain/models/redemption_model.freezed.dart`
- `lib/domain/models/redemption_model.g.dart`
- `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart`

## Passo 3: Executar no Chrome

Depois que os arquivos forem gerados:

```powershell
flutter run -d chrome
```

## Problemas Comuns

### Se o build_runner falhar:
- Certifique-se de que todas as dependências estão instaladas: `flutter pub get`
- Tente limpar o cache: `flutter clean` e depois `flutter pub get`

### Se a localização não gerar:
- Verifique se `generate: true` está no `pubspec.yaml` (já está)
- Verifique se os arquivos `.arb` existem em `lib/l10n/` (já existem)

### Se ainda houver erros:
- Execute `flutter analyze` para ver todos os erros
- Verifique se o Flutter está atualizado: `flutter doctor`

