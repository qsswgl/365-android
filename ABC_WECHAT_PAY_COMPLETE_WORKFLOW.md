# 🚀 完整工作流程：Console 测试农行微信支付

## 📋 今日目标

✅ 在 Chrome DevTools Console 中  
✅ 通过 JavaScript Bridge  
✅ 测试农行综合收银台  
✅ 调起微信支付

## ⏱️ 预计耗时：5-10 分钟

---

## 🎬 第 1 步：准备环境（2 分钟）

### 1.1 确保应用在运行

```powershell
cd K:\365-android

# 查看设备
.\adb devices

# 启动应用
.\adb shell am start -n net.qsgl365/.MainActivity
```

**预期结果**：
```
Starting: Intent { cmp=net.qsgl365/.MainActivity }
```

### 1.2 打开 Chrome DevTools

1. 打开 Google Chrome 浏览器
2. 输入地址：`chrome://inspect`
3. 找到 "WebView in net.qsgl365"
4. 点击 "inspect" 按钮
5. 在新窗口中找到 **Console** 标签

**应该看到**：
```
DevTools 窗口左侧有应用的 DOM 结构
右侧有 Console 标签（可能显示一些页面日志）
```

---

## 🎬 第 2 步：验证 JavaScript Bridge（1 分钟）

在 Console 中执行以下代码：

```javascript
// 检查 Bridge 是否存在
console.log('AndroidBridge 存在:', typeof AndroidBridge !== 'undefined');

// 检查支付方法是否可用
console.log('createWeChatPay 可用:', typeof AndroidBridge.createWeChatPay === 'function');
console.log('createWeChatJsApiPay 可用:', typeof AndroidBridge.createWeChatJsApiPay === 'function');
console.log('createWeChatNativePay 可用:', typeof AndroidBridge.createWeChatNativePay === 'function');
```

**预期结果**：
```
AndroidBridge 存在: true
createWeChatPay 可用: true
createWeChatJsApiPay 可用: true
createWeChatNativePay 可用: true
```

✅ 如果都是 `true`，继续下一步

❌ 如果有 `false`，刷新页面重试

---

## 🎬 第 3 步：执行第一笔测试支付（1 分钟）

### 3.1 执行 APP 支付测试

在 Console 中复制粘贴以下代码：

```javascript
// ========== 农行 APP 支付测试 ==========
console.log('%c========== 开始 APP 支付测试 ==========', 'color: blue; font-weight: bold; font-size: 14px');

const orderNo = 'TEST_APP_' + Date.now();
const amount = '0.01';
const appId = 'wxb4dcf9e2b3c8e5a1';

console.log('订单参数:', {
  orderNo,
  amount,
  appId
});

// 调用支付接口
const result = AndroidBridge.createWeChatPay(
  orderNo,              // 订单号
  amount,               // 金额（元）
  '【测试】APP支付商品',  // 商品描述
  'https://www.qsgl.net/pay/notify',  // 回调 URL
  appId                 // 微信 APPID
);

console.log('返回结果（原始）:', result);

// 解析 JSON
try {
  const data = JSON.parse(result);
  console.log('%c返回数据（格式化）:', 'color: green; font-weight: bold');
  console.log(JSON.stringify(data, null, 2));
  
  // 检查返回状态
  if (data.ReturnCode === 'Success') {
    console.log('%c✓ 支付请求成功！', 'color: green; font-weight: bold; font-size: 12px');
    console.log('订单 ID:', data.OrderId);
    if (data.PayUrl) {
      console.log('支付 URL:', data.PayUrl);
    }
  } else {
    console.log('%c✗ 支付请求返回错误', 'color: red; font-weight: bold; font-size: 12px');
    console.log('错误代码:', data.ReturnCode);
    if (data.ErrorMessage) {
      console.log('错误信息:', data.ErrorMessage);
    }
  }
} catch (e) {
  console.error('JSON 解析失败:', e.message);
  console.log('原始返回:', result);
}

console.log('%c========== APP 支付测试完成 ==========', 'color: blue; font-weight: bold; font-size: 14px');
```

**执行步骤**：
1. 复制上面的全部代码
2. 粘贴到 Console
3. 按 **Enter**
4. 查看输出结果

**预期结果**：
```
✓ 支付请求成功！
订单 ID: xxx
支付 URL: xxx

或

✗ 支付请求返回错误
错误代码: Error
错误信息: xxx
```

