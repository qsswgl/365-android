@echo off
REM 365 Android 扫码功能诊断和测试脚本
REM 用途: 快速诊断和测试扫码功能

echo ========================================
echo 365 农行 - 扫码功能诊断工具
echo ========================================
echo.

cd K:\365-android

echo [1] 检查 ADB 连接状态...
.\adb devices
echo.

echo [2] 检查应用权限状态...
.\adb shell pm list permissions -d | findstr CAMERA
if %ERRORLEVEL% EQU 0 (
    echo ⚠️  发现摄像头权限被永久拒绝！
    echo 可运行命令解除: .\adb shell pm grant net.qsgl365 android.permission.CAMERA
) else (
    echo ✅ 摄像头权限状态正常
)
echo.

echo [3] 检查应用是否已安装...
.\adb shell pm list packages | findstr qsgl365
if %ERRORLEVEL% EQU 0 (
    echo ✅ 应用已安装: net.qsgl365
) else (
    echo ❌ 应用未安装！请先编译和安装 APK
    exit /b 1
)
echo.

echo [4] 检查应用进程...
.\adb shell ps | findstr qsgl365
echo.

echo [5] 清除 logcat 缓冲区...
.\adb logcat -c
echo ✅ logcat 已清除
echo.

echo [6] 启动应用...
.\adb shell am start -n net.qsgl365/.MainActivity
echo ✅ 应用已启动
echo.

echo [7] 开始监听关键日志...
echo.
echo 请在另一个窗口中运行以下命令监听日志:
echo    cd K:\365-android
echo    .\adb logcat *:V
echo.
echo 或运行以下命令只监听相关日志:
echo    .\adb logcat | findstr "BarcodeScannerActivity\|MainActivity"
echo.

echo ========================================
echo ✅ 诊断完成！
echo ========================================
echo.
echo 后续步骤:
echo 1. 打开浏览器访问: http://192.168.1.129:8080/pwa/barcode-test-simple.html
echo 2. 点击 "启动扫码" 按钮
echo 3. 在权限对话框中选择 "允许"
echo 4. 在摄像头中显示二维码或条码
echo 5. 查看日志输出和测试页面结果
echo.
echo 快速命令参考:
echo   .\adb install -r app\build\outputs\apk\debug\app-debug.apk
echo   .\adb shell am clear-debug-app net.qsgl365
echo   .\adb shell pm grant net.qsgl365 android.permission.CAMERA
echo   .\adb shell am force-stop net.qsgl365
echo.
pause
