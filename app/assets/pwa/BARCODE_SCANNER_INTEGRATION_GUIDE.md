# ML Kit 条形码扫描集成指南

## 📋 目录

1. [概述](#概述)
2. [功能特性](#功能特性)
3. [支持的条码格式](#支持的条码格式)
4. [架构设计](#架构设计)
5. [API 文档](#api-文档)
6. [前端集成](#前端集成)
7. [后端实现详解](#后端实现详解)
8. [测试与调试](#测试与调试)
9. [常见问题](#常见问题)
10. [性能优化](#性能优化)

---

## 概述

本文档详细介绍如何在 365 农业银行 Android 应用中集成 **ML Kit 独立 SDK 条形码扫描功能**，以及如何与 WebView 进行通信。

### 核心技术栈

- **ML Kit Barcode Scanner 17.2.0**: Google 最新的独立条码识别库
- **CameraX 1.2.0**: 现代化的 Android 相机框架
- **WebView JavaScript Bridge**: 原生与 Web 通信的桥梁
- **实时图像处理**: 基于 ImageAnalysis 的逐帧分析

### 集成优势

✅ **高精度识别**: 支持 13 种条码格式，识别速度快  
✅ **轻量级方案**: 使用 ML Kit 独立 SDK，无需完整的 Google Play Services  
✅ **离线工作**: 无需网络连接，在设备本地进行识别  
✅ **性能优化**: 采用最新的 STRATEGY_KEEP_ONLY_LATEST 策略，防止内存溢出  
✅ **用户友好**: 专业的扫码 UI，支持相机权限动态请求  

---

## 功能特性

### 核心功能

| 功能 | 描述 |
|------|------|
| **实时扫码** | 启动相机后，实时检测视图中的条码 |
| **多格式支持** | 支持 QR 码、Code 128、EAN、UPC 等 13 种格式 |
| **自动对焦** | CameraX 自动管理对焦，提高识别成功率 |
| **快速响应** | 扫码成功后立即返回数据给 WebView |
| **权限管理** | 自动请求并处理相机权限 |
| **易于集成** | 通过简单的 JavaScript 调用启动扫码 |

### 安全特性

| 特性 | 说明 |
|------|------|
| **权限隔离** | 相机访问由 Android 权限系统严格控制 |
| **数据本地处理** | 所有识别操作在本地进行，不涉及网络 |
| **取消机制** | 用户可随时取消扫码操作 |
| **结果验证** | 有效的扫码结果才会返回给 WebView |

---

## 支持的条码格式

ML Kit 条码扫描器支持以下 13 种条码格式：

### 一维条码（Linear Codes）

| 格式 | 说明 | 应用场景 |
|------|------|---------|
| **QR_CODE** | 二维码 | 营销、支付、信息分享 |
| **CODE_128** | Code 128 | 物流、库存管理 |
| **CODE_39** | Code 39 | 工业标签、医疗应用 |
| **CODE_93** | Code 93 | 加拿大邮局、库存 |
| **CODABAR** | Codabar | 医疗、血库、航运 |
| **EAN_13** | EAN-13 | 超市商品条码 |
| **EAN_8** | EAN-8 | 超市商品条码（简化版） |
| **ITF** | ITF-14 | 物流包装码 |
| **UPC_A** | UPC-A | 北美商品条码 |
| **UPC_E** | UPC-E | UPC-A 压缩版 |

### 二维码（Matrix Codes）

| 格式 | 说明 | 应用场景 |
|------|------|---------|
| **DATA_MATRIX** | Data Matrix | 工业标签、电子元器件 |
| **PDF417** | PDF-417 | 身份证、驾驶证、机票 |
| **AZTEC** | Aztec Code | 机票、医疗处方 |

---

## 架构设计

### 系统架构图

```
┌─────────────────────────────────────────┐
│         WebView (前端 HTML/JS)          │
│  ┌─────────────────────────────────────┐│
│  │ onBarcodeScanned(value, format)     ││
│  │ startScanning() → Android Bridge    ││
│  └─────────────────────────────────────┘│
└──────────────┬──────────────────────────┘
               │ JavaScript Bridge
               ↓
┌─────────────────────────────────────────┐
│   MainActivity (Java)                   │
│  ┌─────────────────────────────────────┐│
│  │ JSBridge.startBarcodeScanning()     ││
│  │   └→ startActivityForResult()       ││
│  │                                      ││
│  │ onActivityResult()                  ││
│  │   └→ invokeBarcodeScannedCallback() ││
│  └─────────────────────────────────────┘│
└──────────────┬──────────────────────────┘
               │ Intent (startActivityForResult)
               ↓
┌─────────────────────────────────────────┐
│   BarcodeScannerActivity (Java)         │
│  ┌─────────────────────────────────────┐│
│  │ BarcodeScanner (ML Kit)             ││
│  │ CameraX (Preview + ImageAnalysis)   ││
│  │ Process each frame in real-time     ││
│  │   └→ setResultAndFinish()           ││
│  └─────────────────────────────────────┘│
└──────────────┬──────────────────────────┘
               │ Intent Result
               ↓
┌─────────────────────────────────────────┐
│   onActivityResult() in MainActivity    │
│   Extract barcode data and invoke JS    │
└─────────────────────────────────────────┘
```

### 数据流向

```
1. JavaScript 调用 AndroidBridge.startBarcodeScanning()
   ↓
2. MainActivity 启动 BarcodeScannerActivity
   ↓
3. BarcodeScannerActivity 初始化相机和 ML Kit
   ↓
4. 用户对准条码，CameraX 实时捕获图像
   ↓
5. ML Kit BarcodeScanner 分析每一帧，检测条码
   ↓
6. 条码识别成功，返回结果给 MainActivity
   ↓
7. MainActivity.onActivityResult() 捕获结果
   ↓
8. 调用 JavaScript onBarcodeScanned() 回调函数
   ↓
9. 前端 JavaScript 获得扫码结果并处理
```

### 关键类说明

#### 1. BarcodeScannerActivity

| 组件 | 作用 |
|------|------|
| **ProcessCameraProvider** | 管理相机实例的生命周期 |
| **BarcodeScanner** | ML Kit 条码识别器，配置多种格式支持 |
| **CameraX Preview** | 显示实时相机预览 |
| **ImageAnalysis** | 逐帧分析，实时检测条码 |
| **ImageProxy** | 当前帧的图像数据 |

#### 2. MainActivity JSBridge

| 方法 | 功能 |
|------|------|
| **startBarcodeScanning()** | 启动扫码 Activity |
| **onActivityResult()** | 接收扫码结果 |
| **invokeBarcodeScannedCallback()** | 调用 JavaScript 回调 |

#### 3. WebView JavaScript

| 函数 | 功能 |
|------|------|
| **startScanning()** | 前端按钮点击处理器，调用原生扫码 |
| **onBarcodeScanned()** | 原生扫码完成后的回调函数 |

---

## API 文档

### Android 端 API

#### JSBridge.startBarcodeScanning()

**声明**
```java
@android.webkit.JavascriptInterface
public void startBarcodeScanning()
```

**功能**: 启动二维码/条形码扫描 Activity

**前端调用示例**
```javascript
// 简单调用
AndroidBridge.startBarcodeScanning();

// 带错误处理
try {
    if (typeof AndroidBridge !== 'undefined' && 
        typeof AndroidBridge.startBarcodeScanning === 'function') {
        AndroidBridge.startBarcodeScanning();
    } else {
        console.error('Android Bridge 不可用');
    }
} catch (error) {
    console.error('启动扫码失败:', error);
}
```

**返回值**: 无 (void)

**权限要求**: CAMERA (已自动请求)

**说明**:
- 此方法是异步的，不阻塞 JavaScript 执行
- 启动 BarcodeScannerActivity，用户可见一个全屏相机界面
- 扫码结果通过 onBarcodeScanned() 回调函数返回

---

### JavaScript 回调 API

#### onBarcodeScanned()

**签名**
```javascript
function onBarcodeScanned(barcodeValue, barcodeFormat) {
    // 处理扫码结果
}
```

**参数**

| 参数 | 类型 | 说明 |
|------|------|------|
| **barcodeValue** | string \| null | 扫描到的条码内容；null 表示取消或出错 |
| **barcodeFormat** | string | 条码格式（见下表）；取消/出错时为 'CANCELLED' 或 'ERROR' |

**支持的条码格式值**

```
QR_CODE       - 二维码
CODE_128      - Code 128
CODE_39       - Code 39
CODE_93       - Code 93
CODABAR       - Codabar
DATA_MATRIX   - Data Matrix
EAN_13        - EAN-13
EAN_8         - EAN-8
ITF           - ITF
UPC_A         - UPC-A
UPC_E         - UPC-E
PDF417        - PDF-417
AZTEC         - Aztec Code
CANCELLED     - 用户取消扫码
ERROR         - 扫码过程出错
```

**使用示例**

```javascript
function onBarcodeScanned(barcodeValue, barcodeFormat) {
    if (barcodeValue === null) {
        if (barcodeFormat === 'CANCELLED') {
            console.log('用户取消了扫码');
        } else {
            console.error('扫码失败:', barcodeFormat);
        }
        return;
    }

    // 成功获得扫码结果
    console.log('扫码成功!');
    console.log('内容:', barcodeValue);
    console.log('格式:', barcodeFormat);

    // 处理扫码结果
    handleBarcodeResult(barcodeValue, barcodeFormat);
}

function handleBarcodeResult(value, format) {
    // 根据条码格式处理
    switch(format) {
        case 'QR_CODE':
            handleQRCode(value);
            break;
        case 'CODE_128':
        case 'EAN_13':
        case 'UPC_A':
            handleProductBarcode(value);
            break;
        default:
            console.log('其他格式:', value);
    }
}
```

---

## 前端集成

### 基础集成步骤

#### 1. 导入测试页面

在 `app/assets/pwa/` 目录中有现成的测试页面：`barcode-scanner-test.html`

```html
<!DOCTYPE html>
<html>
<head>
    <title>扫码测试</title>
</head>
<body>
    <button onclick="startScanning()">启动扫码</button>
    
    <script>
        function startScanning() {
            AndroidBridge.startBarcodeScanning();
        }

        function onBarcodeScanned(value, format) {
            console.log('扫码成功:', value, format);
        }
    </script>
</body>
</html>
```

#### 2. 在你的页面中添加扫码功能

**HTML**
```html
<button id="scanBtn" class="btn-primary">
    <span class="icon">📷</span>
    扫描二维码
</button>

<div id="result" style="display: none;">
    <p>扫码结果: <strong id="resultText"></strong></p>
</div>
```

**JavaScript**
```javascript
// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    const scanBtn = document.getElementById('scanBtn');
    scanBtn.addEventListener('click', startScanning);
});

// 启动扫码
function startScanning() {
    // 检查 Android Bridge 是否可用
    if (typeof AndroidBridge === 'undefined') {
        alert('此功能仅在原生 App 中可用');
        return;
    }

    if (typeof AndroidBridge.startBarcodeScanning !== 'function') {
        alert('扫码功能不可用');
        return;
    }

    try {
        AndroidBridge.startBarcodeScanning();
    } catch (error) {
        alert('启动扫码失败: ' + error.message);
    }
}

// 扫码完成回调（必须定义在全局作用域）
function onBarcodeScanned(value, format) {
    if (value === null) {
        console.log('扫码被取消或出错');
        return;
    }

    // 显示结果
    document.getElementById('resultText').textContent = value;
    document.getElementById('result').style.display = 'block';

    // 进一步处理扫码结果
    processScannedData(value, format);
}

// 处理扫码数据
function processScannedData(value, format) {
    console.log('处理扫码数据:', {
        value: value,
        format: format,
        timestamp: new Date().toISOString()
    });

    // 示例：发送到服务器
    if (format === 'QR_CODE') {
        // 二维码处理逻辑
        handleQRCode(value);
    } else if (['EAN_13', 'EAN_8', 'UPC_A', 'UPC_E', 'CODE_128'].includes(format)) {
        // 商品条码处理逻辑
        handleProductBarcode(value);
    }
}

function handleQRCode(data) {
    // 检查是否为 URL
    if (data.startsWith('http://') || data.startsWith('https://')) {
        window.location.href = data;
    } else {
        console.log('QR 码内容:', data);
    }
}

function handleProductBarcode(code) {
    // 调用 API 查询商品信息
    fetch('/api/product/search?code=' + encodeURIComponent(code))
        .then(res => res.json())
        .then(data => {
            console.log('商品信息:', data);
        })
        .catch(err => console.error('查询失败:', err));
}
```

### 高级用法

#### 扫码结果验证

```javascript
function onBarcodeScanned(value, format) {
    // 验证扫码结果
    if (!isValidBarcode(value, format)) {
        alert('扫码结果无效，请重新扫描');
        return;
    }

    // 处理有效的扫码结果
    handleValidBarcode(value, format);
}

function isValidBarcode(value, format) {
    // 根据格式验证
    switch(format) {
        case 'QR_CODE':
            return value.length > 0;
        case 'EAN_13':
            return /^\d{13}$/.test(value);
        case 'CODE_128':
            return value.length > 0;
        default:
            return true;
    }
}
```

#### 扫码结果加密传输

```javascript
function onBarcodeScanned(value, format) {
    // 加密扫码结果后发送到服务器
    const encryptedData = encryptData(value);
    
    fetch('/api/barcode/process', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            data: encryptedData,
            format: format,
            timestamp: Date.now()
        })
    })
    .then(res => res.json())
    .then(data => {
        console.log('服务器处理结果:', data);
    })
    .catch(err => console.error('发送失败:', err));
}

function encryptData(data) {
    // 这里可以使用 crypto-js 或其他加密库
    return btoa(data); // 简单示例：Base64 编码
}
```

#### 扫码超时处理

```javascript
let scanTimeoutTimer = null;

function startScanning() {
    // 启动 2 分钟超时计时器
    scanTimeoutTimer = setTimeout(() => {
        console.warn('扫码超时，用户可能未完成扫码操作');
        // 可选：显示超时提示
    }, 120000);

    AndroidBridge.startBarcodeScanning();
}

function onBarcodeScanned(value, format) {
    // 取消超时计时器
    if (scanTimeoutTimer) {
        clearTimeout(scanTimeoutTimer);
        scanTimeoutTimer = null;
    }

    // 处理扫码结果
    if (value !== null) {
        handleBarcodeData(value, format);
    }
}
```

---

## 后端实现详解

### BarcodeScannerActivity 核心实现

#### 初始化和权限处理

```java
public class BarcodeScannerActivity extends AppCompatActivity {
    private static final int CAMERA_PERMISSION_REQUEST_CODE = 100;
    private PreviewView previewView;
    private BarcodeScanner barcodeScanner;
    private ProcessCameraProvider cameraProvider;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_barcode_scanner);

        // 检查权限
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) 
                == PackageManager.PERMISSION_GRANTED) {
            startCamera();
        } else {
            // 请求权限
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.CAMERA},
                    CAMERA_PERMISSION_REQUEST_CODE);
        }
    }
}
```

#### 相机启动流程

```java
private void startCamera() {
    // 配置 ML Kit BarcodeScanner
    BarcodeScannerOptions options = new BarcodeScannerOptions.Builder()
            .setBarcodeFormats(
                    Barcode.FORMAT_QR_CODE,
                    Barcode.FORMAT_CODE_128,
                    Barcode.FORMAT_CODE_39,
                    Barcode.FORMAT_CODE_93,
                    Barcode.FORMAT_CODABAR,
                    Barcode.FORMAT_DATA_MATRIX,
                    Barcode.FORMAT_EAN_13,
                    Barcode.FORMAT_EAN_8,
                    Barcode.FORMAT_ITF,
                    Barcode.FORMAT_UPC_A,
                    Barcode.FORMAT_UPC_E,
                    Barcode.FORMAT_PDF417,
                    Barcode.FORMAT_AZTEC
            )
            .build();

    barcodeScanner = BarcodeScanning.getClient(options);

    // 初始化 CameraX
    ListenableFuture<ProcessCameraProvider> cameraProviderFuture = 
            ProcessCameraProvider.getInstance(this);

    cameraProviderFuture.addListener(() -> {
        try {
            cameraProvider = cameraProviderFuture.get();
            bindCameraUseCases();
        } catch (ExecutionException | InterruptedException e) {
            Log.e(TAG, "相机初始化失败", e);
        }
    }, ContextCompat.getMainExecutor(this));
}
```

#### 图像分析和条码检测

```java
private void bindCameraUseCases() {
    // Preview 用于显示相机预览
    Preview preview = new Preview.Builder().build();
    preview.setSurfaceProvider(previewView.getSurfaceProvider());

    // ImageAnalysis 用于实时图像分析
    ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
            .setTargetResolution(new Size(1280, 720))
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build();

    imageAnalysis.setAnalyzer(ContextCompat.getMainExecutor(this), 
            imageProxy -> analyzeImage(imageProxy));

    // 绑定到相机
    cameraProvider.bindToLifecycle(
            this,
            CameraSelector.DEFAULT_BACK_CAMERA,
            preview,
            imageAnalysis);
}

private void analyzeImage(ImageProxy imageProxy) {
    @SuppressLint("UnsafeOptInUsageError")
    Image image = imageProxy.getImage();

    if (image == null) {
        imageProxy.close();
        return;
    }

    InputImage inputImage = InputImage.fromMediaImage(image, imageProxy.getImageInfo().getRotationDegrees());

    barcodeScanner.process(inputImage)
            .addOnSuccessListener(barcodes -> {
                for (Barcode barcode : barcodes) {
                    String barcodeValue = barcode.getRawValue();
                    int barcodeFormat = barcode.getFormat();

                    // 条码检测成功，返回结果
                    if (!hasResult) {
                        hasResult = true;
                        setResultAndFinish(barcodeValue, barcodeFormat);
                    }
                }
            })
            .addOnFailureListener(e -> Log.e(TAG, "条码处理失败", e))
            .addOnCompleteListener(task -> imageProxy.close());
}
```

### MainActivity 结果处理

```java
@Override
public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (requestCode == BARCODE_SCANNER_REQUEST_CODE) {
        if (resultCode == RESULT_OK && data != null) {
            String barcodeValue = data.getStringExtra("barcode_value");
            String barcodeFormat = data.getStringExtra("barcode_format_name");

            // 调用 JavaScript 回调
            invokeBarcodeScannedCallback(barcodeValue, barcodeFormat);
        } else if (resultCode == RESULT_CANCELED) {
            invokeBarcodeScannedCallback(null, "CANCELLED");
        }
    }
}

private void invokeBarcodeScannedCallback(String barcodeValue, String barcodeFormat) {
    if (barcodeValue == null) {
        webView.evaluateJavascript(
            "javascript:if(typeof onBarcodeScanned === 'function') { " +
            "onBarcodeScanned(null, '" + barcodeFormat + "'); }",
            null
        );
    } else {
        String escapedValue = barcodeValue.replace("'", "\\'");
        webView.evaluateJavascript(
            "javascript:if(typeof onBarcodeScanned === 'function') { " +
            "onBarcodeScanned('" + escapedValue + "', '" + barcodeFormat + "'); }",
            null
        );
    }
}
```

---

## 测试与调试

### 单元测试

#### 条码格式验证测试

```java
@Test
public void testBarcodeFormatDetection() {
    // 测试各种条码格式
    assertTrue(isSupportedFormat(Barcode.FORMAT_QR_CODE));
    assertTrue(isSupportedFormat(Barcode.FORMAT_CODE_128));
    assertTrue(isSupportedFormat(Barcode.FORMAT_EAN_13));
    
    // 不支持的格式
    assertFalse(isSupportedFormat(999));
}

private boolean isSupportedFormat(int format) {
    return format == Barcode.FORMAT_QR_CODE ||
           format == Barcode.FORMAT_CODE_128 ||
           format == Barcode.FORMAT_CODE_39 ||
           // ... 其他格式
           format == Barcode.FORMAT_AZTEC;
}
```

### 集成测试

#### 端到端扫码测试

```html
<!-- 在 barcode-scanner-test.html 中进行测试 -->

1. 访问 http://localhost:8080/barcode-scanner-test.html
2. 点击"启动扫码"按钮
3. 用手机摄像头对准条码
4. 验证结果是否正确返回
5. 检查扫码历史是否记录成功
```

### 调试方法

#### 1. Chrome DevTools 调试

```javascript
// 在 WebView 中启用远程调试
// MainActivity 中已经设置了：
if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
    WebView.setWebContentsDebuggingEnabled(true);
}

// 在 Chrome 中访问：chrome://inspect
```

#### 2. Logcat 日志查看

```bash
# 过滤扫码相关日志
adb logcat | grep "WebView"

# 或在 Android Studio 中使用 Logcat 工具
# 搜索关键字: "扫码", "BarcodeScanner", "BarcodeScannerActivity"
```

#### 3. JavaScript 控制台输出

```javascript
// 在 barcode-scanner-test.html 中会自动输出：
[扫码测试] 用户点击启动扫码
[扫码测试] 调用 AndroidBridge.startBarcodeScanning()
[扫码测试] 收到扫码回调: { barcodeValue: "...", barcodeFormat: "QR_CODE" }
[扫码测试] 结果已显示并添加到历史
```

#### 4. 本地测试建议

```bash
# 使用以下测试用二维码：
# - 简单文本：https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Hello
# - 网址：https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://www.example.com
# - 电话：https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=tel:1234567890

# 使用在线条码生成工具：
# - https://barcode.tec-it.com/
# - https://www.barcodes-generator.com/
```

---

## 常见问题

### Q1: 相机权限为什么无法获取？

**A**: 检查以下几点：

1. **AndroidManifest.xml 中的权限声明**
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

2. **运行时权限请求**
   - 在 Android 6.0+ 需要动态请求权限
   - MainActivity 中已经实现了自动请求

3. **用户拒绝权限**
   - 进入设置 → 应用 → 权限 → 开启摄像头权限

### Q2: 为什么扫码不出反应？

**A**: 排查步骤：

1. **检查 CameraX 初始化**
   - 确保 `ProcessCameraProvider` 已获取
   - 查看 Logcat 中是否有相关错误

2. **检查相机硬件**
   - 确认设备有摄像头
   - 尝试其他相机应用是否正常

3. **检查条码位置**
   - 确保条码在相机预览范围内
   - 条码应该清晰可见

4. **查看 Logcat 日志**
   ```bash
   adb logcat | grep "BarcodeScanner"
   adb logcat | grep "Camera"
   ```

### Q3: JavaScript 回调函数没有被调用？

**A**: 检查以下几点：

1. **确认函数名称正确**
   ```javascript
   // 必须是全局函数
   function onBarcodeScanned(value, format) {
       console.log('收到回调');
   }
   ```

2. **检查 WebView 配置**
   ```java
   // MainActivity 中应该有：
   webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");
   ```

3. **验证 Android Bridge 是否可用**
   ```javascript
   console.log('AndroidBridge 可用:', typeof AndroidBridge !== 'undefined');
   console.log('startBarcodeScanning 方法:', typeof AndroidBridge.startBarcodeScanning);
   ```

4. **查看 MainActivity.onActivityResult()**
   - 确保 `invokeBarcodeScannedCallback()` 被正确调用

### Q4: 扫码结果中文乱码？

**A**: 这通常是字符编码问题：

```java
// 在 BarcodeScannerActivity 中确保使用 UTF-8
String barcodeValue = barcode.getRawValue();
// barcode.getRawValue() 已经返回正确编码的字符串

// 在 MainActivity.invokeBarcodeScannedCallback() 中也需要正确转义
String escapedValue = barcodeValue.replace("'", "\\'").replace("\"", "\\\"");
```

### Q5: 性能问题 - 内存占用过高？

**A**: 使用了优化策略：

```java
// 在 BarcodeScannerActivity 中配置了：
ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
        // ↑ 这个配置可以防止帧积压和内存溢出
        .build();

// 额外的优化：
// 1. 设置合理的目标分辨率
.setTargetResolution(new Size(1280, 720))

// 2. 及时关闭资源
imageProxy.close();
```

### Q6: 如何支持更多条码格式？

**A**: 修改 `BarcodeScannerActivity.startCamera()` 方法：

```java
BarcodeScannerOptions options = new BarcodeScannerOptions.Builder()
        .setBarcodeFormats(
                Barcode.FORMAT_QR_CODE,
                Barcode.FORMAT_CODE_128,
                // ... 添加更多格式
                // 所有支持的格式已经包含在内
        )
        .build();
```

所有 13 种格式在当前实现中已经全部支持。

---

## 性能优化

### 内存优化

```java
// 1. 使用 STRATEGY_KEEP_ONLY_LATEST 策略
ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
        .build();

// 2. 及时释放图像资源
imageProxy.close();

// 3. 处理完条码后立即释放
if (barcodeDetected) {
    hasResult = true;
    setResultAndFinish(value, format);
    return; // 不继续处理更多帧
}
```

### 识别速度优化

```java
// 1. 使用合理的分辨率
ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
        .setTargetResolution(new Size(1280, 720))
        .build();

// 2. 降低分析频率（可选）
imageAnalysis.setAnalyzer(executor, new ImageAnalysis.Analyzer() {
    private long lastAnalysisTime = 0;
    
    @Override
    public void analyze(@NonNull ImageProxy imageProxy) {
        long currentTime = System.currentTimeMillis();
        if (currentTime - lastAnalysisTime < 200) { // 每 200ms 分析一次
            imageProxy.close();
            return;
        }
        lastAnalysisTime = currentTime;
        // 进行分析
    }
});
```

### 电池耗电优化

```java
// 1. 及时释放相机
@Override
protected void onPause() {
    super.onPause();
    if (cameraProvider != null) {
        cameraProvider.unbindAll();
    }
}

// 2. 禁用不需要的相机功能
// CameraX 会自动管理，无需额外配置

// 3. 减少帧处理频率
// 上面已经演示了方法
```

---

## 完整集成清单

- [x] 添加 ML Kit 依赖 (17.2.0)
- [x] 添加 CameraX 依赖 (1.2.0)
- [x] 在 AndroidManifest.xml 中声明相机权限
- [x] 注册 BarcodeScannerActivity
- [x] 实现 BarcodeScannerActivity 类（400+ 行代码）
- [x] 创建 activity_barcode_scanner.xml 布局文件
- [x] 创建 colors.xml 和 drawables (UI 资源)
- [x] 在 MainActivity 添加 JSBridge.startBarcodeScanning() 方法
- [x] 在 MainActivity 实现 onActivityResult() 处理
- [x] 实现 invokeBarcodeScannedCallback() 方法
- [x] 创建测试 HTML 页面 (barcode-scanner-test.html)
- [x] 编写本文档 (集成指南)

---

## 相关资源

- **ML Kit Barcode Scanning**: https://developers.google.com/ml-kit/vision/barcode-scanning
- **CameraX 文档**: https://developer.android.com/training/camerax
- **Android 权限指南**: https://developer.android.com/guide/topics/permissions/overview
- **WebView JavaScript Bridge**: https://developer.android.com/guide/webapps/webview

---

## 支持与反馈

如有问题，请：

1. 查看 Logcat 中的错误信息
2. 检查上述"常见问题"部分
3. 确认所有文件已正确创建
4. 测试 barcode-scanner-test.html 页面

**文档版本**: 1.0  
**最后更新**: 2025-01-06  
**支持的 Android 版本**: API 21+
