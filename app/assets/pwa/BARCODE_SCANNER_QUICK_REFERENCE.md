# ML Kit 条形码扫描 - 快速参考

## 🚀 快速开始

### 前端调用（JavaScript）

```javascript
// 启动扫码
function startScanning() {
    AndroidBridge.startBarcodeScanning();
}

// 接收结果（必须定义在全局作用域）
function onBarcodeScanned(value, format) {
    if (value === null) {
        console.log('扫码取消或失败');
        return;
    }
    console.log('扫码结果:', value);
    console.log('条码格式:', format);
}
```

### HTML 按钮示例

```html
<button onclick="startScanning()">扫描二维码</button>
```

## 📋 支持的条码格式

| 格式 | 代码 | 示例应用 |
|------|------|---------|
| 二维码 | `QR_CODE` | 支付、营销 |
| Code 128 | `CODE_128` | 物流、库存 |
| Code 39 | `CODE_39` | 工业标签 |
| Code 93 | `CODE_93` | 库存 |
| Codabar | `CODABAR` | 医疗 |
| Data Matrix | `DATA_MATRIX` | 工业 |
| EAN-13 | `EAN_13` | 商品条码 |
| EAN-8 | `EAN_8` | 商品条码 |
| ITF | `ITF` | 物流包装 |
| UPC-A | `UPC_A` | 北美商品 |
| UPC-E | `UPC_E` | UPC 压缩版 |
| PDF-417 | `PDF417` | 身份证 |
| Aztec | `AZTEC` | 机票 |

## 💻 完整示例

### 简单示例

```html
<!DOCTYPE html>
<html>
<head>
    <title>扫码示例</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        button { padding: 10px 20px; font-size: 16px; }
        #result { margin-top: 20px; color: green; }
    </style>
</head>
<body>
    <h1>二维码扫描</h1>
    <button onclick="startScanning()">点击扫码</button>
    <div id="result"></div>

    <script>
        function startScanning() {
            if (typeof AndroidBridge === 'undefined') {
                alert('Android Bridge 不可用');
                return;
            }
            AndroidBridge.startBarcodeScanning();
        }

        function onBarcodeScanned(value, format) {
            if (value === null) {
                document.getElementById('result').textContent = '扫码被取消';
                return;
            }
            document.getElementById('result').innerHTML = 
                '<p>内容: <strong>' + value + '</strong></p>' +
                '<p>格式: ' + format + '</p>';
        }
    </script>
</body>
</html>
```

### 高级示例 - 支付二维码处理

```javascript
function startPaymentScanning() {
    AndroidBridge.startBarcodeScanning();
}

function onBarcodeScanned(value, format) {
    if (value === null) return;

    if (format === 'QR_CODE') {
        // 处理支付二维码
        processPaymentQR(value);
    } else {
        alert('请扫描支付二维码');
    }
}

function processPaymentQR(qrData) {
    // 发送到服务器处理
    fetch('/api/payment/qr-process', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            qrData: qrData,
            timestamp: Date.now()
        })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert('支付成功！订单号: ' + data.orderNo);
        } else {
            alert('支付失败: ' + data.message);
        }
    })
    .catch(err => alert('网络错误: ' + err.message));
}
```

### 高级示例 - 商品条码查询

```javascript
function startProductScanning() {
    AndroidBridge.startBarcodeScanning();
}

function onBarcodeScanned(value, format) {
    if (value === null) return;

    // 验证是否为商品条码
    if (!['EAN_13', 'EAN_8', 'UPC_A', 'UPC_E', 'CODE_128'].includes(format)) {
        alert('请扫描商品条码');
        return;
    }

    // 查询商品信息
    searchProduct(value, format);
}

function searchProduct(barcode, format) {
    fetch(`/api/product/search?barcode=${encodeURIComponent(barcode)}&format=${format}`)
        .then(res => res.json())
        .then(data => {
            if (data.found) {
                displayProduct(data.product);
            } else {
                alert('找不到商品信息');
            }
        })
        .catch(err => console.error('查询失败:', err));
}

function displayProduct(product) {
    // 显示商品信息
    console.log('商品:', product.name, product.price);
}
```

