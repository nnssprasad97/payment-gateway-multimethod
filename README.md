# 💳 Multi-Method Payment Gateway & Hosted Checkout

A foundational fintech system designed to handle merchant onboarding, order management, and multi-method payment processing (Card & UPI) with a professional hosted checkout experience.

---

## 🚀 Core Features

**Merchant Onboarding**  
Automated seeding of a test merchant with API credentials:  

- API Key: key_test_abc123  
- API Secret: secret_test_xyz789  

**Payment Processing**

- **UPI**: Virtual Payment Address (VPA) validation using the pattern  
  ^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+$
- **Cards**: Luhn Algorithm validation and Network Detection (Visa, Mastercard, Amex, RuPay)

**State Machine**  
Secure transaction lifecycle management (Processing → Success / Failed)

**Hosted Checkout**  
A dedicated customer-facing interface for completing payments

**Merchant Dashboard**  
Real-time statistics calculation and transaction history tracking

---

## 🏗️ System Architecture

The system consists of four primary services:

- **gateway_api (Port 8000)**  
  Backend logic, authentication, and payment validation

- **gateway_dashboard (Port 3000)**  
  Merchant-facing dashboard interface

- **gateway_checkout (Port 3001)**  
  Customer-facing hosted checkout interface

- **pg_gateway (Port 5432)**  
  PostgreSQL database service

---

## 📊 Database Schema

- **Merchants**  
  Stores authentication credentials and account status

- **Orders**  
  Linked to merchants; stores payment amount in paise (smallest currency unit)

- **Payments**  
  Tracks transaction status and method-specific metadata (VPA, Card Network)

---

## 🚦 Getting Started

**Launch the Gateway**  
Run the following command in the root directory:  
docker-compose up -d --build

**Verification**

- API Health: GET http://localhost:8000/health
- Test Merchant: GET http://localhost:8000/api/v1/test/merchant
- Dashboard: http://localhost:3000 (Login: test@example.com passwaord:anything like 123 etc")

---

## 🧪 API Endpoints

- **POST /api/v1/orders**  
  Create a new payment order

- **POST /api/v1/payments**  
  Process a payment using UPI or Card

- **GET /api/v1/payments/:id**  
  Poll for payment status
