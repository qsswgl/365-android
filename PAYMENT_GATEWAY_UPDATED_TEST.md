# 🔄 支付网关 API - 更新测试指南（2026年1月6日）

> 基于最新 Swagger 文档: https://payment.qsgl.net/swagger.json

---

## 📋 API 定义总结

### 🎯 当前可用的端点（Swagger 官方定义）

网关目前在 Swagger 文档中定义了 **3 个端点**：

| 标签 | 端点 | 方法 | 功能 | 状态 |
|-----|------|------|------|------|
| **API Info** | `/` | GET | 获取 API 服务信息 | ✅ 已定义 |
| **Health** | `/health` | GET | 健康检查 | ✅ 已定义 |
| **Utility** | `/ping` | GET | 连接测试 | ✅ 已定义 |

**重要**: 支付相关 API 在当前 Swagger 文档中 **不存在**。

---

## 🧪 完整的测试脚本

### 方案 A: PowerShell 完整测试

保存为 `test-gateway-complete.ps1`:

```powershell
#Requires -Version 5.0

# ============================================================================
# 支付网关完整测试脚本
# 基于最新 Swagger 定义: https://payment.qsgl.net/swagger.json
# ============================================================================

$gateway = "https://payment.qsgl.net"
$localGateway = "http://localhost:8080"

# 颜色定义
$colors = @{
    Success = "Green"
    Error = "Red"
    Warning = "Yellow"
    Info = "Cyan"
    Highlight = "Magenta"
}

function Write-Status {
    param([string]$Message, [ValidateSet("Success", "Error", "Warning", "Info", "Highlight")]$Type = "Info")
    Write-Host "  → $Message" -ForegroundColor $colors[$Type]
}

function Write-Header {
    param([string]$Title, [int]$Level = 1)
    $border = "═" * ($Title.Length + 4)
    Write-Host ""
    Write-Host $border -ForegroundColor $colors["Highlight"]
    Write-Host "  $Title" -ForegroundColor $colors["Highlight"]
    Write-Host $border -ForegroundColor $colors["Highlight"]
}

# ============================================================================
# 测试 1: API 根信息 (GET /)
# ============================================================================
Write-Header "测试 1: 获取 API 信息 (GET /)" 1

Write-Host "  端点: GET $gateway/" -ForegroundColor $colors["Info"]
Write-Host "  功能: 返回 API 的基本信息（名称、版本、运行状态等）" -ForegroundColor $colors["Info"]
Write-Host ""

try {
    $startTime = Get-Date
    $response = Invoke-RestMethod -Uri "$gateway/" -Method Get -TimeoutSec 10
    $duration = (Get-Date) - $startTime
    
    Write-Status "✓ 请求成功 (耗时: $($duration.TotalMilliseconds)ms)" "Success"
    Write-Host ""
    
    # 解析响应
    Write-Host "  响应字段:" -ForegroundColor $colors["Info"]
    Write-Host "    - 名称: $($response.name)" -ForegroundColor $colors["Success"]
    Write-Host "    - 版本: $($response.version)" -ForegroundColor $colors["Success"]
    Write-Host "    - 状态: $($response.status)" -ForegroundColor $colors["Success"]
    Write-Host "    - 环境: $($response.environment)" -ForegroundColor $colors["Success"]
    Write-Host "    - 时间戳: $($response.timestamp)" -ForegroundColor $colors["Success"]
    
    Write-Host ""
    Write-Host "  原始 JSON:" -ForegroundColor $colors["Info"]
    $response | ConvertTo-Json | Write-Host -ForegroundColor $colors["Success"]
    
} catch {
    Write-Status "✗ 请求失败: $($_.Exception.Message)" "Error"
    Write-Host "  建议: 检查网关是否在线，检查网络连接" -ForegroundColor $colors["Warning"]
}

# ============================================================================
# 测试 2: 健康检查 (GET /health)
# ============================================================================
Write-Header "测试 2: 健康检查 (GET /health)" 1

Write-Host "  端点: GET $gateway/health" -ForegroundColor $colors["Info"]
Write-Host "  功能: 返回应用的健康状态（用于 Docker healthcheck 和监控）" -ForegroundColor $colors["Info"]
Write-Host ""

try {
    $startTime = Get-Date
    $response = Invoke-RestMethod -Uri "$gateway/health" -Method Get -TimeoutSec 10
    $duration = (Get-Date) - $startTime
    
    # 判断健康状态
    $statusColor = switch ($response.status) {
        "healthy" { "Success" }
        "degraded" { "Warning" }
        "unhealthy" { "Error" }
        default { "Info" }
    }
    
    Write-Status "✓ 请求成功 (耗时: $($duration.TotalMilliseconds)ms)" "Success"
    Write-Host ""
    
    # 解析响应
    Write-Host "  响应字段:" -ForegroundColor $colors["Info"]
    Write-Host "    - 健康状态: $($response.status)" -ForegroundColor $colors[$statusColor]
    Write-Host "    - 运行时间: $($response.uptime) 秒 (~$($response.uptime / 3600) 小时)" -ForegroundColor $colors["Success"]
    Write-Host "    - 时间戳: $($response.timestamp)" -ForegroundColor $colors["Success"]
    
    # 详细状态说明
    Write-Host ""
    Write-Host "  📊 状态解释:" -ForegroundColor $colors["Info"]
    switch ($response.status) {
        "healthy" {
            Write-Host "    ✓ 应用完全正常，可以接收请求" -ForegroundColor $colors["Success"]
        }
        "degraded" {
            Write-Host "    ⚠ 应用性能下降，部分功能可用" -ForegroundColor $colors["Warning"]
        }
        "unhealthy" {
            Write-Host "    ✗ 应用异常，需要管理员处理" -ForegroundColor $colors["Error"]
        }
    }
    
    Write-Host ""
    Write-Host "  原始 JSON:" -ForegroundColor $colors["Info"]
    $response | ConvertTo-Json | Write-Host -ForegroundColor $colors[$statusColor]
    
} catch {
    Write-Status "✗ 请求失败: $($_.Exception.Message)" "Error"
    Write-Host "  建议: 网关可能不健康，检查网关日志" -ForegroundColor $colors["Warning"]
}

# ============================================================================
# 测试 3: Ping 测试 (GET /ping)
# ============================================================================
Write-Header "测试 3: 连接测试 (GET /ping)" 1

Write-Host "  端点: GET $gateway/ping" -ForegroundColor $colors["Info"]
Write-Host "  功能: 简单的 Ping 测试，验证 API 连接是否正常" -ForegroundColor $colors["Info"]
Write-Host ""

try {
    $startTime = Get-Date
    $response = Invoke-RestMethod -Uri "$gateway/ping" -Method Get -TimeoutSec 10
    $duration = (Get-Date) - $startTime
    
    Write-Status "✓ 请求成功 (耗时: $($duration.TotalMilliseconds)ms)" "Success"
    Write-Host ""
    
    Write-Host "  响应内容: '$response'" -ForegroundColor $colors["Success"]
    
    if ($response -eq "pong") {
        Write-Host "  ✓ Ping 测试正常" -ForegroundColor $colors["Success"]
    }
    
} catch {
    Write-Status "✗ 请求失败: $($_.Exception.Message)" "Error"
    Write-Host "  建议: 检查网络连接，可能是防火墙问题" -ForegroundColor $colors["Warning"]
}

# ============================================================================
# 测试 4: 支付 API 探测
# ============================================================================
Write-Header "测试 4: 支付 API 自动探测" 1

Write-Host "  尝试发现支付相关的 API 端点（在 Swagger 定义外）" -ForegroundColor $colors["Warning"]
Write-Host ""

# 可能的支付 API 路径
$paymentPaths = @(
    "/api/pay/createOrder",
    "/api/payment/createOrder",
    "/pay/createOrder",
    "/payment/order/create",
    "/api/order/create",
    "/api/transaction/create",
    "/api/pay/query",
    "/api/order/query",
    "/api/payment/status",
    "/webhook/pay",
    "/api/callback",
    "/api/notify",
    "/payment/notify"
)

Write-Host "  尝试访问 $($paymentPaths.Count) 个可能的端点..." -ForegroundColor $colors["Info"]
Write-Host ""

$found = @()

foreach ($path in $paymentPaths) {
    try {
        $response = Invoke-RestMethod -Uri "$gateway$path" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
        $found += $path
        Write-Status "✓ 发现: $path" "Success"
    } catch {
        # 静默失败，继续尝试
    }
}

Write-Host ""
if ($found.Count -gt 0) {
    Write-Status "发现 $($found.Count) 个支付 API 端点:" "Success"
    $found | ForEach-Object { Write-Host "    - $_" -ForegroundColor $colors["Success"] }
} else {
    Write-Status "未发现支付 API 端点（在当前 Swagger 文档外）" "Warning"
    Write-Host ""
    Write-Host "  💡 可能的原因:" -ForegroundColor $colors["Info"]
    Write-Host "    1. 支付 API 在不同的服务上" -ForegroundColor $colors["Info"]
    Write-Host "    2. 支付 API 已部署但 Swagger 文档未更新" -ForegroundColor $colors["Info"]
    Write-Host "    3. 支付 API 需要特殊的认证或请求头" -ForegroundColor $colors["Info"]
    Write-Host "    4. 支付 API 还在开发中" -ForegroundColor $colors["Info"]
}

# ============================================================================
# 测试 5: 本地开发环境测试
# ============================================================================
Write-Header "测试 5: 本地开发环境 (http://localhost:8080)" 1

Write-Host "  尝试连接本地开发网关..." -ForegroundColor $colors["Info"]
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "$localGateway/health" -Method Get -TimeoutSec 2
    Write-Status "✓ 本地网关可用" "Success"
    Write-Host "    状态: $($response.status)" -ForegroundColor $colors["Success"]
} catch {
    Write-Status "本地网关不可用（这是正常的，如果您未在本地运行网关）" "Warning"
}

# ============================================================================
# 测试总结
# ============================================================================
Write-Header "📊 测试总结" 1

Write-Host ""
Write-Host "  ✓ 已测试的功能:" -ForegroundColor $colors["Info"]
Write-Host "    1. 获取 API 信息 - 验证网关在线" -ForegroundColor $colors["Success"]
Write-Host "    2. 健康检查 - 验证网关状态" -ForegroundColor $colors["Success"]
Write-Host "    3. 连接测试 - 验证网络连通性" -ForegroundColor $colors["Success"]
Write-Host "    4. 支付 API 探测 - 搜索支付相关端点" -ForegroundColor $colors["Warning"]

Write-Host ""
Write-Host "  📋 下一步建议:" -ForegroundColor $colors["Info"]
Write-Host "    1. 确认网关基础服务正常（如果以上测试都通过 ✓）" -ForegroundColor $colors["Success"]
Write-Host "    2. 联系网关技术支持获取支付 API 的完整定义" -ForegroundColor $colors["Warning"]
Write-Host "    3. 请求更新 Swagger 文档或获取 API 文档" -ForegroundColor $colors["Warning"]
Write-Host "    4. 获取支付 API 的认证方式（如需要）" -ForegroundColor $colors["Warning"]
Write-Host "    5. 根据获得的 API 定义进行集成开发" -ForegroundColor $colors["Info"]

Write-Host ""
Write-Host "  📞 支持信息 (来自 Swagger 文档):" -ForegroundColor $colors["Info"]
Write-Host "    联系人: 技术支持" -ForegroundColor $colors["Info"]
Write-Host "    邮箱: support@qsgl.net" -ForegroundColor $colors["Info"]

Write-Host ""
Write-Host "  📚 Swagger 文档: https://payment.qsgl.net/swagger.json" -ForegroundColor $colors["Highlight"]
Write-Host "  📖 API 文档: https://payment.qsgl.net/docs" -ForegroundColor $colors["Highlight"]

Write-Host ""
```

