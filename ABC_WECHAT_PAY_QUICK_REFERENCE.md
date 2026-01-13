# ⚡ 快速参考卡：Console 支付测试代码

## 🎯 一键复制粘贴到 Console

### 最简单的测试（3 秒完成）

复制整个代码块到 Console 并执行：

```javascript
const r = AndroidBridge.createWeChatPay('TEST_' + Date.now(), '0.01', '测试', 'https://www.qsgl.net/pay/notify', 'wxb4dcf9e2b3c8e5a1');
console.log('支付结果:', r);
```

---

## 📊 三种支付方式对比

### 🔵 APP 支付（最常用）

```javascript
// 适用场景：应用内支付
AndroidBridge.createWeChatPay(
  'ORDER_' + Date.now(),                         // 订单号
  '0.01',                                         // 金额
  '商品名称',                                      // 描述
  'https://www.qsgl.net/pay/notify',            // 回调 URL
  'wxb4dcf9e2b3c8e5a1'                          // 微信 APPID
);
```

**在 Console 中的完整执行**：
```javascript
const result = AndroidBridge.createWeChatPay(
  'ORDER_' + Date.now(),
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);
console.log('APP 支付结果:', result);
```

---

### 🟢 公众号支付

```javascript
// 适用场景：公众号/小程序支付
// 需要用户的 OpenID
AndroidBridge.createWeChatJsApiPay(
  'ORDER_' + Date.now(),
  '0.01',
  '商品',
  'https://www.qsgl.net/pay/notify',
  'o_user_openid_example'  // 替换为实际 OpenID
);
```

**在 Console 中的完整执行**：
```javascript
const result = AndroidBridge.createWeChatJsApiPay(
  'ORDER_' + Date.now(),
  '0.01',
  '公众号商品',
  'https://www.qsgl.net/pay/notify',
  'o_test_openid_12345'  // 示例 OpenID
);
console.log('公众号支付结果:', result);
```

---

### 🟡 扫码支付

```javascript
// 适用场景：生成二维码供用户扫码支付
AndroidBridge.createWeChatNativePay(
  'ORDER_' + Date.now(),
  '0.01',
  '商品',
  'https://www.qsgl.net/pay/notify'
);
```

**在 Console 中的完整执行**：
```javascript
const result = AndroidBridge.createWeChatNativePay(
  'ORDER_' + Date.now(),
  '0.01',
  '扫码商品',
  'https://www.qsgl.net/pay/notify'
);
console.log('扫码支付结果:', result);
console.log('二维码链接:', JSON.parse(result).PayUrl);
```

---

## 🔧 常用测试代码片段

### 测试代码片段 1：验证 Bridge 是否可用

```javascript
console.log('Bridge 可用:', typeof AndroidBridge !== 'undefined');
console.log('支付方法可用:', typeof AndroidBridge.createWeChatPay === 'function');
```

### 测试代码片段 2：测试单笔支付并查看详细结果

```javascript
const orderNo = 'TEST_' + Date.now();
const result = AndroidBridge.createWeChatPay(
  orderNo,
  '0.01',
  '测试商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

// 解析结果
const data = JSON.parse(result);
console.log('==== 支付返回结果 ====');
console.log('订单号:', orderNo);
console.log('返回代码:', data.ReturnCode);
console.log('完整结果:', JSON.stringify(data, null, 2));
```

### 测试代码片段 3：批量测试多笔支付

```javascript
['0.01', '0.10', '1.00', '10.00'].forEach(amount => {
  const result = AndroidBridge.createWeChatPay(
    'TEST_' + amount.replace('.', '_') + '_' + Date.now(),
    amount,
    '金额: ' + amount,
    'https://www.qsgl.net/pay/notify',
    'wxb4dcf9e2b3c8e5a1'
  );
  console.log(`金额 ${amount}:`, result.includes('Success') ? '✓' : '✗');
});
```

### 测试代码片段 4：监听支付结果

```javascript
// 测试支付并继续监控
const result = AndroidBridge.createWeChatPay(
  'ORDER_' + Date.now(),
  '0.01',
  '监控测试',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);

// 解析返回
try {
  const payData = JSON.parse(result);
  
  if (payData.ReturnCode === 'Success') {
    console.log('%c✓ 支付请求成功！', 'color: green; font-weight: bold');
    console.log('订单 ID:', payData.OrderId);
    console.log('支付 URL:', payData.PayUrl);
  } else {
    console.log('%c✗ 支付请求失败', 'color: red; font-weight: bold');
    console.log('错误代码:', payData.ReturnCode);
    console.log('错误信息:', payData.ErrorMessage);
  }
} catch (e) {
  console.error('结果解析失败:', e.message);
}
```

### 测试代码片段 5：获取并显示所有支付参数

```javascript
// 测试当前环境的支付参数
const testParams = {
  orderNo: 'CONSOLE_TEST_' + Date.now(),
  amount: '0.01',
  desc: '控制台测试商品',
  notifyUrl: 'https://www.qsgl.net/pay/notify',
  appId: 'wxb4dcf9e2b3c8e5a1'
};

console.log('==== 支付参数 ====');
console.log(JSON.stringify(testParams, null, 2));

console.log('\n==== 执行支付 ====');
const result = AndroidBridge.createWeChatPay(
  testParams.orderNo,
  testParams.amount,
  testParams.desc,
  testParams.notifyUrl,
  testParams.appId
);

console.log('\n==== 支付返回结果 ====');
console.log(result);
```

