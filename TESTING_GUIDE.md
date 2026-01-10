# Testing Guide & Data-Test-ID Implementation

## Overview

This guide provides comprehensive instructions for testing the payment gateway system and verifying the presence of all required `data-test-id` attributes in the frontend code.

## Frontend Data-Test-ID Specifications

### Dashboard Component IDs

#### Login Page
These attributes are required on the login form component:

```
data-test-id="login-email"         → Email input field
data-test-id="login-password"      → Password input field
data-test-id="login-button"        → Sign in/Login button
```

#### Home Page / Dashboard
These attributes are required on the dashboard home view:

```
data-test-id="dashboard-home"      → Main dashboard container
data-test-id="api-key-display"     → API Key display element
data-test-id="api-secret-display"  → API Secret display element
```

#### Transactions List
These attributes are required on the transactions/orders page:

```
data-test-id="transactions-list"   → Main transactions list container
data-test-id="transaction-row"     → Individual transaction row (repeating)
data-test-id="transaction-order-id" → Order ID in transaction row
data-test-id="transaction-status"  → Status in transaction row
```

### Checkout Page Component IDs

#### Payment Method Selection
These attributes are required on the payment method selector:

```
data-test-id="payment-method-selector" → Container for method selection
data-test-id="upi-option"              → UPI payment radio button
data-test-id="card-option"             → Card payment radio button
```

#### UPI Payment Form
These attributes are required on the UPI payment form:

```
data-test-id="upi-form"            → UPI payment form container
data-test-id="vpa-input"           → VPA input field
data-test-id="submit-button"       → Submit/Pay button
```

#### Card Payment Form
These attributes are required on the card payment form:

```
data-test-id="card-form"           → Card payment form container
data-test-id="card-number"         → Card number input field
data-test-id="card-expiry"         → Card expiry date input field
data-test-id="card-cvv"            → Card CVV input field
data-test-id="submit-button"       → Submit/Pay button (reused)
```

#### Payment Processing States
These attributes are required for different payment states:

```
data-test-id="processing-state"    → Shows while payment is processing
data-test-id="success-state"       → Shows after successful payment
data-test-id="failure-state"       → Shows after failed payment
data-test-id="error-message"       → Error message display element
```

## Implementation Checklist

### Dashboard Frontend
- [ ] Login page has all three data-test-id attributes
- [ ] Dashboard home page has all required display elements with data-test-ids
- [ ] Transactions list has container and row-level data-test-ids
- [ ] All navigation elements between pages work correctly
- [ ] API credentials are retrieved and displayed correctly

### Checkout Page Frontend
- [ ] Payment method selector shows both UPI and Card options
- [ ] UPI and Card forms can be toggled based on selection
- [ ] All input fields have proper data-test-id attributes
- [ ] VPA input validates format in real-time
- [ ] Card input validates card number with Luhn algorithm
- [ ] Submit button enables/disables based on form validity
- [ ] Processing state shows during payment submission
- [ ] Success state displays order and payment confirmation
- [ ] Failure state shows error messages clearly

## API Testing

### Test Merchant Credentials
```
Email: test@example.com
Password: (any password in test mode)
API Key: key_test_abc123
API Secret: secret_test_xyz789
```

### Order Creation Test
```bash
curl -X POST http://localhost:8000/api/v1/orders \
  -H "Authorization: Bearer key_test_abc123:secret_test_xyz789" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 5000,
    "currency": "INR"
  }'

Expected Response (201 Created):
{
  "id": "order_...",
  "merchant_id": "merchant_test_abc123",
  "amount": 5000,
  "currency": "INR",
  "status": "pending",
  "created_at": "2026-01-10T...",
  "checkout_url": "http://localhost:3001?order_id=order_..."
}
```

### Payment Processing Test (UPI)
```bash
curl -X POST http://localhost:8000/api/v1/payments \
  -H "Authorization: Bearer key_test_abc123:secret_test_xyz789" \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "order_123",
    "method": "upi",
    "vpa": "user@upi"
  }'

Expected Response (200 OK):
{
  "id": "payment_...",
  "order_id": "order_123",
  "amount": 5000,
  "method": "upi",
  "vpa": "user@upi",
  "status": "processing",
  "created_at": "2026-01-10T..."
}
```

### Payment Processing Test (Card)
```bash
curl -X POST http://localhost:8000/api/v1/payments \
  -H "Authorization: Bearer key_test_abc123:secret_test_xyz789" \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "order_123",
    "method": "card",
    "card_number": "4532015112830366",
    "expiry": "12/25",
    "cvv": "123"
  }'

Expected Response (200 OK):
{
  "id": "payment_...",
  "order_id": "order_123",
  "amount": 5000,
  "method": "card",
  "card_network": "Visa",
  "card_last_four": "8366",
  "status": "processing",
  "created_at": "2026-01-10T..."
}
```

