# 🗄️ Schema Overview

The database is designed with a relational structure to ensure data integrity across merchants, orders, and payments. It utilizes UUIDs for primary merchant identification and custom-prefixed alphanumeric strings for transaction records.

---

# 1️⃣ Merchants Table

This table handles merchant onboarding and holds the credentials required for API authentication.

Field | Type | Description | Constraints
--- | --- | --- | ---
id | UUID | Unique identifier | Primary Key, Auto-generated
name | String(255) | Merchant name | Required
email | String(255) | Contact email | Unique, Required
api_key | String(64) | Key for authentication | Unique, Required
api_secret | String(64) | Secret for authentication | Required
is_active | Boolean | Account status | Defaults to true
created_at | Timestamp | Creation time | Auto-set

---

# 2️⃣ Orders Table

Stores payment order requests initiated by merchants.

Field | Type | Description | Constraints
--- | --- | --- | ---
id | String(64) | Order identifier | Primary Key, Format: order_ + 16 alphanumeric
merchant_id | UUID | Link to merchant | Foreign Key → merchants(id), Required
amount | Integer | Amount in paise | Required, Minimum 100
currency | String(3) | Currency code | Defaults to INR
status | String(20) | Order state | Defaults to created
notes | JSON | Metadata | Optional

---

# 3️⃣ Payments Table

Tracks individual payment attempts and their specific payment methods.

Field | Type | Description | Constraints
--- | --- | --- | ---
id | String(64) | Payment identifier | Primary Key, Format: pay_ + 16 alphanumeric
order_id | String(64) | Link to order | Foreign Key → orders(id), Required
merchant_id | UUID | Link to merchant | Foreign Key → merchants(id), Required
method | String(20) | Payment type | upi or card
status | String(20) | Payment state | Starts as processing
vpa | String(255) | UPI address | Optional (UPI only)
card_network | String(20) | Network brand | Optional (Card only): visa, mastercard, etc.
card_last4 | String(4) | Last 4 digits | Optional (Card only)

---

# ⚡ Required Indexes

To ensure high performance during merchant queries and automated evaluation, the following indexes are mandatory:

- Index on orders.merchant_id  
  For efficient merchant order history lookups.

- Index on payments.order_id  
  For fast payment status polling.

- Index on payments.status  
  To optimize status-based reporting and analytics.

---

# 🔗 Table Relationships

The system maintains a one-to-many hierarchy:

- Merchant ➔ Orders  
  One merchant can create many orders.

- Order ➔ Payments  
  One order can have multiple payment attempts (in cases of retry), though typically associated with a single final payment record.
