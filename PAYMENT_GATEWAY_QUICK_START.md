# ⚡ 支付网关集成 - 快速开始（3 步）

> 您已有支付网关 API 文档（https://payment.qsgl.net/docs），现在快速集成它

---

## 🎯 3 个步骤，15 分钟完成

### 步骤 1️⃣: 验证网关（3 分钟）

**运行此命令**:

```powershell
# PowerShell - 方法 1: 健康检查
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" | ConvertTo-Json
```

**或**:

```powershell
# PowerShell - 方法 2: Ping 测试
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"
```

**或**:

```bash
# 任何终端 - 方法 3: 获取根信息
curl https://payment.qsgl.net/
```

**预期返回（健康检查）**:

```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "uptime": 3600
}
```

**或 Ping 响应**:

```
pong
```

**或 根信息**:

```json
{
  "name": "农行支付网关 API",
  "version": "1.0",
  "status": "running",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "environment": "Production"
}
```

✅ **完成！网关可用**

---

### 步骤 2️⃣: 修改后端（7 分钟）

**找到您的支付接口** (之前创建的):

```java
// 原代码位置
@PostMapping("/api/pay/createWeChatOrder")
public ResponseEntity<?> createWeChatOrder(@RequestBody PaymentRequest request) {
    // 原逻辑...
}
```

**替换为这段代码** - 调用网关的 **扫码支付端点**:

```java
@PostMapping("/api/pay/createWeChatOrder")
public ResponseEntity<?> createWeChatOrder(@RequestBody PaymentRequest request) {
    try {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        // ⭐ 构建支付请求
        Map<String, Object> paymentRequest = Map.of(
            "orderNo", request.getOrderNo(),
            "amount", request.getAmount(),
            "merchantId", "103881636900016",
            "goodsName", request.getGoodsName(),
            "notifyUrl", "https://您的后端/api/payment/notify",
            "returnUrl", "https://您的前端/payment/result"
        );
        
        HttpEntity<Map<String, Object>> httpEntity = new HttpEntity<>(paymentRequest, headers);
        
        // ⭐ 调用网关的扫码支付端点
        ResponseEntity<Map> response = restTemplate.exchange(
            "https://payment.qsgl.net/api/payment/qrcode",
            HttpMethod.POST,
            httpEntity,
            Map.class
        );
        
        return ResponseEntity.ok(response.getBody());
        
    } catch (Exception e) {
        return ResponseEntity.status(500).body(Map.of(
            "isSuccess", false,
            "message", e.getMessage(),
            "errorCode", "PAYMENT_ERROR"
        ));
    }
}
```

✅ **完成！后端已修改，调用的是网关的真实支付 API**

---

### 步骤 3️⃣: 测试（5 分钟）

**启动后端**:

```bash
mvn spring-boot:run
```

**运行测试脚本** (我已为您准备):

```powershell
# 运行我提供的测试脚本
.\test-payment-gateway.ps1
```

**或者手动测试**:

```powershell
$body = @{
    orderParams = @{
        OrderNo = "TEST_$(Get-Date -UFormat %s)"
        OrderDate = (Get-Date -Format "yyyy/MM/dd")
        OrderTime = (Get-Date -Format "HH:mm:ss")
        OrderAmount = "0.01"
        OrderDesc = "测试"
        AccountNo = "wxb4dcf9e2b3c8e5a1"
        PayTypeID = "APP"
        CurrencyCode = "156"
        BuyIP = "127.0.0.1"
    }
    requestParams = @{
        TrxType = "UnifiedOrderReq"
        PaymentType = "8"
        PaymentLinkType = "4"
        NotifyType = "1"
        ResultNotifyURL = "https://www.qsgl.net/pay/notify"
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "http://localhost:8080/api/pay/createWeChatOrder" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body | ConvertTo-Json
```

**如果看到 `"status": "success"` 和 `"payUrl"`，说明成功** ✅

---

## 🎉 就这么简单！

| 步骤 | 操作 | 时间 |
|------|------|------|
| 1 | 验证网关可用 | 3 分钟 |
| 2 | 修改后端代码 | 7 分钟 |
| 3 | 运行测试 | 5 分钟 |
| **总计** | **集成完成** | **15 分钟** |

---

## 📚 需要更多信息？

- **Swagger 定义的详细测试**: `PAYMENT_GATEWAY_SWAGGER_TEST.md` ⭐ **基于真实 API 定义**
- **完整的测试脚本**: `PAYMENT_GATEWAY_TEST_SCRIPTS.md`
- **详细的调试指南**: `PAYMENT_GATEWAY_DEBUG_GUIDE.md`
- **从客户端到网关的完整流程**: `INTEGRATE_PAYMENT_GATEWAY.md`
- **网关 Swagger 文档**: https://payment.qsgl.net/swagger.json
- **网关 API 文档**: https://payment.qsgl.net/docs

---

## 🚀 下一步

### 如果测试成功 ✅
1. 提交代码
2. 部署到测试服务器
3. 从客户端进行端到端测试

### 如果遇到问题 ❌
1. 查看 `PAYMENT_GATEWAY_DEBUG_GUIDE.md` 的故障排查部分
2. 运行 `.\test-payment-gateway.ps1` 获取详细信息
3. 检查网关日志

---

**准备好了？现在就开始吧！** ⚡