## 🔍 调试技巧

### 检查 Android Bridge 可用性

```javascript
// 在页面加载时检查
if (typeof AndroidBridge === 'undefined') {
    console.warn('运行在 Web 环境，不在原生 App 中');
} else if (typeof AndroidBridge.startBarcodeScanning === 'function') {
    console.log('扫码功能可用');
} else {
    console.error('扫码功能不可用');
}
```

### 验证回调函数

```javascript
// 确保回调函数在全局作用域
window.onBarcodeScanned = function(value, format) {
    console.log('回调已触发', value, format);
};

// 或检查函数是否已定义
function checkCallback() {
    console.log('onBarcodeScanned 已定义:', typeof onBarcodeScanned === 'function');
}
```

### Logcat 日志查看

```bash
# 查看所有扫码相关日志
adb logcat | grep -E "(WebView|BarcodeScanner|BarcodeScannerActivity)"

# 查看特定关键字
adb logcat | grep "扫码"
```

## ⚙️ 常见错误排查

| 问题 | 解决方案 |
|------|--------|
| "Android Bridge 未定义" | 确认在原生 App 中运行，不是浏览器 |
| "startBarcodeScanning 不存在" | 检查 MainActivity 是否已更新 |
| "回调函数没有被调用" | 确保 `onBarcodeScanned` 在全局作用域，不在函数内部 |
| "相机权限错误" | 在系统设置中授予摄像头权限 |
| "扫码无反应" | 检查条码是否清晰，设备是否有摄像头 |

## 📱 测试页面

完整的测试页面已包含在应用资源中：

```
app/assets/pwa/barcode-scanner-test.html
```

功能包括：
- 一键启动扫码
- 结果显示
- 扫码历史记录
- 复制功能

### 访问方式

在应用中加载此 HTML 文件：

```java
webView.loadUrl("file:///android_asset/pwa/barcode-scanner-test.html");
```

## 🔐 安全建议

1. **验证扫码结果**
   ```javascript
   function validateBarcode(value, format) {
       if (!value || value.trim().length === 0) {
           return false;
       }
       // 根据格式添加额外验证
       return true;
   }
   ```

2. **转义用户输入**
   ```javascript
   function escapeString(str) {
       return str.replace(/[<>"'&]/g, char => ({
           '<': '&lt;',
           '>': '&gt;',
           '"': '&quot;',
           "'": '&#39;',
           '&': '&amp;'
       })[char]);
   }
   ```

3. **HTTPS 传输**
   ```javascript
   // 使用 HTTPS 而不是 HTTP
   fetch('https://api.example.com/process', {...})
   ```

4. **输入长度限制**
   ```javascript
   function onBarcodeScanned(value, format) {
       if (value.length > 1000) {
           alert('扫码内容过长，可能无效');
           return;
       }
       // 处理
   }
   ```

## 📊 性能注意事项

- 扫码识别速度: 通常 < 500ms
- 内存占用: ~50-100MB
- 电池耗电: 取决于使用时长
- 支持分辨率: 1280x720 以上推荐

## 📞 获取帮助

1. 查看 `BARCODE_SCANNER_INTEGRATION_GUIDE.md` 了解完整文档
2. 检查 Logcat 日志查找错误信息
3. 测试 `barcode-scanner-test.html` 验证功能
4. 查看 BarcodeScannerActivity.java 源代码

## 🎯 API 速查表

| 项目 | 值 |
|------|-----|
| JavaScript 接口 | `AndroidBridge` |
| 启动方法 | `startBarcodeScanning()` |
| 回调函数 | `onBarcodeScanned(value, format)` |
| 取消/失败值 | `value === null` |
| 取消格式 | `'CANCELLED'` |
| 错误格式 | `'ERROR'` |
| 最小 API 级别 | 21 |
| 最小权限 | `android.permission.CAMERA` |

## 📝 更新日志

- **v1.0** (2025-01-06): 初始版本，支持 13 种条码格式

---

**提示**: 对于更多高级用法和完整实现细节，请参考 `BARCODE_SCANNER_INTEGRATION_GUIDE.md`
