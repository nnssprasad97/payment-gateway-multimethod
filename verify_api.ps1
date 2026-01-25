$ErrorActionPreference = "Stop"

function Assert-Status($response, $expected) {
    if ($response.StatusCode -ne $expected) {
        Write-Error "Expected status $expected but got $($response.StatusCode). Content: $($response.Content)"
    }
}

Write-Host "1. Checking Health..."
$health = Invoke-WebRequest -Uri "http://localhost:8000/health" -Method Get -UseBasicParsing
Assert-Status $health 200
Write-Host "Health OK: $($health.Content)"

Write-Host "`n2. Creating Order..."
$headers = @{
    "X-Api-Key"    = "key_test_abc123"
    "X-Api-Secret" = "secret_test_xyz789"
    "Content-Type" = "application/json"
}
$orderBody = @{
    amount   = 50000
    currency = "INR"
    receipt  = "rcpt_test_1"
} | ConvertTo-Json

$order = Invoke-WebRequest -Uri "http://localhost:8000/api/v1/orders" -Method Post -Headers $headers -Body $orderBody -UseBasicParsing
Assert-Status $order 201
$orderData = $order.Content | ConvertFrom-Json
$orderId = $orderData.id
Write-Host "Order Created: $orderId"

Write-Host "`n3. Checking Public Order Endpoint (for Checkout)..."
$pubOrder = Invoke-WebRequest -Uri "http://localhost:8000/api/v1/orders/$orderId/public" -Method Get -UseBasicParsing
Assert-Status $pubOrder 200
Write-Host "Public Order OK"

Write-Host "`n4. Creating UPI Payment..."
$paymentBody = @{
    order_id = $orderId
    method   = "upi"
    vpa      = "test@upi"
} | ConvertTo-Json

$payment = Invoke-WebRequest -Uri "http://localhost:8000/api/v1/payments" -Method Post -Headers $headers -Body $paymentBody -UseBasicParsing
Assert-Status $payment 201
$paymentData = $payment.Content | ConvertFrom-Json
$paymentId = $paymentData.id
Write-Host "Payment Created: $paymentId (Status: $($paymentData.status))"

Write-Host "`n5. Polling Payment Status..."
Start-Sleep -Seconds 2
$status = Invoke-WebRequest -Uri "http://localhost:8000/api/v1/payments/$paymentId" -Method Get -Headers $headers -UseBasicParsing
$statusData = $status.Content | ConvertFrom-Json
Write-Host "Current Status: $($statusData.status)"

Write-Host "`nVerification Complete!"
