# 🎯 从客户端测试到支付网关集成 - 完整指南

> 您已经验证了客户端 ✅，现在需要通过支付网关完成整个流程

---

## 📊 完整的支付流程

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  用户 App (客户端)                                           │
│  ├─ Console 调用: AndroidBridge.createWeChatPay()            │
│  └─ 获得参数: OrderParams + RequestParams  ✅               │
│                                                              │
└─────────────────────────┬──────────────────────────────────┘
                          │
                          │ POST 请求
                          │ 订单参数
                          ▼
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  您的后端服务器                                              │
│  ├─ 接收参数                                                │
│  ├─ 验证订单                                                │
│  └─ 转发到支付网关  ⏳                                       │
│                                                              │
└─────────────────────────┬──────────────────────────────────┘
                          │
                          │ POST 请求
                          │ 订单数据
                          ▼
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  支付网关 (payment.qsgl.net)                                 │
│  ├─ API: https://payment.qsgl.net/api/pay/createOrder       │
│  ├─ 调用农行支付接口                                        │
│  └─ 返回支付链接  ⏳                                         │
│                                                              │
└─────────────────────────┬──────────────────────────────────┘
                          │
                          │ 返回 PayUrl
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  您的后端服务器                                              │
│  └─ 返回支付链接给客户端                                    │
│                                                              │
└─────────────────────────┬──────────────────────────────────┘
                          │
                          │ 返回 PayUrl
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  用户 App (客户端)                                           │
│  ├─ 接收支付链接                                            │
│  ├─ 调起微信支付                                            │
│  └─ 完成支付  ⏳                                             │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## 🚀 集成步骤

### 步骤 1️⃣: 验证支付网关可用（5 分钟）

**运行测试脚本**:

```powershell
# 方法 1: 下载并运行我提供的脚本
.\test-payment-gateway.ps1
```

**或者直接测试**:

```powershell
# 快速验证网关连接
$info = Invoke-RestMethod -Uri "https://payment.qsgl.net/api/info"
$info | ConvertTo-Json
```

**预期输出**:
```json
{
  "name": "农行支付网关 API",
  "version": "1.0.0",
  "status": "running",
  "timestamp": "2026-01-06T14:30:00Z"
}
```

---

### 步骤 2️⃣: 修改后端服务（30 分钟）

**现有代码** (来自 `ABC_BACKEND_QUICK_CARD.md`):

```java
@PostMapping("/api/pay/createWeChatOrder")
public ResponseEntity<?> createWeChatOrder(@RequestBody PaymentRequest request) {
    try {
        // 1. 验证参数
        // 2. 调用农行接口（旧逻辑）
        // 3. 返回结果
    } catch (Exception e) {
        return ResponseEntity.status(500).body(...);
    }
}
```

**修改为通过网关的新代码**:

```java
@PostMapping("/api/pay/createWeChatOrder")
public ResponseEntity<?> createWeChatOrder(@RequestBody PaymentRequest request) {
    try {
        // 1. 验证参数
        Map<String, Object> orderParams = request.getOrderParams();
        Map<String, Object> requestParams = request.getRequestParams();
        
        if (orderParams == null || orderParams.get("OrderNo") == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "status", "error",
                "message", "缺少必要参数"
            ));
        }
        
        // 2. 通过支付网关创建订单（新逻辑）
        RestTemplate restTemplate = new RestTemplate();
        String gatewayUrl = "https://payment.qsgl.net/api/pay/createOrder";
        
        Map<String, Object> gatewayRequest = Map.of(
            "orderParams", orderParams,
            "requestParams", requestParams
        );
        
        @SuppressWarnings("unchecked")
        Map<String, Object> gatewayResponse = restTemplate.postForObject(
            gatewayUrl,
            gatewayRequest,
            Map.class
        );
        
        // 3. 检查网关返回
        if (!gatewayResponse.containsKey("payUrl")) {
            return ResponseEntity.status(500).body(Map.of(
                "status", "error",
                "message", "网关未返回支付链接"
            ));
        }
        
        // 4. 返回支付链接给客户端
        return ResponseEntity.ok(Map.of(
            "status", "success",
            "payUrl", gatewayResponse.get("payUrl"),
            "orderId", gatewayResponse.get("orderId"),
            "message", "订单创建成功"
        ));
        
    } catch (Exception e) {
        return ResponseEntity.status(500).body(Map.of(
            "status", "error",
            "message", e.getMessage()
        ));
    }
}
```