### Payment Status Check Test
```bash
curl -X GET http://localhost:8000/api/v1/payments/payment_123 \
  -H "Authorization: Bearer key_test_abc123:secret_test_xyz789"

Expected Response (200 OK):
{
  "id": "payment_123",
  "order_id": "order_123",
  "amount": 5000,
  "status": "success",
  "created_at": "2026-01-10T12:00:10Z",
  "completed_at": "2026-01-10T12:00:15Z"
}
```

## Validation Logic Testing

### VPA Validation
Valid VPA format: `[a-zA-Z0-9._-]+@[a-zA-Z0-9]+`

Test Cases:
- ✅ Valid: user@upi
- ✅ Valid: test.user@okhdfcbank
- ✅ Valid: user-123@ibl
- ❌ Invalid: userupi (no @)
- ❌ Invalid: @upi (no prefix)
- ❌ Invalid: user@ (no bank)

### Luhn Algorithm Validation
Test valid card numbers:
- ✅ Visa: 4532015112830366
- ✅ Mastercard: 5425233010103442
- ✅ Amex: 374245455400126
- ✅ RuPay: 6073249123456789

Test invalid card numbers:
- ❌ 4532015112830367 (fails Luhn check)
- ❌ 1234567890123456 (invalid length or fails Luhn)

### Card Network Detection
- Visa: Starts with 4
- Mastercard: Starts with 5 (51-55)
- Amex: Starts with 3 (34 or 37)
- RuPay: Starts with 6

### Expiry Validation
Valid expiry: MM/YY where current date <= expiry date
- ✅ Valid: 12/25 (if current date is before 12/2025)
- ❌ Invalid: 12/20 (expired)
- ❌ Invalid: 13/25 (invalid month)

## End-to-End Testing Flow

1. **Start Docker Containers**
   ```bash
   docker-compose up -d --build
   ```

2. **Verify Services**
   - API Health: GET http://localhost:8000/health
   - Test Merchant: GET http://localhost:8000/api/v1/test/merchant
   - Dashboard: http://localhost:3000
   - Checkout: http://localhost:3001

3. **Test Dashboard Login**
   - Navigate to http://localhost:3000
   - Login with test@example.com and any password
   - Verify API Key and Secret display
   - Check transactions list

4. **Test Order Creation via API**
   - Create an order using POST /api/v1/orders
   - Note the order ID and checkout_url

5. **Test Checkout Flow**
   - Access checkout page with order ID
   - Select payment method (UPI)
   - Enter valid VPA
   - Submit payment
   - Verify success state

6. **Test Card Payment Flow**
   - Create another order
   - Select Card payment method
   - Enter test card: 4532015112830366
   - Enter expiry: 12/25
   - Enter CVV: 123
   - Submit payment
   - Verify success state

7. **Test Error Handling**
   - Try invalid VPA format
   - Try invalid card number (fails Luhn)
   - Try expired card
   - Verify error messages display

## Automated Testing Notes

Automated tests will:
1. Clone the repository
2. Run `docker-compose up -d --build`
3. Wait for services to be healthy
4. Query all API endpoints
5. Verify response formats and status codes
6. Check for all required data-test-id attributes
7. Simulate user interactions on frontend
8. Verify payment flows end-to-end

Ensure all data-test-id attributes are:
- **Present**: Every required ID must be in the DOM
- **Unique**: No duplicates (except transaction-row)
- **Stable**: Don't change based on data or state
- **Accessible**: Easily findable by automated tests

## Troubleshooting

### Service Not Starting
- Check Docker is installed and running
- Verify ports 8000, 3000, 3001, 5432 are available
- Check logs: `docker-compose logs -f [service_name]`

### Frontend Elements Not Found
- Verify data-test-id attributes are spelled correctly
- Check for typos or spacing issues
- Ensure elements are rendered (not hidden by CSS)
- Open browser DevTools (F12) and inspect elements

### Payment Validation Failing
- Verify VPA format matches regex pattern
- Verify card number passes Luhn check
- Verify expiry date is valid (MM/YY format)
- Check API response for detailed error messages

## Documentation References

- API Response Formats: See README.md
- Database Schema: See Schema.md
- System Architecture: See Architecture.md
- Payment Validation Logic: See README.md (Security & Best Practices section)
