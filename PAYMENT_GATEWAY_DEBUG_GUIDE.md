# 🎯 支付网关 API - 本地调试完整指南

> 您的支付网关已部署在 https://payment.qsgl.net/docs#/
> 本指南基于 API Info 接口进行开发调试

---

## 📋 API 网关信息

**API 地址**: https://payment.qsgl.net/docs#/  
**文档格式**: Swagger/OpenAPI  
**API 类型**: RESTful  

---

## 🎯 第 1 步：了解 API Info 接口

### API 接口信息获取

**端点**: `GET /api/info`  
**功能**: 返回 API 的基本信息，包含名称、版本、运行状态等

### 请求示例

```bash
curl -X GET https://payment.qsgl.net/api/info
```

### PowerShell 请求

```powershell
$response = Invoke-RestMethod -Uri "https://payment.qsgl.net/api/info" -Method Get
$response | ConvertTo-Json | Write-Host
```

### JavaScript 请求

```javascript
fetch('https://payment.qsgl.net/api/info')
  .then(r => r.json())
  .then(data => console.log(JSON.stringify(data, null, 2)))
```

### 预期返回（基于文档截图）

```json
{
  "name": "农行支付网关 API",
  "version": "1.0.0",
  "status": "running",
  "timestamp": "2026-01-06T14:30:00.123456Z",
  "environment": "Production"
}
```

---

## 🚀 第 2 步：本地调试设置

### 环境准备

```powershell
# 1. 验证网络连接
Test-NetConnection payment.qsgl.net -Port 443

# 2. 验证 API 可访问
$uri = "https://payment.qsgl.net/api/info"
$response = Invoke-RestMethod -Uri $uri -Method Get
Write-Host "API 状态: $($response.status)"
```

### 从您的 Android 应用调用

**后端 Java Spring Boot 代码**:

```java
package com.qsgl365.payment;

import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class PaymentGatewayService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    private static final String GATEWAY_URL = "https://payment.qsgl.net";
    
    // 获取网关信息
    public Map<String, Object> getGatewayInfo() {
        String url = GATEWAY_URL + "/api/info";
        
        try {
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return response;
        } catch (Exception e) {
            return Map.of(
                "status", "error",
                "message", "获取网关信息失败: " + e.getMessage()
            );
        }
    }
    
    // 创建支付订单（调用网关）
    public Map<String, Object> createPaymentOrder(Map<String, Object> orderParams) {
        String url = GATEWAY_URL + "/api/pay/createOrder";
        
        try {
            Map<String, Object> response = restTemplate.postForObject(
                url,
                orderParams,
                Map.class
            );
            return response;
        } catch (Exception e) {
            return Map.of(
                "status", "error",
                "message", "创建订单失败: " + e.getMessage()
            );
        }
    }
}
```

---

## 💻 第 3 步：快速调试脚本

### PowerShell 快速测试脚本

```powershell
# payment-api-debug.ps1

# 配置
$GATEWAY_URL = "https://payment.qsgl.net"
$API_INFO_ENDPOINT = "/api/info"

# 彩色输出函数
function Write-Success {
    Write-Host $args[0] -ForegroundColor Green
}

function Write-Error-Msg {
    Write-Host $args[0] -ForegroundColor Red
}

function Write-Info {
    Write-Host $args[0] -ForegroundColor Cyan
}

# 1. 测试网关连接
Write-Info "========== 测试网关连接 =========="
try {
    $response = Invoke-RestMethod -Uri "$GATEWAY_URL$API_INFO_ENDPOINT" -Method Get -ErrorAction Stop
    Write-Success "✓ 网关连接成功"
    Write-Host "API 信息:"
    $response | ConvertTo-Json | Write-Host
} catch {
    Write-Error-Msg "✗ 网关连接失败: $_"
    exit 1
}

Write-Info ""
Write-Info "========== 网关信息解析 =========="
Write-Host "名称: $($response.name)"
Write-Host "版本: $($response.version)"
Write-Host "状态: $($response.status)"
Write-Host "时间戳: $($response.timestamp)"
Write-Host "环境: $($response.environment)"

Write-Success "✓ 调试完成"
```

**运行脚本**:
```powershell
.\payment-api-debug.ps1
```

---

### Python 快速测试脚本

```python
# payment_api_debug.py

import requests
import json
from datetime import datetime

# 配置
GATEWAY_URL = "https://payment.qsgl.net"
API_INFO_ENDPOINT = "/api/info"

def test_gateway_connection():
    """测试网关连接"""
    print("=" * 50)
    print("测试网关连接")
    print("=" * 50)
    
    try:
        url = f"{GATEWAY_URL}{API_INFO_ENDPOINT}"
        print(f"请求 URL: {url}")
        
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        print("\n✓ 网关连接成功")
        print(f"\nAPI 信息:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        # 解析信息
        print(f"\n━━━━ 网关信息详情 ━━━━")
        print(f"名称: {data.get('name', 'N/A')}")
        print(f"版本: {data.get('version', 'N/A')}")
        print(f"状态: {data.get('status', 'N/A')}")
        print(f"时间戳: {data.get('timestamp', 'N/A')}")
        print(f"环境: {data.get('environment', 'N/A')}")
        
        return True
        
    except requests.exceptions.RequestException as e:
        print(f"\n✗ 网关连接失败: {e}")
        return False

if __name__ == "__main__":
    success = test_gateway_connection()
    exit(0 if success else 1)
```

