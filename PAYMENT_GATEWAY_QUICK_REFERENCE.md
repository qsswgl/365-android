# ⚡ 农行支付网关 - 快速参考卡

> 快速查阅 API 信息、命令和代码片段

---

## 🔗 API 端点速查

| # | 方法 | 端点 | 功能 | 参数 | 响应 |
|---|------|------|------|------|------|
| 1 | GET | `/` | API 信息 | 无 | name, version, status |
| 2 | GET | `/health` | 健康检查 | 无 | status, uptime |
| 3 | GET | `/ping` | Ping 测试 | 无 | "pong" |
| 4 | POST | `/api/payment/qrcode` | 扫码支付 | orderNo, amount... | qrCode, transactionId |
| 5 | POST | `/api/payment/ewallet` | 电子钱包支付 | 同上 | redirectUrl, transactionId |
| 6 | GET | `/api/payment/query/{orderNo}` | 订单查询 | orderNo | status, amount |
| 7 | POST | `/api/payment/notify` | 支付回调 | 农行发送 | "SUCCESS" |
| 8 | GET | `/api/payment/health` | 支付健康 | 无 | status, service |

---

## 🚀 快速命令

### Ping 测试
```powershell
# PowerShell
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"

# Bash
curl https://payment.qsgl.net/ping

# Python
import requests
print(requests.get("https://payment.qsgl.net/ping").text)
```

### 健康检查
```powershell
# PowerShell
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" | ConvertTo-Json

# Bash
curl https://payment.qsgl.net/health | jq .

# Python
import json, requests
data = requests.get("https://payment.qsgl.net/health").json()
print(json.dumps(data, indent=2))
```

### 创建支付订单
```powershell
# PowerShell
$body = @{
    orderNo = "ORD_$(Get-Date -UFormat %s)"
    amount = 0.01
    merchantId = "103881636900016"
    goodsName = "测试商品"
    notifyUrl = "https://your-backend.com/notify"
    returnUrl = "https://your-frontend.com/result"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/payment/qrcode" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body | ConvertTo-Json
```

```bash
# Bash
curl -X POST https://payment.qsgl.net/api/payment/qrcode \
  -H "Content-Type: application/json" \
  -d '{
    "orderNo": "ORD_'$(date +%s)'",
    "amount": 0.01,
    "merchantId": "103881636900016",
    "goodsName": "测试商品",
    "notifyUrl": "https://your-backend.com/notify",
    "returnUrl": "https://your-frontend.com/result"
  }' | jq .
```

```python
# Python
import requests, time

payload = {
    "orderNo": f"ORD_{int(time.time())}",
    "amount": 0.01,
    "merchantId": "103881636900016",
    "goodsName": "测试商品",
    "notifyUrl": "https://your-backend.com/notify",
    "returnUrl": "https://your-frontend.com/result"
}

response = requests.post(
    "https://payment.qsgl.net/api/payment/qrcode",
    json=payload
)

print(response.json())
```

### 查询订单
```powershell
# PowerShell
Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/payment/query/ORD20260106001" `
    -Method Get | ConvertTo-Json
```

```bash
# Bash
curl https://payment.qsgl.net/api/payment/query/ORD20260106001 | jq .
```

```python
# Python
import requests

response = requests.get(
    "https://payment.qsgl.net/api/payment/query/ORD20260106001"
)

print(response.json())
```

---

## 💻 代码片段

### Java - 创建订单

```java
RestTemplate restTemplate = new RestTemplate();
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);

Map<String, Object> request = new HashMap<>();
request.put("orderNo", "ORD_" + System.currentTimeMillis());
request.put("amount", 0.01);
request.put("merchantId", "103881636900016");
request.put("goodsName", "测试商品");
request.put("notifyUrl", "https://your-backend.com/notify");
request.put("returnUrl", "https://your-frontend.com/result");

HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);

ResponseEntity<Map> response = restTemplate.exchange(
    "https://payment.qsgl.net/api/payment/qrcode",
    HttpMethod.POST,
    entity,
    Map.class
);

System.out.println(response.getBody());
```

### Java - 查询订单

```java
ResponseEntity<Map> response = restTemplate.exchange(
    "https://payment.qsgl.net/api/payment/query/ORD20260106001",
    HttpMethod.GET,
    null,
    Map.class
);

Map<String, Object> order = response.getBody();
String status = (String) order.get("status");  // PENDING, SUCCESS, FAILED, EXPIRED
```

### Java - 处理回调

```java
@PostMapping("/api/payment/notify")
public String handleNotify(HttpServletRequest request) {
    String orderNo = request.getParameter("OrderNo");
    String status = request.getParameter("Status");
    String transactionId = request.getParameter("TransactionId");
    
    // 验证签名
    if (!verifySignature(request)) {
        return "FAIL";
    }
    
    // 更新订单
    if ("SUCCESS".equals(status)) {
        updateOrderStatus(orderNo, "PAID");
    }
    
    return "SUCCESS";
}
```

### Python - 创建订单

```python
import requests
import json

payload = {
    "orderNo": "ORD_" + str(int(time.time())),
    "amount": 0.01,
    "merchantId": "103881636900016",
    "goodsName": "测试商品",
    "notifyUrl": "https://your-backend.com/notify",
    "returnUrl": "https://your-frontend.com/result"
}

response = requests.post(
    "https://payment.qsgl.net/api/payment/qrcode",
    json=payload,
    headers={"Content-Type": "application/json"}
)

result = response.json()
print(f"订单号: {result['orderNo']}")
print(f"交易 ID: {result['transactionId']}")
print(f"二维码: {result['qrCode']}")
```

### Node.js - 创建订单

```javascript
const axios = require('axios');

