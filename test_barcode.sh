#!/bin/bash
# 扫码功能诊断和测试脚本

echo "========================================"
echo "365 农行 APP - 扫码功能诊断脚本"
echo "========================================"
echo ""

# 检查 ADB 连接
echo "[1] 检查 ADB 连接..."
adb devices
echo ""

# 清理日志
echo "[2] 清理日志缓冲..."
adb logcat -c
sleep 1

# 启动应用
echo "[3] 启动应用..."
adb shell am start -n net.qsgl365/.MainActivity
sleep 5

# 获取日志
echo ""
echo "[4] 应用启动日志（WebView 相关）..."
echo "========================================"
adb logcat -d 2>&1 | grep -i "WebView" | tail -20
echo ""

# 创建测试 JavaScript 代码
echo "[5] 准备测试代码..."
cat > /tmp/barcode_test.js << 'EOF'
// 测试 AndroidBridge 可用性
console.log('[TEST] 开始测试 AndroidBridge');
console.log('[TEST] AndroidBridge 类型:', typeof AndroidBridge);

if (typeof AndroidBridge !== 'undefined') {
    console.log('[TEST] ✓ AndroidBridge 对象存在');
    console.log('[TEST] 可用方法:', Object.keys(AndroidBridge));
    
    if (typeof AndroidBridge.startBarcodeScanning === 'function') {
        console.log('[TEST] ✓ startBarcodeScanning 方法存在');
        console.log('[TEST] 调用 startBarcodeScanning()...');
        try {
            AndroidBridge.startBarcodeScanning();
            console.log('[TEST] ✓ 调用成功');
        } catch(e) {
            console.error('[TEST] ✗ 调用失败:', e.message);
        }
    } else {
        console.error('[TEST] ✗ startBarcodeScanning 方法不存在');
    }
} else {
    console.error('[TEST] ✗ AndroidBridge 对象未定义');
}
EOF

echo "[6] 等待用户在手机上点击扫码按钮..."
echo "提示：请在设备上打开应用，找到扫码测试页面，并点击"启动扫码"按钮"
echo ""
sleep 3

echo "[7] 获取实时日志（按 Ctrl+C 停止）..."
echo "========================================"
adb logcat 2>&1 | grep -E "WebView|Barcode|扫码"

echo ""
echo "========================================"
echo "诊断完成"
echo "========================================"
