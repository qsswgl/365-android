# 🎯 Console 测试指南：通过 JavaScript Bridge 调起农行微信支付

## 📋 概述

本指南教您如何在 Chrome DevTools Console 中直接测试农行综合收银台的微信支付功能，无需修改前端代码。

## ✅ 前置条件

- ✅ Chrome DevTools 已打开（chrome://inspect）
- ✅ 应用已运行在设备上
- ✅ WebView 调试已启用（已验证）
- ✅ JavaScript Bridge 已注册

## 🚀 快速开始：3 种支付方式

### 方式 1️⃣: APP 支付（推荐测试）

**应用场景**: 在应用内直接调起微信 APP 支付

**Console 代码**:
```javascript
// APP 支付 - 最常用的支付方式
const result = AndroidBridge.createWeChatPay(
  'TEST_ORDER_' + Date.now(),           // 订单号（必须唯一）
  '0.01',                                // 金额（元，推荐用小金额测试）
  '测试商品',                             // 订单描述
  'https://www.qsgl.net/pay/notify',    // 支付结果通知URL
  'wxb4dcf9e2b3c8e5a1'                  // 微信 APPID（请替换为实际 APPID）
);

console.log('APP 支付结果:', result);
console.log('返回数据类型:', typeof result);
```

**执行步骤**:
1. 打开 Chrome DevTools 的 **Console** 标签
2. 复制上面的代码
3. 粘贴到 Console 并按 **Enter**
4. 查看返回结果

**预期结果**:
```json
{
  "ReturnCode": "Success",
  "OrderId": "xxx",
  "PayUrl": "xxx",
  // 其他农行返回的参数
}
```

---

### 方式 2️⃣: 公众号/小程序支付

**应用场景**: 在微信公众号或小程序中进行支付

**Console 代码**:
```javascript
// 公众号支付 - 需要用户的微信 OpenID
const openId = 'o_example_openid_123456789';  // 替换为实际的微信 OpenID

const result = AndroidBridge.createWeChatJsApiPay(
  'TEST_JSAPI_' + Date.now(),            // 订单号
  '0.01',                                 // 金额（元）
  '公众号测试商品',                       // 订单描述
  'https://www.qsgl.net/pay/notify',    // 通知URL
  openId                                  // 用户 OpenID
);

console.log('公众号支付结果:', result);
```

**需要的信息**:
- 微信 OpenID（用户在公众号的唯一标识）
- 获取方式：在微信公众号授权登录后获得

---

### 方式 3️⃣: 扫码支付

**应用场景**: 生成二维码，用户扫码支付

**Console 代码**:
```javascript
// 扫码支付 - 返回二维码链接
const result = AndroidBridge.createWeChatNativePay(
  'TEST_NATIVE_' + Date.now(),           // 订单号
  '0.01',                                 // 金额（元）
  '扫码测试商品',                         // 订单描述
  'https://www.qsgl.net/pay/notify'     // 通知URL
);

console.log('扫码支付结果:', result);
console.log('扫码支付返回的数据:', JSON.parse(result));
```

**预期结果**:
- 返回包含二维码链接的 JSON
- 可以用二维码生成工具生成二维码
- 用户扫码后自动跳转支付页面

---

## 📊 完整的测试脚本

### 一键测试所有三种支付方式

将以下代码复制到 Console 执行：

```javascript
// ========== 农行微信支付测试脚本 ==========

console.log('%c========== 开始测试农行微信支付 ==========', 'color: blue; font-size: 14px; font-weight: bold');

// 生成测试订单号
const timestamp = Date.now();
const appPayOrderNo = 'APP_TEST_' + timestamp;
const jsapiPayOrderNo = 'JSAPI_TEST_' + timestamp;
const nativePayOrderNo = 'NATIVE_TEST_' + timestamp;

console.log('测试订单号:', {
  appPayOrderNo,
  jsapiPayOrderNo,
  nativePayOrderNo
});

// ========== 测试 1: APP 支付 ==========
console.log('%c测试 1: APP 支付', 'color: green; font-weight: bold');
try {
  const appPayResult = AndroidBridge.createWeChatPay(
    appPayOrderNo,
    '0.01',
    '【测试】APP支付商品',
    'https://www.qsgl.net/pay/notify',
    'wxb4dcf9e2b3c8e5a1'
  );
  
  console.log('APP 支付请求已发送');
  console.log('返回结果:', appPayResult);
  
  try {
    const appPayData = JSON.parse(appPayResult);
    console.log('返回数据（JSON 格式）:', appPayData);
    console.log('返回代码:', appPayData.ReturnCode);
  } catch (e) {
    console.log('返回结果不是 JSON 格式，原始内容:', appPayResult);
  }
} catch (error) {
  console.error('APP 支付失败:', error.message);
}

console.log('---');

// ========== 测试 2: 公众号支付 ==========
console.log('%c测试 2: 公众号支付', 'color: green; font-weight: bold');
try {
  const jsapiPayResult = AndroidBridge.createWeChatJsApiPay(
    jsapiPayOrderNo,
    '0.01',
    '【测试】公众号支付商品',
    'https://www.qsgl.net/pay/notify',
    'o_test_openid_example_123456'  // 示例 OpenID，需替换为实际值
  );
  
  console.log('公众号支付请求已发送');
  console.log('返回结果:', jsapiPayResult);
  
  try {
    const jsapiPayData = JSON.parse(jsapiPayResult);
    console.log('返回数据（JSON 格式）:', jsapiPayData);
  } catch (e) {
    console.log('返回结果不是 JSON 格式');
  }
} catch (error) {
  console.error('公众号支付失败:', error.message);
}

console.log('---');

// ========== 测试 3: 扫码支付 ==========
console.log('%c测试 3: 扫码支付', 'color: green; font-weight: bold');
try {
  const nativePayResult = AndroidBridge.createWeChatNativePay(
    nativePayOrderNo,
    '0.01',
    '【测试】扫码支付商品',
    'https://www.qsgl.net/pay/notify'
  );
  
  console.log('扫码支付请求已发送');
  console.log('返回结果:', nativePayResult);
  
  try {
    const nativePayData = JSON.parse(nativePayResult);
    console.log('返回数据（JSON 格式）:', nativePayData);
    if (nativePayData.PayUrl) {
      console.log('✓ 二维码链接:', nativePayData.PayUrl);
    }
  } catch (e) {
    console.log('返回结果不是 JSON 格式');
  }
} catch (error) {
  console.error('扫码支付失败:', error.message);
}

console.log('%c========== 测试完成 ==========', 'color: blue; font-size: 14px; font-weight: bold');
console.log('请查看 LogCat 日志了解详细信息');
```

