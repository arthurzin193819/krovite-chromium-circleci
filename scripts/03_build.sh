#!/usr/bin/env bash
set -Eeuo pipefail
export PATH="$HOME/chromium/depot_tools:$PATH"
cd "$HOME/chromium/src"
[[ -f out/Krovite/build.ninja || -f out/Krovite/build.ninja.stamp ]] || { echo 'ERRO: saída GN não existe'; exit 14; }
mkdir -p "$HOME/project/output"
echo 'Compilação real: autoninja -j 3 -C out/Krovite chrome_public_apk'
# Não silenciar erros nem tratar timeout como sucesso.
autoninja -j 3 -C out/Krovite chrome_public_apk

APK='out/Krovite/apks/ChromePublic.apk'
[[ -s "$APK" ]] || { echo "ERRO: build terminou, mas APK esperado não existe: $APK" >&2; find out/Krovite -name '*.apk' -type f | head -20; exit 16; }
cp -f "$APK" "$HOME/project/output/ChromiumAndroid-arm64.apk"
cd "$HOME/project/output"
sha256sum ChromiumAndroid-arm64.apk > SHA256SUMS.txt
ls -lh ChromiumAndroid-arm64.apk SHA256SUMS.txt
