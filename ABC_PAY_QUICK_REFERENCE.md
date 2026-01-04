# 农行微信支付快速参考卡

## ⚠️ 重要提示

**农行支付需要后端服务器中转！**

```
Android → 你的后端服务器 → 农行服务器 → 微信支付
```

详见：`ABC_PAY_ARCHITECTURE.md`

---

## ⚡ 30秒快速开始

### 前端调用代码（2步）

```javascript
// 步骤1: 获取支付参数
var params = AndroidBridge.createWeChatPay(
    'ORDER' + Date.now(),           // 订单号
    '0.01',                          // 金额
    '商品描述',                      // 描述
    'http://yourserver.com/notify',  // 通知URL
    'wx1234567890'                   // 微信APPID
);

// 步骤2: 发送到你的后端服务器
var data = JSON.parse(params);
fetch('https://yourserver.com/api/abc-pay/create-order', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify(data.RequestParams)
})
.then(res => res.json())
.then(result => {
    if (result.ReturnCode === '0000') {
        console.log('支付成功');
    } else {
        console.error('失败: ' + result.ErrorMessage);
    }
});
```

---

## 📝 配置清单

### 必须配置的项目

#### 1. 后端服务器（必须）
```
搭建后端API服务器
部署农行SDK（TrustPayClient-V3.3.3.jar）
配置证书文件和商户号
```

#### 2. Android配置（已完成✅）
```java
// AbcPayConfig.java 已创建
// JSBridge方法已添加
// 参数构建逻辑已实现
```

#### 3. 前端调用（需要修改）
```javascript
// 调用AndroidBridge后
// 将参数发送到你的后端服务器
fetch('https://yourserver.com/api/abc-pay/create-order', ...)
```

---

## 🎯 3种支付方式

### 1. APP支付（最常用）
```javascript
AndroidBridge.createWeChatPay(orderNo, amount, desc, notifyUrl, appId)
```

### 2. 公众号/小程序支付
```javascript
AndroidBridge.createWeChatJsApiPay(orderNo, amount, desc, notifyUrl, openId)
```

### 3. 扫码支付
```javascript
AndroidBridge.createWeChatNativePay(orderNo, amount, desc, notifyUrl)
```

---

## 🔍 快速诊断

### 问题1: "AndroidBridge未定义"
**检查：** MainActivity.java 第XXX行是否有：
```java
webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");
```

### 问题2: "商户号不存在"
**检查：** AbcPayConfig.java 中 `MERCHANT_ID` 是否正确

### 问题3: "证书文件未配置"
**检查：** 
```bash
ls app/src/main/assets/
# 应该看到 TrustPay.cer 和 merchant.pfx
```

### 问题4: 编译失败
**解决：** 
```bash
.\gradlew.bat clean
.\gradlew.bat assembleRelease
```

---

## 📊 返回码速查

| 返回码 | 含义 | 处理 |
|--------|------|------|
| 0000 | 成功 | 继续支付 |
| 1001 | 处理中 | 轮询查询 |
| 2001 | 商户号错误 | 检查配置 |
| 3001 | 签名失败 | 检查证书 |
| 4001 | 订单重复 | 换订单号 |
| 9999 | 其他错误 | 查日志 |

---

## 🛠️ 常用命令

```bash
# 编译APK
.\gradlew.bat assembleRelease

# 安装APK
adb install -r app/build/outputs/apk/release/app-release.apk

# 查看日志
adb logcat | findstr "AbcPay"

# 清理构建
.\gradlew.bat clean
```

---

## 📞 技术支持

- **农行文档**: https://pay.test.abchina.com/easyebus/
- **示例代码**: `综合收银台接口包_V3.3.3软件包/Web/Order/`
- **详细文档**: `ABC_WECHAT_PAY_INTEGRATION.md`

---

## ✅ 集成完成检查清单

- [ ] JAR包已复制到 `app/libs/`（4个文件）
- [ ] 证书已放到 `app/src/main/assets/`（2个文件）
- [ ] `AbcPayConfig.java` 中商户号已配置
- [ ] `AbcPayConfig.java` 中证书密码已配置
- [ ] APK编译成功
- [ ] 前端能调用 `AndroidBridge.createWeChatPay()`
- [ ] 日志中看到 "农行支付配置信息"
- [ ] 支付接口返回正常JSON

全部打勾 = 集成完成！🎉

---

**版本**: V3.3.3 | **日期**: 2026-01-04
