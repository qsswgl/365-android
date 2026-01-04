# 🔴 重要说明：农行支付正确的集成架构

## ⚠️ 架构调整

经过编译测试发现，**农行TrustPayClient SDK是服务端SDK**，不能直接在Android客户端使用。

### 正确的集成架构

```
Android客户端
    ↓ (HTTPS)
你的后端服务器
    ↓ (使用农行SDK)
农行综合收银台服务器
    ↓
微信支付平台
```

### ❌ 错误方式（无法实现）
```
Android客户端 → 直接使用农行SDK → 农行服务器
```
**原因**：农行TrustPayClient是Java服务端SDK，依赖服务器环境的证书管理、签名验证等功能。

### ✅ 正确方式（已实现）
```
Android客户端 → 你的后端API → 后端使用农行SDK → 农行服务器
```

---

## 📦 当前实现方案

### Android端（已完成）

**文件**: `AbcWeChatPayManager.java`

功能：构建支付参数并返回给前端，前端将参数发送到你的后端服务器。

**JavaScript调用**：
```javascript
var result = AndroidBridge.createWeChatPay(
    orderNo, amount, orderDesc, notifyUrl, appId
);

// 解析结果
var params = JSON.parse(result);
if (params.Status === 'NeedServerProxy') {
    // 将params发送到你的后端服务器
    fetch('https://yourserver.com/api/abc-pay/create-order', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(params.RequestParams)
    })
    .then(res => res.json())
    .then(data => {
        if (data.ReturnCode === '0000') {
            // 支付成功，拉起微信
        }
    });
}
```

**返回数据结构**：
```json
{
  "Status": "NeedServerProxy",
  "Message": "需要通过服务器中转调用农行支付接口",
  "RequestParams": {
    "TrxType": "UnifiedOrderReq",
    "Order": {
      "PayTypeID": "APP",
      "OrderNo": "ORDER123",
      "OrderAmount": "0.01",
      ...
    },
    "CommodityType": "0101",
    "PaymentType": "8",
    ...
  },
  "ServerUrl": "https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet",
  "MerchantId": "你的商户号"
}
```

---

## 🖥️ 后端服务器实现（需要你实现）

### 环境要求

- **语言**: Java (推荐) / Node.js / Python / PHP 等
- **农行SDK**: TrustPayClient-V3.3.3.jar（服务端）
- **证书文件**: merchant.pfx, TrustPay.cer

### Java后端示例

#### 1. 项目结构
```
your-backend-server/
├── lib/
│   ├── TrustPayClient-V3.3.3.jar
│   ├── commons-codec-1.3.jar
│   ├── commons-httpclient-3.0.1.jar
│   └── commons-logging.jar
├── cert/
│   ├── TrustPay.cer
│   └── merchant.pfx
└── src/
    └── AbcPayController.java
```

#### 2. Controller代码示例

```java
package com.yourcompany.controller;

import com.abc.pay.client.ebus.common.EBusMerchantCommonRequest;
import com.abc.pay.client.JSON;
import org.springframework.web.bind.annotation.*;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/abc-pay")
public class AbcPayController {
    
    @PostMapping("/create-order")
    public String createWeChatPayOrder(@RequestBody Map<String, Object> params) {
        try {
            // 创建农行请求对象
            EBusMerchantCommonRequest request = new EBusMerchantCommonRequest();
            
            // 设置请求参数（从Android端传来）
            request.dicRequest.put("TrxType", params.get("TrxType"));
            request.dicRequest.put("Order", params.get("Order"));
            request.dicRequest.put("CommodityType", params.get("CommodityType"));
            request.dicRequest.put("PaymentType", params.get("PaymentType"));
            request.dicRequest.put("PaymentLinkType", params.get("PaymentLinkType"));
            request.dicRequest.put("NotifyType", params.get("NotifyType"));
            request.dicRequest.put("ResultNotifyURL", params.get("ResultNotifyURL"));
            request.dicRequest.put("MerchantRemarks", params.get("MerchantRemarks"));
            request.dicRequest.put("MerModelFlag", params.get("MerModelFlag"));
            
            // 调用农行服务器
            JSON responseJson = request.postRequest();
            String result = responseJson.getIJsonString();
            
            return result;
            
        } catch (Exception e) {
            return "{\"ReturnCode\":\"Error\",\"ErrorMessage\":\"" + e.getMessage() + "\"}";
        }
    }
    
    @PostMapping("/payment-notify")
    public String paymentNotify(@RequestBody Map<String, Object> params) {
        // 处理农行支付结果通知
        // ...
        return "SUCCESS";
    }
}
```

#### 3. Spring Boot配置

```yaml
# application.yml
abc:
  pay:
    merchant-id: 你的商户号
    cert-file: /path/to/merchant.pfx
    cert-password: 你的证书密码
    trust-cert-file: /path/to/TrustPay.cer
    server-url: https://pay.test.abchina.com:443
```

---

## 🔄 完整支付流程

### 步骤1：用户点击支付

```javascript
// 前端页面
function startPay() {
    // 1. 调用Android JSBridge获取支付参数
    var params = AndroidBridge.createWeChatPay(
        'ORDER' + Date.now(),
        '0.01',
        '测试商品',
        'https://yourserver.com/api/abc-pay/payment-notify',
        'wx1234567890'
    );
    
    var data = JSON.parse(params);
    
    // 2. 发送参数到你的后端服务器
    fetch('https://yourserver.com/api/abc-pay/create-order', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(data.RequestParams)
    })
    .then(res => res.json())
    .then(result => {
        // 3. 处理农行返回结果
        if (result.ReturnCode === '0000') {
            // 支付订单创建成功
            console.log('支付成功');
            // 拉起微信支付（需要微信SDK）
        } else {
            alert('支付失败: ' + result.ErrorMessage);
        }
    })
    .catch(err => {
        alert('网络错误: ' + err.message);
    });
}
```

