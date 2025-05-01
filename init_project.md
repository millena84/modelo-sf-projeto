
# init_project.md - Criação/Uso do Ambiente Salesforce

  

### 🔖 Versões
| Versão | Data | Descrição |
|--------|------------|------------------------------------|
| v01 | 01/05/2025 | Criação do passo a passo inicial |

 
---

  

## 🚩 Premissas

1. Ter usuário no GitHub.
2. Ter uma organização Salesforce (playground ou Developer Edition):
- Caso deseje usar scratch org, a DevHub deve estar habilitada.
3. Ter o VSCode instalado:
- Criar pasta para projetos VSCode.
- Criar subpasta para projeto Salesforce.
4. Ter um repositório Git criado para o projeto Salesforce.
5. Ter Git configurado na máquina com Git Bash instalado. 
> Obs: Configure nome e email do Git (se ainda não configurado):
    
    git config --global user.name "Seu Nome"
    git config --global user.email "seu@email.com"  

---

## 👣 Passo a Passo

### Lista:

1. Abrir o VSCode na pasta do projeto Salesforce.
2. Clonar o repositório: `git clone URL_REPO_AQUI`
3. Configurar arquivos essenciais:
-  `config_init.json` (obrigatório)
-  `model_project-scratch-def.json` (se usar scratch org)
-  `model_package.xml` (se usar retrieve/deploy)

4. Executar os scripts:

-  `create_proj_scratch_org.sh` → cria projeto, autoriza org e scratch org.
-  `create_project_org.sh` → cria projeto e autoriza org (opcional).
-  `create_doc_struc.sh` → cria estrutura de documentação (opcional).

---
 

### 🔍 Visual 

🚩 Premissas:
[ 0.1 - Criar usuário GitHub - web ]
			⬇️
[ 0.2 - Criar organização Salesforce - web ]
			⬇️
[ 0.2.1 - Autorizar DevHub - web ]
			⬇️
[ 0.3 - Instalar VSCode - web/terminal ]
			⬇️
[ 0.3.1 - Criar pasta de projetos ]
			⬇️
[ 0.3.2 - Criar pasta do projeto SF - local/terminal ]
			⬇️
[ 0.4 - Criar repositório Git - web ]
			⬇️
[ 0.5 - Instalar Git Bash e configurar Git - terminal ]

👣 Passos:
[ 1 - Abrir VSCode na pasta do projeto SF ]
			⬇️
[ 2 - Clonar repositório modelo ]
			⬇️
[ 3 - Configurar arquivos ]
			⬇️
[ 4.1 - config_init.json ]
			⬇️
[ 4.2 - model_project-scratch-def.json ]
			⬇️
[ 4.3 - model_package.xml ]
			⬇️
[ 5.1 - Executar create_proj_scratch_org.sh ]
			⬇️
[ 5.2 - Executar create_project_org.sh ]
			⬇️
[ 5.3 - executar create_doc_struc.sh ]  🔚


### 🧱Estrutura do repositório clonado

Após o clone, será criada na raiz do diretório do seu projeto salesforce isso aqui:

📂_init_project/
├── 🖥️auth_org_sf.sh [aliasOrg] {futuro}
├── ⚙️config_init.json
├── 🖥️create_doc_struct.sh [localProjectPath]
├── 🖥️create_proj_scratch_org.sh [aliasOrg;aliasScratchOrg]
├── 🖥️create_project_org.sh [aliasOrg]
├── 📄init_steps.md
├── ⚙️model-package.xml
└── ⚙️model_project-scratch-def.json

  

### ⚙️Sobre as configurações
#### 4.1. Configurar: config_init.json
Essas informações serão usadas nos scripts de criação dos ambientes.

    {
	    "orgAlias": "Alias da sua organizacao",
	    "scratchOrgAlias": "Alias da sua scratch org",
	    "defaultBranchGit": "B0001-v00-project-structure",
	    "manifestPath": "manifest/package.xml",
	    "scratchDefPath": "config/project-scratch-def.json",
	    "urlGitProject": "https://github.com/millena84/modelo-sf-projeto.git"
    }
 

### 4.2. Configurar: model_project-scratch-def.json
#### O que é esse arquivo?
O arquivo usado de referência para criar/definir que funcionalidades você quer disponível na sua Scratch Org.