**运行脚本**:
```bash
python payment_api_debug.py
```

---

## 🧪 第 4 步：完整的调试工作流

### 步骤 1: 验证网关信息

```powershell
# 获取网关 API 信息
$info = Invoke-RestMethod -Uri "https://payment.qsgl.net/api/info"

# 检查关键字段
$info | Select-Object name, version, status, environment | Format-Table
```

### 步骤 2: 获取支付方法列表（如果有）

```powershell
# 获取支持的支付方式
$methods = Invoke-RestMethod -Uri "https://payment.qsgl.net/api/payment-methods" -Method Get

$methods | ConvertTo-Json | Write-Host
```

### 步骤 3: 调用支付接口

```powershell
# 构建订单参数
$orderData = @{
    OrderNo = "TEST_$(Get-Date -UFormat %s)"
    OrderDate = (Get-Date -Format "yyyy/MM/dd")
    OrderTime = (Get-Date -Format "HH:mm:ss")
    OrderAmount = "0.01"
    OrderDesc = "测试商品"
    AccountNo = "wxb4dcf9e2b3c8e5a1"
    PayTypeID = "APP"
    CurrencyCode = "156"
    BuyIP = "127.0.0.1"
    ResultNotifyURL = "https://www.qsgl.net/pay/notify"
} | ConvertTo-Json

# 调用支付网关
$response = Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/pay/createOrder" `
    -Method Post `
    -ContentType "application/json" `
    -Body $orderData

$response | ConvertTo-Json | Write-Host
```

---

## 📊 完整的调试检查清单

### 连接检查
- [ ] 网关地址可访问 (https://payment.qsgl.net)
- [ ] 文档页面可打开 (https://payment.qsgl.net/docs)
- [ ] API Info 接口返回成功
- [ ] 返回的 status 为 "running" 或 "active"

### 数据检查
- [ ] 返回值包含 name 字段
- [ ] 返回值包含 version 字段
- [ ] 返回值包含 status 字段
- [ ] 返回值格式为 JSON
- [ ] 无 SSL/TLS 错误

### 功能检查
- [ ] 能获取支付方法列表（如有）
- [ ] 能创建支付订单
- [ ] 能获取支付链接
- [ ] 能处理错误响应
- [ ] 能处理网络超时

---

## 🔍 常见错误和解决方案

### 错误 1: SSL/TLS 证书错误

**错误信息**:
```
The remote certificate is invalid according to the validation procedure.
```

**解决方案** (仅用于开发环境):

```powershell
# PowerShell 跳过 SSL 验证（开发用）
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$response = Invoke-RestMethod -Uri "https://payment.qsgl.net/api/info"
```

### 错误 2: 网络连接超时

**错误信息**:
```
The operation has timed out.
```

**解决方案**:

```powershell
# 增加超时时间
$response = Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/api/info" `
    -TimeoutSec 30
```

### 错误 3: 404 Not Found

**错误信息**:
```
(404) Not Found
```

**解决方案**:
1. 检查 API 端点是否正确
2. 查看文档确认正确的路径
3. 检查网关是否正确部署

---

## 🚀 从 Android 应用集成

### 修改后端支付服务

```java
@Service
public class PaymentService {
    
    @Value("${payment.gateway.url:https://payment.qsgl.net}")
    private String gatewayUrl;
    
    @Autowired
    private RestTemplate restTemplate;
    
    /**
     * 通过支付网关创建订单
     */
    public Map<String, Object> createOrderViaGateway(
        Map<String, Object> orderParams,
        Map<String, Object> requestParams
    ) {
        try {
            // 1. 构建网关请求
            Map<String, Object> gatewayRequest = new HashMap<>();
            gatewayRequest.put("orderParams", orderParams);
            gatewayRequest.put("requestParams", requestParams);
            
            // 2. 调用网关 API
            String url = gatewayUrl + "/api/pay/createOrder";
            
            Map<String, Object> response = restTemplate.postForObject(
                url,
                gatewayRequest,
                Map.class
            );
            
            // 3. 返回结果
            return response;
            
        } catch (Exception e) {
            return Map.of(
                "status", "error",
                "message", "网关调用失败: " + e.getMessage()
            );
        }
    }
    
