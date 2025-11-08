# ⚡ Instruções Rápidas para Corrigir Erros

## 🔴 PROBLEMA PRINCIPAL

Os arquivos gerados pelo **Freezed** e pela **localização** não existem ainda. Isso causa todos os erros de "undefined getter", "undefined method", etc.

## ✅ SOLUÇÃO (Execute no PowerShell)

```powershell
# 1. Instalar dependências
flutter pub get

# 2. Gerar arquivos de localização
flutter gen-l10n

# 3. Gerar arquivos Freezed (JSON serialization)
flutter pub run build_runner build --delete-conflicting-outputs
```

**OU execute o script:**
```powershell
.\generate_files.bat
```

## 🎯 Depois de gerar os arquivos

Execute no Chrome:
```powershell
flutter run -d chrome
```

## 📝 Nota

- Os erros de `AppLocalizations` vão desaparecer após `flutter gen-l10n`
- Os erros de `toJson()`, `id`, `ownerId`, etc. vão desaparecer após `build_runner`
- Alguns avisos (warnings) podem permanecer, mas não impedem a execução

## ⚠️ Se ainda houver problemas

1. Limpe o projeto: `flutter clean`
2. Reinstale dependências: `flutter pub get`
3. Execute novamente os comandos de geração

