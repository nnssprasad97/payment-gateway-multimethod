# 🏗️ System Architecture Overview

The Payment Gateway is designed as a decoupled, containerized system comprising four primary services managed via Docker Compose.

## 🔧 Core Components

### 🗄️ Database (PostgreSQL)

The central source of truth, storing data for Merchants, Orders, and Payments using exact table relationships and indexes for efficiency.

### ⚙️ Gateway API (Backend)

Built with Express.js (or Spring Boot), this service handles all business logic, including authentication, Luhn algorithm validation for cards, VPA format checks, and the transaction state machine.

### 📊 Merchant Dashboard (Frontend)

A React-based application running on Port 3000, used by merchants to manage credentials and view real-time transaction analytics.

### 💳 Hosted Checkout (Checkout-Page)

A standalone React application running on Port 3001 that provides a secure interface for customers to select payment methods and process transactions.

# 🔄 System Data Flow

The system follows a defined lifecycle from order creation to final payment settlement.

## 1️⃣ Order Creation Flow (Merchant to API)

The Merchant initiates a request to POST /api/v1/orders using their X-Api-Key and X-Api-Secret.

The API validates merchant credentials and creates an order record with the format:  
order_ + 16 characters

The order is stored with an initial status of created.

## 2️⃣ Checkout Initialization (Customer to Checkout)

The customer is redirected to the hosted checkout page using:  
http://localhost:3001/checkout?order_id={order_id}

The Checkout Page calls the public endpoint:  
GET /api/v1/orders/{order_id}/public

This endpoint returns order amount and currency without requiring authentication.

## 3️⃣ Payment Processing (Customer to API)

The customer submits payment details (UPI VPA or Card information).

The API validates the input:

- Luhn Algorithm check for card numbers
- Regex-based validation for UPI VPA format

A payment record is created with the format:  
pay_ + 16 characters

The payment status is immediately set to processing.

A simulated delay of 5–10 seconds represents bank interaction, after which the payment transitions to either success or failed state.

## 4️⃣ Analytics & Monitoring (Merchant to Dashboard)

The Merchant logs into the Dashboard at:  
http://localhost:3000

The Dashboard fetches transaction data using the Merchant’s API credentials.

All analytics such as total transaction amount, transaction count, and success rate are calculated dynamically from the database.
