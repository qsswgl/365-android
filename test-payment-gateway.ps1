# ========================================
# 农行支付网关 API 测试脚本 - PowerShell
# ========================================
# 基于 Swagger 文档: https://payment.qsgl.net/swagger.json
# 测试所有支付相关的 API 端点
# ========================================

$gatewayUrl = "https://payment.qsgl.net"
$merchantId = "103881636900016"
$notifyUrl = "https://your-backend.com/api/payment/notify"
$returnUrl = "https://your-frontend.com/payment/result"

# 颜色定义
$colors = @{
    Success = "Green"
    Error = "Red"
    Info = "Cyan"
    Warning = "Yellow"
    Header = "Magenta"
}

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "===========================================" -ForegroundColor $colors.Header
    Write-Host $Title -ForegroundColor $colors.Header
    Write-Host "===========================================" -ForegroundColor $colors.Header
}

function Test-Ping {
    Write-Header "1️⃣  Ping 测试"
    try {
        $response = Invoke-RestMethod -Uri "$gatewayUrl/ping" -Method Get -TimeoutSec 10
        Write-Host "✓ Ping 成功: $response" -ForegroundColor $colors.Success
        return $true
    } catch {
        Write-Host "✗ Ping 失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

function Test-Health {
    Write-Header "2️⃣  健康检查"
    try {
        $response = Invoke-RestMethod -Uri "$gatewayUrl/health" -Method Get -TimeoutSec 10
        $status = $response.status
        
        if ($status -eq "healthy") {
            Write-Host "✓ 健康状态: $status" -ForegroundColor $colors.Success
        } elseif ($status -eq "degraded") {
            Write-Host "⚠ 健康状态: $status (性能下降)" -ForegroundColor $colors.Warning
        } else {
            Write-Host "✗ 健康状态: $status (不健康)" -ForegroundColor $colors.Error
        }
        
        Write-Host "  运行时间: $($response.uptime) 秒" -ForegroundColor $colors.Info
        Write-Host "  时间戳: $($response.timestamp)" -ForegroundColor $colors.Info
        
        return $status -eq "healthy"
    } catch {
        Write-Host "✗ 健康检查失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

function Test-RootInfo {
    Write-Header "3️⃣  API 信息"
    try {
        $response = Invoke-RestMethod -Uri "$gatewayUrl/" -Method Get -TimeoutSec 10
        
        Write-Host "✓ API 信息获取成功" -ForegroundColor $colors.Success
        Write-Host "  名称: $($response.name)" -ForegroundColor $colors.Info
        Write-Host "  版本: $($response.version)" -ForegroundColor $colors.Info
        Write-Host "  状态: $($response.status)" -ForegroundColor $colors.Info
        Write-Host "  环境: $($response.environment)" -ForegroundColor $colors.Info
        Write-Host "  时间戳: $($response.timestamp)" -ForegroundColor $colors.Info
        
        return $true
    } catch {
        Write-Host "✗ API 信息获取失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

function Test-QRCodePayment {
    Write-Header "4️⃣  创建扫码支付订单 (/api/payment/qrcode)"
    try {
        $orderNo = "TEST_$(Get-Date -UFormat %s)"
        
        $paymentRequest = @{
            orderNo = $orderNo
            amount = 0.01
            merchantId = $merchantId
            goodsName = "测试商品"
            notifyUrl = $notifyUrl
            returnUrl = $returnUrl
            remarks = "PowerShell 自动化测试"
        } | ConvertTo-Json
        
        Write-Host "发送请求：" -ForegroundColor $colors.Info
        Write-Host $paymentRequest -ForegroundColor $colors.Info
        
        $response = Invoke-RestMethod `
            -Uri "$gatewayUrl/api/payment/qrcode" `
            -Method Post `
            -ContentType "application/json" `
            -Body $paymentRequest `
            -TimeoutSec 10
        
        if ($response.isSuccess) {
            Write-Host "✓ 订单创建成功" -ForegroundColor $colors.Success
            Write-Host "  订单号: $($response.orderNo)" -ForegroundColor $colors.Info
            Write-Host "  状态: $($response.status)" -ForegroundColor $colors.Info
            Write-Host "  交易 ID: $($response.transactionId)" -ForegroundColor $colors.Info
            if ($response.qrCode) {
                Write-Host "  二维码: $($response.qrCode)" -ForegroundColor $colors.Info
            }
            Write-Host "  消息: $($response.message)" -ForegroundColor $colors.Info
            return $response.orderNo
        } else {
            Write-Host "✗ 订单创建失败: $($response.message)" -ForegroundColor $colors.Error
            return $null
        }
    } catch {
        Write-Host "✗ 请求失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $null
    }
}

function Test-EWalletPayment {
    Write-Header "5️⃣  创建电子钱包支付订单 (/api/payment/ewallet)"
    try {
        $orderNo = "EWALLET_$(Get-Date -UFormat %s)"
        
        $paymentRequest = @{
            orderNo = $orderNo
            amount = 0.01
            merchantId = $merchantId
            goodsName = "电子钱包测试"
            notifyUrl = $notifyUrl
            returnUrl = $returnUrl
        } | ConvertTo-Json
        
        Write-Host "发送请求：" -ForegroundColor $colors.Info
        Write-Host $paymentRequest -ForegroundColor $colors.Info
        
        $response = Invoke-RestMethod `
            -Uri "$gatewayUrl/api/payment/ewallet" `
            -Method Post `
            -ContentType "application/json" `
            -Body $paymentRequest `
            -TimeoutSec 10
        
        if ($response.isSuccess) {
            Write-Host "✓ 订单创建成功" -ForegroundColor $colors.Success
            Write-Host "  订单号: $($response.orderNo)" -ForegroundColor $colors.Info
            Write-Host "  状态: $($response.status)" -ForegroundColor $colors.Info
            Write-Host "  交易 ID: $($response.transactionId)" -ForegroundColor $colors.Info
            if ($response.redirectUrl) {
                Write-Host "  跳转 URL: $($response.redirectUrl)" -ForegroundColor $colors.Info
            }
            return $response.orderNo
        } else {
            Write-Host "✗ 订单创建失败: $($response.message)" -ForegroundColor $colors.Error
            return $null
        }
    } catch {
        Write-Host "✗ 请求失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $null
    }
}

function Test-QueryOrder {
    param([string]$OrderNo)
    
    Write-Header "6️⃣  查询订单状态 (/api/payment/query/{orderNo})"
    
    if (-not $OrderNo) {
        Write-Host "⚠ 跳过：无可用的订单号" -ForegroundColor $colors.Warning
        return $false
    }
    
    try {
        Write-Host "查询订单: $OrderNo" -ForegroundColor $colors.Info
        
        $response = Invoke-RestMethod `
            -Uri "$gatewayUrl/api/payment/query/$OrderNo" `
            -Method Get `
            -TimeoutSec 10
        
        if ($response.isSuccess) {
            Write-Host "✓ 查询成功" -ForegroundColor $colors.Success
            Write-Host "  订单号: $($response.orderNo)" -ForegroundColor $colors.Info
            Write-Host "  状态: $($response.status)" -ForegroundColor $colors.Info
            Write-Host "  交易 ID: $($response.transactionId)" -ForegroundColor $colors.Info
            Write-Host "  金额: $($response.amount)" -ForegroundColor $colors.Info
            return $true
        } else {
            Write-Host "✗ 查询失败: $($response.message)" -ForegroundColor $colors.Error
            return $false
        }
    } catch {
        Write-Host "✗ 请求失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

function Test-PaymentHealth {
    Write-Header "7️⃣  支付服务健康检查 (/api/payment/health)"
    try {
        $response = Invoke-RestMethod `
            -Uri "$gatewayUrl/api/payment/health" `
            -Method Get `
            -TimeoutSec 10
        
        if ($response.status -eq "healthy") {
            Write-Host "✓ 支付服务健康" -ForegroundColor $colors.Success
        } else {
            Write-Host "⚠ 支付服务状态: $($response.status)" -ForegroundColor $colors.Warning
        }
        
        Write-Host "  服务: $($response.service)" -ForegroundColor $colors.Info
        Write-Host "  时间戳: $($response.timestamp)" -ForegroundColor $colors.Info
        
        return $response.status -eq "healthy"
    } catch {
        Write-Host "✗ 健康检查失败: $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

# ========================================
# 主测试流程
# ========================================

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor $colors.Header
Write-Host "║   农行支付网关 API 完整测试套件        ║" -ForegroundColor $colors.Header
Write-Host "║   时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')          ║" -ForegroundColor $colors.Header
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor $colors.Header

$results = @{
    Ping = $false
    Health = $false
    RootInfo = $false
    QRCodePayment = $false
    EWalletPayment = $false
    QueryOrder = $false
    PaymentHealth = $false
}

# 基础测试
$results.Ping = Test-Ping
$results.Health = Test-Health
$results.RootInfo = Test-RootInfo

# 支付服务健康检查
$results.PaymentHealth = Test-PaymentHealth

# 支付订单创建测试
$qrcodeOrderNo = Test-QRCodePayment
$results.QRCodePayment = $qrcodeOrderNo -ne $null

$ewalletOrderNo = Test-EWalletPayment
$results.EWalletPayment = $ewalletOrderNo -ne $null

# 订单查询测试
if ($qrcodeOrderNo) {
    $results.QueryOrder = Test-QueryOrder -OrderNo $qrcodeOrderNo
}

# ========================================
# 测试结果汇总
# ========================================

Write-Header "📊 测试结果汇总"

$passCount = 0
$failCount = 0

foreach ($test in $results.GetEnumerator()) {
    $status = if ($test.Value) { "✓ PASS" } else { "✗ FAIL" }
    $color = if ($test.Value) { $colors.Success } else { $colors.Error }
    
    Write-Host "$status - $($test.Key)" -ForegroundColor $color
    
    if ($test.Value) { $passCount++ } else { $failCount++ }
}

Write-Host ""
Write-Host "总计: $passCount 通过, $failCount 失败" -ForegroundColor $(if ($failCount -eq 0) { $colors.Success } else { $colors.Error })

# ========================================
# 故障排查建议
# ========================================

if ($failCount -gt 0) {
    Write-Header "⚠️  故障排查建议"
    
    if (-not $results.Ping) {
        Write-Host "❌ Ping 失败:" -ForegroundColor $colors.Error
        Write-Host "   • 检查网络连接是否正常" -ForegroundColor $colors.Info
        Write-Host "   • 检查防火墙设置" -ForegroundColor $colors.Info
        Write-Host "   • 确认网关地址是否正确: $gatewayUrl" -ForegroundColor $colors.Info
    }
    
    if (-not $results.Health) {
        Write-Host "❌ 健康检查失败:" -ForegroundColor $colors.Error
        Write-Host "   • 网关服务可能未启动" -ForegroundColor $colors.Info
        Write-Host "   • 检查网关日志了解详情" -ForegroundColor $colors.Info
    }
    
    if (-not $results.PaymentHealth) {
        Write-Host "❌ 支付服务健康检查失败:" -ForegroundColor $colors.Error
        Write-Host "   • 支付服务可能有问题" -ForegroundColor $colors.Info
        Write-Host "   • 检查支付服务依赖项（数据库、农行 API 等）" -ForegroundColor $colors.Info
    }
    
    if (-not $results.QRCodePayment -or -not $results.EWalletPayment) {
        Write-Host "❌ 支付订单创建失败:" -ForegroundColor $colors.Error
        Write-Host "   • 检查请求参数是否正确" -ForegroundColor $colors.Info
        Write-Host "   • 确认商户 ID ($merchantId) 是否有效" -ForegroundColor $colors.Info
        Write-Host "   • 检查回调 URL 是否可访问" -ForegroundColor $colors.Info
    }
} else {
    Write-Header "🎉 所有测试通过！"
    Write-Host "网关完全正常，可以进行生产环境集成。" -ForegroundColor $colors.Success
}

Write-Host ""
