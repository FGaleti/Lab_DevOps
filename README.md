# Laboratório DevOps: Aprenda DevOps na Prática com Projetos Progressivos

Olá! Eu sou Maria Lazara, DevOps Engineer, e vou guiar você nesta jornada DevOps.

Sei que conceitos como containerização, Infrastructure as Code (IaC) e CI/CD podem parecer intimidadores no início. Por isso, adoto uma didática simples e prática: vamos construir o conhecimento **de trás para frente**.

Isso significa começar por um problema real — algo que você pode vivenciar e compreender os impactos — e somente depois buscar uma solução, experimentando ferramentas como Docker, Terraform e GitHub Actions. No final, conectamos a prática à teoria para consolidar o aprendizado.

Meu objetivo é ensinar você a resolver problemas comuns que profissionais DevOps enfrentam diariamente, como:

- “Funciona na minha máquina, mas não no servidor.”
- “Deploys manuais causam indisponibilidade.”
- “Os ambientes possuem configurações diferentes.”
- “As alterações de infraestrutura não estão documentadas.”
- “O processo de publicação depende de uma única pessoa.”

Cada projeto deste laboratório representa uma peça de um quebra-cabeça. Os projetos estão conectados e aumentam gradualmente de dificuldade, simulando a evolução de um ambiente básico para um pipeline DevOps profissional.

Este repositório contém três pastas, cada uma com um projeto independente, mas interligado:

- **projeto-devops-fase-1**: fundamentos de containerização e deploy manual de um site estático na AWS.
- **projeto-devops-fase-2**: automação da infraestrutura utilizando Terraform e Infrastructure as Code.
- **projeto-devops-fase-3**: automação completa com CI/CD utilizando GitHub Actions, Terraform e Docker.

Cada pasta possui seu próprio arquivo `README.md`, com instruções detalhadas e desafios para simular problemas reais. Clone o repositório, siga os passos e experimente.

> **Espaço reservado para imagem:** estrutura do repositório no GitHub mostrando as três pastas.

---

## Pré-requisitos Técnicos

> **IMPORTANTE:** Este laboratório foi desenvolvido para pessoas com conhecimento básico ou intermediário em desenvolvimento e infraestrutura. Não se trata de um curso introdutório sobre fundamentos.

### Conhecimentos obrigatórios

#### Linux/Unix básico

- Navegação pelo terminal com `ls`, `cd`, `mkdir`, `cp`, `mv` e `rm`.
- Edição de arquivos com Nano, Vim ou Visual Studio Code.
- Gerenciamento básico de permissões com `chmod` e `sudo`.
- Utilização de SSH e conexões remotas.

#### AWS básico

- Conhecimento dos conceitos de EC2, IAM, VPC e Security Groups.
- Criação de instâncias e configuração de acesso.
- AWS CLI instalada, configurada e funcional.
- Conhecimento básico sobre o Free Tier e os custos dos serviços.

#### Docker básico ou intermediário

- Diferença entre imagem e container.
- Comandos essenciais, como `build`, `run`, `push` e `pull`.
- Criação de um Dockerfile básico.
- Conceito de registries, como Docker Hub e Amazon ECR.

#### Terraform básico

- Conceitos de Infrastructure as Code.
- Comandos básicos, como `init`, `plan`, `apply` e `destroy`.
- Conhecimento básico de HCL — HashiCorp Configuration Language.
- Conceito de arquivo de estado, ou `state file`.

#### Git e GitHub

- Comandos básicos, como `clone`, `add`, `commit`, `push` e `pull`.
- Criação e configuração de repositórios.
- Conceitos básicos de branches.

### Autoavaliação rápida

Antes de começar, verifique se você consegue responder positivamente às seguintes perguntas:

- [ ] Consigo criar uma instância EC2 e conectar nela por SSH?
- [ ] Sei criar uma imagem Docker e executar um container?
- [ ] Já utilizei o comando `terraform apply` para criar recursos?
- [ ] Domino os comandos básicos do terminal Linux?

> Se você respondeu negativamente a mais de uma pergunta, é recomendável revisar os fundamentos antes de continuar.

---

## Por Que Utilizar a Abordagem “De Trás para Frente”?

Em vez de começar somente com conceitos teóricos, como “o que é Docker?”, vamos reproduzir situações próximas da realidade.

Primeiro, você enfrenta um problema concreto e compreende os impactos dele. Depois, pesquisa e implementa uma ferramenta capaz de resolver esse problema. Por fim, estuda os conceitos teóricos relacionados à solução aplicada.

Por exemplo:

1. Primeiro, você vivencia as dificuldades de um deploy manual.
2. Depois, procura uma maneira de automatizar esse processo.
3. Finalmente, compreende a teoria relacionada, como o isolamento de dependências proporcionado por containers.

