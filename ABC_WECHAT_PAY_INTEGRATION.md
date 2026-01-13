# 农行综合收银台微信支付集成文档

## 📋 目录

1. [概述](#概述)
2. [集成说明](#集成说明)
3. [配置步骤](#配置步骤)
4. [使用方法](#使用方法)
5. [前端调用示例](#前端调用示例)
6. [测试指南](#测试指南)
7. [常见问题](#常见问题)

---

## 概述

本文档说明如何在当前Android应用中集成农行综合收银台V3.3.3的微信支付功能，实现WebView JavaScript桥接调用。

### 集成内容

✅ **已完成的集成工作：**

1. **农行SDK集成**
   - 复制 `TrustPayClient-V3.3.3.jar` 到 `app/libs/`
   - 复制依赖库（commons-codec、commons-httpclient、commons-logging）

2. **核心类创建**
   - `AbcPayConfig.java` - 农行支付配置类
   - `AbcWeChatPayManager.java` - 微信支付管理类
   - `AbcPayResultActivity.java` - 支付结果回调处理

3. **JavaScript Bridge方法**
   - `createWeChatPay()` - APP支付
   - `createWeChatJsApiPay()` - 公众号/小程序支付
   - `createWeChatNativePay()` - 扫码支付

4. **配置文件更新**
   - `build.gradle` - 添加农行SDK依赖
   - `AndroidManifest.xml` - 添加权限和Activity声明

---

## 集成说明

### 架构设计

```
WebView (前端)
    ↓
JavaScript Bridge
    ↓
AbcWeChatPayManager
    ↓
农行SDK (TrustPayClient)
    ↓
农行综合收银台服务器
    ↓
微信支付
```

### 文件清单

| 文件 | 路径 | 说明 |
|------|------|------|
| TrustPayClient-V3.3.3.jar | app/libs/ | 农行核心SDK |
| commons-*.jar | app/libs/ | 依赖库（3个） |
| AbcPayConfig.java | app/src/main/java/net/qsgl365/ | 配置类 |
| AbcWeChatPayManager.java | app/src/main/java/net/qsgl365/ | 支付管理类 |
| AbcPayResultActivity.java | app/src/main/java/net/qsgl365/ | 回调Activity |
| MainActivity.java | app/src/main/java/net/qsgl365/ | 已添加JSBridge方法 |

---

## 配置步骤

### 1. 获取农行商户资料

需要联系农行获取以下信息：

- **商户号** (MerchantID)
- **商户证书** (merchant.pfx)
- **商户证书密码** (MerchantCertPassword)
- **农行平台证书** (TrustPay.cer)

### 2. 配置商户信息

编辑 `app/src/main/java/net/qsgl365/AbcPayConfig.java`：

```java
// 商户编号（由农行提供）
public static final String MERCHANT_ID = "你的商户号";

// 商户证书密码（由农行提供）
public static final String MERCHANT_CERT_PASSWORD = "你的证书密码";

// 是否使用测试环境（正式上线改为 false）
public static boolean USE_TEST_ENV = true;
```

### 3. 放置证书文件

将证书文件放到 `app/src/main/assets/` 目录：

```
app/src/main/assets/
├── TrustPay.cer        # 农行平台证书
└── merchant.pfx        # 商户证书
```

**注意：** 证书文件需要从农行获取，缺少证书会导致支付失败。

### 4. 编译APK

```bash
# Windows PowerShell
.\gradlew.bat assembleRelease
```

编译成功后，APK位于：
```
app/build/outputs/apk/release/app-release.apk
```

---

## 使用方法

### JavaScript Bridge API

#### 1. APP微信支付

```javascript
/**
 * 创建APP微信支付订单
 * 
 * @param {string} orderNo - 订单号（唯一，建议格式：时间戳+随机数）
 * @param {string} amount - 订单金额（元，如 "0.01"）
 * @param {string} orderDesc - 订单描述
 * @param {string} notifyUrl - 支付结果通知URL
 * @param {string} appId - 微信应用APPID
 * @returns {string} 农行平台返回的JSON结果
 */
var result = AndroidBridge.createWeChatPay(
    'ORDER20260104001',     // 订单号
    '0.01',                 // 金额（元）
    '测试商品购买',          // 订单描述
    'http://yourserver.com/notify',  // 通知URL
    'wx1234567890abcdef'    // 微信APPID
);

// 解析返回结果
var resultObj = JSON.parse(result);
if (resultObj.ReturnCode === '0000') {
    console.log('订单创建成功');
    // 拉起微信支付
    // 返回结果中包含支付所需参数
} else {
    console.error('订单创建失败: ' + resultObj.ErrorMessage);
}
```

#### 2. 公众号/小程序支付

```javascript
/**
 * 创建公众号/小程序微信支付订单
 * 
 * @param {string} orderNo - 订单号
 * @param {string} amount - 订单金额
 * @param {string} orderDesc - 订单描述
 * @param {string} notifyUrl - 支付结果通知URL
 * @param {string} openId - 用户在公众号/小程序的OpenID
 * @returns {string} 农行平台返回的JSON结果
 */
var result = AndroidBridge.createWeChatJsApiPay(
    'ORDER20260104002',
    '0.01',
    '测试商品购买',
    'http://yourserver.com/notify',
    'oABC_123xyz456'  // 用户OpenID
);
```

#### 3. 扫码支付

```javascript
/**
 * 创建扫码支付订单
 * 
 * @param {string} orderNo - 订单号
 * @param {string} amount - 订单金额
 * @param {string} orderDesc - 订单描述
 * @param {string} notifyUrl - 支付结果通知URL
 * @returns {string} 农行平台返回的JSON结果（包含二维码链接）
 */
var result = AndroidBridge.createWeChatNativePay(
    'ORDER20260104003',
    '0.01',
    '测试商品购买',
    'http://yourserver.com/notify'
);

// 解析结果
var resultObj = JSON.parse(result);
if (resultObj.ReturnCode === '0000') {
    var qrCodeUrl = resultObj.CodeUrl;  // 二维码链接
    // 显示二维码给用户扫描
}
```

---

## 前端调用示例

### 完整的支付流程示例

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>农行微信支付示例</title>
</head>
<body>
    <h1>微信支付测试</h1>
    
    <button onclick="testWeChatPay()">发起APP支付</button>
    <button onclick="testJsApiPay()">发起公众号支付</button>
    <button onclick="testNativePay()">发起扫码支付</button>
    
    <div id="result"></div>

    <script>
        // 生成订单号
        function generateOrderNo() {
            var timestamp = new Date().getTime();
            var random = Math.floor(Math.random() * 10000);
            return 'ORDER' + timestamp + random;
        }
        
        // APP支付
        function testWeChatPay() {
            try {
                var orderNo = generateOrderNo();
                var result = AndroidBridge.createWeChatPay(
                    orderNo,
                    '0.01',
                    '测试APP支付',
                    'http://yourserver.com/notify',
                    'wx1234567890abcdef'
                );
                
                document.getElementById('result').innerHTML = 
                    '<h3>支付结果：</h3><pre>' + 
                    JSON.stringify(JSON.parse(result), null, 2) + 
                    '</pre>';
                    
            } catch (error) {
                alert('支付失败: ' + error.message);
            }
        }
        
        // 公众号支付
        function testJsApiPay() {
            try {
                var orderNo = generateOrderNo();
                var result = AndroidBridge.createWeChatJsApiPay(
                    orderNo,
                    '0.01',
                    '测试公众号支付',
                    'http://yourserver.com/notify',
                    'oABC_123xyz456'
                );
                
                document.getElementById('result').innerHTML = 
                    '<h3>支付结果：</h3><pre>' + 
                    JSON.stringify(JSON.parse(result), null, 2) + 
                    '</pre>';
                    
            } catch (error) {
                alert('支付失败: ' + error.message);
            }
        }
        
        // 扫码支付
        function testNativePay() {
            try {
                var orderNo = generateOrderNo();
                var result = AndroidBridge.createWeChatNativePay(
                    orderNo,
                    '0.01',
                    '测试扫码支付',
                    'http://yourserver.com/notify'
                );
                
                var resultObj = JSON.parse(result);
                if (resultObj.ReturnCode === '0000') {
                    // 显示二维码
                    var qrCodeUrl = resultObj.CodeUrl;
                    document.getElementById('result').innerHTML = 
                        '<h3>请扫描二维码支付：</h3>' +
                        '<p>二维码链接：' + qrCodeUrl + '</p>' +
                        '<img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + 
                        encodeURIComponent(qrCodeUrl) + '" />';
                } else {
                    alert('订单创建失败: ' + resultObj.ErrorMessage);
                }
                
            } catch (error) {
                alert('支付失败: ' + error.message);
            }
        }
    </script>
</body>
</html>
```

---

## 测试指南

### 测试前准备

1. **确认证书文件已放置**
   - `app/src/main/assets/TrustPay.cer`
   - `app/src/main/assets/merchant.pfx`

2. **确认配置正确**
   - 商户号
   - 证书密码
   - 测试环境开关

3. **编译并安装APK**
   ```bash
   .\gradlew.bat assembleRelease
   adb install -r app/build/outputs/apk/release/app-release.apk
   ```

### 测试步骤

#### 测试1：检查SDK加载

```bash
# 查看日志
adb logcat | findstr "AbcPay"

# 期望看到：
# AbcPayConfig: ========== 农行支付配置信息 ==========
# AbcPayConfig: 环境: 测试环境
# AbcPayConfig: 服务器: https://pay.test.abchina.com:443
# AbcPayConfig: 商户号: 你的商户号
```

#### 测试2：调用支付接口

在WebView中打开测试页面，点击"发起APP支付"按钮。

查看日志：
```bash
adb logcat | findstr "WebView"

# 期望看到：
# WebView: === JavaScript 调用微信支付（APP） ===
# WebView: 订单号: ORDER...
# WebView: 金额: 0.01
# AbcWeChatPayManager: 请求参数构建完成，准备发送到农行服务器...
# AbcWeChatPayManager: 农行服务器返回: {...}
```

#### 测试3：验证返回结果

正常返回示例：
```json
{
  "ReturnCode": "0000",
  "ErrorMessage": "交易成功",
  "TrxId": "202601040001234567",
  "OrderNo": "ORDER20260104001",
  "PayInfo": "...",
  "CodeUrl": "weixin://wxpay/..."
}
```

错误返回示例：
```json
{
  "ReturnCode": "9999",
  "ErrorMessage": "商户号不存在"
}
```

---

## 常见问题

### Q1: 编译时找不到农行SDK的类

**原因：** JAR包未正确添加到项目

**解决方案：**
1. 确认 `app/libs/` 目录下有这些JAR包：
   - TrustPayClient-V3.3.3.jar
   - commons-codec-1.3.jar
   - commons-httpclient-3.0.1.jar
   - commons-logging.jar

2. 确认 `app/build.gradle` 中添加了依赖：
   ```gradle
   dependencies {
       implementation files('libs/TrustPayClient-V3.3.3.jar')
       implementation files('libs/commons-codec-1.3.jar')
       implementation files('libs/commons-httpclient-3.0.1.jar')
       implementation files('libs/commons-logging.jar')
   }
   ```

3. 重新同步Gradle：
   ```bash
   .\gradlew.bat clean build
   ```

### Q2: 支付时提示"证书文件未配置"

**原因：** 证书文件未放到assets目录

**解决方案：**
1. 创建 `app/src/main/assets/` 目录
2. 放置证书文件：
   - TrustPay.cer
   - merchant.pfx
3. 重新编译APK

### Q3: 支付返回"商户号不存在"

**原因：** 商户号配置错误或未在农行开通

**解决方案：**
1. 检查 `AbcPayConfig.java` 中的 `MERCHANT_ID`
2. 确认商户号是否在农行测试环境开通
3. 联系农行技术支持确认商户状态

### Q4: 支付返回"签名验证失败"

**原因：** 证书不匹配或证书密码错误

**解决方案：**
1. 检查 `AbcPayConfig.java` 中的 `MERCHANT_CERT_PASSWORD`
2. 确认证书文件是否正确（与商户号匹配）
3. 确认证书文件未损坏

### Q5: 网络请求超时

**原因：** 网络连接问题或服务器地址错误

**解决方案：**
1. 检查设备网络连接
2. 确认 `USE_TEST_ENV` 配置正确
3. 测试环境：`pay.test.abchina.com`
4. 生产环境：`pay.abchina.com`

### Q6: JavaScript调用时提示"AndroidBridge未定义"

**原因：** WebView未正确添加JavaScript接口

**解决方案：**
1. 确认 `MainActivity.java` 中有以下代码：
   ```java
   webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");
   ```
2. 确认WebView已启用JavaScript：
   ```java
   settings.setJavaScriptEnabled(true);
   ```

---

## 农行支付返回码说明

| 返回码 | 说明 | 处理建议 |
|--------|------|----------|
| 0000 | 交易成功 | 继续支付流程 |
| 1001 | 交易处理中 | 轮询查询订单状态 |
| 2001 | 商户号不存在 | 检查商户号配置 |
| 2002 | 商户未开通 | 联系农行开通 |
| 3001 | 签名验证失败 | 检查证书配置 |
| 3002 | 证书过期 | 更新证书文件 |
| 4001 | 订单号重复 | 使用新的订单号 |
| 4002 | 订单金额错误 | 检查金额格式 |
| 5001 | 系统错误 | 稍后重试 |
| 9999 | 其他错误 | 查看ErrorMessage |

---

## 技术支持

### 农行技术文档

- 常用网址：`https://pay.test.abchina.com/easyebus/`
- 备用网址：`https://bank.u51.com/ebus-two/docs/#/`

### 代码示例参考

- 原始示例：`综合收银台接口包_V3.3.3软件包/Web/Order/WeiXinOrderRequest.html`
- 原始JSP：`综合收银台接口包_V3.3.3软件包/Web/Order/WeiXinOrderRequest.jsp`

### 日志查看

```bash
# 查看所有支付相关日志
adb logcat | findstr "AbcPay\|WebView"

# 仅查看错误日志
adb logcat *:E | findstr "AbcPay"

# 保存日志到文件
adb logcat > payment_log.txt
```

---

## 版本信息

- **农行SDK版本**: V3.3.3
- **集成日期**: 2026-01-04
- **Android最低版本**: API 21 (Android 5.0)
- **目标版本**: API 34 (Android 14)

---

## 附录

### A. 支付流程图

```
用户点击支付
    ↓
前端调用 AndroidBridge.createWeChatPay()
    ↓
AbcWeChatPayManager 构建请求参数
    ↓
发送HTTP请求到农行服务器
    ↓
农行服务器处理并返回结果
    ↓
前端接收JSON结果
    ↓
解析ReturnCode判断成功/失败
    ↓
成功: 拉起微信APP支付
失败: 显示错误信息
    ↓
支付完成后农行回调通知
    ↓
AbcPayResultActivity接收回调
    ↓
返回支付结果给前端
```

### B. 证书文件说明

#### TrustPay.cer（农行平台证书）
- 用途：验证农行服务器身份
- 获取方式：农行提供
- 更新频率：通常1-3年更新一次

#### merchant.pfx（商户证书）
- 用途：验证商户身份，签名请求
- 获取方式：农行提供
- 包含内容：商户私钥和公钥
- 密码保护：需要证书密码才能使用

### C. 测试卡号

联系农行获取测试用微信账号和测试金额。

---

**文档结束**

如有问题，请查看日志输出或联系技术支持。
