@echo off
echo Gerando arquivos Freezed e Localizacoes...
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
echo Concluido!

