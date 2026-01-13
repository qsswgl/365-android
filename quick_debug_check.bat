@echo off
REM WebView 调试快速诊断脚本

echo ===== WebView 远程调试诊断工具 =====
echo.

REM 1. 重启 ADB
echo [1/5] 重启 ADB 服务...
adb kill-server
timeout /t 2 /nobreak
adb start-server
echo ✓ ADB 已重启
echo.

REM 2. 连接设备
echo [2/5] 重新连接设备...
adb connect 192.168.1.129:42797
timeout /t 2 /nobreak
echo.

REM 3. 验证设备连接
echo [3/5] 验证设备状态...
adb devices -l
echo.

REM 4. 启动应用
echo [4/5] 启动应用和清空日志...
adb shell am force-stop net.qsgl365
timeout /t 1 /nobreak
adb logcat -c
adb shell am start -n net.qsgl365/.MainActivity
timeout /t 3 /nobreak
echo.

REM 5. 检查 WebView 调试日志
echo [5/5] 检查 WebView 调试日志...
echo.
adb logcat -d | findstr "WebView 远程调试"
echo.

REM 提示用户
echo ===== 诊断完成 =====
echo.
echo 现在请按照以下步骤在 Chrome 中查看页面:
echo 1. 打开 Chrome 浏览器
echo 2. 地址栏输入: chrome://inspect
echo 3. 确保已勾选 "Discover USB devices" 或 "Discover network targets"
echo 4. 在左侧设备列表中应该看到您的应用
echo 5. 点击 "inspect" 按钮开始调试
echo.
echo 如果仍然看不到页面，请尝试:
echo - 刷新 Chrome 标签页（F5）
echo - 关闭所有 DevTools 窗口后重新打开
echo - 重启 Chrome 浏览器
echo.
echo 按任意键退出...
pause>nul
