# 🔗 Base URL
http://localhost:8000

# 🔐 Authentication

All protected endpoints require the following headers for merchant authentication:

X-Api-Key: Merchant’s unique API key  
X-Api-Secret: Merchant’s unique API secret

# ❤️ Health Check

Endpoint: GET /health  
Authentication: None  

Response (200 OK):

JSON
{
  "status": "healthy",
  "database": "connected",
  "redis": "connected",
  "worker": "running",
  "timestamp": "2026-01-10T10:30:00Z"
}

Note: Deliverable 2 requires Redis and Worker status fields.

# 1️⃣ Create Order

Endpoint: POST /api/v1/orders  
Authentication: Required  

Request Body:

JSON
{
  "amount": 50000,
  "currency": "INR",
  "receipt": "receipt_123",
  "notes": {
    "customer_name": "John Doe"
  }
}

Note: Amount is in paise (₹500.00 = 50000).

Response (201 Created):

JSON
{
  "id": "order_NXhj67fGH2jk9mPq",
  "merchant_id": "550e8400-e29b-41d4-a716-446655440000",
  "amount": 50000,
  "currency": "INR",
  "status": "created",
  "created_at": "2026-01-10T10:30:00Z"
}

# 2️⃣ Create Payment

Endpoint: POST /api/v1/payments  
Authentication: Required  

Request Body (UPI):

JSON
{
  "order_id": "order_NXhj67fGH2jk9mPq",
  "method": "upi",
  "vpa": "user@paytm"
}

Request Body (Card):

JSON
{
  "order_id": "order_NXhj67fGH2jk9mPq",
  "method": "card",
  "card": {
    "number": "4111111111111111",
    "expiry_month": "12",
    "expiry_year": "2027",
    "cvv": "123",
    "holder_name": "John Doe"
  }
}

Response (201 Created):

JSON
{
  "id": "pay_H8sK3jD9s2L1pQr",
  "order_id": "order_NXhj67fGH2jk9mPq",
  "amount": 50000,
  "status": "processing",
  "method": "card",
  "card_network": "visa",
  "card_last4": "1111"
}

Note: Payments enter the processing state immediately.

# 3️⃣ Get Payment Status

Endpoint: GET /api/v1/payments/{payment_id}  
Authentication: Required  

Response (200 OK):

JSON
{
  "id": "pay_H8sK3jD9s2L1pQr",
  "order_id": "order_NXhj67fGH2jk9mPq",
  "status": "success",
  "method": "upi",
  "vpa": "user@paytm",
  "updated_at": "2026-01-10T10:31:10Z"
}

# 4️⃣ Public Order Details (For Checkout)

Endpoint: GET /api/v1/orders/{order_id}/public  
Authentication: None  

Response (200 OK):

JSON
{
  "id": "order_NXhj67fGH2jk9mPq",
  "amount": 50000,
  "currency": "INR",
  "status": "created"
}

# ⚠️ Error Response Standardization

All errors follow this exact structure for automated evaluation:

Example (400 Bad Request):

JSON
{
  "error": {
    "code": "BAD_REQUEST_ERROR",
    "description": "amount must be at least 100"
  }
}
