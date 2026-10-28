# Krovite — experimento Chromium Android no CircleCI Free

O projeto tenta compilar `chrome_public_apk` para Android ARM64 no CircleCI. Nenhum APK foi produzido ou testado ainda.

## Por que a pipeline foi corrigida

A configuração anterior continha 12 caches de `~/chromium`, com dezenas de GB cada. Isso poderia esgotar o armazenamento/créditos gratuitos. **Todos os caches, workspaces e 10 estágios foram removidos.** O CircleCI Free limita cada job a 1 hora, então dividir a compilação em jobs sem armazenar o checkout não preserva o progresso. Não existe, nesta configuração, compilação incremental entre jobs.

## Uso pelo celular

1. Entre em https://app.circleci.com/ com sua conta GitHub e configure este repositório usando `.circleci/config.yml` da branch `main`.
2. A primeira pipeline dispara somente `validate`: verifica a sintaxe Bash e o checkout do projeto; não baixa Chromium e não executa compilação.
3. Se quiser **tentar compilar**, em CircleCI acesse *Trigger Pipeline* para este projeto e branch `main`, escolha *Add Parameters* e configure `build_chromium` (boolean) = `true`. Isso executa o job `compile_chromium`.
4. Acompanhe os logs. Se o APK for produzido, ele será enviado para os Artifacts como `ChromiumAndroid-arm64.apk`.

## Limitações documentadas

- A máquina `large` usa Linux x86-64 com aproximadamente 4 vCPUs, 15 GB RAM e 150 GB de disco.
- **Cada job Free dura no máximo 1 hora.** O trabalho de baixar, configurar e compilar o Chromium do zero provavelmente ultrapassa esse limite, especialmente com 4 vCPUs.
- **Não há checkpoint entre execuções.** A configuração evita caches enormes, mas não resolve a necessidade de persistência para uma compilação longa.
- A execução de compilação é intencionalmente manual (parâmetro falso por padrão) para não consumir créditos por cada push.
- Nenhuma promessa de APK final ou de término dentro da cota gratuita.
- Se o build falhar ou o limite terminar, seu job deve falhar: não existe PASS fictício nem APK falso.
- O resultado, se compilado, será Chromium Android original; a personalização Krovite ainda não foi feita.

Documentação: https://chromium.googlesource.com/chromium/src/+/HEAD/docs/android_build_instructions.md ; https://circleci.com/docs/reference/configuration-reference/ ; https://circleci.com/pricing/
