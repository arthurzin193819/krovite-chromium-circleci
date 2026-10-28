#!/usr/bin/env bash
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive
export PATH="$HOME/chromium/depot_tools:$PATH"
cd "$HOME/chromium/src"
[[ -d build && -f ../.gclient ]] || { echo 'ERRO: checkout Chromium inexistente ou incompleto'; exit 13; }
# O script Android instala as dependências Linux e específicas do Android.
bash build/install-build-deps-android.sh

gclient runhooks
mkdir -p out/Krovite
cat > out/Krovite/args.gn <<'GN'
target_os = "android"
target_cpu = "arm64"
is_debug = false
is_component_build = false
symbol_level = 0
use_remoteexec = false
GN
gn gen out/Krovite
printf '\nConfiguração Android ARM64 concluída.\n'
df -h "$HOME"
