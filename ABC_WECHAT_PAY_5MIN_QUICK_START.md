# ⚡ 农行微信支付 Console 测试 - 5 分钟快速指南

## 🎯 你要做什么？

在 Chrome DevTools Console 中，通过 JavaScript Bridge，测试农行综合收银台的微信支付功能。

## ⏱️ 耗时：5 分钟

---

## 📋 前置条件

✅ Chrome DevTools 已打开（点击 inspect）  
✅ Console 标签可见  
✅ 应用已在设备上运行  

---

## 🚀 3 个步骤

### ▶️ 步骤 1: 验证 Bridge

在 Console 中粘贴：
```javascript
console.log(typeof AndroidBridge.createWeChatPay === 'function');
```

**应该返回**: `true` ✅

---

### ▶️ 步骤 2: 执行支付测试

在 Console 中粘贴：
```javascript
const result = AndroidBridge.createWeChatPay(
  'TEST_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

console.log('结果:', JSON.parse(result));
```

**应该返回**: JSON 对象，包含 `ReturnCode` 和 `OrderId` ✅

---

### ▶️ 步骤 3: 查看日志

在 PowerShell 中：
```powershell
.\adb logcat -d | Select-String "WebView|支付"
```

**应该看到**: 支付订单创建的日志 ✅

---

## 🎯 三种支付方式对比表

| 方式 | 方法名 | 用途 | 使用场景 |
|------|-------|------|---------|
| **APP** | `createWeChatPay` | 应用内支付 | 最常用 |
| **公众号** | `createWeChatJsApiPay` | 公众号支付 | 需要 OpenID |
| **扫码** | `createWeChatNativePay` | 生成二维码 | 返回二维码链接 |

---

## 📝 完整的一键测试代码

复制整个代码块，粘贴到 Console 并执行：

```javascript
// ========== 农行微信支付一键测试 ==========

console.log('%c========== 开始测试 ==========', 'color: blue; font-size: 14px; font-weight: bold');

// 测试 APP 支付
console.log('%c[1] APP 支付', 'color: green; font-weight: bold');
const appResult = AndroidBridge.createWeChatPay(
  'TEST_APP_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);
console.log(JSON.parse(appResult));

// 测试扫码支付
console.log('%c[2] 扫码支付', 'color: green; font-weight: bold');
const nativeResult = AndroidBridge.createWeChatNativePay(
  'TEST_NATIVE_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify'
);
console.log(JSON.parse(nativeResult));

// 测试公众号支付
console.log('%c[3] 公众号支付', 'color: green; font-weight: bold');
const jsApiResult = AndroidBridge.createWeChatJsApiPay(
  'TEST_JSAPI_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'o_test_openid'
);
console.log(JSON.parse(jsApiResult));

console.log('%c========== 测试完成 ==========', 'color: blue; font-size: 14px; font-weight: bold');
```

---

## 🔍 快速检查清单

- [ ] Bridge 返回 `true`
- [ ] 支付返回 JSON 数据
- [ ] 数据包含 `ReturnCode` 字段
- [ ] LogCat 显示支付日志
- [ ] 没有红色错误

---

## ❓ 常见问题

### 返回 undefined？
```javascript
location.reload();  // 刷新页面
```

### 返回错误？
```powershell
.\adb logcat -d | Select-String "Error|Exception"  # 查看错误
```

### 想看详细日志？
```powershell
.\adb logcat | Select-String "WebView"  # 实时查看
```

---

## 📚 详细文档

需要更多细节？查看这些文件：

- **ABC_WECHAT_PAY_QUICK_REFERENCE.md** - 快速参考卡（推荐）
- **ABC_WECHAT_PAY_CONSOLE_TEST.md** - 完整测试指南
- **ABC_WECHAT_PAY_COMPLETE_WORKFLOW.md** - 详细工作流程

---

## ✨ 就这么简单！

**5 分钟内您就能**：
✅ 验证支付接口  
✅ 调起微信支付  
✅ 获取支付结果  
✅ 查看完整日志  

现在就开始吧！ 🚀

