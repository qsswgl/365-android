# 🚀 农行支付集成 - 快速参考卡

## 📱 立即开始（3 步搞定）

```bash
# 1️⃣ 安装
adb install -r app\build\outputs\apk\release\app-release.apk

# 2️⃣ 启动
adb shell am start -n net.qsgl365/.MainActivity

# 3️⃣ 测试
# 在应用 WebView 中执行：
window.createWeChatPay({orderNo:'TEST001',orderAmount:'0.01',orderDesc:'测试'})
```

---

## 🔑 关键信息

| 信息 | 值 |
|------|-----|
| **商户号** | 103881636900016 |
| **证书密码** | ay365365 |
| **环境** | 测试 (pay.test.abchina.com) |
| **SHA1** | 890515e6ec356bb9156916c9facea108192e3748 |
| **MD5** | 6c43d323ce2e7f35ae5d28551627b414 |
| **APK** | app-release.apk (29.56 MB) |

---

## 💳 支付方式

```javascript
// ①②③ 选择一种方式调用

①  window.createWeChatPay({orderNo:'',orderAmount:'0.01',orderDesc:''})
②  window.createWeChatJsApiPay({orderNo:'',orderAmount:'0.01',orderDesc:''})
③  window.createWeChatNativePay({orderNo:'',orderAmount:'0.01',orderDesc:''})
```

---

## 🔍 调试

```bash
# 查看日志
adb logcat | findstr AbcPay

# 期望看到
AbcPayConfig: 商户号: 103881636900016
AbcWeChatPayManager: 农行服务器返回...
```

---

## 📋 文件位置

| 文件 | 路径 |
|------|------|
| 配置类 | app/src/main/java/.../AbcPayConfig.java |
| 商户证 | app/src/main/assets/merchant.pfx |
| 平台证 | app/src/main/assets/TrustPay.cer |
| Release APK | app/build/outputs/apk/release/app-release.apk |
| Debug APK | app/build/outputs/apk/debug/app-debug.apk |

---

## ⚙️ 生产环境（上线前）

```java
// 修改 AbcPayConfig.java
USE_TEST_ENV = false;                    // 切换生产
MERCHANT_ID = "生产商户号";               // 更新商户号
MERCHANT_CERT_PASSWORD = "生产密码";      // 更新密码
// 替换 TrustPay.cer 为生产版本
```

---

## ✅ 配置清单

- ✅ 商户号已配置
- ✅ 证书已部署
- ✅ APK 已编译
- ✅ 可直接安装测试

---

**完成度：100% | 状态：就绪 | 日期：2026.01.05**
