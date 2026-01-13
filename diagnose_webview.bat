#!/bin/bash
# WebView 调试诊断脚本

echo "========== WebView 调试诊断 =========="
echo ""

echo "1. 检查 ADB 设备连接状态"
adb devices
echo ""

echo "2. 检查应用进程是否运行"
adb shell ps | grep net.qsgl365
echo ""

echo "3. 检查 WebView 调试日志"
adb logcat -d | grep -i "webview\|debugg"
echo ""

echo "4. 查看应用的完整日志"
adb logcat -d | grep "net.qsgl365"
echo ""

echo "5. 尝试重启 WebView 调试"
adb shell setprop debug.force_rtl 0
echo "已发送 WebView 调试指令"
echo ""

echo "建议步骤："
echo "1. 关闭 Chrome DevTools"
echo "2. 运行命令: adb kill-server && adb start-server"
echo "3. 等待 2 秒"
echo "4. 重新打开 Chrome DevTools 的 chrome://inspect"
echo "5. 刷新页面"
