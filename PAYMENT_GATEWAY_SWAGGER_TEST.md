# 🎯 支付网关 API 测试 - 基于 Swagger 定义

> 根据 https://payment.qsgl.net/swagger.json 的真实 API 定义

---

## 📋 网关实际提供的 API 端点

根据 Swagger 文档，支付网关提供以下端点：

### 1. 根信息端点 (GET /)
**目的**: 获取 API 服务信息  
**路径**: `/`  
**方法**: GET

**请求**:
```bash
curl https://payment.qsgl.net/
```

或 PowerShell:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/" -Method Get | ConvertTo-Json
```

**返回示例**:
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

### 2. 健康检查端点 (GET /health)
**目的**: 返回应用的健康状态  
**路径**: `/health`  
**方法**: GET  
**用途**: Docker healthcheck 和监控系统使用

**请求**:
```bash
curl https://payment.qsgl.net/health
```

或 PowerShell:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" -Method Get | ConvertTo-Json
```

**返回示例 (正常)**:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "uptime": 3600
}
```

**返回示例 (异常)** - HTTP 503:
```json
{
  "status": "unhealthy",
  "timestamp": "2026-01-06T14:30:00.1234567Z",
  "message": "Critical dependencies unavailable",
  "uptime": 1800
}
```

**状态值**:
- `healthy` - 应用健康
- `degraded` - 性能下降
- `unhealthy` - 应用异常

---

### 3. Ping 测试端点 (GET /ping)
**目的**: 简单的 Ping 测试，验证 API 连接  
**路径**: `/ping`  
**方法**: GET  
**返回**: 简单的 "pong" 文本

**请求**:
```bash
curl https://payment.qsgl.net/ping
```

或 PowerShell:
```powershell
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping" -Method Get
```

**返回**:
```
pong
```

---

## 🧪 完整的测试脚本（基于 Swagger 定义）

### PowerShell 测试脚本

```powershell
# gateway-health-check.ps1
# 基于 Swagger 定义的网关健康检查脚本

$GATEWAY_URL = "https://payment.qsgl.net"