const payload = {
    orderNo: `ORD_${Date.now()}`,
    amount: 0.01,
    merchantId: "103881636900016",
    goodsName: "测试商品",
    notifyUrl: "https://your-backend.com/notify",
    returnUrl: "https://your-frontend.com/result"
};

axios.post(
    'https://payment.qsgl.net/api/payment/qrcode',
    payload,
    { headers: { 'Content-Type': 'application/json' } }
).then(response => {
    console.log('订单创建成功:', response.data);
    console.log('二维码:', response.data.qrCode);
}).catch(error => {
    console.error('创建失败:', error.response.data);
});
```

---

## 📊 状态码和错误

### HTTP 状态码
| 代码 | 含义 | 处理方式 |
|------|------|---------|
| 200 | OK | 正常处理 |
| 400 | Bad Request | 检查参数 |
| 404 | Not Found | 订单不存在 |
| 500 | Server Error | 重试 |
| 503 | Service Unavailable | 服务故障，等待恢复 |

### 常见错误代码
| 错误代码 | 含义 | 解决方案 |
|---------|------|---------|
| INVALID_AMOUNT | 金额错误 | 检查金额格式 |
| INVALID_MERCHANT_ID | 商户 ID 错误 | 确认商户 ID |
| ORDER_DUPLICATE | 订单重复 | 生成新的订单号 |
| ORDER_NOT_FOUND | 订单不存在 | 检查订单号 |
| PAYMENT_ERROR | 支付错误 | 联系技术支持 |

---

## ✅ 验证网关

### 完整检查（3 分钟）
```powershell
# 运行完整测试套件
.\test-payment-gateway.ps1
```

### 快速检查（30 秒）
```powershell
# 1. Ping 测试
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"  # 应该返回 "pong"

# 2. 健康检查
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" | ConvertTo-Json  # 应该显示 "healthy"

# 3. API 信息
Invoke-RestMethod -Uri "https://payment.qsgl.net/"  # 应该显示 API 信息
```

---

## 📋 订单参数

### 创建订单必需参数

```
orderNo       (string)  - 订单号，唯一，由您生成
amount        (number)  - 金额（元），最多 2 位小数
merchantId    (string)  - 商户 ID: 103881636900016
goodsName     (string)  - 商品名称
notifyUrl     (string)  - 回调地址 (可选)
returnUrl     (string)  - 返回地址 (可选)
remarks       (string)  - 备注 (可选)
```

### 响应字段说明

```
isSuccess       (boolean) - 是否成功
orderNo         (string)  - 订单号
transactionId   (string)  - 交易流水号（农行生成）
status          (string)  - 状态: PENDING/SUCCESS/FAILED/EXPIRED
qrCode          (string)  - 二维码（扫码支付）
redirectUrl     (string)  - 跳转 URL（电子钱包）
message         (string)  - 返回信息
timestamp       (string)  - 时间戳
```

---

## 🔄 订单状态流转

```
创建订单
  ↓
PENDING (待支付)
  ↓
  ├─→ SUCCESS (支付成功) ✓
  │     ↓
  │   订单完成
  │
  ├─→ FAILED (支付失败) ✗
  │     ↓
  │   允许重试
  │
  └─→ EXPIRED (订单过期) ⏰
        ↓
      需要创建新订单
```

---

## 🔐 安全最佳实践

1. **始终验证签名** - 使用农行公钥验证回调数据
2. **HTTPS only** - 所有通信都必须使用 HTTPS
3. **不要暴露商户 ID** - 在前端隐藏商户 ID
4. **验证金额** - 回调时再次验证金额是否正确
5. **处理重复回调** - 农行可能发送多次回调，需要幂等处理
6. **日志记录** - 记录所有交易和回调，便于对账

---

## 🚨 常见问题

### Q: 如何生成唯一订单号？
```java
// 使用时间戳 + UUID
String orderNo = "ORD_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8);

// 或使用自增 ID
String orderNo = "ORD_" + order.getId();
```

### Q: 支付完成后如何获取订单状态？
```
方法 1: 通过回调通知（主动推送）
方法 2: 通过查询 API（主动拉取）GET /api/payment/query/{orderNo}
方法 3: 定时任务查询（定期检查）
```

### Q: 回调重复怎么办？
```
使用 transactionId 作为关键字进行幂等处理：
if (已经存在此 transactionId 的记录) {
    return "SUCCESS"  // 不再处理，直接返回成功
}
```

### Q: 如何处理超时问题？
```
建议设置 10-30 秒超时，并实现重试机制
最多重试 3 次，每次间隔 5 秒
```

---

## 📞 快速参考

**网关地址**: https://payment.qsgl.net  
**商户 ID**: 103881636900016  
**技术支持**: support@qsgl.net  
**API 文档**: https://payment.qsgl.net/docs  
**Swagger**: https://payment.qsgl.net/swagger.json  

---

## 📚 相关文档

- `PAYMENT_GATEWAY_QUICK_START.md` - 快速开始（15 分钟）
- `PAYMENT_GATEWAY_API_REFERENCE.md` - 完整 API 参考
- `PAYMENT_GATEWAY_BACKEND_INTEGRATION.md` - 后端集成代码
- `PAYMENT_GATEWAY_UPDATED_SUMMARY.md` - 更新总结
- `test-payment-gateway.ps1` - PowerShell 测试脚本
- `test-payment-gateway.py` - Python 测试脚本

---

**版本**: 1.0  
**更新**: 2026-01-06  
**状态**: ✅ 可用

