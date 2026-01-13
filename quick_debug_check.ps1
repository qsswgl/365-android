#!/usr/bin/env powershell
# WebView 远程调试快速诊断脚本

Write-Host "===== WebView 远程调试诊断工具 =====" -ForegroundColor Cyan
Write-Host ""

# 1. 重启 ADB
Write-Host "[1/5] 重启 ADB 服务..." -ForegroundColor Yellow
.\adb kill-server | Out-Null
Start-Sleep -Seconds 2
.\adb start-server | Out-Null
Write-Host "✓ ADB 已重启" -ForegroundColor Green
Write-Host ""

# 2. 连接设备
Write-Host "[2/5] 重新连接设备..." -ForegroundColor Yellow
$connectResult = .\adb connect 192.168.1.129:42797
Write-Host $connectResult
Start-Sleep -Seconds 2
Write-Host ""

# 3. 验证设备连接
Write-Host "[3/5] 验证设备状态..." -ForegroundColor Yellow
.\adb devices -l
Write-Host ""

# 4. 启动应用
Write-Host "[4/5] 启动应用和清空日志..." -ForegroundColor Yellow
.\adb shell am force-stop net.qsgl365 | Out-Null
Start-Sleep -Seconds 1
.\adb logcat -c | Out-Null
.\adb shell am start -n net.qsgl365/.MainActivity | Out-Null
Start-Sleep -Seconds 3
Write-Host "✓ 应用已启动" -ForegroundColor Green
Write-Host ""

# 5. 检查 WebView 调试日志
Write-Host "[5/5] 检查 WebView 调试日志..." -ForegroundColor Yellow
Write-Host ""
$logs = .\adb logcat -d | Select-String "WebView.*远程调试"
if ($logs) {
    Write-Host "✓ 检测到 WebView 调试启用日志:" -ForegroundColor Green
    Write-Host $logs
} else {
    Write-Host "⚠ 未检测到调试启用日志，检查完整日志..." -ForegroundColor Yellow
    .\adb logcat -d | Select-String "WebView"
}
Write-Host ""

# 诊断完成
Write-Host "===== 诊断完成 =====" -ForegroundColor Cyan
Write-Host ""
Write-Host "现在请按照以下步骤在 Chrome 中查看页面:" -ForegroundColor Green
Write-Host "1. 打开 Chrome 浏览器"
Write-Host "2. 地址栏输入: chrome://inspect"
Write-Host "3. 确保已勾选 'Discover USB devices' 或 'Discover network targets'"
Write-Host "4. 在左侧设备列表中应该看到您的应用"
Write-Host "5. 点击 'inspect' 按钮开始调试"
Write-Host ""
Write-Host "如果仍然看不到页面，请尝试:" -ForegroundColor Yellow
Write-Host "- 刷新 Chrome 标签页（F5）"
Write-Host "- 关闭所有 DevTools 窗口后重新打开"
Write-Host "- 重启 Chrome 浏览器"
Write-Host "- 在 Chrome 设置中启用 'Developer mode'"
