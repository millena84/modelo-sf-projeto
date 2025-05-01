#!/bin/bash

function info {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}
function success {
  echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}
function error {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
}

CONFIG_FILE="config_init.json"
if [ ! -f "$CONFIG_FILE" ]; then
  error "Arquivo $CONFIG_FILE não encontrado!"
  exit 1
fi
orgAlias=$(jq -r '.orgAlias' $CONFIG_FILE)
scratchOrgAlias=$(jq -r '.scratchOrgAlias' $CONFIG_FILE)
defaultBranchGit=$(jq -r '.defaultBranchGit' $CONFIG_FILE)
manifestPath=$(jq -r '.manifestPath' $CONFIG_FILE)
scratchDefPath=$(jq -r '.scratchDefPath' $CONFIG_FILE)
urlGitProject=$(jq -r '.urlGitProject' $CONFIG_FILE)

info "Criando projeto Salesforce..."
sf project generate --name "$orgAlias" --template standard
cd "$orgAlias" || exit

info "Autorizando DevHub..."
sf org login web --set-default-dev-hub --alias "$orgAlias"

info "Criando Scratch Org..."
sf org create scratch --definition-file "$scratchDefPath" --set-default --duration-days 7 --alias "$scratchOrgAlias"

read -p "Deseja fazer retrieve dos metadados (y/n)? " doRetrieve
if [[ "$doRetrieve" == "y" ]]; then
  sf project retrieve start --manifest "$manifestPath"
fi

read -p "Deseja importar dados (y/n)? " doImport
if [[ "$doImport" == "y" ]]; then
  info "Importando dados..."
  sf data import tree --plan data/data-plan.json
fi

info "Inicializando Git..."
git init
git remote add origin "$urlGitProject"
echo "* text=auto eol=lf" > .gitattributes

git checkout -b "$defaultBranchGit"
git add .
git commit -m "chore(init): definição da estrutura inicial do projeto"
git push -u origin "$defaultBranchGit"

git checkout master
git pull origin master || true
git merge "$defaultBranchGit"
git push origin master
git branch -d "$defaultBranchGit"

sf org open --target-org "$scratchOrgAlias"

success "Projeto criado e ambiente configurado com sucesso!"