#### O que significam os campos?
| Recurso (Feature/Setting) | Descrição |
|:----------------------------|:--------------------------------------------------------------------------------|
| AuthorApex | Permite o uso de Apex na org (código personalizado). |
| API | Habilita acesso à API do Salesforce para integração. |
| Communities | Ativa o Experience Cloud (antigo Communities). |
| ContactsToMultipleAccounts | Permite relacionar um contato a várias contas. |
| DebugApex | Permite a depuração (debug) de código Apex. |
| DevelopmentWave | Recursos antigos do Wave Analytics (CRM Analytics). |
| MarketingUser | Flag de permissão para uso de recursos de marketing (exige configuração extra). |
| MultiCurrency | Permite múltiplas moedas na organização. |
| PersonAccounts | Ativa uso de contas do tipo pessoa física. |
| PlatformEncryption | Ativa criptografia em nível de plataforma. |
| RecordTypes | Habilita uso de tipos de registro nos objetos. |
| ServiceCloud | Flag genérica para funcionalidades do Service Cloud. |
| StateAndCountryPicklist | Ativa listas de seleção para estado/país. |
| Workflow | Ativa uso de regras de workflow. |
| EnableSetPasswordInApi | Permite definir senha via API. |
| BatchManagement | Permite gerenciamento de lotes (em jobs assíncronos). |
| FieldAuditTrail | Mantém histórico completo de alterações em campos (recurso premium). |
| SalesCloudEinstein | Ativa funcionalidades do Sales Cloud Einstein. |
| DevOpsCenter | Ativa o Salesforce DevOps Center. |
| ForceComPlatform | Core da plataforma Salesforce para uso de apps e objetos. |
| CustomNotificationType | Permite definir tipos de notificações customizadas. |
| Chatbot | Ativa o Einstein Bot (Chatbot em canais digitais). |
| CaseClassification | Ativa classificação de casos com AI. |
| SharedActivities | Permite atividades (eventos/tarefas) compartilhadas com vários contatos. |
| Knowledge | Ativa o uso do objeto Knowledge (base de conhecimento). |
| Sites | Ativa o uso do recurso de Sites públicos. |
| FlowSites | Permite execução de flows via Sites. |
| Functions | Ativa Salesforce Functions (funções serverless). |
| Entitlements | Ativa recursos de SLA e gerenciamento de contratos de serviço. |
| PipelineInspection | Recurso de análise de pipeline de vendas com Einstein. |
| orgPreferenceSettings | Configurações gerais de preferências da organização. |
| apexSettings | Configurações relacionadas ao uso do Apex. |
| lightningExperienceSettings | Habilita o Lightning Experience. |
| chatterSettings | Ativa o Salesforce Chatter. |
| flowsSettings | Configurações de execução de Flow. |
| securitySettings | Políticas de segurança, como senha mínima. |
| sharingSettings | Configurações de modelo de compartilhamento. |
| emailSettings | Configurações gerais de e-mail (como Email-to-Case). |
| knowledgeSettings | Configurações para ativar e gerenciar o Salesforce Knowledge. |
| opportunitySettings | Configurações de Oportunidades, como equipe de vendas. |
| accountSettings | Configurações de contas, como times de conta. |
| contactsSettings | Configurações de contatos, como múltiplas contas. |
| mobileSettings | Configurações relacionadas a dispositivos móveis. |
| emailAdministrationSettings | Administração de políticas de e-mail. |
| languageSettings | Configuração do Translation Workbench. |
| customSettings | Permite uso de Custom Settings. |
| caseSettings | Configurações de casos e Email-to-Case. |
| serviceCloudSettings | Habilita funcionalidades do Service Cloud. |
| fieldServiceSettings | Ativa funcionalidades do Field Service. |
| dataCloudSettings | Ativa funcionalidades do Salesforce Data Cloud. |
  

#### 4.3. Configurar: model_package.xml
##### O que é esse arquivo?
O arquivo de referência para quando você for fazer retrieve (tem essa opção na criação), você precisa indicar aqui do que quer fazer retrieve. O mesmo vale para deploy sf via terminal.

##### O que significam os campos?
| Tipo de Metadado (package.xml) | Descrição |
|:---------------------------------|:-------------------------------------------------------------------|
| ApexClass | Classes escritas em Apex. |
| ApexComponent | Componentes Visualforce personalizados. |
| ApexPage | Páginas Visualforce. |
| ApexTrigger | Triggers Apex ativadas por eventos em objetos. |
| AssignmentRules | Regras de atribuição de registros (como Cases). |
| AuraDefinitionBundle | Componentes Aura. |
| AutoResponseRules | Regras de resposta automática (principalmente para Cases). |
| BusinessProcess | Processos de negócio vinculados a objetos padrão como Opportunity. |
| CallCenter | Configurações de Call Center. |
| CustomApplication | Apps personalizados no App Launcher. |
| CustomMetadata | Tipos de metadados personalizados. |
| CustomObject | Objetos customizados. |
| CustomObjectTranslation | Traduções de objetos personalizados. |
| CustomPermission | Permissões personalizadas. |
| CustomSite | Sites públicos do Salesforce. |
| Dashboard | Painéis (Dashboards) criados no sistema. |
| Document | Documentos armazenados na aba 'Documentos'. |
| EmailTemplate | Modelos de e-mail. |
| EscalationRules | Regras de escalonamento (principalmente para Cases). |
| Flow | Automatizações criadas no Flow Builder. |
| GlobalValueSet | Conjuntos de valores globais reutilizáveis. |
| Group | Grupos públicos. |
| HomePageComponent | Componentes de homepage clássica. |
| HomePageLayout | Layouts de homepage clássica. |
| Layout | Layouts de página dos objetos. |
| LightningComponentBundle | Componentes Lightning Web Components (LWC). |
| MatchingRules | Regras de correspondência (matching). |
| Network | Sites Experience Cloud (antigas comunidades). |
| PermissionSet | Conjuntos de permissões. |
| PermissionSetGroup | Agrupamentos de permission sets. |
| Profile | Perfis de usuário. |
| Queue | Filas de encaminhamento de registros. |
| RecordType | Tipos de registro. |
| RemoteSiteSetting | Domínios externos aprovados. |
| Report | Relatórios criados no sistema. |
| ReportType | Tipos de relatório customizados. |
| Role | Funções hierárquicas. |
| SharingRules | Regras de compartilhamento. |
| StaticResource | Recursos estáticos (JS, CSS, imagens, etc). |
| Translations | Traduções personalizadas. |
| ValidationRule | Regras de validação. |
| Workflow | Regras de Workflow. |
| WorkflowRule | Regra de workflow individual. |
| Weblink | Botões e links customizados. |
 