---

## 🎬 第 4 步：同时在 LogCat 中查看详细日志（1 分钟）

在 PowerShell 中执行：

```powershell
# 清空日志
.\adb logcat -c

# 执行支付（在 Console 中再执行一遍上面的代码）

# 等待 2 秒
Start-Sleep -Seconds 2

# 查看支付相关日志
.\adb logcat -d | Select-String "WebView|AbcWeChatPayManager" -Context 1
```

**预期看到的日志**：
```
D WebView: === JavaScript 调用微信支付（APP） ===
D WebView: 订单号: TEST_APP_1234567890
D WebView: 金额: 0.01
D WebView: 描述: 【测试】APP支付商品
D AbcWeChatPayManager: ========== 创建农行微信支付订单 ==========
D AbcWeChatPayManager: 订单号: TEST_APP_1234567890
D AbcWeChatPayManager: 金额: 0.01
D AbcWeChatPayManager: 支付类型: APP
D WebView: 支付订单创建成功，返回结果: {...}
```

✅ 看到这些日志说明支付接口正常工作

---

## 🎬 第 5 步：测试其他支付方式（2 分钟）

### 5.1 测试扫码支付

在 Console 中执行：

```javascript
console.log('%c========== 扫码支付测试 ==========', 'color: orange; font-weight: bold; font-size: 14px');

const nativeResult = AndroidBridge.createWeChatNativePay(
  'TEST_NATIVE_' + Date.now(),
  '0.01',
  '【测试】扫码支付商品',
  'https://www.qsgl.net/pay/notify'
);

console.log('扫码支付结果:', nativeResult);

try {
  const nativeData = JSON.parse(nativeResult);
  if (nativeData.PayUrl) {
    console.log('%c✓ 获得二维码链接:', 'color: green; font-weight: bold');
    console.log(nativeData.PayUrl);
  }
} catch (e) {
  console.error('解析失败:', e.message);
}
```

### 5.2 测试公众号支付

```javascript
console.log('%c========== 公众号支付测试 ==========', 'color: purple; font-weight: bold; font-size: 14px');

const jsApiResult = AndroidBridge.createWeChatJsApiPay(
  'TEST_JSAPI_' + Date.now(),
  '0.01',
  '【测试】公众号支付商品',
  'https://www.qsgl.net/pay/notify',
  'o_test_openid_example_123456'  // 示例 OpenID，需替换为实际值
);

console.log('公众号支付结果:', jsApiResult);

try {
  const jsApiData = JSON.parse(jsApiResult);
  console.log('返回数据:', JSON.stringify(jsApiData, null, 2));
} catch (e) {
  console.error('解析失败:', e.message);
}
```

---

## 🎬 第 6 步：验证和分析结果（2 分钟）

### 6.1 在 Console 中检查返回的数据结构

```javascript
// 获取最后一次支付的结果
const lastResult = AndroidBridge.createWeChatPay(
  'VERIFY_' + Date.now(),
  '0.01',
  '验证测试',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

// 解析并显示完整结构
const data = JSON.parse(lastResult);
console.log('==== 返回数据结构 ====');
Object.keys(data).forEach(key => {
  console.log(`${key}: ${data[key]}`);
});
```

### 6.2 在 Network 标签中查看 HTTP 请求

1. 在 DevTools 中打开 **Network** 标签
2. 在 Console 中执行支付代码
3. 查看 Network 标签中是否有新的请求
4. 检查请求状态和响应数据

**应该看到**：
```
请求 URL: 农行服务器地址
状态码: 200 或 其他成功状态
响应: JSON 格式的支付结果
```

---

## ✅ 完整测试清单

执行完以上所有步骤后，检查以下项目：

- [ ] **环境准备**
  - [ ] 应用已启动
  - [ ] Chrome DevTools 已打开
  - [ ] Console 标签可见

- [ ] **Bridge 验证**
  - [ ] AndroidBridge 存在
  - [ ] createWeChatPay 方法可用
  - [ ] createWeChatJsApiPay 方法可用
  - [ ] createWeChatNativePay 方法可用

- [ ] **APP 支付测试**
  - [ ] 支付请求已发送
  - [ ] 返回了 JSON 数据
  - [ ] ReturnCode 字段存在
  - [ ] LogCat 有相应日志

- [ ] **扫码支付测试**
  - [ ] 支付请求已发送
  - [ ] 返回了二维码链接
  - [ ] PayUrl 字段有效

