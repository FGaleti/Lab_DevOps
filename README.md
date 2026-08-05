# Lab_DevOps

Projeto de laboratório prático de DevOps que integra containerização, Infrastructure as Code (IaC) e um pipeline de CI/CD completo, incluindo deploy automatizado com rollback. O objetivo é demonstrar, em um único repositório, o ciclo de vida de uma aplicação desde o código até a execução em produção na AWS.

O projeto adapta a metodologia do laboratório "DevOps na Prática", desenvolvido por Maria Lazara, consolidando as etapas propostas (containerização, IaC e CI/CD) em uma implementação única e integrada.

## Visão geral

A aplicação é um site estático (HTML, CSS e JavaScript) empacotado em uma imagem Docker baseada em Nginx. A infraestrutura de execução é provisionada na AWS via Terraform, e a esteira de integração e entrega contínua é implementada com GitHub Actions, cobrindo build, testes automatizados de fumaça, publicação de imagem e deploy com verificação de saúde e rollback automático em caso de falha.

## Estrutura do repositório

```
Lab_DevOps/
├── .github/
│   └── workflows/
│       ├── ci.yaml                 # Integração contínua: build e smoke test
│       ├── cd.yaml                 # Entrega contínua: build, push e deploy
│       └── validando-runner.yaml   # Diagnóstico do runner self-hosted
├── app/
│   ├── index.html
│   ├── css/
│   │   └── style.css
│   └── js/
│       └── script.js
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   └── .dockerignore
├── infrastructure/
│   └── terraform/
│       ├── provider.tf
│       ├── backend.tf
│       ├── ec2.tf
│       └── ecr.tf
├── LICENSE
└── README.md
```

## Aplicação

Site estático de demonstração, sem dependências de build (HTML, CSS e JavaScript puros). Serve como carga de trabalho para validar todo o pipeline de containerização e deploy, não sendo o foco funcional do projeto.

## Containerização

A imagem é construída a partir de `docker/Dockerfile`, utilizando `nginx:alpine` como base:

- O conteúdo de `app/` é copiado para `/usr/share/nginx/html`.
- A porta 80 é exposta e servida pelo Nginx em primeiro plano.

O arquivo `docker/docker-compose.yaml` define como o container é executado em produção:

- A imagem é parametrizada pela variável de ambiente `APP_IMAGE`, definida em tempo de deploy.
- O container é publicado na porta `8080:80` e configurado com `restart: unless-stopped`.
- Um healthcheck HTTP (`wget --spider`) verifica a disponibilidade da aplicação a cada 10 segundos.
- Um `.dockerignore` dedicado impede que arquivos de documentação, controle de versão e artefatos temporários sejam enviados ao contexto de build.

## Infraestrutura (Terraform)

A infraestrutura é declarada em `infrastructure/terraform` e provisiona os recursos necessários na região `us-east-1`:

| Arquivo | Recurso | Descrição |
|---|---|---|
| `provider.tf` | Provider AWS | Define a região utilizada pelos recursos. |
| `backend.tf` | Backend remoto S3 | Armazena o `state` do Terraform de forma centralizada e versionada. |
| `ecr.tf` | `aws_ecr_repository` | Repositório privado (`site_prod`) para armazenar as imagens Docker da aplicação. |
| `ec2.tf` | `aws_instance` + `aws_security_group` | Instância EC2 (`t2.micro`) com IAM Instance Profile associado ao ECR, e um Security Group com regras de entrada para SSH, HTTP e HTTPS, e saída irrestrita. |

Pontos de atenção sobre a configuração atual:

- O acesso SSH está restrito por CIDR, mas o valor `seu-ip/32` em `ec2.tf` é um placeholder e deve ser substituído pelo IP real autorizado antes de qualquer `terraform apply`.
- O `key_name` (`chave-site-prod`) e o IAM Instance Profile (`ECR-EC2-Role`) precisam existir previamente na conta AWS utilizada, pois não são criados por este código.
- O bucket do backend remoto é específico do ambiente do autor e deve ser ajustado para outros usos do repositório.

