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

# sagat_ai - Secure Banking API

API for banking operations, including JWT authentication, transfers, scheduled transfers, statement and balance inquiry.

## 🚀 Technologies

* Ruby on Rails
* PostgreSQL
* Sidekiq (async jobs)
* Docker
* RSpec (automated tests)
* Swagger (API documentation)

## ⚙️ Setup and Installation

### Prerequisites

* Ruby 3.2+
* Rails 8+
* PostgreSQL
* Redis (for Sidekiq)
* Docker (optional, recommended)

### Manual Installation

```sh
bundle install
rails db:setup
```

### Using Docker

```sh
docker build -t sagat_ai .
docker run -p 3000:3000 sagat_ai
```

### Using Docker Compose (if available)

```sh
docker-compose up --build
```

## 🧪 Running Tests

```sh
bundle exec rspec
```

## 📖 API Documentation (Swagger)

After running the server, access:

```
http://localhost:3000/api-docs
```

## 🔐 Authentication and Main Flows

### 1. Register user

```http
POST /api/v1/auth/register
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "name": "Test User",
    "cpf": "52998224725"
  }
}
```

### 2. Login

```http
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "token": "<JWT>",
  "user": { ... }
}
```

> Use the JWT token in the header for the next requests:
> `Authorization: Bearer <token>`

### 3. Check balance

```http
GET /api/v1/account/balance
Authorization: Bearer <token>
```

### 4. Make a transfer

```http
POST /api/v1/transactions
Authorization: Bearer <token>
{
  "transaction": {
    "amount": 100.0,
    "destination_account_id": 2,
    "description": "Transfer payment"
  }
}
```

### 5. Schedule a future transfer

```http
POST /api/v1/scheduled_transactions
Authorization: Bearer <token>
{
  "transaction": {
    "amount": 50.0,
    "destination_account_id": 2,
    "description": "Rent payment",
    "scheduled_for": "2025-05-25T10:00:00"
  }
}
```

### 6. List statement (with optional filters)

```http
GET /api/v1/statement?start_date=2025-05-01&end_date=2025-05-31&min_amount=10&type=transfer
Authorization: Bearer <token>
```

## 📌 Main Technical Decisions

* JWT authentication for security
* CPF validation on registration
* Atomic operations for balance updates
* Sidekiq for scheduling and async processing
* Automated tests with RSpec
* Docker for easy setup and deploy
* Swagger for interactive API documentation

## 📝 What I would do differently with more time / Future improvements

* Implement pagination in statement endpoints
* Add more detailed Swagger/OpenAPI documentation and examples
* Implement detailed audit logs for all critical operations
* Improve test coverage (integration and edge cases)
* Implement API versioning
* Add admin dashboard for user/account management
* Add rate limiting and brute-force protection
* Add email notifications for scheduled/failed transfers
* Add 2FA/MFA for sensitive operations
* Add monitoring and alerting (ex: Sentry, NewRelic)
* Add internationalization (i18n) for multi-language support

## 📸 Screenshots or GIFs (optional)

Add here screenshots or GIFs showing API usage (ex: Postman, terminal, Swagger UI, etc).

---

Any questions? Open an issue or contact me!