    /**
     * 获取支付网关信息
     */
    public Map<String, Object> getGatewayInfo() {
        try {
            String url = gatewayUrl + "/api/info";
            Map<String, Object> info = restTemplate.getForObject(url, Map.class);
            return info;
        } catch (Exception e) {
            return Map.of(
                "status", "error",
                "message", e.getMessage()
            );
        }
    }
}
```

### 在 Controller 中使用

```java
@RestController
@RequestMapping("/api/payment")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    @GetMapping("/gateway-info")
    public ResponseEntity<?> getGatewayInfo() {
        Map<String, Object> info = paymentService.getGatewayInfo();
        return ResponseEntity.ok(info);
    }
    
    @PostMapping("/create-order")
    public ResponseEntity<?> createOrder(@RequestBody Map<String, Object> request) {
        Map<String, Object> orderParams = (Map<String, Object>) request.get("orderParams");
        Map<String, Object> requestParams = (Map<String, Object>) request.get("requestParams");
        
        Map<String, Object> result = paymentService.createOrderViaGateway(
            orderParams,
            requestParams
        );
        
        return ResponseEntity.ok(result);
    }
}
```

---

## 📱 Android 前端集成

### 修改 Console 测试代码

```javascript
// 从本地 Console 测试网关

// 1. 先获取网关信息
const gatewayInfo = await fetch('https://payment.qsgl.net/api/info')
  .then(r => r.json());

console.log('网关信息:', gatewayInfo);

// 2. 然后调用支付（通过您的后端）
const paymentResult = await fetch('/api/payment/create-order', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    orderParams: {
      OrderNo: 'TEST_' + Date.now(),
      OrderDate: '2026/01/06',
      OrderTime: '10:01:33',
      OrderAmount: '0.01',
      OrderDesc: '测试商品',
      AccountNo: 'wxb4dcf9e2b3c8e5a1',
      PayTypeID: 'APP',
      CurrencyCode: '156',
      BuyIP: '127.0.0.1',
      ResultNotifyURL: 'https://www.qsgl.net/pay/notify'
    },
    requestParams: {
      TrxType: 'UnifiedOrderReq',
      PaymentType: '8',
      PaymentLinkType: '4',
      NotifyType: '1',
      CommodityType: '0101',
      MerModelFlag: '0',
      ResultNotifyURL: 'https://www.qsgl.net/pay/notify'
    }
  })
})
.then(r => r.json());

console.log('支付结果:', paymentResult);
```

---

## 🔧 配置文件

### application.properties

```properties
# 支付网关配置
payment.gateway.url=https://payment.qsgl.net

# 支付相关配置
abc.merchant.id=103881636900016
abc.merchant.password=ay365365

# API 超时设置
api.timeout.seconds=30
api.max.retries=3
```

### application.yml

```yaml
payment:
  gateway:
    url: https://payment.qsgl.net
    timeout: 30s
    max-retries: 3

abc:
  merchant:
    id: "103881636900016"
    password: "ay365365"
```

---

## 🧪 测试清单

### 第 1 阶段：基础连接测试

- [ ] 网关 API 可访问
- [ ] 文档页面可打开
- [ ] API Info 接口返回成功
- [ ] 返回数据格式正确

### 第 2 阶段：功能测试

- [ ] 能获取支付方法列表
- [ ] 能创建测试订单
- [ ] 能获取支付链接
- [ ] 能处理错误情况

### 第 3 阶段：集成测试

- [ ] 后端调用网关成功
- [ ] 前端能接收返回数据
- [ ] 支付链接可用
- [ ] 完整流程可执行

### 第 4 阶段：生产测试

- [ ] 使用真实账户测试
- [ ] 验证支付成功
- [ ] 验证回调通知
- [ ] 验证数据一致性

---

## 📞 调试技巧

### 1. 保存 API 响应用于分析

```powershell
# 保存响应到文件
$response = Invoke-RestMethod -Uri "https://payment.qsgl.net/api/info"
$response | ConvertTo-Json | Out-File -FilePath "gateway-response.json" -Encoding UTF8

# 查看保存的文件
Get-Content gateway-response.json
```

### 2. 使用 Postman 测试（推荐）

1. 打开 Postman
2. 新建 GET 请求
3. URL: `https://payment.qsgl.net/api/info`
4. 点击 Send
5. 查看返回结果

### 3. 使用浏览器开发者工具

在浏览器 Console 中:
```javascript
fetch('https://payment.qsgl.net/api/info')
  .then(r => r.json())
  .then(d => console.table(d))
```

### 4. 实时日志查看

```powershell
# 实时查看应用日志
.\adb logcat | Select-String "PaymentService|gateway|payment"
```

---

## 🎯 下一步

### 立刻做（现在）
1. [ ] 打开 https://payment.qsgl.net/docs 查看完整文档
2. [ ] 运行本地测试脚本验证连接
3. [ ] 记录 API Info 返回的信息

### 今天做
1. [ ] 修改后端代码调用网关
2. [ ] 部署后端服务
3. [ ] 从前端测试支付流程

### 本周做
1. [ ] 完整的端到端测试
2. [ ] 处理边界情况
3. [ ] 部署到生产环境

---

## 📚 参考资源

- **API 文档**: https://payment.qsgl.net/docs
- **Swagger UI**: https://payment.qsgl.net/docs#/
- **API Info 端点**: https://payment.qsgl.net/api/info

---

**现在就打开网关文档并开始调试吧！** 🚀