---

## 📋 测试清单

执行完整测试时按以下步骤进行：

- [ ] **第 1 步**：验证 Bridge 是否可用
  ```javascript
  console.log(typeof AndroidBridge !== 'undefined');
  ```

- [ ] **第 2 步**：执行 APP 支付测试
  ```javascript
  AndroidBridge.createWeChatPay('TEST_' + Date.now(), '0.01', '测试', 'https://www.qsgl.net/pay/notify', 'wxb4dcf9e2b3c8e5a1');
  ```

- [ ] **第 3 步**：检查返回结果
  ```javascript
  // 应该返回 JSON 字符串，包含 ReturnCode 字段
  ```

- [ ] **第 4 步**：在 LogCat 中查看应用日志
  ```powershell
  .\adb logcat -d | Select-String "WebView|AbcWeChatPayManager"
  ```

- [ ] **第 5 步**：测试其他支付方式
  ```javascript
  AndroidBridge.createWeChatJsApiPay(...);
  AndroidBridge.createWeChatNativePay(...);
  ```

---

## 🎯 故障排查快速命令

### 问题：返回 undefined

```javascript
// 检查 Bridge
typeof AndroidBridge  // 应该返回 "object"
typeof AndroidBridge.createWeChatPay  // 应该返回 "function"
```

### 问题：返回错误 JSON

```javascript
// 查看完整错误
const result = AndroidBridge.createWeChatPay('TEST', '0.01', 'Test', 'https://...', 'id');
const data = JSON.parse(result);
console.log('错误代码:', data.ReturnCode);
console.log('错误信息:', data.ErrorMessage);
```

### 问题：没有看到日志

```powershell
# 检查完整日志
.\adb logcat -d | Select-String "WebView|支付|Payment"

# 实时查看日志
.\adb logcat | Select-String "WebView"
```

---

## 💎 高级用法

### 动态生成多个订单号

```javascript
// 生成唯一订单号的函数
function generateOrderNo(prefix = 'ORDER') {
  return prefix + '_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

// 使用
const orderNo = generateOrderNo('TEST_PAY');
console.log('生成的订单号:', orderNo);

// 执行支付
const result = AndroidBridge.createWeChatPay(
  orderNo,
  '0.01',
  '商品',
  'https://www.qsgl.net/pay/notify',
  'wxb4dcf9e2b3c8e5a1'
);
```

### 创建可重用的支付函数

```javascript
// 定义支付函数
function testPay(amount, type = 'app') {
  const orderNo = 'TEST_' + Date.now();
  
  console.log(`创建${type}支付订单: ${orderNo}, 金额: ${amount}元`);
  
  if (type === 'app') {
    return AndroidBridge.createWeChatPay(
      orderNo, amount, '测试', 'https://www.qsgl.net/pay/notify', 'wxb4dcf9e2b3c8e5a1'
    );
  } else if (type === 'native') {
    return AndroidBridge.createWeChatNativePay(
      orderNo, amount, '测试', 'https://www.qsgl.net/pay/notify'
    );
  }
}

// 使用
const result = testPay('0.01', 'app');
console.log('支付结果:', result);
```

### 自动化测试脚本

```javascript
// 自动测试脚本
async function runAutomatedTests() {
  const results = [];
  const amounts = ['0.01', '0.10', '1.00'];
  
  for (const amount of amounts) {
    try {
      const result = AndroidBridge.createWeChatPay(
        'AUTO_TEST_' + amount.replace('.', '_') + '_' + Date.now(),
        amount,
        '自动测试金额: ' + amount,
        'https://www.qsgl.net/pay/notify',
        'wxb4dcf9e2b3c8e5a1'
      );
      
      const data = JSON.parse(result);
      results.push({
        amount,
        success: data.ReturnCode === 'Success',
        returnCode: data.ReturnCode
      });
      
      console.log(`✓ 金额 ${amount}: ${data.ReturnCode}`);
    } catch (e) {
      results.push({
        amount,
        success: false,
        error: e.message
      });
      console.error(`✗ 金额 ${amount}: ${e.message}`);
    }
  }
  
  console.log('\n==== 测试总结 ====');
  console.table(results);
  return results;
}

// 执行测试
runAutomatedTests();
```

---

## 🔗 相关文档

- **ABC_WECHAT_PAY_CONSOLE_TEST.md** - 完整指南
- **README_ABC_PAY.md** - 农行支付配置
- **WEBVIEW_DEBUG_QUICK_START.md** - DevTools 快速开始

---

## ⚡ 最快速的方式

**只需 3 行代码**：
```javascript
const r = AndroidBridge.createWeChatPay('ORDER_' + Date.now(), '0.01', 'Test', 'https://www.qsgl.net/pay/notify', 'wxb4dcf9e2b3c8e5a1');
console.log('结果:', r);
console.log('状态:', JSON.parse(r).ReturnCode);
```

**复制粘贴到 Console，按 Enter，完成！** ✅