---

## 📖 参数详细说明

### createWeChatPay (APP 支付)

| 参数 | 类型 | 说明 | 示例 |
|------|------|------|------|
| orderNo | String | 订单号（必须唯一）| `TEST_ORDER_${Date.now()}` |
| amount | String | 金额（元为单位）| `"0.01"` 或 `"99.99"` |
| orderDesc | String | 订单描述 | `"测试商品"` |
| notifyUrl | String | 支付结果通知 URL | `"https://...pay/notify"` |
| appId | String | 微信应用 ID | `"wxb4dcf9e2b3c8e5a1"` |

### createWeChatJsApiPay (公众号支付)

| 参数 | 类型 | 说明 | 示例 |
|------|------|------|------|
| orderNo | String | 订单号 | `TEST_JSAPI_${Date.now()}` |
| amount | String | 金额 | `"0.01"` |
| orderDesc | String | 订单描述 | `"公众号商品"` |
| notifyUrl | String | 通知 URL | `"https://...pay/notify"` |
| openId | String | 用户 OpenID | `"o_abc123xyz..."` |

### createWeChatNativePay (扫码支付)

| 参数 | 类型 | 说明 | 示例 |
|------|------|------|------|
| orderNo | String | 订单号 | `TEST_NATIVE_${Date.now()}` |
| amount | String | 金额 | `"0.01"` |
| orderDesc | String | 订单描述 | `"扫码商品"` |
| notifyUrl | String | 通知 URL | `"https://...pay/notify"` |

---

## 🔍 查看详细日志

### 在 Chrome Console 中

执行支付测试后，在 Console 中查看返回结果和错误信息。

### 在 LogCat 中

同时查看设备日志了解更详细的执行过程：

```powershell
# 实时查看日志
.\adb logcat -d | Select-String "WebView|AbcWeChat|支付" -Context 2
```

**期望看到的日志**:
```
D WebView: === JavaScript 调用微信支付（APP） ===
D WebView: 订单号: TEST_ORDER_1234567890
D WebView: 金额: 0.01
D AbcWeChatPayManager: ========== 创建农行微信支付订单 ==========
D AbcWeChatPayManager: 订单号: TEST_ORDER_1234567890
D AbcWeChatPayManager: 金额: 0.01
D AbcWeChatPayManager: 支付类型: APP
D WebView: 支付订单创建成功，返回结果: {...}
```

---

## 🎯 测试场景

### 场景 1: 验证支付接口是否正常

```javascript
// 最简单的测试
const result = AndroidBridge.createWeChatPay(
  'TEST_' + Date.now(),
  '0.01',
  'Test',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

// 检查返回
console.log(typeof result === 'string' ? '✓ 返回了字符串' : '✗ 返回数据类型错误');
console.log(result.includes('ReturnCode') ? '✓ 返回了有效的 JSON' : '✗ 返回数据格式错误');
```

### 场景 2: 测试不同金额

```javascript
const amounts = ['0.01', '0.10', '1.00', '99.99'];

amounts.forEach(amount => {
  const result = AndroidBridge.createWeChatPay(
    'TEST_' + amount.replace('.', '_') + '_' + Date.now(),
    amount,
    'Amount Test: ' + amount,
    'https://www.qsgl.net/pay/notify',
    'wxb4dcf9e2b3c8e5a1'
  );
  
  console.log(`金额 ${amount}: ${result.substring(0, 50)}...`);
});
```

### 场景 3: 批量测试订单

