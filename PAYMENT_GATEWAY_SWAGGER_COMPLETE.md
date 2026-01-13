# 🎯 支付网关 API - 根据 Swagger 定义的完整指南

> 基于 https://payment.qsgl.net/swagger.json 的真实 API 定义

---

## 📊 网关提供的所有 API 端点

### 根据 Swagger 文档，网关目前提供 3 个端点：

#### 1️⃣ 根信息端点 (API Info)
```
GET /
```

**功能**: 获取 API 服务的基本信息

**请求示例**:
```bash
curl https://payment.qsgl.net/
```

**返回**:
```json
{
  "name": "农行支付网关 API",
  "version": "1.0",
  "status": "running",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "environment": "Production"
}
```

---

#### 2️⃣ 健康检查端点 (Health)
```
GET /health
```

**功能**: 返回应用的健康状态（用于监控和 Docker healthcheck）

**请求示例**:
```bash
curl https://payment.qsgl.net/health
```

**返回 (正常)**:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "uptime": 3600
}
```

**返回 (异常，HTTP 503)**:
```json
{
  "status": "unhealthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "message": "Critical dependencies unavailable",
  "uptime": 1800
}
```

**状态值**:
- `healthy` - 应用健康，可以使用 ✓
- `degraded` - 性能下降 ⚠
- `unhealthy` - 应用异常，需要管理员处理 ✗

---

#### 3️⃣ Ping 测试端点 (Utility)
```
GET /ping
```

**功能**: 简单的 Ping 测试，验证 API 连接

**请求示例**:
```bash
curl https://payment.qsgl.net/ping
```

**返回**:
```
pong
```

---

## ⚠️ 重要信息

**目前 Swagger 文档中只定义了这 3 个基础端点。**

支付相关的 API 端点（如 `/api/pay/createOrder` 等）可能：
1. ✓ 已部署但文档未更新
2. ⏳ 还在开发中
3. 📍 在不同的路径或需要特殊认证

**建议做法**:
1. 联系技术支持确认支付 API 的完整定义
2. 请他们更新 Swagger 文档
3. 或者直接查阅他们的开发文档

---

## 🛠️ 现在可以做的事

### 方案 A: 完全依赖 Swagger 定义的现有 API

```java
@Service
public class PaymentGatewayService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    // 验证网关健康状态
    public Map<String, Object> checkGatewayHealth() {
        return restTemplate.getForObject(
            "https://payment.qsgl.net/health",
            Map.class
        );
    }
    
    // 获取网关信息
    public Map<String, Object> getGatewayInfo() {
        return restTemplate.getForObject(
            "https://payment.qsgl.net/",
            Map.class
        );
    }
    
    // Ping 测试
    public String ping() {
        return restTemplate.getForObject(
            "https://payment.qsgl.net/ping",
            String.class
        );
    }
}
```

---

### 方案 B: 期望支付 API 已部署但未在 Swagger 中定义

如果支付 API 已部署（基于您提到的网关文档），它们可能在以下路径：

**可能的支付 API 路径**:
```
POST /api/pay/createOrder          - 创建支付订单
GET  /api/order/query              - 查询订单状态
GET  /api/pay/getLink              - 获取支付链接
POST /api/payment/notify           - 支付回调通知处理
GET  /api/payment-methods          - 获取支付方式列表
```

**测试方法** (手动探测):

```powershell
# 1. 尝试创建订单
$body = @{
    orderParams = @{
        OrderNo = "TEST_$(Get-Date -UFormat %s)"
        OrderAmount = "0.01"
        # ... 其他参数
    }
    requestParams = @{
        # ... 请求参数
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/pay/createOrder" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

---

## 📞 建议的下一步

### 1️⃣ 联系网关技术支持
```
问题: Swagger 文档中缺少支付相关的 API 端点定义
需求: 
  1. 更新 swagger.json 包含完整的支付 API
  2. 或提供完整的 API 文档
  3. 提供支付 API 的认证方式（如有需要）
```

### 2️⃣ 同时测试现有的基础 API

```powershell
# 保存为 test-gateway-basic.ps1
function Test-PaymentGateway {
    $baseUrl = "https://payment.qsgl.net"
    
    # 测试 1: Ping
    Write-Host "1. 测试 Ping..." -ForegroundColor Cyan
    try {
        $ping = Invoke-RestMethod -Uri "$baseUrl/ping"
        Write-Host "✓ Ping: $ping" -ForegroundColor Green
    } catch { Write-Host "✗ Ping 失败" -ForegroundColor Red }
    
    # 测试 2: 健康检查
    Write-Host "2. 测试健康检查..." -ForegroundColor Cyan
    try {
        $health = Invoke-RestMethod -Uri "$baseUrl/health"
        $status = $health.status
        Write-Host "✓ 状态: $status" -ForegroundColor Green
    } catch { Write-Host "✗ 健康检查失败" -ForegroundColor Red }
    
    # 测试 3: 根信息
    Write-Host "3. 获取 API 信息..." -ForegroundColor Cyan
    try {
        $info = Invoke-RestMethod -Uri "$baseUrl/"
        Write-Host "✓ API 名称: $($info.name)" -ForegroundColor Green
        Write-Host "  版本: $($info.version)" -ForegroundColor Green
        Write-Host "  环境: $($info.environment)" -ForegroundColor Green
    } catch { Write-Host "✗ 获取信息失败" -ForegroundColor Red }
    
    # 尝试发现支付 API
    Write-Host ""
    Write-Host "尝试发现支付 API..." -ForegroundColor Yellow
    
    $paymentPaths = @(
        "/api/pay/createOrder",
        "/api/order/query",
        "/api/pay/getLink",
        "/api/payment-methods",
        "/pay/createOrder",
        "/payment/order/create"
    )
    
    foreach ($path in $paymentPaths) {
        try {
            $response = Invoke-RestMethod -Uri "$baseUrl$path" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
            Write-Host "✓ 发现: $path" -ForegroundColor Green
        } catch {
            # 忽略错误，继续尝试下一个
        }
    }
}

Test-PaymentGateway
```

**运行此脚本**:
```powershell
.\test-gateway-basic.ps1
```

---

## 🎯 当前可以集成的内容

### 立刻可用

✅ 网关健康监控
```java
// 监控网关健康状态
@Scheduled(fixedDelay = 60000)
public void monitorGatewayHealth() {
    Map<String, Object> health = restTemplate.getForObject(
        "https://payment.qsgl.net/health",
        Map.class
    );
    
    if ("healthy".equals(health.get("status"))) {
        // 网关正常，可以接收支付请求
        paymentService.enablePayment();
    } else {
        // 网关异常，禁用支付功能
        paymentService.disablePayment();
    }
}
```

✅ 网关信息展示
```java
@GetMapping("/api/gateway/info")
public ResponseEntity<?> getGatewayInfo() {
    try {
        Map<String, Object> info = restTemplate.getForObject(
            "https://payment.qsgl.net/",
            Map.class
        );
        return ResponseEntity.ok(info);
    } catch (Exception e) {
        return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
    }
}
```

### 等待中

⏳ 支付相关 API（等待完整的定义）
- 创建订单
- 查询订单
- 获取支付链接
- 处理回调

---

## 📋 检查清单

### 现在就做

- [ ] 运行 Swagger 定义的 3 个端点测试
- [ ] 确认网关基础服务正常
- [ ] 记录网关的响应时间

### 接下来

- [ ] 联系网关技术支持获取支付 API 的完整定义
- [ ] 获取 swagger.json 的完整版本
- [ ] 确认支付 API 的认证方式

### 最后

- [ ] 根据完整的 API 定义进行集成
- [ ] 充分的测试和验证

---

## 📚 参考资源

- **Swagger JSON**: https://payment.qsgl.net/swagger.json
- **网关文档**: https://payment.qsgl.net/docs
- **测试指南**: `PAYMENT_GATEWAY_SWAGGER_TEST.md`
- **快速开始**: `PAYMENT_GATEWAY_QUICK_START.md`

---

## 💡 总结

**现状**:
- ✓ 网关基础服务可用（Ping、Health、Info）
- ⏳ 支付相关 API 需要确认

**建议**:
1. 先测试现有的 3 个基础 API
2. 联系技术支持确认支付 API 的完整定义
3. 等待 Swagger 文档更新或获取详细文档
4. 再进行支付集成开发

**下一步**:
→ 打开 `PAYMENT_GATEWAY_SWAGGER_TEST.md` 进行基础测试

