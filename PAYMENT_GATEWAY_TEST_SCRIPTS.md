# 测试支付网关 API 的快速脚本集合

## 1. PowerShell 快速测试脚本

保存为 `test-payment-gateway.ps1`:

```powershell
# test-payment-gateway.ps1
# 支付网关 API 快速测试脚本

# ═══════════════════════════════════════════════════════════
# 配置
# ═══════════════════════════════════════════════════════════

$GATEWAY_URL = "https://payment.qsgl.net"
$MerchantId = "103881636900016"
$NotifyUrl = "https://www.qsgl.net/pay/notify"

# ═══════════════════════════════════════════════════════════
# 彩色输出函数
# ═══════════════════════════════════════════════════════════

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Msg {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host "$Title" -ForegroundColor Blue
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
}

# ═══════════════════════════════════════════════════════════
# 测试 1: 获取 API 信息
# ═══════════════════════════════════════════════════════════

function Test-GatewayInfo {
    Write-Section "测试 1: 获取网关 API 信息"
    
    try {
        $url = "$GATEWAY_URL/api/info"
        Write-Info "请求: GET $url"
        
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 10
        
        Write-Success "网关信息获取成功"
        Write-Host ""
        Write-Host "返回数据:" -ForegroundColor Yellow
        $response | ConvertTo-Json | Write-Host
        
        return $response
    }
    catch {
        Write-Error-Msg "获取网关信息失败: $_"
        return $null
    }
}

# ═══════════════════════════════════════════════════════════
# 测试 2: 创建支付订单
# ═══════════════════════════════════════════════════════════

function Test-CreatePaymentOrder {
    Write-Section "测试 2: 创建支付订单"
    
    try {
        # 构建订单数据
        $orderNo = "TEST_$(Get-Date -UFormat %s)"
        $orderData = @{
            orderParams = @{
                OrderNo = $orderNo
                OrderDate = (Get-Date -Format "yyyy/MM/dd")
                OrderTime = (Get-Date -Format "HH:mm:ss")
                OrderAmount = "0.01"
                OrderDesc = "测试商品"
                AccountNo = "wxb4dcf9e2b3c8e5a1"
                PayTypeID = "APP"
                CurrencyCode = "156"
                BuyIP = "127.0.0.1"
                ReceiverAddress = ""
            }
            requestParams = @{
                TrxType = "UnifiedOrderReq"
                PaymentType = "8"
                PaymentLinkType = "4"
                NotifyType = "1"
                CommodityType = "0101"
                MerModelFlag = "0"
                MerchantRemarks = ""
                ResultNotifyURL = $NotifyUrl
            }
        }
        
        $url = "$GATEWAY_URL/api/pay/createOrder"
        $body = $orderData | ConvertTo-Json -Depth 10
        
        Write-Info "请求: POST $url"
        Write-Info "订单号: $orderNo"
        
        $response = Invoke-RestMethod `
            -Uri $url `
            -Method Post `
            -ContentType "application/json" `
            -Body $body `
            -TimeoutSec 10
        
        Write-Success "订单创建成功"
        Write-Host ""
        Write-Host "返回数据:" -ForegroundColor Yellow
        $response | ConvertTo-Json | Write-Host
        
        return $response
    }
    catch {
        Write-Error-Msg "创建订单失败: $_"
        return $null
    }
}

# ═══════════════════════════════════════════════════════════
# 测试 3: 获取支付链接
# ═══════════════════════════════════════════════════════════

function Test-GetPaymentLink {
    param($PaymentOrder)
    
    Write-Section "测试 3: 获取支付链接"
    
    if (-not $PaymentOrder) {
        Write-Error-Msg "没有有效的订单信息，跳过此测试"
        return
    }
    
    try {
        $orderId = $PaymentOrder.orderId
        
        if (-not $orderId) {
            Write-Error-Msg "订单中没有 orderId 字段"
            return
        }
        
        $url = "$GATEWAY_URL/api/pay/getLink?orderId=$orderId"
        
        Write-Info "请求: GET $url"
        
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 10
        
        Write-Success "支付链接获取成功"
        Write-Host ""
        Write-Host "支付链接:" -ForegroundColor Yellow
        Write-Host $response.payUrl -ForegroundColor Green
        
        return $response
    }
    catch {
        Write-Error-Msg "获取支付链接失败: $_"
        return $null
    }
}

# ═══════════════════════════════════════════════════════════
# 测试 4: 查询订单状态
# ═══════════════════════════════════════════════════════════

function Test-QueryOrderStatus {
    param($OrderNo)
    
    Write-Section "测试 4: 查询订单状态"
    
    if (-not $OrderNo) {
        Write-Error-Msg "缺少订单号，跳过此测试"
        return
    }
    
    try {
        $url = "$GATEWAY_URL/api/order/query?orderNo=$OrderNo"
        
        Write-Info "请求: GET $url"
        Write-Info "订单号: $OrderNo"
        
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 10
        
        Write-Success "订单状态查询成功"
        Write-Host ""
        Write-Host "订单状态:" -ForegroundColor Yellow
        $response | ConvertTo-Json | Write-Host
        
        return $response
    }
    catch {
        Write-Error-Msg "查询订单失败: $_"
        return $null
    }
}

