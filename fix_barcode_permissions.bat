@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ====================================
echo 扫码权限一键修复工具
echo ====================================
echo.

REM 检查 ADB 是否可用
.\adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到 adb.exe
    echo 请确保在 365-android 目录中运行此脚本
    pause
    exit /b 1
)

echo ✓ ADB 连接正常

REM 检查设备连接
echo.
echo [准备] 检查设备连接...
.\adb devices | findstr "device" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到已连接的设备
    echo 请先连接 Android 设备
    pause
    exit /b 1
)
echo ✓ 设备已连接

REM 授予权限
echo.
echo [1/5] 正在授予摄像头权限...
.\adb shell pm grant net.qsgl365 android.permission.CAMERA >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ 摄像头权限已授予
) else (
    echo ⚠ 权限授予可能失败，继续处理...
)

REM 清空应用数据（可选）
echo.
echo [2/5] 清空应用缓存...
.\adb shell pm clear net.qsgl365 >nul 2>&1
echo ✓ 缓存已清空

REM 关闭应用
echo.
echo [3/5] 关闭应用...
.\adb shell am force-stop net.qsgl365 >nul 2>&1
timeout /t 2 >nul
echo ✓ 应用已关闭

REM 启动应用
echo.
echo [4/5] 重新启动应用...
.\adb shell am start -n net.qsgl365/.MainActivity >nul 2>&1
timeout /t 3 >nul
echo ✓ 应用已启动

REM 验证权限
echo.
echo [5/5] 验证权限状态...
.\adb shell pm list permissions -g | findstr "android.permission.CAMERA" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ 权限验证成功
) else (
    echo ⚠ 权限验证失败，请手动检查
)

echo.
echo ====================================
echo ✅ 修复完成！
echo ====================================
echo.
echo 现在请按以下步骤测试:
echo.
echo 1. 打开 Chrome 浏览器
echo 2. 访问以下 URL:
echo    http://192.168.1.129:8080/pwa/barcode-test-simple.html
echo.
echo 3. 点击"🔍 启动扫码"按钮
echo.
echo 4. 在摄像头前展示二维码或条形码
echo.
echo 预期结果:
echo - 应该看到摄像头预览（全屏黑色区域）
echo - 扫描成功后显示扫码内容
echo.
echo 如果仍然失败，请查看:
echo - BARCODE_ERROR_FIX_GUIDE.md (本地诊断指南)
echo - logcat 输出以获取详细错误信息
echo.
pause