---

### 步骤 3️⃣: 本地测试后端（15 分钟）

**启动后端服务**:

```bash
# Spring Boot
mvn spring-boot:run

# 或者用 gradle
./gradlew bootRun
```

**测试接口**:

```powershell
# PowerShell 测试
$body = @{
    orderParams = @{
        OrderNo = "TEST_$(Get-Date -UFormat %s)"
        OrderDate = (Get-Date -Format "yyyy/MM/dd")
        OrderTime = (Get-Date -Format "HH:mm:ss")
        OrderAmount = "0.01"
        OrderDesc = "测试商品"
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
        CommodityType = "0101"
        MerModelFlag = "0"
        ResultNotifyURL = "https://www.qsgl.net/pay/notify"
    }
} | ConvertTo-Json

# 调用后端接口
$response = Invoke-RestMethod `
    -Uri "http://localhost:8080/api/pay/createWeChatOrder" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body

$response | ConvertTo-Json
```

**预期返回**:

```json
{
  "status": "success",
  "payUrl": "https://...",
  "orderId": "xxx",
  "message": "订单创建成功"
}
```

---

### 步骤 4️⃣: 从客户端调用后端（30 分钟）

**修改前端代码** (在 WebView 中):

```javascript
// 旧代码（仅生成参数）
const result = AndroidBridge.createWeChatPay(
  'TEST_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

// 新代码（调用后端，再调起支付）
const result = AndroidBridge.createWeChatPay(
  'TEST_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

const paymentData = JSON.parse(result);

// 发送到您的后端
fetch('https://your-backend.com/api/pay/createWeChatOrder', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    orderParams: paymentData.OrderParams,
    requestParams: paymentData.RequestParams
  })
})
.then(r => r.json())
.then(data => {
  console.log('后端返回:', data);
  
  if (data.status === 'success') {
    // 拿到支付链接，调起微信支付
    const payUrl = data.payUrl;
    console.log('支付链接:', payUrl);
    
    // TODO: 调起微信支付的代码
    // WeChat.pay(payUrl);
  } else {
    console.error('获取支付链接失败:', data.message);
  }
})
.catch(error => {
  console.error('请求失败:', error);
});
```

---

### 步骤 5️⃣: 完整端到端测试（1 小时）

**完整的测试场景**:

```javascript
// ========== 完整的支付流程测试 ==========

async function testPaymentFlow() {
  console.log('🎯 开始完整的支付流程测试');
  
  // 1. 生成支付参数
  console.log('📋 步骤 1: 生成支付参数');
  const result = AndroidBridge.createWeChatPay(
    'TEST_' + Date.now(),
    '0.01',
    '测试商品',
    'https://www.qsgl.net/pay/notify',
    'wxb4dcf9e2b3c8e5a1'
  );
  const paymentData = JSON.parse(result);
  console.log('✓ 参数生成成功:', paymentData);
  
  // 2. 调用后端接口
  console.log('\n🔗 步骤 2: 调用后端接口');
  const backendResponse = await fetch('https://your-backend.com/api/pay/createWeChatOrder', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      orderParams: paymentData.OrderParams,
      requestParams: paymentData.RequestParams
    })
  })
  .then(r => {
    console.log('✓ 后端响应: ' + r.status);
    return r.json();
  });
  
  console.log('✓ 后端返回:', backendResponse);
  
  // 3. 验证支付链接
  console.log('\n🔒 步骤 3: 验证支付链接');
  if (backendResponse.status === 'success' && backendResponse.payUrl) {
    console.log('✓ 支付链接有效:', backendResponse.payUrl);
  } else {
    console.error('✗ 支付链接无效:', backendResponse.message);
    return false;
  }
  
  // 4. 调起微信支付（如果有）
  console.log('\n💳 步骤 4: 调起微信支付');
  // TODO: 实现微信支付调起
  // const wechatResult = await WeChat.pay(backendResponse.payUrl);
  
  console.log('\n✅ 完整流程测试完成!');
  return true;
}