**运行此脚本**:
```powershell
cd K:\365-android
.\test-gateway-complete.ps1
```

---

### 方案 B: Python 完整测试

保存为 `test_gateway_complete.py`:

```python
#!/usr/bin/env python3
"""
支付网关完整测试脚本
基于最新 Swagger 定义: https://payment.qsgl.net/swagger.json
"""

import requests
import json
import time
from datetime import datetime
from typing import Dict, Any, List
from enum import Enum

class Color:
    """ANSI 颜色定义"""
    HEADER = '\033[95m'
    OK = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    INFO = '\033[94m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

class Status(Enum):
    SUCCESS = "Success"
    ERROR = "Error"
    WARNING = "Warning"
    INFO = "Info"

def print_status(message: str, status: Status = Status.INFO):
    """打印状态信息"""
    colors = {
        Status.SUCCESS: Color.OK,
        Status.ERROR: Color.FAIL,
        Status.WARNING: Color.WARNING,
        Status.INFO: Color.INFO,
    }
    color = colors.get(status, Color.INFO)
    print(f"  {color}→ {message}{Color.RESET}")

def print_header(title: str, level: int = 1):
    """打印标题"""
    border = "═" * (len(title) + 4)
    print()
    print(f"{Color.BOLD}{Color.INFO}{border}{Color.RESET}")
    print(f"{Color.BOLD}{Color.INFO}  {title}{Color.RESET}")
    print(f"{Color.BOLD}{Color.INFO}{border}{Color.RESET}")

def test_api_root(gateway: str) -> bool:
    """测试 1: 获取 API 根信息 (GET /)"""
    print_header("测试 1: 获取 API 信息 (GET /)", 1)
    
    print(f"  端点: GET {gateway}/" + " " * (40 - len(f"{gateway}/")))
    print(f"  功能: 返回 API 的基本信息（名称、版本、运行状态等）")
    print()
    
    try:
        start = time.time()
        response = requests.get(f"{gateway}/", timeout=10)
        duration = (time.time() - start) * 1000
        
        response.raise_for_status()
        data = response.json()
        
        print_status(f"✓ 请求成功 (耗时: {duration:.0f}ms)", Status.SUCCESS)
        print()
        
        print("  响应字段:")
        print(f"    - 名称: {data.get('name')}")
        print(f"    - 版本: {data.get('version')}")
        print(f"    - 状态: {data.get('status')}")
        print(f"    - 环境: {data.get('environment')}")
        print(f"    - 时间戳: {data.get('timestamp')}")
        
        print()
        print("  原始 JSON:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        return True
        
    except Exception as e:
        print_status(f"✗ 请求失败: {str(e)}", Status.ERROR)
        print("  建议: 检查网关是否在线，检查网络连接")
        return False

def test_health(gateway: str) -> bool:
    """测试 2: 健康检查 (GET /health)"""
    print_header("测试 2: 健康检查 (GET /health)", 1)
    
    print(f"  端点: GET {gateway}/health")
    print("  功能: 返回应用的健康状态（用于 Docker healthcheck 和监控）")
    print()
    
    try:
        start = time.time()
        response = requests.get(f"{gateway}/health", timeout=10)
        duration = (time.time() - start) * 1000
        
        data = response.json()
        status = data.get('status', 'unknown')
        
        status_color = {
            'healthy': Color.OK,
            'degraded': Color.WARNING,
            'unhealthy': Color.FAIL,
        }.get(status, Color.INFO)
        
        print_status(f"✓ 请求成功 (耗时: {duration:.0f}ms)", Status.SUCCESS)
        print()
        
        print("  响应字段:")
        print(f"    - 健康状态: {status_color}{status}{Color.RESET}")
        uptime_hours = data.get('uptime', 0) / 3600
        print(f"    - 运行时间: {data.get('uptime')} 秒 (~{uptime_hours:.1f} 小时)")
        print(f"    - 时间戳: {data.get('timestamp')}")
        
        print()
        print("  📊 状态解释:")
        status_msg = {
            'healthy': '✓ 应用完全正常，可以接收请求',
            'degraded': '⚠ 应用性能下降，部分功能可用',
            'unhealthy': '✗ 应用异常，需要管理员处理',
        }.get(status, '❓ 未知状态')
        print(f"    {status_msg}")
        
        print()
        print("  原始 JSON:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        return status == 'healthy'
        
    except Exception as e:
        print_status(f"✗ 请求失败: {str(e)}", Status.ERROR)
        print("  建议: 网关可能不健康，检查网关日志")
        return False

def test_ping(gateway: str) -> bool:
    """测试 3: Ping 测试 (GET /ping)"""
    print_header("测试 3: 连接测试 (GET /ping)", 1)
    
    print(f"  端点: GET {gateway}/ping")
    print("  功能: 简单的 Ping 测试，验证 API 连接是否正常")
    print()
    
    try:
        start = time.time()
        response = requests.get(f"{gateway}/ping", timeout=10)
        duration = (time.time() - start) * 1000
        
        response.raise_for_status()
        data = response.text.strip()
        
        print_status(f"✓ 请求成功 (耗时: {duration:.0f}ms)", Status.SUCCESS)
        print()
        
        print(f"  响应内容: '{data}'")
        
        if data == "pong":
            print("  ✓ Ping 测试正常")
            return True
        else:
            print(f"  ⚠ 意外的响应: {data}")
            return False
        
    except Exception as e:
        print_status(f"✗ 请求失败: {str(e)}", Status.ERROR)
        print("  建议: 检查网络连接，可能是防火墙问题")
        return False

def discover_payment_apis(gateway: str) -> List[str]:
    """测试 4: 支付 API 自动探测"""
    print_header("测试 4: 支付 API 自动探测", 1)
    
    print("  尝试发现支付相关的 API 端点（在 Swagger 定义外）")
    print()
    
    payment_paths = [
        "/api/pay/createOrder",
        "/api/payment/createOrder",
        "/pay/createOrder",
        "/payment/order/create",
        "/api/order/create",
        "/api/transaction/create",
        "/api/pay/query",
        "/api/order/query",
        "/api/payment/status",
        "/webhook/pay",
        "/api/callback",
        "/api/notify",
        "/payment/notify"
    ]
    
    print(f"  尝试访问 {len(payment_paths)} 个可能的端点...")
    print()
    
    found = []
    
    for path in payment_paths:
        try:
            response = requests.get(f"{gateway}{path}", timeout=2)
            # 任何不是 404 的响应都表示路径存在
            if response.status_code != 404:
                found.append(path)
                print_status(f"✓ 发现: {path}", Status.SUCCESS)
        except:
            pass
    
    print()
    if found:
        print_status(f"发现 {len(found)} 个支付 API 端点:", Status.SUCCESS)
        for path in found:
            print(f"    - {path}")
    else:
        print_status("未发现支付 API 端点（在当前 Swagger 文档外）", Status.WARNING)
        print()
        print("  💡 可能的原因:")
        print("    1. 支付 API 在不同的服务上")
        print("    2. 支付 API 已部署但 Swagger 文档未更新")
        print("    3. 支付 API 需要特殊的认证或请求头")
        print("    4. 支付 API 还在开发中")
    
    return found

def main():
    """主测试函数"""
    gateway = "https://payment.qsgl.net"
    
    print(f"{Color.BOLD}{Color.HEADER}")
    print("=" * 70)
    print("  支付网关完整测试脚本")
    print("  基于最新 Swagger 定义: https://payment.qsgl.net/swagger.json")
    print("=" * 70)
    print(f"{Color.RESET}")
    
    # 执行测试
    results = {
        "API 信息": test_api_root(gateway),
        "健康检查": test_health(gateway),
        "连接测试": test_ping(gateway),
    }
    
    # 发现支付 API
    payment_apis = discover_payment_apis(gateway)
    
    # 打印总结
    print_header("📊 测试总结", 1)
    
    print()
    print("  ✓ 已测试的功能:")
    for test_name, result in results.items():
        symbol = "✓" if result else "✗"
        status = Status.SUCCESS if result else Status.ERROR
        print_status(f"{symbol} {test_name}", status)
    
    print()
    print("  📋 下一步建议:")
    
    all_pass = all(results.values())
    if all_pass:
        print_status("1. ✓ 网关基础服务正常", Status.SUCCESS)
        print("  2. 📞 联系网关技术支持获取支付 API 的完整定义")
        print("  3. 📋 请求更新 Swagger 文档或获取 API 文档")
        print("  4. 🔐 获取支付 API 的认证方式（如需要）")
    else:
        print_status("1. ✗ 检查网关连接问题", Status.ERROR)
        print("  2. 📞 联系网关技术支持")
    
    print()
    print("  📞 支持信息 (来自 Swagger 文档):")
    print("    联系人: 技术支持")
    print("    邮箱: support@qsgl.net")
    
    print()
    print(f"  {Color.BOLD}{Color.HEADER}📚 Swagger 文档: https://payment.qsgl.net/swagger.json{Color.RESET}")
    print(f"  {Color.BOLD}{Color.HEADER}📖 API 文档: https://payment.qsgl.net/docs{Color.RESET}")
    print()

if __name__ == "__main__":
    main()
```

