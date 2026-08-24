# 🚀 SaaS Task Planner — Rails 8, Hotwire & Sidekiq Showcase

Este é um projeto portfólio desenvolvido para demonstrar domínio sênior na stack moderna do **Ruby on Rails 8.1**, com foco em reatividade sem frameworks SPA (Hotwire), componentização (ViewComponent), processamento assíncrono (Sidekiq) e otimização de banco de dados (PostgreSQL).

---

## 🛠️ Stack Tecnológica & Arquitetura

- **Core:** Ruby on Rails 8.1.x + Ruby 3.3.x.
- **Banco de Dados (PostgreSQL):** Modelagem com índice de busca (`add_index :tasks, :status`) e restrições de banco (`null: false`, valores default) para otimização de performance em queries do dashboard.
- **Reatividade Real-time (Hotwire / Turbo Streams):**
  - Integração nativa do Turbo com ActionCable.
  - Callbacks do Active Record (`after_create_commit` e `after_update_commit`) disparando atualizações parciais de HTML diretamente para os navegadores de todos os clientes conectados por WebSockets.
- **Componentização (ViewComponent):** Criação do `MetricCardComponent` para renderizar de forma isolada, testável e reutilizável os cards de KPIs do topo do dashboard.
- **Background Jobs (Sidekiq + Redis):** Processamento assíncrono e resiliente das tarefas fora da thread de request do servidor web (Puma).
- **Estilização (Tailwind CSS v4):** Layout premium escuro (*dark mode*) com efeitos de *glassmorphism* (fundo translúcido, bordas sutis e desfoque).
- **Testes Automatizados (RSpec):**
  - **Model Specs:** Validações de presença e valores default.
  - **Request Specs:** Criação de recursos e validação de enfileiramento de jobs no Sidekiq.
  - **Job Specs:** Execução síncrona do job testando a mudança de estados do model.

---

## ⚡ Detalhes Técnicos Implementados

### 1. Reatividade Turbo Streams
Quando o usuário cria uma tarefa:
1. O formulário envia a requisição via Turbo Stream POST.
2. A tarefa é criada com status `pending`. O callback `after_create_commit` insere a nova linha da tarefa no topo da tabela de todos os usuários conectados em tempo real.
3. O controller dispara o `ProcessTaskJob.perform_async(task.id)` e limpa o formulário instantaneamente.
4. O Sidekiq inicia a execução do Job, muda o status da tarefa para `processing` (o callback `after_update_commit` atualiza a linha da tabela na tela com efeito visual *pulse*).
5. O Job finge fazer uma tarefa pesada (`sleep 3`), atualiza o status para `completed` e preenche o sumário de estatísticas (a linha é atualizada em tempo real para cor verde).

### 2. Otimização PostgreSQL
Para demonstrar preocupação com performance de queries em cenários de alta concorrência:
- Foi criado um índice B-Tree no campo `status` da tabela `tasks`:
  ```ruby
  add_index :tasks, :status
  ```
  Isso acelera buscas filtradas por status e a agregação de contadores como `Task.where(status: 'completed').count` que geram as métricas no dashboard.

---

## 🚀 Como Executar o Projeto Localmente

### Pré-requisitos
Certifique-se de possuir o **Docker** instalado para rodar os serviços locais de banco de dados e Redis.

### 1. Iniciar Banco de Dados e Redis (Docker)
Inicie os serviços necessários:
```bash
# Iniciar o PostgreSQL do projeto principal
docker start seguro_hub-db-1

# Iniciar o Redis para o Sidekiq
docker run -d --name rails8-redis -p 6379:6379 redis:alpine
```

### 2. Configurar o Rails 8
Clone o projeto e prepare o banco de dados:
```bash
# Instalar as gems do projeto
bundle install

# Criar e rodar as migrações
bin/rails db:create
bin/rails db:migrate
```

### 3. Rodar a Suíte de Testes
Certifique-se de que tudo está compilando e todos os testes estão passando:
```bash
bundle exec rspec
```

### 4. Executar a Aplicação
Inicie o servidor do Rails e o processo do Sidekiq simultaneamente usando o comando de desenvolvimento integrado do Tailwind:
```bash
# Iniciar servidor Rails, Tailwind watcher e Sidekiq
bin/dev
```

Acesse no seu navegador em: **[http://localhost:3000](http://localhost:3000)**.
