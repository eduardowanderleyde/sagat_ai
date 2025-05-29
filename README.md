# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# sagat_ai - API Bancária Segura

API para operações bancárias, incluindo autenticação JWT, transferências, agendamento de transferências futuras, extrato e consulta de saldo.

## 🚀 Tecnologias

- Ruby on Rails
* PostgreSQL
* Sidekiq (processamento assíncrono)
* Docker
* RSpec (testes automatizados)

## ⚙️ Setup e Instalação

### Pré-requisitos

- Ruby 3.2+
* Rails 8+
* PostgreSQL
* Redis (para Sidekiq)
* Docker (opcional, recomendado)

### Instalação manual

```sh
bundle install
rails db:setup
```

### Usando Docker

```sh
docker build -t sagat_ai .
docker run -p 3000:3000 sagat_ai
```

### Usando Docker Compose (se disponível)

```sh
docker-compose up --build
```

## 🧪 Rodando os Testes

```sh
bundle exec rspec
```

## 🔐 Autenticação e Fluxos Principais

### 1. Criar usuário

```http
POST /api/v1/users
{
  "user": {
    "email": "usuario@exemplo.com",
    "password": "senha123",
    "name": "Nome Completo",
    "cpf": "12345678900"
  }
}
```

### 2. Login

```http
POST /api/v1/auth/login
{
  "email": "usuario@exemplo.com",
  "password": "senha123"
}
```

**Resposta:**

```json
{
  "token": "<JWT>",
  "user": { ... }
}
```

> Use o token JWT no header das próximas requisições:
> `Authorization: Bearer <token>`

### 3. Consultar saldo

```http
GET /api/v1/conta/saldo
Authorization: Bearer <token>
```

### 4. Realizar transferência

```http
POST /api/v1/transferencias
Authorization: Bearer <token>
{
  "transaction": {
    "amount": 100.0,
    "destination_account_id": 2,
    "description": "Pagamento"
  }
}
```

### 5. Agendar transferência futura

```http
POST /api/v1/transferencias/agendada
Authorization: Bearer <token>
{
  "transaction": {
    "amount": 50.0,
    "destination_account_id": 2,
    "description": "Pagamento aluguel",
    "scheduled_for": "2025-05-25T10:00:00"
  }
}
```

### 6. Listar extrato (com filtros opcionais)

```http
GET /api/v1/extrato?start_date=2025-05-01&end_date=2025-05-31&min_amount=10&type=transfer
Authorization: Bearer <token>
```

## 📌 Principais decisões técnicas

- Autenticação JWT para segurança
* Validação de CPF no cadastro
* Operações atômicas para atualização de saldo
* Sidekiq para agendamento e processamento assíncrono
* Testes automatizados com RSpec
* Docker para facilitar setup e deploy

## 📝 O que faria diferente com mais tempo

- Implementaria paginação no extrato
* Adicionaria documentação Swagger/OpenAPI
* Implementaria logs de auditoria detalhados
* Melhoraria a cobertura de testes (ex: testes de integração)
* Implementaria versionamento de API

## 📸 Prints ou GIFs (opcional)

Adicione aqui prints de requisições ou GIFs mostrando o uso da API (ex: Postman, terminal, etc).

---

Qualquer dúvida, abra uma issue ou entre em contato!
