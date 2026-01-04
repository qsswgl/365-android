# 农行综合收银台微信支付集成指南

## 🎯 快速开始

### 30秒了解

本项目已集成**农行综合收银台V3.3.3**的微信支付功能，支持：
- ✅ APP支付
- ✅ 公众号/小程序支付  
- ✅ 扫码支付

前端调用示例：
```javascript
// 发起APP微信支付
var result = AndroidBridge.createWeChatPay(
    'ORDER' + Date.now(),    // 订单号
    '0.01',                  // 金额
    '商品描述',               // 描述
    'http://yourserver.com/notify',  // 通知URL
    'wx1234567890'           // 微信APPID
);
```

---

## 📚 文档导航

| 文档 | 说明 | 适合人群 |
|------|------|----------|
| **ABC_PAY_QUICK_REFERENCE.md** | 快速参考卡 | 所有人 |
| **ABC_PAY_CHECKLIST.md** | 集成检查清单 | 开发者 |
| **ABC_WECHAT_PAY_INTEGRATION.md** | 详细集成文档 | 技术人员 |
| **ABC_PAY_INTEGRATION_SUMMARY.md** | 完成报告 | 项目经理 |

---

## 🚀 立即开始

### 步骤1：配置商户信息（必须）

1. **获取农行商户资料**
   - 联系农行申请商户号
   - 获取证书文件（TrustPay.cer、merchant.pfx）
   - 获取证书密码

2. **修改配置文件**
   
   编辑 `app/src/main/java/net/qsgl365/AbcPayConfig.java`：
   ```java
   // 第73行：改成你的商户号
   public static final String MERCHANT_ID = "你的商户号";
   
   // 第78行：改成你的证书密码
   public static final String MERCHANT_CERT_PASSWORD = "你的密码";
   ```

3. **放置证书文件**
   
   将证书文件复制到 `app/src/main/assets/`：
   ```
   app/src/main/assets/
   ├── TrustPay.cer        # 农行平台证书
   └── merchant.pfx        # 商户证书
   ```

### 步骤2：编译APK

```bash
# Windows PowerShell
cd K:\365-android
.\gradlew.bat assembleRelease
```

### 步骤3：测试支付

1. 安装APK到测试设备
   ```bash
   adb install -r app/build/outputs/apk/release/app-release.apk
   ```

2. 在WebView中打开测试页面
   ```
   file:///android_asset/pwa/abc_pay_test.html
   ```

3. 填写测试数据并点击"发起支付"

---

## 💡 常见问题

### Q: 编译失败怎么办？
A: 查看 [ABC_PAY_CHECKLIST.md](ABC_PAY_CHECKLIST.md) 的"常见问题检查"部分

### Q: 支付返回"商户号不存在"？
A: 检查 `AbcPayConfig.java` 中的商户号配置是否正确

### Q: JavaScript调用时提示"AndroidBridge未定义"？
A: 确认在Android WebView中运行，不是普通浏览器

### Q: 需要哪些证书文件？
A: 需要2个文件（从农行获取）：
- TrustPay.cer - 农行平台证书
- merchant.pfx - 商户证书

---

## 📦 已集成内容

### Java核心类（3个）
- `AbcPayConfig.java` - 配置类
- `AbcWeChatPayManager.java` - 支付管理类
- `AbcPayResultActivity.java` - 回调处理

### JavaScript Bridge API（3个方法）
- `createWeChatPay()` - APP支付
- `createWeChatJsApiPay()` - 公众号/小程序支付
- `createWeChatNativePay()` - 扫码支付

### SDK库（4个JAR包）
- TrustPayClient-V3.3.3.jar
- commons-codec-1.3.jar
- commons-httpclient-3.0.1.jar
- commons-logging.jar

---

## 🔍 调试方法

### 查看支付日志
```bash
adb logcat | findstr "AbcPay\|WebView"
```

期望看到：
```
AbcPayConfig: ========== 农行支付配置信息 ==========
AbcPayConfig: 商户号: 你的商户号
AbcWeChatPayManager: 请求参数构建完成
AbcWeChatPayManager: 农行服务器返回: {...}
```

---

## 📞 技术支持

### 农行官方
- 测试环境：https://pay.test.abchina.com/easyebus/
- 备用地址：https://bank.u51.com/ebus-two/docs/#/

### 本地文档
详见项目根目录下的文档文件：
- `ABC_PAY_QUICK_REFERENCE.md` - 快速参考（推荐先看）
- `ABC_WECHAT_PAY_INTEGRATION.md` - 详细文档
- `ABC_PAY_CHECKLIST.md` - 检查清单

---

## ⚡ 快速参考

### 前端调用示例

```javascript
// 1. APP支付
AndroidBridge.createWeChatPay(orderNo, amount, desc, notifyUrl, appId);

// 2. 公众号支付
AndroidBridge.createWeChatJsApiPay(orderNo, amount, desc, notifyUrl, openId);

// 3. 扫码支付
AndroidBridge.createWeChatNativePay(orderNo, amount, desc, notifyUrl);

// 解析返回结果
var result = JSON.parse(返回值);
if (result.ReturnCode === '0000') {
    // 支付成功
} else {
    // 支付失败
    console.error(result.ErrorMessage);
}
```

### 返回码说明

| 返回码 | 含义 | 处理 |
|--------|------|------|
| 0000 | 成功 | 继续支付流程 |
| 2001 | 商户号错误 | 检查配置 |
| 3001 | 签名失败 | 检查证书 |
| 4001 | 订单重复 | 换新订单号 |

---

## ✅ 集成状态

- [x] 农行SDK集成（4个JAR包）
- [x] 核心类开发（3个Java类）
- [x] JavaScript Bridge API（3个方法）
- [x] 配置文件更新
- [ ] 商户号配置（需要从农行获取）
- [ ] 证书文件放置（需要从农行获取）
- [ ] 功能测试

**当前进度**: 代码集成完成，等待配置商户信息

---

## 📊 项目信息

- **SDK版本**: 农行综合收银台 V3.3.3
- **集成日期**: 2026-01-04
- **支持平台**: Android 5.0+ (API 21+)
- **代码行数**: 约2300行

---

**需要帮助？** 查看 [ABC_PAY_QUICK_REFERENCE.md](ABC_PAY_QUICK_REFERENCE.md)