```javascript
// 创建 5 个不同的支付订单
for (let i = 1; i <= 5; i++) {
  const orderNo = 'TEST_BATCH_' + i + '_' + Date.now();
  
  const result = AndroidBridge.createWeChatPay(
    orderNo,
    '0.01',
    '批量测试订单 ' + i,
    'https://www.qsgl.net/pay/notify',
    'wxb4dcf9e2b3c8e5a1'
  );
  
  console.log(`订单 ${i}:`, result.includes('Success') ? '✓ 成功' : '✗ 失败');
}
```

---

## 💡 常见问题和解决方案

### Q1: 返回 "undefined"

**问题**: Console 显示 undefined

**原因**: JavaScript Bridge 可能没有正确注册

**解决**:
```javascript
// 检查 Bridge 是否存在
console.log('AndroidBridge 是否存在:', typeof AndroidBridge !== 'undefined');

// 检查方法是否存在
console.log('createWeChatPay 方法:', typeof AndroidBridge.createWeChatPay);

// 如果都不存在，尝试刷新页面
location.reload();
```

### Q2: 返回错误信息

**问题**: 返回 `{"ReturnCode":"Error","ErrorMessage":"..."}`

**解决**:
1. 检查参数是否正确
2. 查看 LogCat 日志获取详细错误
3. 验证农行配置是否正确

### Q3: 返回 "success" 但金额为 0

**问题**: 支付成功但金额显示为 0

**解决**:
```javascript
// 确保金额是字符串格式
const amount = '0.01';  // ✓ 正确
// const amount = 0.01;  // ✗ 错误，应该是字符串
```

### Q4: 返回 null

**问题**: 返回 null

**解决**:
```javascript
// 检查是否有 Java 异常
// 查看 LogCat: 
// .\adb logcat -d | Select-String "Exception|Error"

// 检查方法调用是否正确
const result = AndroidBridge.createWeChatPay(
  'ORDER',      // 不能为空
  '0.01',       // 不能为空或 0
  'DESC',       // 不能为空
  'https://...', // 必须是有效 URL
  'APPID'       // 不能为空
);
```

---

## 🔐 实际使用建议

### 使用真实数据测试

```javascript
// 使用真实的微信 APPID 和 OpenID
const realAppId = 'wx8888888888888888';  // 您的真实微信 APPID
const realOpenId = 'o_user_real_openid'; // 真实用户 OpenID
const realNotifyUrl = 'https://www.qsgl.net/api/pay/notify'; // 实际的服务器回调地址

const result = AndroidBridge.createWeChatPay(
  'ORDER_' + new Date().getTime(),
  '0.01',
  '真实测试商品',
  realNotifyUrl,
  realAppId
);
```

### 测试错误处理

```javascript
// 测试各种错误情况
const testCases = [
  { orderNo: '', amount: '0.01', desc: 'Empty orderNo' },
  { orderNo: 'TEST', amount: '0', desc: 'Zero amount' },
  { orderNo: 'TEST', amount: '', desc: 'Empty amount' },
  { orderNo: 'TEST', amount: '0.01', desc: '', appId: 'empty desc' }
];

testCases.forEach(test => {
  try {
    const result = AndroidBridge.createWeChatPay(
      test.orderNo,
      test.amount,
      test.desc,
      'https://www.qsgl.net/pay/notify',
      'wxb4dcf9e2b3c8e5a1'
    );
    console.log(test.desc + ': ' + (result.includes('Error') ? '✓ 返回错误' : '✗ 未返回错误'));
  } catch (e) {
    console.log(test.desc + ': ✓ 抛出异常 - ' + e.message);
  }
});
```

---

## 📱 完整的工作流程

### 步骤 1: 打开 Chrome DevTools

```
1. 在 Chrome 中打开: chrome://inspect
2. 点击您应用的 "inspect" 按钮
3. 在打开的 DevTools 中选择 "Console" 标签
```

### 步骤 2: 验证 JavaScript Bridge

```javascript
// 验证接口是否可用
console.log('✓ Bridge 初始化完成:', 
  typeof AndroidBridge !== 'undefined' && 
  typeof AndroidBridge.createWeChatPay === 'function'
);
```

### 步骤 3: 执行支付测试

```javascript
// 复制前面的完整测试脚本并执行
```

### 步骤 4: 查看结果

```javascript
// 在 Console 中查看返回的 JSON
// 同时在 LogCat 中查看应用日志
```

### 步骤 5: 分析数据

```javascript
// 解析返回的 JSON
const response = '{"ReturnCode":"Success",...}';
const data = JSON.parse(response);
console.log('支付状态:', data.ReturnCode);
console.log('订单 ID:', data.OrderId);
console.log('支付 URL:', data.PayUrl);
```

---

## 🚀 下一步

1. ✅ 验证支付接口工作正常
2. ✅ 测试各种金额和场景
3. ✅ 检查 LogCat 日志确保没有错误
4. ✅ 准备用真实数据进行完整支付流程测试
5. ✅ 集成到前端代码中实现完整功能

---

**现在您可以在 Console 中直接测试农行微信支付了！** 🎉