# ═══════════════════════════════════════════════════════════
# 主函数
# ═══════════════════════════════════════════════════════════

function Main {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  支付网关 API 快速测试工具                              ║" -ForegroundColor Cyan
    Write-Host "║  Gateway: $GATEWAY_URL          ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    # 执行测试
    $gatewayInfo = Test-GatewayInfo
    
    if ($gatewayInfo) {
        Write-Success "网关状态正常，继续进行订单创建测试"
        
        $paymentOrder = Test-CreatePaymentOrder
        
        if ($paymentOrder) {
            Test-GetPaymentLink $paymentOrder
            
            if ($paymentOrder.OrderNo) {
                Start-Sleep -Seconds 2
                Test-QueryOrderStatus $paymentOrder.OrderNo
            }
        }
    }
    
    Write-Section "测试完成"
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════
# 运行主函数
# ═══════════════════════════════════════════════════════════

Main
```

**运行方法**:
```powershell
# 方法 1: 直接运行
.\test-payment-gateway.ps1

# 方法 2: 使用管理员模式
powershell -ExecutionPolicy Bypass -File .\test-payment-gateway.ps1

# 方法 3: 在 PowerShell 中直接执行
powershell -Command ". .\test-payment-gateway.ps1"
```

---

## 2. Python 快速测试脚本

保存为 `test_payment_gateway.py`:

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import json
from datetime import datetime
import sys

# ═══════════════════════════════════════════════════════════
# 配置
# ═══════════════════════════════════════════════════════════

GATEWAY_URL = "https://payment.qsgl.net"
MERCHANT_ID = "103881636900016"
NOTIFY_URL = "https://www.qsgl.net/pay/notify"

# ═══════════════════════════════════════════════════════════
# 颜色输出函数
# ═══════════════════════════════════════════════════════════

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    YELLOW = '\033[93m'
    END = '\033[0m'

def print_success(msg):
    print(f"{Colors.GREEN}✓ {msg}{Colors.END}")

def print_error(msg):
    print(f"{Colors.RED}✗ {msg}{Colors.END}")

def print_info(msg):
    print(f"{Colors.CYAN}ℹ {msg}{Colors.END}")

def print_section(title):
    print()
    print("━" * 60)
    print(f"{Colors.BLUE}{title}{Colors.END}")
    print("━" * 60)

# ═══════════════════════════════════════════════════════════
# 测试函数
# ═══════════════════════════════════════════════════════════

def test_gateway_info():
    """测试 1: 获取网关 API 信息"""
    print_section("测试 1: 获取网关 API 信息")
    
    try:
        url = f"{GATEWAY_URL}/api/info"
        print_info(f"请求: GET {url}")
        
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        print_success("网关信息获取成功")
        print(f"\n返回数据:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        return data
        
    except Exception as e:
        print_error(f"获取网关信息失败: {e}")
        return None

def test_create_payment_order():
    """测试 2: 创建支付订单"""
    print_section("测试 2: 创建支付订单")
    
    try:
        # 构建订单数据
        now = datetime.now()
        order_no = f"TEST_{int(now.timestamp())}"
        
        order_data = {
            "orderParams": {
                "OrderNo": order_no,
                "OrderDate": now.strftime("%Y/%m/%d"),
                "OrderTime": now.strftime("%H:%M:%S"),
                "OrderAmount": "0.01",
                "OrderDesc": "测试商品",
                "AccountNo": "wxb4dcf9e2b3c8e5a1",
                "PayTypeID": "APP",
                "CurrencyCode": "156",
                "BuyIP": "127.0.0.1",
                "ReceiverAddress": ""
            },
            "requestParams": {
                "TrxType": "UnifiedOrderReq",
                "PaymentType": "8",
                "PaymentLinkType": "4",
                "NotifyType": "1",
                "CommodityType": "0101",
                "MerModelFlag": "0",
                "MerchantRemarks": "",
                "ResultNotifyURL": NOTIFY_URL
            }
        }
        
        url = f"{GATEWAY_URL}/api/pay/createOrder"
        print_info(f"请求: POST {url}")
        print_info(f"订单号: {order_no}")
        
        response = requests.post(
            url,
            json=order_data,
            headers={"Content-Type": "application/json"},
            timeout=10
        )
        response.raise_for_status()
        
        data = response.json()
        print_success("订单创建成功")
        print(f"\n返回数据:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        return data
        
    except Exception as e:
        print_error(f"创建订单失败: {e}")
        return None

def test_get_payment_link(payment_order):
    """测试 3: 获取支付链接"""
    print_section("测试 3: 获取支付链接")
    
    if not payment_order or "orderId" not in payment_order:
        print_error("没有有效的订单信息或缺少 orderId")
        return None
    
    try:
        order_id = payment_order["orderId"]
        url = f"{GATEWAY_URL}/api/pay/getLink?orderId={order_id}"
        
        print_info(f"请求: GET {url}")
        
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        print_success("支付链接获取成功")
        print(f"\n支付链接:")
        print(f"{Colors.GREEN}{data.get('payUrl', 'N/A')}{Colors.END}")
        
        return data
        
    except Exception as e:
        print_error(f"获取支付链接失败: {e}")
        return None

def test_query_order_status(order_no):
    """测试 4: 查询订单状态"""
    print_section("测试 4: 查询订单状态")
    
    if not order_no:
        print_error("缺少订单号")
        return None
    
    try:
        url = f"{GATEWAY_URL}/api/order/query?orderNo={order_no}"
        
        print_info(f"请求: GET {url}")
        print_info(f"订单号: {order_no}")
        
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        print_success("订单状态查询成功")
        print(f"\n订单状态:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        return data
        
    except Exception as e:
        print_error(f"查询订单失败: {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 主函数
# ═══════════════════════════════════════════════════════════

def main():
    print()
    print(f"{Colors.CYAN}╔" + "═" * 58 + "╗{Colors.END}")
    print(f"{Colors.CYAN}║  支付网关 API 快速测试工具                              ║{Colors.END}")
    print(f"{Colors.CYAN}║  Gateway: {GATEWAY_URL:<40}║{Colors.END}")
    print(f"{Colors.CYAN}╚" + "═" * 58 + "╝{Colors.END}")
    
    # 执行测试
    gateway_info = test_gateway_info()
    
    if gateway_info:
        print_success("网关状态正常，继续进行订单创建测试")
        
        payment_order = test_create_payment_order()
        
        if payment_order:
            test_get_payment_link(payment_order)
            
            # 获取订单号用于查询
            order_no = payment_order.get("OrderNo") or payment_order.get("orderNo")
            if order_no:
                import time
                time.sleep(2)
                test_query_order_status(order_no)
    
    print_section("测试完成")
    print()

if __name__ == "__main__":
    main()
```

**运行方法**:
```bash
# 方法 1: 直接运行
python test_payment_gateway.py

# 方法 2: 使用 python3
python3 test_payment_gateway.py

# 方法 3: 给脚本执行权限
chmod +x test_payment_gateway.py
./test_payment_gateway.py
```

---

## 3. 快速测试命令

### 使用 curl 测试

```bash
# 1. 获取网关信息
curl -X GET "https://payment.qsgl.net/api/info"

# 2. 创建支付订单
curl -X POST "https://payment.qsgl.net/api/pay/createOrder" \
  -H "Content-Type: application/json" \
  -d '{
    "orderParams": {
      "OrderNo": "TEST_'$(date +%s)'",
      "OrderDate": "'$(date +%Y/%m/%d)'",
      "OrderTime": "'$(date +%H:%M:%S)'",
      "OrderAmount": "0.01",
      "OrderDesc": "测试商品",
      "AccountNo": "wxb4dcf9e2b3c8e5a1",
      "PayTypeID": "APP",
      "CurrencyCode": "156",
      "BuyIP": "127.0.0.1"
    },
    "requestParams": {
      "TrxType": "UnifiedOrderReq",
      "PaymentType": "8",
      "PaymentLinkType": "4",
      "NotifyType": "1",
      "ResultNotifyURL": "https://www.qsgl.net/pay/notify"
    }
  }'

# 3. 查询订单
curl -X GET "https://payment.qsgl.net/api/order/query?orderNo=TEST_123456789"
```

---

## 4. 使用 Postman 测试

### 导入配置

```json
{
  "info": {
    "name": "支付网关 API",
    "version": "1.0"
  },
  "item": [
    {
      "name": "获取网关信息",
      "request": {
        "method": "GET",
        "url": "{{gateway_url}}/api/info"
      }
    },
    {
      "name": "创建支付订单",
      "request": {
        "method": "POST",
        "url": "{{gateway_url}}/api/pay/createOrder",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"orderParams\": {...},\n  \"requestParams\": {...}\n}"
        }
      }
    }
  ],
  "variable": [
    {
      "key": "gateway_url",
      "value": "https://payment.qsgl.net"
    }
  ]
}
```

---

## 使用建议

### 第 1 步: 运行 PowerShell 脚本
```powershell
.\test-payment-gateway.ps1
```

### 第 2 步: 查看输出
注意以下关键信息：
- 网关连接状态
- API 返回的信息
- 订单创建是否成功
- 支付链接是否可用

### 第 3 步: 根据结果调整

如果成功 ✓:
- 继续集成到应用
- 准备生产部署

如果失败 ✗:
- 检查网络连接
- 查看错误信息
- 查阅网关文档