# 彩色输出函数
function Write-Success { param([string]$msg); Write-Host "✓ $msg" -ForegroundColor Green }
function Write-Error-Msg { param([string]$msg); Write-Host "✗ $msg" -ForegroundColor Red }
function Write-Info { param([string]$msg); Write-Host "ℹ $msg" -ForegroundColor Cyan }
function Write-Section { param([string]$msg); Write-Host ""; Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; Write-Host $msg -ForegroundColor Blue; Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" }

# 测试 1: Ping 测试
function Test-Ping {
    Write-Section "测试 1: Ping 端点 (GET /ping)"
    
    try {
        $response = Invoke-RestMethod -Uri "$GATEWAY_URL/ping" -Method Get -TimeoutSec 10
        Write-Success "Ping 成功: $response"
        return $true
    } catch {
        Write-Error-Msg "Ping 失败: $_"
        return $false
    }
}

# 测试 2: 健康检查
function Test-Health {
    Write-Section "测试 2: 健康检查 (GET /health)"
    
    try {
        $response = Invoke-RestMethod -Uri "$GATEWAY_URL/health" -Method Get -TimeoutSec 10
        Write-Success "健康检查成功"
        Write-Host ""
        Write-Host "状态信息:" -ForegroundColor Yellow
        $response | ConvertTo-Json | Write-Host
        
        # 解析状态
        $status = $response.status
        if ($status -eq "healthy") {
            Write-Success "网关状态: 健康 ✓"
        } elseif ($status -eq "degraded") {
            Write-Info "网关状态: 性能下降 ⚠"
        } else {
            Write-Error-Msg "网关状态: 异常 ✗"
        }
        
        return $status -eq "healthy"
        
    } catch {
        Write-Error-Msg "健康检查失败: $_"
        return $false
    }
}

# 测试 3: 获取根信息
function Test-RootInfo {
    Write-Section "测试 3: 根信息 (GET /)"
    
    try {
        $response = Invoke-RestMethod -Uri "$GATEWAY_URL/" -Method Get -TimeoutSec 10
        Write-Success "根信息获取成功"
        Write-Host ""
        Write-Host "API 信息:" -ForegroundColor Yellow
        $response | ConvertTo-Json | Write-Host
        
        Write-Host ""
        Write-Host "详细信息:" -ForegroundColor Yellow
        Write-Host "  名称: $($response.name)"
        Write-Host "  版本: $($response.version)"
        Write-Host "  状态: $($response.status)"
        Write-Host "  环境: $($response.environment)"
        Write-Host "  时间: $($response.timestamp)"
        
        return $true
        
    } catch {
        Write-Error-Msg "获取根信息失败: $_"
        return $false
    }
}

# 主函数
function Main {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  支付网关健康检查 (基于 Swagger 定义)                   ║" -ForegroundColor Cyan
    Write-Host "║  Gateway: $GATEWAY_URL                       ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    $results = @()
    
    # 执行所有测试
    $results += Test-Ping
    $results += Test-Health
    $results += Test-RootInfo
    
    # 总结
    Write-Section "测试总结"
    $passCount = ($results | Where-Object { $_ -eq $true }).Count
    $totalCount = $results.Count
    
    Write-Host "通过: $passCount/$totalCount" -ForegroundColor Green
    
    if ($passCount -eq $totalCount) {
        Write-Success "所有测试通过！网关运行正常"
        Write-Host ""
        Write-Info "下一步: 可以进行支付相关的 API 集成"
    } else {
        Write-Error-Msg "部分测试失败，请检查网关状态"
    }
    
    Write-Host ""
}

Main
```

**保存为**: `gateway-health-check.ps1`

**运行方式**:
```powershell
.\gateway-health-check.ps1
```

---

### Python 测试脚本

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import json
from datetime import datetime

GATEWAY_URL = "https://payment.qsgl.net"

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
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
    print(f"{Colors.CYAN}{title}{Colors.END}")
    print("━" * 60)

def test_ping():
    """测试 Ping 端点"""
    print_section("测试 1: Ping 端点 (GET /ping)")
    
    try:
        response = requests.get(f"{GATEWAY_URL}/ping", timeout=10)
        response.raise_for_status()
        print_success(f"Ping 成功: {response.text}")
        return True
    except Exception as e:
        print_error(f"Ping 失败: {e}")
        return False

def test_health():
    """测试健康检查"""
    print_section("测试 2: 健康检查 (GET /health)")
    
    try:
        response = requests.get(f"{GATEWAY_URL}/health", timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            print_success("健康检查成功")
            print("\n状态信息:")
            print(json.dumps(data, indent=2, ensure_ascii=False))
            
            status = data.get("status", "unknown")
            if status == "healthy":
                print_success("网关状态: 健康 ✓")
            elif status == "degraded":
                print_info("网关状态: 性能下降 ⚠")
            else:
                print_error("网关状态: 异常 ✗")
            
            return status == "healthy"
        else:
            print_error(f"健康检查异常: HTTP {response.status_code}")
            print(response.text)
            return False
            
    except Exception as e:
        print_error(f"健康检查失败: {e}")
        return False

def test_root_info():
    """测试根信息"""
    print_section("测试 3: 根信息 (GET /)")
    
    try:
        response = requests.get(f"{GATEWAY_URL}/", timeout=10)
        response.raise_for_status()
        
        data = response.json()
        print_success("根信息获取成功")
        print("\nAPI 信息:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        print("\n详细信息:")
        print(f"  名称: {data.get('name', 'N/A')}")
        print(f"  版本: {data.get('version', 'N/A')}")
        print(f"  状态: {data.get('status', 'N/A')}")
        print(f"  环境: {data.get('environment', 'N/A')}")
        print(f"  时间: {data.get('timestamp', 'N/A')}")
        
        return True
        
    except Exception as e:
        print_error(f"获取根信息失败: {e}")
        return False

def main():
    print()
    print(f"{Colors.CYAN}╔" + "═" * 58 + "╗{Colors.END}")
    print(f"{Colors.CYAN}║  支付网关健康检查 (基于 Swagger 定义)                   ║{Colors.END}")
    print(f"{Colors.CYAN}║  Gateway: {GATEWAY_URL:<40}║{Colors.END}")
    print(f"{Colors.CYAN}╚" + "═" * 58 + "╝{Colors.END}")
    
    results = []
    
    # 执行所有测试
    results.append(test_ping())
    results.append(test_health())
    results.append(test_root_info())
    
    # 总结
    print_section("测试总结")
    pass_count = sum(results)
    total_count = len(results)
    
    print(f"通过: {pass_count}/{total_count}")
    
    if pass_count == total_count:
        print_success("所有测试通过！网关运行正常")
        print_info("下一步: 可以进行支付相关的 API 集成")
    else:
        print_error("部分测试失败，请检查网关状态")
    
    print()

if __name__ == "__main__":
    main()
```

**保存为**: `gateway_health_check.py`

**运行方式**:
```bash
python gateway_health_check.py
```

---

## 🚀 快速测试命令

### 最简单的测试（3 个命令）

```powershell
# 1. Ping 测试
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"

# 2. 健康检查
Invoke-RestMethod -Uri "https://payment.qsgl.net/health" | ConvertTo-Json

# 3. 根信息
Invoke-RestMethod -Uri "https://payment.qsgl.net/" | ConvertTo-Json
```

### 使用 curl

```bash
# 1. Ping 测试
curl https://payment.qsgl.net/ping

# 2. 健康检查
curl https://payment.qsgl.net/health

# 3. 根信息
curl https://payment.qsgl.net/
```

---

## ✅ 完整的测试清单

### 第 1 阶段：基础连接测试

- [ ] Ping 端点返回 "pong"
- [ ] 健康检查返回 HTTP 200
- [ ] 健康检查 status 为 "healthy"
- [ ] 根信息返回 API 详情

### 第 2 阶段：状态验证

- [ ] 网关名称正确显示
- [ ] 版本号显示正确
- [ ] 运行状态为 "running"
- [ ] 时间戳格式正确 (ISO 8601)

### 第 3 阶段：可靠性测试

- [ ] 连续 10 次请求都成功
- [ ] 响应时间 < 1 秒
- [ ] 没有 5xx 错误
- [ ] 没有超时情况

---

## 📝 Swagger 文档结构

网关提供的完整 API 定义在: https://payment.qsgl.net/swagger.json

**当前可用的 API 分类**:

| 类别 | 端点 | 方法 | 说明 |
|------|------|------|------|
| **Health** | /health | GET | 健康检查 |
| **Utility** | /ping | GET | Ping 测试 |
| **API Info** | / | GET | API 信息 |

**下一步**: 等待文档中支付相关的 API 端点定义，如:
- `/api/pay/createOrder` - 创建支付订单
- `/api/order/query` - 查询订单状态
- `/api/payment/methods` - 获取支付方式

---

## 🎯 确认网关可用

运行下面的 PowerShell 命令，确认网关可用：

```powershell
# 快速确认
try {
    $ping = Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"
    $health = Invoke-RestMethod -Uri "https://payment.qsgl.net/health"
    $info = Invoke-RestMethod -Uri "https://payment.qsgl.net/"
    
    if ($ping -eq "pong" -and $health.status -eq "healthy") {
        Write-Host "✓ 网关正常！可以继续集成" -ForegroundColor Green
    } else {
        Write-Host "✗ 网关异常" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ 无法连接网关: $_" -ForegroundColor Red
}
```

---

## 📞 故障排查

### 无法连接网关

**检查清单**:
```powershell
# 1. 检查网络连接
Test-NetConnection payment.qsgl.net -Port 443

# 2. 增加超时时间
$response = Invoke-RestMethod `
    -Uri "https://payment.qsgl.net/ping" `
    -TimeoutSec 60

# 3. 跳过 SSL 验证（仅开发）
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
Invoke-RestMethod -Uri "https://payment.qsgl.net/ping"
```

### 健康检查返回异常

**含义**:
- `healthy` - 网关正常，可以使用 ✓
- `degraded` - 性能下降，部分功能可用 ⚠
- `unhealthy` - 网关异常，需要联系管理员 ✗

---

**现在就运行脚本测试网关吧！** 🚀

