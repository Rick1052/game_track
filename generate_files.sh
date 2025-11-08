#!/bin/bash
echo "Gerando arquivos Freezed e Localizações..."
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
echo "Concluído!"

