@echo off
REM 完整的权限修复和测试脚本

echo ========== 权限修复脚本 ==========
echo.
echo [1] 检查ADB连接...
adb devices
echo.

echo [2] 卸载旧应用...
adb shell pm uninstall net.qsgl365
echo.

echo [3] 清理并重新编译...
call gradlew.bat clean assembleDebug
echo.

echo [4] 重新安装APK...
adb install app\build\outputs\apk\debug\app-debug.apk
echo.

echo [5] 启动应用...
adb shell am start -n net.qsgl365/.MainActivity
echo.

echo [6] 清空日志...
adb logcat -c
echo.

echo ========== 测试步骤 ==========
echo.
echo 请执行以下步骤进行测试：
echo 1. 打开浏览器访问: https://www.qsgl.net/html/365app/pwa/barcode-test-simple.html
echo 2. 点击"启动扫码"按钮
echo 3. 此时应该弹出"允许摄像头权限?"的对话框
echo 4. 请点击"允许"按钮
echo 5. 观察是否能够正常启动扫码功能
echo.

echo ========== 日志监控 ==========
echo 实时监控应用日志...
adb logcat net.qsgl365:V *:S

pause