---

## 💻Sobre a criação dos ambientes
### 5.1. Execução shell: create_proj_scratch_org.sh
#### O que esse script faz?
Em linhas gerais, ele faz todas criação do projeto (sfdx/sf), scratch org para desenvolvimento e documenta numa branch inicial do git.

##### Detalhe do que ele cria:
OBS: falta auttorizar dev hub Criar DevHub via Shell

1. Cria projeto SF local no diretório do arquivo de configuração
2. Conecta na org do arquivo de configuração
3. Cria scratch org
4. Opção de fazer ou não retrieve
5. Opção de importar ou não dados
6. Conecta no repositório git
7. Cria o arquivo .gitattributes para limpar quebra de linha windows
8. Cria branch para subida da estrutura atual para o repostório do arquivo de configuração
9. Faz todos os trâmites de subida nessa branch:
	1. Aponta para essa branch
	2. Faz stage (git init)
	3. Faz commit com mensagem padrão informando a definição da estutura
	4. Faz o push
	5. Volta para a branch master
10. Faz todos os trâmites de merge da branch de criação de ambiente para a master
	1. Aponta para a branch master
	2. Sincroniza local e remoto (git pull)
	3. Faz o merge da branch de criação de ambiente para a master
	4. Faz o commit (?)
	5. Faz o push
	6. Deleta branch de criação de ambiente do git local
11. Abre scratch org criada para manipulação.

 #### Como executar?
Passo 1) Na raiz do projeto, rodar no terminal esse comando para dar permissão de execução no script:

    chmod +x create_proj_scratch_org.sh

Passo 2) Executar o script:

     ./create_proj_scratch_org.sh


### 5.2. Execução shell: create_project_org.sh
EM CONSTRUÇÃO
 

### 5.3. Execução shell: create_proj_scratch_org.sh
#### O que esse script faz?
Cria a estrutura de diretórios que vai comportar a documentação.

OBS:. só serão necessário se vc só trouxe o diretório _init_project. Se trouxe toda estrutura do repo, já contempla esses diretórios

  

## 📂Como deve ficar a estrutura de diretórios final?
_docs/
├── logs/
│ ├── json/
│ │ ├── audit-package-xml.json
│ │ └── audit-audit-trails.json
│ ├── md/
│ │ ├── audit-package-xml.md
│ │ └── audit-audit-trails.md
├── scripts/
│ ├── env/ # variáveis de ambiente, configurações locais
│ ├── devel/ # scripts para retrieve, análise, diff
│ └── doc/ # scripts para gerar documentação
├── tests/ # (opcional) testes dos scripts de auditoria ou CI
└── org/
├── obj/
│ ├── custom/ # objetos customizados
│ └── standard/ # objetos padrão (ex: Account, Contact)
├── code/
│ ├── class/ # Apex classes
│ ├── trigger/ # Apex triggers
├── api/ # NamedCredentials, ExternalServices, mocks
└── components/
├── aura/ # Aura components
├── lwc/ # Lightning Web Components
├── vf/ # Visualforce pages e components
└── standard/ # componentes padrão customizados

_init_project/
├── auth_org_sf.sh [config_init.json.prop.aliasOrg {futuro}]
├── config_init.json
├── create_doc_struct.md [config_init.json.prop.localProjectPath]
├── create_proj_scratch_org.sh [config_init.json.prop.aliasOrg;config_init.json.prop.aliasScratchOrg]
├── create_project_org.sh [config_init.json.prop.aliasOrg]
├── init_steps.md
├── model-package.xml
└── model_project-scratch-def.json

  

NOTA EXTRA: init_project precisara ser clonada do git dentro de uma pasta de projeto que seria o projeto SF, e na criacao, o comando deve considerar isso

> Documento revisado conforme boas práticas, com foco em clareza, sequência lógica e legibilidade para novos usuários.
