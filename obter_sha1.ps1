# Script para obter o SHA-1 fingerprint do Android
# Execute: .\obter_sha1.ps1

Write-Host "Obtendo SHA-1 fingerprint..." -ForegroundColor Green
Write-Host ""

# Tentar obter via gradlew
if (Test-Path "android\gradlew.bat") {
    Write-Host "Tentando obter via Gradle..." -ForegroundColor Yellow
    Set-Location android
    .\gradlew signingReport 2>&1 | Select-String -Pattern "SHA1" -Context 2,2
    Set-Location ..
    Write-Host ""
}

# Obter via keytool
Write-Host "Obtendo via keytool..." -ForegroundColor Yellow
$keystorePath = "$env:USERPROFILE\.android\debug.keystore"

if (Test-Path $keystorePath) {
    keytool -list -v -keystore $keystorePath -alias androiddebugkey -storepass android -keypass android | Select-String -Pattern "SHA1"
} else {
    Write-Host "Keystore não encontrado em: $keystorePath" -ForegroundColor Red
    Write-Host "Execute 'flutter build apk' primeiro para criar o keystore." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Copie o SHA-1 acima e adicione no Firebase Console:" -ForegroundColor Green
Write-Host "https://console.firebase.google.com/project/gametrack-d20a7/settings/general" -ForegroundColor Cyan




