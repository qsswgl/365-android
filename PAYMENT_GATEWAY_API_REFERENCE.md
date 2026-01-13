# 🌐 农行支付网关 API 完整参考指南

> 基于官方 Swagger 文档：https://payment.qsgl.net/swagger.json  
> 更新时间：2026-01-06  
> 版本：1.0.0

---

## 📋 目录

1. [API 概览](#-api-概览)
2. [基础端点](#-基础端点)
3. [支付相关端点](#-支付相关端点)
4. [数据模型](#-数据模型)
5. [错误处理](#-错误处理)
6. [集成示例](#-集成示例)
7. [故障排查](#-故障排查)

---

## 🏢 API 概览

### 服务信息

| 项目 | 值 |
|------|-----|
| **API 名称** | 农行支付网关 API |
| **版本** | 1.0.0 |
| **描述** | 农行综合收银台支付网关接口服务 |
| **联系人** | 技术支持 |
| **联系邮箱** | support@qsgl.net |

### 服务地址

| 环境 | URL |
|------|-----|
| **生产环境** | https://payment.qsgl.net |
| **开发环境** | http://localhost:8080 |

### 支持的支付方式

- ✓ 扫码支付（二维码）
- ✓ 电子钱包支付
- ✓ 银行卡支付
- ✓ App 支付
- ✓ 网页支付

---

## 🔧 基础端点

### 1. 获取 API 信息 - 根端点

```
GET /
```

**用途**: 获取 API 的基本信息，包括版本、状态等

**请求示例**:
```bash
curl -X GET https://payment.qsgl.net/
```

**PowerShell 示例**:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/" -Method Get
```

**Python 示例**:
```python
import requests
response = requests.get("https://payment.qsgl.net/")
print(response.json())
```

**响应 (200 OK)**:
```json
{
  "name": "农行支付网关 API",
  "version": "1.0",
  "status": "running",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "environment": "Production"
}
```

**响应说明**:
- `name` - API 服务名称
- `version` - API 版本号
- `status` - 服务运行状态
- `timestamp` - 响应时间戳（ISO 8601 格式）
- `environment` - 运行环境（生产/测试）

---

### 2. 健康检查

```
GET /health
```

**用途**: 检查 API 服务的健康状态（Docker healthcheck、监控系统使用）

**请求示例**:
```bash
curl -X GET https://payment.qsgl.net/health
```

**PowerShell 示例**:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" -Method Get
```

**Python 示例**:
```python
import requests
response = requests.get("https://payment.qsgl.net/health")
print(response.json())
```

**响应 (200 OK - 健康)**:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "uptime": 3600
}
```

**响应 (503 Service Unavailable - 不健康)**:
```json
{
  "status": "unhealthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "message": "Critical dependencies unavailable"
}
```

**状态值说明**:
| 状态 | 含义 | HTTP 代码 |
|------|------|---------|
| `healthy` | 服务健康，正常运行 | 200 |
| `degraded` | 性能下降，部分功能受影响 | 200 |
| `unhealthy` | 服务故障，无法正常运行 | 503 |

**响应字段说明**:
- `status` - 健康状态枚举值
- `timestamp` - 响应时间戳
- `uptime` - 应用运行时间（秒）
- `message` - 状态描述（仅在异常时返回）

---

### 3. Ping 测试

```
GET /ping
```

**用途**: 简单的 Ping 测试端点，验证 API 连接是否正常

**请求示例**:
```bash
curl -X GET https://payment.qsgl.net/ping
```

**PowerShell 示例**:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping" -Method Get
```

**Python 示例**:
```python
import requests
response = requests.get("https://payment.qsgl.net/ping")
print(response.text)  # 返回文本，不是 JSON
```

**响应 (200 OK)**:
```
pong
```

**说明**: 此端点返回纯文本 "pong"，用于快速验证服务可用性。

---

### 4. 支付服务健康检查

```
GET /api/payment/health
```

**用途**: 检查支付服务的健康状态

**请求示例**:
```bash
curl -X GET https://payment.qsgl.net/api/payment/health
```

**PowerShell 示例**:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/api/payment/health" -Method Get
```

**Python 示例**:
```python
import requests
response = requests.get("https://payment.qsgl.net/api/payment/health")
print(response.json())
```

**响应 (200 OK)**:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "service": "ABC Payment Gateway"
}
```

**说明**: 此端点专门用于检查支付功能的健康状态。

---

## 💳 支付相关端点

### 5. 创建扫码支付订单

```
POST /api/payment/qrcode
Content-Type: application/json
```

**用途**: 使用二维码方式创建支付订单，客户端扫描返回的二维码进行支付

**请求示例**:
```bash
curl -X POST https://payment.qsgl.net/api/payment/qrcode \
  -H "Content-Type: application/json" \
  -d '{
    "orderNo": "ORD20260106001",
    "amount": 100.00,
    "merchantId": "103881636900016",
    "goodsName": "商品购买",
    "notifyUrl": "https://example.com/api/payment/notify",
    "returnUrl": "https://example.com/payment/result",
    "remarks": "订单备注"
  }'
```

**PowerShell 示例**:
```powershell
$body = @{
    orderNo = "ORD20260106001"
    amount = 100.00
    merchantId = "103881636900016"
    goodsName = "商品购买"
    notifyUrl = "https://example.com/api/payment/notify"
    returnUrl = "https://example.com/payment/result"
    remarks = "订单备注"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/payment/qrcode" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**Python 示例**:
```python
import requests
import json

payload = {
    "orderNo": "ORD20260106001",
    "amount": 100.00,
    "merchantId": "103881636900016",
    "goodsName": "商品购买",
    "notifyUrl": "https://example.com/api/payment/notify",
    "returnUrl": "https://example.com/payment/result",
    "remarks": "订单备注"
}

response = requests.post(
    "https://payment.qsgl.net/api/payment/qrcode",
    json=payload,
    headers={"Content-Type": "application/json"}
)

print(response.json())
```

**请求参数说明**:
| 参数 | 类型 | 必需 | 说明 | 例子 |
|------|------|------|------|------|
| `orderNo` | string | ✓ | 订单号，商户系统内唯一 | ORD20260106001 |
| `amount` | number | ✓ | 支付金额，单位：元 | 100.00 |
| `merchantId` | string | ✓ | 商户 ID，由农行分配 | 103881636900016 |
| `goodsName` | string | ✓ | 商品名称/订单描述 | 商品购买 |
| `notifyUrl` | string | ✗ | 支付回调地址 | https://example.com/api/payment/notify |
| `returnUrl` | string | ✗ | 返回地址 | https://example.com/payment/result |
| `remarks` | string | ✗ | 备注信息 | 订单备注 |

**成功响应 (200 OK)**:
```json
{
  "isSuccess": true,
  "orderNo": "ORD20260106001",
  "transactionId": "2026010600000001",
  "status": "PENDING",
  "qrCode": "https://payment.abc.com/scan/1234567890",
  "message": "支付订单创建成功",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

**失败响应 (400 Bad Request)**:
```json
{
  "isSuccess": false,
  "message": "金额格式错误",
  "errorCode": "INVALID_AMOUNT",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

---

### 6. 创建电子钱包支付订单

```
POST /api/payment/ewallet
Content-Type: application/json
```

**用途**: 使用电子钱包方式创建支付订单

**请求示例**:
```bash
curl -X POST https://payment.qsgl.net/api/payment/ewallet \
  -H "Content-Type: application/json" \
  -d '{
    "orderNo": "EWALLET20260106001",
    "amount": 50.00,
    "merchantId": "103881636900016",
    "goodsName": "电子钱包充值",
    "notifyUrl": "https://example.com/api/payment/notify",
    "returnUrl": "https://example.com/payment/result"
  }'
```

**PowerShell 示例**:
```powershell
$body = @{
    orderNo = "EWALLET20260106001"
    amount = 50.00
    merchantId = "103881636900016"
    goodsName = "电子钱包充值"
    notifyUrl = "https://example.com/api/payment/notify"
    returnUrl = "https://example.com/payment/result"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/payment/ewallet" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**Python 示例**:
```python
import requests

payload = {
    "orderNo": "EWALLET20260106001",
    "amount": 50.00,
    "merchantId": "103881636900016",
    "goodsName": "电子钱包充值",
    "notifyUrl": "https://example.com/api/payment/notify",
    "returnUrl": "https://example.com/payment/result"
}

response = requests.post(
    "https://payment.qsgl.net/api/payment/ewallet",
    json=payload
)

print(response.json())
```

**请求参数**: 同 `/api/payment/qrcode`

**成功响应 (200 OK)**:
```json
{
  "isSuccess": true,
  "orderNo": "EWALLET20260106001",
  "transactionId": "2026010600000002",
  "status": "PENDING",
  "redirectUrl": "https://payment.abc.com/ewallet/pay?orderNo=EWALLET20260106001",
  "message": "支付订单创建成功",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

---

### 7. 查询订单状态

```
GET /api/payment/query/{orderNo}
```

**用途**: 根据订单号查询支付订单的当前状态

**请求示例**:
```bash
curl -X GET https://payment.qsgl.net/api/payment/query/ORD20260106001
```

**PowerShell 示例**:
```powershell
$orderNo = "ORD20260106001"

Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/payment/query/$orderNo" `
    -Method Get
```

**Python 示例**:
```python
import requests

order_no = "ORD20260106001"

response = requests.get(
    f"https://payment.qsgl.net/api/payment/query/{order_no}"
)

print(response.json())
```

**URL 参数说明**:
| 参数 | 类型 | 说明 | 例子 |
|------|------|------|------|
| `orderNo` | string | 订单号，在 URL 路径中 | ORD20260106001 |

**成功响应 (200 OK)**:
```json
{
  "isSuccess": true,
  "orderNo": "ORD20260106001",
  "transactionId": "2026010600000001",
  "status": "SUCCESS",
  "amount": 100.00,
  "message": "订单查询成功",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

**订单状态值**:
| 状态 | 含义 |
|------|------|
| `PENDING` | 待支付，等待用户完成支付 |
| `SUCCESS` | 已支付，支付成功 |
| `FAILED` | 已失败，支付失败 |
| `EXPIRED` | 已过期，订单已过期，无法支付 |

**失败响应 (404 Not Found)**:
```json
{
  "isSuccess": false,
  "message": "订单不存在",
  "errorCode": "ORDER_NOT_FOUND",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

---

### 8. 支付回调通知

```
POST /api/payment/notify
Content-Type: application/x-www-form-urlencoded
```

**用途**: 农行支付系统向商户服务器的回调接口。当支付完成后，农行会向此端点发送回调通知。

**说明**: 
- 此接口由农行主动调用，不需要商户主动调用
- 商户需要在服务器上实现此接口来处理支付完成通知
- 需要验证签名确保数据安全

**回调请求示例** (农行发送):
```
POST https://example.com/api/payment/notify HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Host: example.com

OrderNo=ORD20260106001&TransactionId=2026010600000001&Status=SUCCESS&Amount=100.00&Timestamp=2026-01-06T14:35:00Z&Sign=xxxxxxxxxxxx...
```

**Java 后端实现示例**:
```java
@PostMapping("/api/payment/notify")
public String handlePaymentNotify(HttpServletRequest request) {
    try {
        // 1. 获取回调参数
        String orderNo = request.getParameter("OrderNo");
        String transactionId = request.getParameter("TransactionId");
        String status = request.getParameter("Status");
        String amount = request.getParameter("Amount");
        String sign = request.getParameter("Sign");
        
        // 2. 验证签名（使用农行公钥）
        boolean isSignValid = verifySignature(request, sign);
        if (!isSignValid) {
            return "FAIL"; // 签名验证失败
        }
        
        // 3. 根据状态更新订单
        if ("SUCCESS".equals(status)) {
            // 支付成功，更新订单状态
            updateOrderStatus(orderNo, "PAID");
            updateTransactionId(orderNo, transactionId);
        } else if ("FAILED".equals(status)) {
            // 支付失败
            updateOrderStatus(orderNo, "FAILED");
        }
        
        // 4. 返回 SUCCESS
        return "SUCCESS";
        
    } catch (Exception e) {
        logger.error("处理支付回调失败", e);
        return "FAIL";
    }
}

private boolean verifySignature(HttpServletRequest request, String sign) {
    // 使用农行公钥验证签名
    // 实现细节根据农行提供的 SDK
    return true; // 示例
}
```

**回调参数说明**:
| 参数 | 类型 | 说明 |
|------|------|------|
| `OrderNo` | string | 订单号 |
| `TransactionId` | string | 农行交易流水号 |
| `Status` | string | 支付状态 (SUCCESS/FAILED) |
| `Amount` | number | 支付金额 |
| `Timestamp` | datetime | 支付完成时间 |
| `Sign` | string | 农行签名，用于验证 |

**回调响应要求**:
- **成功**: 返回字符串 `SUCCESS` (HTTP 200)
- **失败**: 返回字符串 `FAIL` (任何 HTTP 状态)

---

## 📊 数据模型

### PaymentRequest (支付请求)

支付订单创建的请求对象。

```json
{
  "orderNo": "ORD20260106001",
  "amount": 100.00,
  "merchantId": "103881636900016",
  "goodsName": "商品购买",
  "notifyUrl": "https://example.com/api/payment/notify",
  "returnUrl": "https://example.com/payment/result",
  "remarks": "订单备注"
}
```

**字段说明**:
| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `orderNo` | string | ✓ | 订单号，商户系统内唯一 |
| `amount` | number | ✓ | 支付金额，单位：元，最多 2 位小数 |
| `merchantId` | string | ✓ | 商户 ID，由农行分配 |
| `goodsName` | string | ✓ | 商品名称，用于展示给用户 |
| `notifyUrl` | string | ✗ | 支付完成后的服务器回调地址 |
| `returnUrl` | string | ✗ | 支付完成后用户跳转的地址 |
| `remarks` | string | ✗ | 备注信息，不会显示给用户 |

---

### PaymentResponse (支付响应)

支付订单创建的响应对象。

```json
{
  "isSuccess": true,
  "orderNo": "ORD20260106001",
  "transactionId": "2026010600000001",
  "status": "PENDING",
  "qrCode": "https://payment.abc.com/scan/1234567890",
  "redirectUrl": "https://payment.abc.com/pay?orderNo=ORD20260106001",
  "message": "支付订单创建成功",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

**字段说明**:
| 字段 | 类型 | 说明 |
|------|------|------|
| `isSuccess` | boolean | 是否成功 |
| `orderNo` | string | 订单号 |
| `transactionId` | string | 农行交易流水号，用于对账 |
| `status` | string | 订单状态 (PENDING/SUCCESS/FAILED/EXPIRED) |
| `qrCode` | string | 二维码内容（仅扫码支付返回） |
| `redirectUrl` | string | 跳转 URL（部分支付方式返回） |
| `message` | string | 返回信息 |
| `timestamp` | datetime | 响应时间戳 |

---

### ErrorResponse (错误响应)

错误情况下的响应对象。

```json
{
  "isSuccess": false,
  "message": "金额格式错误",
  "errorCode": "INVALID_AMOUNT",
  "timestamp": "2026-01-06T14:30:00.1234567Z"
}
```

**字段说明**:
| 字段 | 类型 | 说明 |
|------|------|------|
| `isSuccess` | boolean | 总是 false |
| `message` | string | 错误信息描述 |
| `errorCode` | string | 错误代码 |
| `timestamp` | datetime | 错误发生时间戳 |

---

## ⚠️ 错误处理

### HTTP 状态码

| 状态码 | 含义 | 说明 |
|--------|------|------|
| 200 | OK | 请求成功 |
| 400 | Bad Request | 请求参数错误或业务处理失败 |
| 404 | Not Found | 资源不存在 |
| 500 | Internal Server Error | 服务器错误 |
| 503 | Service Unavailable | 服务不可用 |

### 常见错误代码

| 错误代码 | 含义 | 解决方案 |
|---------|------|---------|
| `INVALID_AMOUNT` | 金额格式错误 | 检查金额格式，确保有 2 位小数 |
| `INVALID_MERCHANT_ID` | 商户 ID 无效 | 确认商户 ID 是否正确 |
| `ORDER_DUPLICATE` | 订单号重复 | 使用新的唯一订单号 |
| `ORDER_NOT_FOUND` | 订单不存在 | 检查订单号是否正确 |
| `PAYMENT_ERROR` | 支付处理错误 | 查看错误消息，联系技术支持 |
| `GATEWAY_ERROR` | 网关错误 | 稍后重试或联系技术支持 |

### 错误处理最佳实践

```java
public void handlePaymentError(Exception e, String orderNo) {
    if (e instanceof HttpClientErrorException) {
        HttpClientErrorException httpError = (HttpClientErrorException) e;
        int status = httpError.getRawStatusCode();
        String body = httpError.getResponseBodyAsString();
        
        Map<String, Object> error = new Gson().fromJson(body, Map.class);
        String errorCode = (String) error.get("errorCode");
        String message = (String) error.get("message");
        
        // 根据错误代码处理
        switch (errorCode) {
            case "INVALID_AMOUNT":
                // 处理金额错误
                break;
            case "ORDER_DUPLICATE":
                // 处理重复订单，可能需要重新查询订单状态
                queryOrderStatus(orderNo);
                break;
            case "GATEWAY_ERROR":
                // 重试或记录日志
                retryPayment(orderNo);
                break;
            default:
                // 未知错误
                notifyAdmin(errorCode, message);
        }
    }
}
```

---

## 🔗 集成示例

### Java/Spring Boot 完整示例

```java
@Service
public class PaymentGatewayService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    private static final String GATEWAY_URL = "https://payment.qsgl.net";
    private static final String MERCHANT_ID = "103881636900016";
    
    /**
     * 创建扫码支付订单
     */
    public PaymentResponse createQRCodePayment(PaymentRequest request) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<PaymentRequest> httpEntity = new HttpEntity<>(request, headers);
            
            ResponseEntity<PaymentResponse> response = restTemplate.exchange(
                GATEWAY_URL + "/api/payment/qrcode",
                HttpMethod.POST,
                httpEntity,
                PaymentResponse.class
            );
            
            return response.getBody();
            
        } catch (Exception e) {
            logger.error("创建支付订单失败", e);
            throw new PaymentException("支付订单创建失败: " + e.getMessage());
        }
    }
    
    /**
     * 查询订单状态
     */
    public PaymentResponse queryOrderStatus(String orderNo) {
        try {
            ResponseEntity<PaymentResponse> response = restTemplate.exchange(
                GATEWAY_URL + "/api/payment/query/" + orderNo,
                HttpMethod.GET,
                null,
                PaymentResponse.class
            );
            
            return response.getBody();
            
        } catch (Exception e) {
            logger.error("查询订单失败", e);
            throw new PaymentException("订单查询失败: " + e.getMessage());
        }
    }
    
    /**
     * 检查网关健康状态
     */
    public HealthStatus checkGatewayHealth() {
        try {
            ResponseEntity<HealthStatus> response = restTemplate.exchange(
                GATEWAY_URL + "/health",
                HttpMethod.GET,
                null,
                HealthStatus.class
            );
            
            return response.getBody();
            
        } catch (Exception e) {
            logger.error("健康检查失败", e);
            return null;
        }
    }
}

@RestController
@RequestMapping("/api/payment")
public class PaymentController {
    
    @Autowired
    private PaymentGatewayService paymentGatewayService;
    
    @PostMapping("/order")
    public ResponseEntity<?> createOrder(@RequestBody PaymentRequest request) {
        try {
            PaymentResponse response = paymentGatewayService.createQRCodePayment(request);
            return ResponseEntity.ok(response);
        } catch (PaymentException e) {
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @PostMapping("/notify")
    public String handlePaymentNotify(HttpServletRequest request) {
        try {
            // 验证签名、处理支付结果...
            return "SUCCESS";
        } catch (Exception e) {
            return "FAIL";
        }
    }
}
```

### Python 完整示例

```python
import requests
from datetime import datetime
import logging

class PaymentGatewayService:
    def __init__(self):
        self.gateway_url = "https://payment.qsgl.net"
        self.merchant_id = "103881636900016"
        self.logger = logging.getLogger(__name__)
    
    def create_qrcode_payment(self, order_no, amount, goods_name, notify_url, return_url):
        """创建扫码支付订单"""
        try:
            payload = {
                "orderNo": order_no,
                "amount": amount,
                "merchantId": self.merchant_id,
                "goodsName": goods_name,
                "notifyUrl": notify_url,
                "returnUrl": return_url
            }
            
            response = requests.post(
                f"{self.gateway_url}/api/payment/qrcode",
                json=payload,
                headers={"Content-Type": "application/json"},
                timeout=10
            )
            
            response.raise_for_status()
            return response.json()
            
        except Exception as e:
            self.logger.error(f"创建支付订单失败: {str(e)}")
            raise
    
    def query_order_status(self, order_no):
        """查询订单状态"""
        try:
            response = requests.get(
                f"{self.gateway_url}/api/payment/query/{order_no}",
                timeout=10
            )
            
            response.raise_for_status()
            return response.json()
            
        except Exception as e:
            self.logger.error(f"查询订单失败: {str(e)}")
            raise
    
    def check_gateway_health(self):
        """检查网关健康状态"""
        try:
            response = requests.get(
                f"{self.gateway_url}/health",
                timeout=10
            )
            
            response.raise_for_status()
            return response.json()
            
        except Exception as e:
            self.logger.error(f"健康检查失败: {str(e)}")
            return None


# Flask 应用示例
from flask import Flask, request, jsonify

app = Flask(__name__)
payment_service = PaymentGatewayService()

@app.route('/api/payment/order', methods=['POST'])
def create_order():
    try:
        data = request.json
        response = payment_service.create_qrcode_payment(
            data['orderNo'],
            data['amount'],
            data['goodsName'],
            data['notifyUrl'],
            data['returnUrl']
        )
        return jsonify(response)
    except Exception as e:
        return jsonify({"isSuccess": False, "message": str(e)}), 500

@app.route('/api/payment/notify', methods=['POST'])
def handle_payment_notify():
    try:
        # 验证签名...
        order_no = request.form.get('OrderNo')
        status = request.form.get('Status')
        
        # 更新订单状态...
        
        return "SUCCESS"
    except Exception as e:
        return "FAIL"

if __name__ == '__main__':
    app.run(debug=True)
```

---

## 🔍 故障排查

### 问题 1: 连接超时

**症状**: 请求 API 时超时

**解决方案**:
1. 检查网络连接
2. 确认网关 URL 是否正确：`https://payment.qsgl.net`
3. 检查防火墙是否阻止 HTTPS 连接
4. 尝试从命令行 Ping 网关：`ping payment.qsgl.net`

### 问题 2: 403 Forbidden

**症状**: 返回 403 错误

**解决方案**:
1. 检查商户 ID 是否正确
2. 确认您的 IP 是否被限制
3. 联系技术支持检查 IP 白名单

### 问题 3: 支付订单创建失败

**症状**: 创建订单时返回错误

**解决方案**:
1. 检查所有必填参数是否都提供了
2. 验证金额格式（最多 2 位小数）
3. 确认订单号是否唯一
4. 检查回调 URL 是否有效

### 问题 4: 健康检查返回 unhealthy

**症状**: `/health` 端点返回 `unhealthy` 状态

**解决方案**:
1. 检查网关日志
2. 验证数据库连接
3. 确认农行 API 连接是否正常
4. 联系技术支持

### 调试技巧

1. **启用日志**: 记录所有 API 请求和响应
   ```java
   logging.level.org.springframework.web.client.RestTemplate=DEBUG
   ```

2. **使用 Postman**: 测试 API 端点
   - 导入 Swagger URL: `https://payment.qsgl.net/swagger.json`
   - 逐个测试各个端点

3. **监控网络**: 使用 Wireshark 或 Charles 分析请求

4. **保存交易 ID**: 每次成功的支付都会返回 `transactionId`，用于对账和调试

---

## 📞 获取帮助

- **技术支持**: support@qsgl.net
- **API 文档**: https://payment.qsgl.net/docs
- **Swagger 定义**: https://payment.qsgl.net/swagger.json

---

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| 1.0.0 | 2026-01-06 | 初始版本，包含 7 个 API 端点 |

---

**文档版本**: 1.0.0  
**最后更新**: 2026-01-06  
**维护者**: 农行支付网关技术团队