**运行此脚本**:
```powershell
# 需要 Python 3.6+
python test_gateway_complete.py
```

---

## 🎯 快速命令测试

### 方法 1: PowerShell (推荐)

```powershell
# 1. 获取 API 信息
Write-Host "1. API 信息" -ForegroundColor Cyan
Invoke-RestMethod -Uri "https://payment.qsgl.net/" | ConvertTo-Json

# 2. 健康检查
Write-Host "`n2. 健康检查" -ForegroundColor Cyan
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" | ConvertTo-Json

# 3. Ping 测试
Write-Host "`n3. Ping 测试" -ForegroundColor Cyan
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"
```

### 方法 2: curl

```bash
# 1. 获取 API 信息
curl -s https://payment.qsgl.net/ | jq .

# 2. 健康检查
curl -s https://payment.qsgl.net/health | jq .

# 3. Ping 测试
curl -s https://payment.qsgl.net/ping
```

### 方法 3: 浏览器

直接访问：
- https://payment.qsgl.net/
- https://payment.qsgl.net/health
- https://payment.qsgl.net/ping

---

## 📊 预期响应

### GET / 预期响应

```json
{
  "name": "农行支付网关 API",
  "version": "1.0",
  "status": "running",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "environment": "Production"
}
```

### GET /health 预期响应

```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "uptime": 3600
}
```

### GET /ping 预期响应

```
pong
```

---

## ⚠️ 关键问题待解决

### 问题 1: Swagger 文档缺少支付 API 定义

**现象**: 
- 文档中只有 3 个基础端点
- 支付相关的 API 不存在

**可能原因**:
1. 支付 API 已部署，但 Swagger 文档未更新
2. 支付 API 在不同的服务上（需要不同的 URL）
3. 支付 API 还在开发中
4. 支付 API 需要特殊的认证，不在公开文档中

**解决方案**:
```
📞 立即联系技术支持：
   邮箱: support@qsgl.net
   
   说明: 
   1. Swagger 文档中缺少支付 API 的定义
   2. 请提供支付 API 的完整 Swagger 定义或文档
   3. 或更新 https://payment.qsgl.net/swagger.json
   4. 支付 API 的路径、认证方式、请求/响应格式