Essa abordagem é baseada na resolução de problemas. Cada projeto começa com uma situação realista, como uma empresa em crescimento enfrentando gargalos técnicos e operacionais.

---

## Visão Geral dos Projetos

Durante o laboratório, construiremos um website estático simples, utilizando HTML, CSS e JavaScript, e realizaremos seu deploy na AWS.

O foco principal, entretanto, não é o desenvolvimento do site, mas o processo DevOps necessário para construí-lo, distribuí-lo e executá-lo.

Cada fase resolve problemas encontrados na fase anterior e adiciona novas camadas de automação.

---

### Projeto 1: Containerização com Docker e Deploy Manual na AWS

**Nível:** básico

#### Problema real

Imagine uma pequena equipe na qual uma alteração funciona corretamente no computador do desenvolvedor, mas apresenta falhas ao ser executada no servidor AWS devido a diferenças de configuração e dependências.

Além disso, os deploys são realizados manualmente por SSH, aumentando o risco de erros e o tempo necessário para publicar uma nova versão.

#### Solução prática

Utilize o Docker para empacotar o site em uma imagem portátil. Crie um repositório no Amazon ECR, envie a imagem e realize o deploy manual em uma instância EC2.

#### Ferramentas e serviços utilizados

- Docker
- AWS CLI
- Amazon ECR
- Amazon EC2
- AWS Security Groups

#### Conexão com a próxima fase

A containerização ajuda a resolver o problema de inconsistência entre ambientes. Entretanto, o provisionamento da infraestrutura e o deploy ainda são manuais, preparando o cenário para a automação implementada na Fase 2.

#### Tempo estimado

De 2 a 3 horas.

#### Desafio inicial

Tente realizar o deploy manualmente sem utilizar Docker e observe as dificuldades relacionadas às dependências e às diferenças de ambiente.

> **Espaço reservado para imagem:** diagrama da arquitetura do Projeto 1, mostrando código local, Docker, ECR, EC2 e navegador.

---

### Projeto 2: Automação de Infraestrutura com Terraform

**Nível:** intermediário

#### Problema real

A empresa cresceu e agora precisa recriar rapidamente ambientes de desenvolvimento, homologação e produção.

A criação manual de recursos pelo console da AWS causa inconsistências, erros e configurações não rastreadas, também conhecidas como `drift`.

Um deploy emergencial pode falhar porque determinada configuração não foi documentada ou reproduzida corretamente.

#### Solução prática

Trate a infraestrutura como código utilizando Terraform. Declare recursos como EC2, ECR e IAM Roles em arquivos HCL, permitindo que o Terraform provisione e gerencie a infraestrutura automaticamente.

#### Ferramentas e conceitos utilizados

