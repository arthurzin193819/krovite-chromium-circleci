#!/usr/bin/env bash
set -Eeuo pipefail
export PATH="$HOME/chromium/depot_tools:$PATH"
cd "$HOME/chromium/src"
[[ -f out/Krovite/build.ninja || -f out/Krovite/build.ninja.stamp ]] || { echo 'ERRO: GN não foi restaurado do cache'; exit 14; }
mkdir -p "$HOME/project/output"
APK=out/Krovite/apks/ChromePublic.apk
if [[ ! -s "$APK" ]]; then
  echo "Compilação real: autoninja -j 2 -C out/Krovite chrome_public_apk"
  echo 'Limite local deste estágio: 35 minutos, reservando tempo para salvar o checkpoint.'
  set +e
  timeout --signal=INT --kill-after=25s 35m autoninja -j 2 -C out/Krovite chrome_public_apk
  rc=$?
  set -e
  case "$rc" in
    0) echo 'Compilador retornou sucesso.' ;;
    124|130) echo 'Estágio interrompido pelo orçamento de tempo; próximo job retoma o build.' ;;
    *) echo "FALHA REAL no compilador (exit $rc); consultar log do job." >&2; exit "$rc" ;;
  esac
fi
if [[ -s "$APK" ]]; then
  cp -f "$APK" "$HOME/project/output/ChromiumAndroid-arm64.apk"
  sha256sum "$HOME/project/output/ChromiumAndroid-arm64.apk" | tee "$HOME/project/output/SHA256SUMS.txt"
  echo 'APK REAL GERADO! Encontrar em Artifacts do job.'
else
  echo 'Ainda sem APK. Checkpoint de compilação será salvo no cache.'
fi
du -sh "$HOME/chromium" || true
df -h "$HOME" || true