// 运行测试
testPaymentFlow().catch(console.error);
```

---

## 🧪 测试清单

### 第 1 阶段：网关连接测试

- [ ] 网关地址可访问 (https://payment.qsgl.net)
- [ ] API Info 接口返回成功
- [ ] 返回数据包含必要字段
- [ ] 网关状态为 "running" 或 "active"

### 第 2 阶段：后端集成测试

- [ ] 后端服务启动成功
- [ ] 后端接口接收请求
- [ ] 后端成功调用网关
- [ ] 后端返回支付链接
- [ ] 支付链接格式正确

### 第 3 阶段：客户端集成测试

- [ ] 客户端生成参数正确
- [ ] 客户端成功调用后端
- [ ] 客户端接收支付链接
- [ ] 客户端可以显示链接
- [ ] 支付链接可点击

### 第 4 阶段：完整流程测试

- [ ] 能完整执行整个流程
- [ ] 每个环节都没有错误
- [ ] 日志记录完整
- [ ] 错误处理正确

---

## 📝 配置文件修改

### application.properties

```properties
# 支付网关配置（新增）
payment.gateway.url=https://payment.qsgl.net

# 后端服务配置（现有）
server.port=8080
server.servlet.context-path=/

# API 调用配置
api.timeout.seconds=30
api.retry.count=3
```

### application.yml

```yaml
# 新增
payment:
  gateway:
    url: https://payment.qsgl.net
    timeout: 30s
    max-retries: 3

# 现有
server:
  port: 8080
  servlet:
    context-path: /
```

---

## 🔍 常见问题

### Q1: 网关连接超时

**原因**: 网络问题或网关宕机

**解决方案**:
```powershell
# 检查网络连接
Test-NetConnection payment.qsgl.net -Port 443

# 增加超时时间
$response = Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/info" `
    -TimeoutSec 60
```

### Q2: 支付链接为空

**原因**: 网关没有返回 PayUrl

**解决方案**:
1. 检查订单参数是否正确
2. 查看网关返回的完整数据
3. 查阅网关文档了解必须字段

### Q3: 后端无法调用网关

**原因**: 代理/防火墙问题或 HTTPS 证书问题

**解决方案**:
```java
// 跳过 HTTPS 证书验证（仅开发用）
HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();
httpClientBuilder.setSSLContext(
    SSLContext.getInstance("TLS")
);

CloseableHttpClient httpClient = httpClientBuilder.build();
HttpComponentsClientHttpRequestFactory factory = 
    new HttpComponentsClientHttpRequestFactory(httpClient);
    
RestTemplate restTemplate = new RestTemplate(factory);
```

### Q4: 支付链接无效

**原因**: 链接格式错误或网关生成失败

**解决方案**:
1. 检查链接是否包含必要参数
2. 验证订单信息是否正确
3. 检查网关日志

---

## 🎯 下一步

### 立刻做（现在）
- [ ] 运行网关测试脚本
- [ ] 确认网关可用
- [ ] 查看网关文档

### 今天做
- [ ] 修改后端代码
- [ ] 本地测试后端
- [ ] 修改前端代码

### 明天做
- [ ] 完整的端到端测试
- [ ] 处理错误情况
- [ ] 记录所有问题

### 本周做
- [ ] 性能优化
- [ ] 安全审计
- [ ] 部署到生产

---

## 📚 参考资源

- **支付网关文档**: https://payment.qsgl.net/docs
- **测试脚本**: `PAYMENT_GATEWAY_TEST_SCRIPTS.md`
- **调试指南**: `PAYMENT_GATEWAY_DEBUG_GUIDE.md`
- **客户端测试**: `ABC_WECHAT_PAY_5MIN_QUICK_START.md`

---

**现在就开始集成支付网关吧！** 🚀