## Pipeline de CI (`ci.yaml`)

Disparado em `push` e `pull_request` para a branch `main`, e também manualmente via `workflow_dispatch`.

Etapas executadas:

1. Checkout do código.
2. Build da imagem Docker com Buildx, carregada localmente (`load: true`, `push: false`), sem publicação em registry.
3. Validação básica da imagem gerada (listagem e inspeção do conteúdo do container).
4. Teste de fumaça: o container é executado localmente na porta 8080, e um laço de repetição tenta requisições HTTP por até 15 tentativas antes de considerar falha.

Configurações adicionais do workflow:

- `concurrency` cancela execuções redundantes na mesma referência de branch.
- `permissions: contents: read` restringe o token do job ao mínimo necessário.
- `timeout-minutes` evita que o job fique preso indefinidamente.

## Pipeline de CD (`cd.yaml`)

Disparado automaticamente ao final de uma execução bem-sucedida do workflow de CI (`workflow_run`), ou manualmente via `workflow_dispatch`.

O pipeline é dividido em dois jobs:

**build-and-push** (`ubuntu-latest`)
- Autentica no Docker Hub.
- Constrói a imagem e publica duas tags: uma vinculada ao commit (`IMAGE_TAG`) e outra `latest`.

**deploy** (runner self-hosted, depende de `build-and-push`)
- Identifica a imagem atualmente em execução, para permitir rollback posterior.
- Valida a existência do arquivo `docker-compose.yaml` e sua configuração.
- Baixa a nova imagem e recria o container via `docker compose up -d --force-recreate`.
- Executa uma verificação de saúde HTTP com múltiplas tentativas.
- Em caso de falha na verificação: coleta diagnóstico (logs e estado do container) e executa rollback automático para a imagem anterior, validando novamente a disponibilidade da aplicação.
- Exibe, ao final, o estado consolidado do container, independentemente do resultado.

Este desenho implementa deploy com verificação de saúde e rollback automático, reduzindo o risco de indisponibilidade em publicações com falha.

## Verificação do runner self-hosted (`validando-runner.yaml`)

Workflow de diagnóstico, disparado manualmente, utilizado para confirmar que o runner self-hosted está operacional antes de habilitá-lo para deploys: verifica identidade do usuário, sistema operacional, versão do Docker e do Docker Compose, e containers em execução.

## Requisitos de execução

Para reproduzir o pipeline completo, são necessários:

- Conta AWS com permissões para EC2, ECR, IAM e S3.
- Terraform instalado, para provisionamento da infraestrutura.
- Uma instância EC2 configurada como runner self-hosted do GitHub Actions (com Docker e Docker Compose instalados), utilizada pelo job de deploy.
- Os seguintes secrets configurados no repositório do GitHub:
  - `DOCKER_USERNAME`: usuário do Docker Hub.
  - `DOCKERHUB_KEY`: token de acesso ao Docker Hub.

## Execução local da aplicação

Para testar a aplicação isoladamente, sem depender do pipeline:

```bash
docker build -t app:local -f docker/Dockerfile .
docker run -d -p 8080:80 --name app-local app:local
curl http://localhost:8080
```

Para simular o deploy via Docker Compose:

```bash
APP_IMAGE=app:local docker compose -f docker/docker-compose.yaml up -d
```

## Provisionamento da infraestrutura

```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

Recomenda-se sempre revisar a saída do `terraform plan` antes de aplicar alterações, e executar `terraform destroy` ao encerrar os testes, para evitar custos desnecessários na conta AWS.

## Licença

Este projeto está licenciado sob os termos da licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.

## Créditos

A metodologia e a proposta pedagógica original deste laboratório foram desenvolvidas por Maria Lazara, DevOps Engineer. Este repositório representa uma implementação e adaptação prática dessa metodologia, integrando containerização, Infrastructure as Code e um pipeline de CI/CD completo em um único projeto.
