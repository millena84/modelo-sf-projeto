#!/bin/bash
set -euo pipefail

# === Funções utilitárias ===
info()    { echo -e "\033[1;34m[INFO] $*\033[0m"; }
warn()    { echo -e "\033[1;33m[AVISO] $*\033[0m"; }
error()   { echo -e "\033[1;31m[ERRO] $*\033[0m"; }
success() { echo -e "\033[1;32m[✔] $*\033[0m"; }

# === 1. Verifica CLI 'sf' ===
if ! command -v sf &> /dev/null; then
  error "A CLI 'sf' não está instalada. Instale via npm ou brew antes de continuar."
  exit 1
fi

info "Versão da CLI: $(sf --version)"

# === 2. Verifica Node.js ===
if ! command -v node &> /dev/null; then
  error "Node.js não encontrado. É necessário para processar o JSON de configuração."
  exit 1
fi

info "Versão do Node.js: $(node -v)"

# === 3. Verifica se comandos essenciais estão disponíveis via sf help ===
info "Verificando comandos essenciais disponíveis na CLI..."

REQUIRED_COMMANDS=(
  "org login"
  "org list"
  "data export"
  "project generate"
)

MISSING_COMMANDS=()

for cmd in "${REQUIRED_COMMANDS[@]}"; do
  if ! sf help $cmd &>/dev/null; then
    MISSING_COMMANDS+=("$cmd")
  fi
done

if [ ${#MISSING_COMMANDS[@]} -eq 0 ]; then
  success "Todos os comandos necessários estão disponíveis na CLI. ✅"
else
  warn "Comandos ausentes (plugins podem estar faltando):"
  for cmd in "${MISSING_COMMANDS[@]}"; do
    echo " - sf $cmd"
  done
  echo ""
  read -rp "Deseja instalar agora os plugins recomendados? (s/n): " install_resp
  if [[ "$install_resp" == "s" ]]; then
    sf plugins install @salesforce/plugin-org
    sf plugins install @salesforce/plugin-data
    sf plugins install @salesforce/plugin-dev
    sf plugins install @salesforce/plugin-source
    success "Plugins instalados com sucesso!"
  else
    error "Plugins essenciais não instalados. A execução pode falhar."
    exit 1
  fi
fi

# === 4. Verifica arquivo de configuração principal ===
CONFIG_FILE="_11_config_org.json"
if [ ! -f "$CONFIG_FILE" ]; then
  error "Arquivo de configuração '$CONFIG_FILE' não encontrado no diretório atual."
  exit 1
fi
info "Arquivo de configuração encontrado: $CONFIG_FILE"

# === 4.1 Verifica arquivos obrigatórios e mostra última modificação ===
REQUIRED_FILES=(
  "_11_config_org.json"
  "_21_model_sfdx-project.json"
  "_22_model_package.xml"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    error "Arquivo obrigatório '$file' não encontrado!"
    exit 1
  else
    mod_time=$(date -d @"$(stat -c %Y "$file")" "+%d/%m/%Y %H:%M:%S")
    success " ❱❱ Arquivo '$file' encontrado. Última modificação: $mod_time"
  fi
done

# === 5. Lê dados do JSON de configuração ===
ORG_ALIAS=$(node -e "console.log(require('./$CONFIG_FILE').infoOrg.alias)")
PROJECT_ALIAS=$(node -e "console.log(require('./$CONFIG_FILE').infoOrg.aliasProject)")
PROJECT_PATH=$(node -e "console.log(require('./$CONFIG_FILE').infoOrg.localProjectPath)" | tr -d '\r\n' | sed 's|\\|/|g')

info "Alias da organização: $ORG_ALIAS"
info "Alias do projeto: $PROJECT_ALIAS"
info "Caminho esperado do projeto: $PROJECT_PATH"

# === 6. Normaliza diretório atual ===
CURRENT_DIR=$(cd . && pwd -W 2>/dev/null || pwd)
CURRENT_DIR=$(echo "$CURRENT_DIR" | sed 's|\\|/|g')

# === 7. Compara diretórios ===
if [[ "$CURRENT_DIR" != "$PROJECT_PATH" ]]; then
  warn "Você está em '$CURRENT_DIR', mas o esperado é '$PROJECT_PATH'."
  read -rp "Deseja continuar mesmo assim? (s/n): " continuar
  [[ "$continuar" != "s" ]] && exit 1
fi

# === 8. Verifica se a org está conectada ===
info "Verificando se a org '$ORG_ALIAS' já está autenticada..."
if sf org list | grep -q "$ORG_ALIAS"; then
  success "Org '$ORG_ALIAS' já conectada."
else
  warn "Org '$ORG_ALIAS' não encontrada nas conexões ativas."
  read -rp "Deseja tentar logar agora com device flow? (s/n): " resp
  if [[ "$resp" == "s" ]]; then
    sf org login device --alias "$ORG_ALIAS"
  else
    error "Org não conectada. Cancelando verificação."
    exit 1
  fi
fi

# === 9. Simulação do comando de criação de projeto ===
info "Simulando comando de criação de projeto (sem executar)..."
echo "Comando simulado:"
echo "sf project generate --name \"$PROJECT_ALIAS\" --template standard"

success "✅ Verificação concluída com sucesso. Ambiente pronto para execução do script de criação!"