- [ ] **公众号支付测试**
  - [ ] 支付请求已发送
  - [ ] 返回了有效数据

- [ ] **日志验证**
  - [ ] LogCat 显示 "支付订单创建成功"
  - [ ] 没有异常错误
  - [ ] 所有参数正确记录

---

## 🎯 预期的完整输出

### Console 输出示例

```
========== 开始 APP 支付测试 ==========

订单参数: {
  orderNo: 'TEST_APP_1704556432100',
  amount: '0.01',
  appId: 'wxb4dcf9e2b3c8e5a1'
}

返回结果（原始）: {"ReturnCode":"Success","OrderId":"2024010612345678","PayUrl":"https://..."}

返回数据（格式化）:
{
  "ReturnCode": "Success",
  "OrderId": "2024010612345678",
  "PayUrl": "https://...",
  ...
}

✓ 支付请求成功！
订单 ID: 2024010612345678
支付 URL: https://...

========== APP 支付测试完成 ==========
```

### LogCat 输出示例

```
D/WebView: === JavaScript 调用微信支付（APP） ===
D/WebView: 订单号: TEST_APP_1704556432100
D/WebView: 金额: 0.01
D/WebView: 描述: 【测试】APP支付商品
D/AbcWeChatPayManager: ========== 创建农行微信支付订单 ==========
D/AbcWeChatPayManager: 订单号: TEST_APP_1704556432100
D/AbcWeChatPayManager: 金额: 0.01
D/AbcWeChatPayManager: 支付类型: APP
D/WebView: 支付订单创建成功，返回结果: {"ReturnCode":"Success",...}
```

---

## 🔧 遇到问题时

### 问题 1：返回 undefined

```javascript
// 检查
typeof AndroidBridge  // 应该是 "object"

// 解决方案
location.reload();  // 刷新页面重新加载
```

### 问题 2：返回 null

```javascript
// 检查日志
.\adb logcat -d | Select-String "Exception|Error"

// 查看详细错误
.\adb logcat -d | Select-String "AbcWeChatPayManager"
```

### 问题 3：返回错误代码

```javascript
// 查看完整错误信息
const result = AndroidBridge.createWeChatPay(...);
const data = JSON.parse(result);
console.log('完整错误信息:', data);

// 检查参数是否正确
console.log('订单号是否为空:', orderNo === '');
console.log('金额是否为 0:', amount === '0' || amount === 0);
console.log('APPID 是否正确:', appId.length > 0);
```

---

## 📊 测试数据参考

### 测试金额

推荐使用以下金额进行测试：
- `0.01` - 最小测试金额
- `0.10` - 十分金额
- `1.00` - 整数金额
- `99.99` - 较大金额

### 测试订单号

建议订单号格式：
```
TEST_APP_[timestamp]        // APP 支付
TEST_JSAPI_[timestamp]      // 公众号支付
TEST_NATIVE_[timestamp]     // 扫码支付
TEST_[功能]_[timestamp]     // 其他测试
```

### 微信配置

使用以下示例配置进行测试：
```
APPID: wxb4dcf9e2b3c8e5a1      // 示例微信 APPID
OpenID: o_test_openid_example  // 示例 OpenID
NotifyURL: https://www.qsgl.net/pay/notify
```

---

## ✨ 完成标志

当您看到以下情况时，说明测试已完全成功：

✅ **Console 中**：
- 显示 "✓ 支付请求成功！"
- 返回了有效的 JSON 数据
- 包含 OrderId 和 PayUrl

✅ **LogCat 中**：
- 显示 "支付订单创建成功"
- 没有红色的 Exception 或 Error

✅ **Network 标签中**：
- 请求状态码为 200
- 响应包含正确的支付数据

✅ **功能验证**：
- 三种支付方式都能调用
- 所有返回数据都有效

---

## 🚀 下一步

完成上述测试后，您已经验证了：
1. ✅ JavaScript Bridge 工作正常
2. ✅ 农行支付接口可以调用
3. ✅ 支付数据能正确返回
4. ✅ 日志记录完整

现在您可以：
- 👉 **继续深入测试**：修改参数，测试不同场景
- 👉 **集成到前端**：将支付逻辑集成到页面
- 👉 **生产验证**：使用真实支付数据进行测试
- 👉 **错误处理**：添加完整的错误处理逻辑

---

**现在开始测试吧！** 🎉

