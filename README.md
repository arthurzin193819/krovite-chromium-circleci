# Krovite - tentativa de compilação Chromium Android ARM64 no CircleCI Free

Este repositório contém uma pipeline que realmente tenta executar a compilação oficial
`autoninja -j 2 -C out/Krovite chrome_public_apk`.

## Usar pelo celular
1. No navegador Android, abra https://app.circleci.com/ e entre usando seu GitHub.
2. Escolha a organização e configure o projeto público `krovite-chromium-build` no plano Free.
   Se usou outro nome, selecione esse nome.
3. Habilite a pipeline; ela é iniciada por alterações na branch `main` (ou clique em Trigger Pipeline).
4. Acompanhe os jobs `fetch_source`, `configure_source`, `compile_01` ... .
5. Se aparecer `ChromiumAndroid-arm64.apk` nos artifacts de algum job, baixe-o no celular.

## Limites reais
- CircleCI Free oferece Linux VM large com 4 vCPUs, ~15 GB RAM, 150 GB disco.
- Cada job tem limite de 1 hora. A pipeline divide a compilação e usa caches grandes.
- Cache de dezenas de gigabytes pode demorar demais ou ser rejeitado. Não há garantia de conclusão.
- Créditos gratuitos e cotas de armazenamento podem ser consumidos e bloquear a pipeline.
- O repo criado contém apenas os scripts de CI: o Chromium é obtido diretamente do upstream.
- O resultado é Chromium original para Android, ainda **não** Krovite personalizado.
- Nenhum APK está pronto antes de um job realmente concluir com sucesso.

Fontes:
https://chromium.googlesource.com/chromium/src/+/main/docs/android_build_instructions.md
https://circleci.com/docs/reference/configuration-reference/
https://circleci.com/pricing/
