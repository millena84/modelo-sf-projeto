#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Script: _20_create_project_sf.sh
# Descrição: Inicializa ambiente Salesforce com base em um JSON de configuração
# Autor: Millena Ferreira dos Reis
# Data de criação: 2025-05-05
# Versão: 1.0.0
# -----------------------------------------------------------------------------

# === Configurações iniciais ===
set -euo pipefail
IFS=$'\n\t'

# === Constantes ===
CONFIG_FILE="_11_config_org.json"


# === Funções utilitárias para mostrar no termianl ===
head()    { echo -e "\033[1;36m| $*\033[0m"; }
info()    { echo -e "\033[1;34m| [ INFO ] ❱❱❱ $*\033[0m"; }
warn()    { echo -e "\033[1;33m| [ ⚠ ] $*\033[0m"; }
error()   { echo -e "\033[1;31m| [ ✖ ] $*\033[0m"; }
success() { echo -e "\033[1;32m| [ ✔ ] $*\033[0m"; }


# # === recepcao json _10_config_org.json ===
get_json_value() {
  node -e "console.log(require('./$CONFIG_FILE').$1)"
}


# # === timestamp para log no terminal ===
timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# # === modelos dos arquivos de configuração projeto e retrieve (futuro) ===
MODEL_SFDX="_21_model_sfdx-project.json"
MODEL_MANIFEST="_22_model_package.xml"


# # === cabeçalho script ===
head "══════════════════════════════════════════════════════════════"
head " 🏁 INICIANDO PROCESSO DE CRIAÇÃO AUTOMATIZADA SALESFORCE - [$(timestamp)]"
head "══════════════════════════════════════════════════════════════"
info "| ❱❱❱❱❱❱❱ SUGESTÃO: Faça login na organização em questão via web."
info "|                  Normalmente, facilita o processo de autenticação."
echo "|"


# # === Leitura do _config_org.json ===
BASE_PATH="$(cd "$(dirname "$0")" && pwd)"
## ===>>>> Informações para projeto x organização/sandbox <<<<=== ##
INFO_ORG_ALIAS=$(get_json_value infoOrg.alias)
INFO_ORG_ALIAS_PROJ=$(get_json_value infoOrg.aliasProject)
INFO_ORG_URL_LOGIN=$(get_json_value infoOrg.urlLogin)
INFO_ORG_USR_LOGIN=$(get_json_value infoOrg.username)
INFO_ORG_MANIFEST_PATH=$(get_json_value infoOrg.manifestPath)
EXPECTED_PATH=$(get_json_value infoOrg.localProjectPath | tr -d '\r\n'| sed 's|\\|/|g')
## ===>>>> Informações para projeto x DevHub x Scratch Org <<<<=== ##
INFO_DHSO_ALIAS=$(get_json_value infoDevHub.alias)
INFO_DHSO_ALIAS_PROJ=$(get_json_value infoDevHub.aliasProject)
INFO_ORG_MANIFEST_PATH=$(get_json_value infoDevHub.manifestPath)
SCRATCH_DEF_PATH=$(get_json_value infoDevHub.scratchDefPath | tr -d '\r\n'| sed 's|\\|/|g')


# # === Checa diretório atual ===
CURRENT_PATH=$(pwd -W 2>/dev/null || pwd)
CURRENT_PATH=$(echo "$CURRENT_PATH" | sed 's|\\|/|g')

head "|------------------------------------------------------------"
head "| [ ⛿ ] - Checando configurações json..."
head "|------------------------------------------------------------"
echo "|"
info " ❱❱❱❱❱❱❱ Diretório atual: $CURRENT_PATH"
info " ❱❱❱❱❱❱❱ Diretório esperado: $EXPECTED_PATH"
echo "|"

if [[ "$CURRENT_PATH" != "$EXPECTED_PATH" ]]; then
  warn "| Diretório atual é diferente do esperado no JSON."
  info "|  Esperado: $EXPECTED_PATH"
  info "|  Atual:    $CURRENT_PATH"
  read -rp "|  ❱❱❱❱❱❱❱ Deseja continuar mesmo assim? (s/n) ❱ " answer
  [[ "$answer" != "s" ]] && error "Execução cancelada pelo usuário." && exit 1
fi


head "|------------------------------------------------------------"
head "| [ ⛿ ] - Iniciando antenticação organização..."
head "|------------------------------------------------------------"

# # === Autenticação na org Salesforce ===
info "Autenticando organização com alias '$INFO_ORG_ALIAS'..."
info ">>> SUGESTÃO: Se você ainda não fez login via web, use uma janela anônima <<<"
echo "|"

if sf org login device --alias "$INFO_ORG_ALIAS" --instance-url "$INFO_ORG_URL_LOGIN" --set-default; then
  sf config set target-org "$INFO_ORG_ALIAS"
  success "Organização autenticada com sucesso!"
  echo "|"
else
  error "❱❱❱ Falha no login. Verifique o navegador ou tente novamente com uma aba anônima."
  exit 1
fi


head "|------------------------------------------------------------"
head "| [ ⛿ ] - Iniciando criação projeto Salesforce..."
head "|------------------------------------------------------------"
echo "|"

info "⛏  Criando projeto Salesforce ..."
info " ❱❱❱❱❱❱❱ Criando projeto alias = $INFO_ORG_ALIAS_PROJ"
echo "|"

if sf project generate --name "$(basename "$PWD")" --template standard; then
  success "Projeto criado com sucesso com alias $INFO_ORG_ALIAS_PROJ definido como padrão!"
  echo "|"
else
  error "❱❱❱ Falha ao criar o projeto Salesforce '$INFO_ORG_ALIAS_PROJ'"
  exit 1
fi


info "⛏  Substituindo arquivos com modelos personalizados..."
echo "|"
for file in "MODEL_SFDX" "MODEL_MANIFEST"; do
  if [ ! -f "$BASE_PATH/$file" ]; then
    error "Arquivo obrigatório '$BASE_PATH/$file' não foi encontrado. Verifique se está no diretório correto."
    exit 1
  fi
done


cp "$BASE_PATH/MODEL_SFDX" "sfdx-project.json"
# cp "$BASE_PATH/model_project-scratch-def.json" $scratchDefPath"
# cp "$BASE_PATH/_init_project/.gitattributes" .
mkdir -p "$(dirname "$INFO_ORG_MANIFEST_PATH")"
cp "$BASE_PATH/MODEL_MANIFEST" "$INFO_ORG_MANIFEST_PATH"

mod_time=$(date -d @"$(stat -c %Y "$BASE_PATH/manifest/package.xml")" "+%d/%m/%Y %H:%M:%S")
success " ❱❱ Última modificação /manifest/package.xml: $mod_time"

mod_time=$(date -d @"$(stat -c %Y sfdx-project.json)" "+%d/%m/%Y %H:%M:%S")
success " ❱❱ Última modificação sfdx-project.json: $mod_time"
