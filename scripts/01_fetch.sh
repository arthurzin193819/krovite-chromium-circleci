#!/usr/bin/env bash
set -Eeuo pipefail
mkdir -p "$HOME/chromium"
cd "$HOME/chromium"
df -h "$HOME"
[[ "$(uname -m)" == x86_64 ]] || { echo 'ERRO: runner não é x86-64'; exit 11; }
if [[ ! -d depot_tools ]]; then
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
export PATH="$HOME/chromium/depot_tools:$PATH"
if [[ ! -d src ]]; then
  fetch --no-history --nohooks android
else
  echo 'Checkout existente; não baixarei outra cópia.'
fi
[[ -d src && -f .gclient ]] || { echo 'ERRO: checkout Chromium incompleto'; exit 12; }
cat src/README.md >/dev/null || true
printf 'Chromium src commit: '
git -C src rev-parse HEAD
printf '\nTamanho: '; du -sh "$HOME/chromium" || true