- Terraform
- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`
- Backend remoto no Amazon S3
- Gerenciamento do estado do Terraform
- Outputs para integração com outros processos

#### Conexão com a próxima fase

A Fase 2 integra a infraestrutura criada pelo Terraform com a aplicação containerizada da Fase 1.

A infraestrutura passa a ser reproduzível e versionada, mas o deploy da aplicação ainda depende de procedimentos manuais. Isso prepara o ambiente para a automação completa implementada na Fase 3.

#### Tempo estimado

De 2 a 4 horas.

#### Desafio inicial

Tente recriar manualmente o ambiente do Projeto 1 em uma nova região da AWS e identifique os pontos de dificuldade, repetição e risco de erro.

> **Espaço reservado para imagem:** diagrama da arquitetura do Projeto 2, mostrando os arquivos Terraform, a infraestrutura AWS e o deploy do container Docker.

---

### Projeto 3: Automação Completa com CI/CD

**Nível:** avançado

#### Problema real

Com vários desenvolvedores realizando mudanças diariamente, os deploys manuais podem gerar gargalos, erros humanos, falta de padronização e ausência de auditabilidade.

Atualizações urgentes podem ser comprometidas por processos manuais ou por conflitos no estado do Terraform, causando indisponibilidade e atrasos.

#### Solução prática

Separe os repositórios de aplicação e infraestrutura e utilize GitHub Actions para criar pipelines de CI/CD.

Alterações no código podem iniciar automaticamente os seguintes processos:

- Validação do código.
- Construção da imagem Docker.
- Publicação da imagem no registry.
- Execução do `terraform plan`.
- Aplicação das alterações de infraestrutura.
- Deploy da nova versão.
- Aprovações manuais para ambientes críticos.

#### Ferramentas e conceitos utilizados

- GitHub Actions
- Workflows YAML
- GitHub Secrets
- Aprovações manuais
- Integração entre múltiplos repositórios
- Docker
- Terraform
- AWS

#### Conexão com as fases anteriores

A Fase 3 integra a containerização desenvolvida no Projeto 1 com a infraestrutura como código criada no Projeto 2.

O resultado é um pipeline DevOps automatizado, rastreável e adequado para o trabalho em equipe.

#### Tempo estimado

De 3 a 5 horas.

#### Desafio inicial

Simule deploys manuais simultâneos no ambiente desenvolvido na Fase 2 e observe os possíveis conflitos e riscos operacionais.

> **Espaço reservado para imagem:** diagrama completo da arquitetura do Projeto 3, mostrando os repositórios GitHub, GitHub Actions, infraestrutura AWS e deploy da aplicação.

---

## Como Começar

### 1. Clone o repositório

```bash
git clone https://github.com/marialazara/laboratorio-devops.git
cd laboratorio-devops
```

### 2. Escolha uma fase

Comece pela pasta `projeto-devops-fase-1` e avance gradualmente.

Cada pasta possui seu próprio arquivo `README.md`, com pré-requisitos, instruções, desafios e orientações para solução de problemas.

### 3. Prepare o ambiente

Certifique-se de possuir uma conta AWS e esteja atento aos custos dos recursos utilizados.

Sempre que possível, utilize recursos elegíveis ao Free Tier e remova os recursos criados ao terminar os exercícios.

Instale e configure as ferramentas necessárias:

- Docker
- Terraform
- AWS CLI
- Git
- Visual Studio Code ou outro editor de sua preferência

### 4. Siga as recomendações gerais

- Utilize o Visual Studio Code para editar os arquivos.
- Teste as alterações localmente antes de publicá-las.
- Analise o resultado do `terraform plan` antes de executar o `terraform apply`.
- Não armazene credenciais diretamente nos arquivos do repositório.
- Remova os recursos da AWS ao finalizar o laboratório para evitar custos.
- Consulte o `git status` antes de realizar commits.
- Não envie arquivos sensíveis ou credenciais para o GitHub.

### 5. Personalize o projeto

Substitua os valores de exemplo pelos valores relacionados ao seu ambiente, como:

- Região da AWS.
- Nomes dos repositórios.
- Identificadores dos recursos.
- Endereços e nomes das instâncias.
- Variáveis de ambiente.
- Secrets utilizados nos pipelines.

---

## Conceitos Aprendidos

Ao final do laboratório, você terá contato prático com ferramentas e conceitos importantes para a atuação de um profissional DevOps.

### Containerização com Docker

A containerização reduz inconsistências entre ambientes e permite distribuir aplicações juntamente com as dependências necessárias para sua execução.

### Infrastructure as Code com Terraform

O Terraform permite criar, modificar e versionar a infraestrutura utilizando código, tornando os ambientes mais reproduzíveis e auditáveis.

### CI/CD com GitHub Actions

O GitHub Actions permite automatizar processos de integração, validação, construção, publicação e deploy de aplicações.

### Melhores práticas

Durante os projetos, você também trabalhará com:

- Gerenciamento de secrets.
- Aprovações manuais.
- Controle e bloqueio do estado do Terraform.
- Identificação de `drift`.
- Versionamento de infraestrutura.
- Rastreabilidade de mudanças.
- Separação entre código da aplicação e código da infraestrutura.

Os projetos simulam uma progressão próxima da realidade: partem de processos manuais, avançam para infraestrutura como código e terminam em um fluxo automatizado de CI/CD.

---

## Recursos Adicionais

- https://docs.docker.com/
- https://developer.hashicorp.com/terraform
- https://docs.github.com/actions
- Livro: *The DevOps Handbook*, para aprofundamento em conceitos e práticas DevOps.
- Comunidades: https://www.reddit.com/r/devops/ e https://stackoverflow.com/.

---

## Notas Finais

DevOps envolve cultura, processos, colaboração e automação. O objetivo das ferramentas apresentadas neste laboratório é reduzir tarefas manuais, aumentar a confiabilidade dos ambientes e permitir que as equipes dediquem mais tempo à melhoria contínua e à inovação.

Caso encontre algum problema durante os exercícios, pesquise a mensagem de erro, consulte a documentação oficial e procure compreender a causa antes de aplicar uma solução. Essa investigação também faz parte do desenvolvimento das habilidades necessárias para atuar na área.

### Créditos

Este laboratório, incluindo sua metodologia, estrutura, proposta de aprendizagem progressiva e projetos originais, foi desenvolvido por **Maria Lazara**, DevOps Engineer e criadora do conteúdo.

Todo o mérito pela idealização e elaboração do material pertence à autora. A reprodução deste conteúdo neste repositório tem finalidade exclusivamente educacional e de estudo, mantendo os devidos créditos e o reconhecimento pelo trabalho original de Maria Lazara.

Para conhecer outros conteúdos e acompanhar o trabalho da autora, acesse:

- https://www.youtube.com/@marialazaradev
- https://github.com/marialazara/laboratorio-devops