### 步骤2：后端调用农行接口

```java
// 你的后端服务器
@PostMapping("/create-order")
public String createOrder(@RequestBody Map<String, Object> params) {
    // 使用农行SDK调用农行服务器
    EBusMerchantCommonRequest request = new EBusMerchantCommonRequest();
    // ... 设置参数
    JSON response = request.postRequest();
    return response.getIJsonString();
}
```

### 步骤3：农行返回支付结果

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

### 步骤4：拉起微信支付

前端接收到返回结果后，使用微信SDK拉起微信APP完成支付。

---

## 📝 快速开始（3步）

### 1. 在你的后端服务器部署农行SDK

```bash
# 复制JAR包到后端项目
cp K:/365-android/app/libs/*.jar /your/backend/lib/

# 复制证书文件
cp /path/to/cert/*.{pfx,cer} /your/backend/cert/
```

### 2. 创建后端API接口

参考上面的 `AbcPayController.java` 示例。

### 3. 修改Android前端调用代码

```javascript
// 不直接使用AndroidBridge返回的结果
// 而是发送到你的后端服务器
var params = AndroidBridge.createWeChatPay(...);
var data = JSON.parse(params);

// 发送到后端
fetch('https://yourserver.com/api/abc-pay/create-order', {
    method: 'POST',
    body: JSON.stringify(data.RequestParams)
})
.then(res => res.json())
.then(result => {
    // 处理农行返回的真实结果
});
```

---

## 🚀 测试流程

### 1. 测试后端API

```bash
# 使用curl测试后端接口
curl -X POST https://yourserver.com/api/abc-pay/create-order \
  -H "Content-Type: application/json" \
  -d '{
    "TrxType": "UnifiedOrderReq",
    "Order": {
      "PayTypeID": "APP",
      "OrderNo": "TEST001",
      "OrderAmount": "0.01",
      "OrderDesc": "测试",
      ...
    },
    ...
  }'
```

期望返回：
```json
{
  "ReturnCode": "0000",
  "ErrorMessage": "交易成功",
  ...
}
```

### 2. 测试Android端

在Android WebView中打开测试页面，点击支付按钮，查看：

```bash
# 查看Android日志
adb logcat | findstr "AbcPay\|WebView"

# 期望看到：
# AbcWeChatPayManager: 请求参数构建完成
# AbcWeChatPayManager: 返回结果: {"Status":"NeedServerProxy",...}
```

---

## 📚 相关文档

### 农行官方文档
- 测试环境: https://pay.test.abchina.com/easyebus/
- 参考代码: `综合收银台接口包_V3.3.3软件包/Web/Order/WeiXinOrderRequest.jsp`

### 本地文档
- `ABC_WECHAT_PAY_INTEGRATION.md` - 详细集成文档（已更新）
- `ABC_PAY_QUICK_REFERENCE.md` - 快速参考

---

## ❓ 常见问题

### Q1: 为什么不能在Android直接使用农行SDK？

**A**: 农行TrustPayClient是Java服务端SDK，设计用于运行在服务器环境：
- 需要服务器级别的证书管理
- 需要签名验证和加密处理
- 依赖服务器环境的配置文件
- Android环境无法满足这些要求

### Q2: 我没有后端服务器怎么办？

**A**: 必须有后端服务器才能使用农行支付。可选方案：
1. 使用云服务器（阿里云、腾讯云等）
2. 使用Serverless服务（AWS Lambda、阿里云函数计算等）
3. 联系农行咨询是否有Android SDK（目前没有）

### Q3: Android端的代码还有用吗？

**A**: 有用！Android端负责：
- 构建支付参数
- 提供JavaScript Bridge接口
- 接收支付结果
- 处理支付回调

只是最终的农行接口调用需要通过后端服务器。

### Q4: 需要修改现有代码吗？

**A**: 需要小改前端调用方式：

**之前（错误）**:
```javascript
var result = AndroidBridge.createWeChatPay(...);
// 直接使用result，以为是农行返回的结果
```

**现在（正确）**:
```javascript
var params = AndroidBridge.createWeChatPay(...);
// params是支付参数，需要发送到后端
fetch('https://yourserver.com/api/...', {
    body: JSON.stringify(JSON.parse(params).RequestParams)
})
.then(res => res.json())  // 这才是农行返回的结果
```

---

## ✅ 下一步行动

### 立即可做
1. ✅ Android代码已完成（编译成功）
2. ✅ 参数构建逻辑已实现
3. ✅ JavaScript Bridge已添加

### 需要你实现
1. ⏳ 搭建后端服务器（Java/Node.js等）
2. ⏳ 在后端集成农行SDK
3. ⏳ 创建API接口 `/api/abc-pay/create-order`
4. ⏳ 配置证书和商户号
5. ⏳ 修改前端代码，调用后端API

### 预计时间
- 后端实现：2-4小时（如果熟悉）
- 联调测试：1-2小时
- 总计：半天可完成

---

**重要提示**: 农行支付必须通过后端服务器中转，这是行业标准做法，所有第三方支付（支付宝、微信支付等）都是这样的架构，确保安全性。

**文档版本**: 2.0（架构修正版）  
**更新日期**: 2026-01-04