```

---

## 📋 测试检查清单

### 立即执行

- [ ] 运行 PowerShell 测试脚本 (`test-gateway-complete.ps1`)
- [ ] 或运行 Python 测试脚本 (`test_gateway_complete.py`)
- [ ] 记录所有 3 个基础端点的响应

### 基于测试结果

**如果 3 个基础端点都通过 ✓**:
- [ ] 确认网关基础服务正常
- [ ] 联系技术支持获取支付 API 定义
- [ ] 等待支付 API 文档更新

**如果有端点失败 ✗**:
- [ ] 检查网关是否在线
- [ ] 检查网络连接/防火墙
- [ ] 查看网关日志
- [ ] 联系技术支持

---

## 📞 技术支持

**来自 Swagger 文档的官方支持信息**:
- 名称: 技术支持
- 邮箱: support@qsgl.net

**建议您发送的邮件内容**:

```
主题: 支付网关 API 定义请求

尊敬的技术支持团队：

我们正在集成您的支付网关 (https://payment.qsgl.net)，目前遇到以下问题：

1. Swagger 文档 (https://payment.qsgl.net/swagger.json) 中只定义了 3 个基础端点 (/, /health, /ping)
2. 缺少支付相关的 API 定义（如创建订单、查询订单等）

请提供：
1. 支付 API 的完整 Swagger 定义（更新 swagger.json）
2. 或完整的 API 文档（PDF/Markdown）
3. 支付 API 的：
   - 端点 URL
   - HTTP 方法 (GET/POST)
   - 请求参数格式
   - 响应格式
   - 认证方式（如有）

感谢！
```

---

## 🎯 现状总结

| 项目 | 状态 | 说明 |
|------|------|------|
| 基础网关 | ✅ 已定义 | /, /health, /ping 在 Swagger 中定义 |
| 支付 API | ❌ 未定义 | 不在当前 Swagger 文档中 |
| 网关连接 | 需测试 | 运行脚本验证 |
| 支付集成 | ⏳ 等待 | 等待 API 定义 |

---

## 📚 资源链接

| 资源 | URL |
|------|-----|
| Swagger 定义 | https://payment.qsgl.net/swagger.json |
| API 文档 | https://payment.qsgl.net/docs |
| 支持邮箱 | support@qsgl.net |

---

**现在就运行测试脚本，确认网关基础服务正常！** ⚡

