# 🔧 农行微信支付 - 服务器中转集成指南

## ✅ 当前状态

您的客户端代码 **100% 正常**！

```json
{
  "Status": "NeedServerProxy",
  "Message": "需要通过服务器中转调用农行支付接口",
  "ServerUrl": "https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet"
}
```

现在需要的是**服务器端**来完成剩余的步骤。

---

## 📊 当前流程图

```
┌─────────────────────────────────────────────────────────────┐
│                        用户 App (客户端)                      │
│                                                              │
│  1. ✅ 生成订单参数 (OrderParams)                            │
│  2. ✅ 生成请求参数 (RequestParams)                          │
│  3. ✅ 获得服务器 URL (ServerUrl)                            │
│  4. ✅ 返回 NeedServerProxy 状态                             │
│                                                              │
│     现在需要：将这些参数发送给服务器                           │
└────────────────────────┬──────────────────────────────────┘
                         │
                         │ POST 请求
                         │ 发送 OrderParams + RequestParams
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    您的后端服务器（需要实现）                  │
│                                                              │
│  1. ⏳ 接收客户端发来的参数                                    │
│  2. ⏳ 验证订单信息                                           │
│  3. ⏳ 调用农行支付接口                                       │
│     (https://pay.test.abchina.com:443/ebus/...)             │
│  4. ⏳ 处理农行返回的结果                                      │
│  5. ⏳ 返回支付链接给客户端                                    │
│                                                              │
└────────────────────────┬──────────────────────────────────┘
                         │
                         │ 返回结果
                         │ {PayUrl, ...}
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    用户 App（客户端）                         │
│                                                              │
│  5. ⏳ 接收支付链接                                           │
│  6. ⏳ 调起微信支付                                           │
│  7. ⏳ 获取支付结果                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 您获得的关键信息

### 1️⃣ 服务器地址
```
ServerUrl: https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
```

### 2️⃣ 订单参数 (OrderParams)
```json
{
  "AccountNo": "wxb4dcf9e2b3c8e5a1",
  "BuyIP": "127.0.0.1",
  "CurrencyCode": "156",
  "OrderAmount": "0.01",
  "OrderDate": "2026/01/06",
  "OrderDesc": "测试商品",
  "OrderNo": "TEST_1767664893226",
  "OrderTime": "10:01:33",
  "PayTypeID": "APP",
  "ReceiverAddress": ""
}
```

### 3️⃣ 请求参数 (RequestParams)
```json
{
  "CommodityType": "0101",
  "MerModelFlag": "0",
  "MerchantRemarks": "",
  "NotifyType": "1",
  "Order": { ... },
  "PaymentLinkType": "4",
  "PaymentType": "8",
  "ResultNotifyURL": "https://www.qsgl.net/pay/notify",
  "TrxType": "UnifiedOrderReq"
}
```

### 4️⃣ 商户信息
```
MerchantId: 103881636900016
```

---

## 🔄 服务器需要做的事

### 方案 A: 使用现有的后端服务（推荐）

如果你们公司已有现成的支付后端服务：

1. **与后端开发协调**
   - 告诉他们需要一个新的接口，接收这些参数
   - 该接口应该调用农行的支付 API

2. **后端需要实现**
   ```
   POST /api/pay/createOrder
   
   请求体:
   {
     "orderParams": { ... },      // 订单参数
     "requestParams": { ... }     // 请求参数
   }
   
   返回:
   {
     "payUrl": "xxx",              // 支付链接
     "orderId": "xxx",
     ...
   }
   ```

3. **客户端修改**
   ```javascript
   // 客户端发送到服务器
   fetch('https://yourserver.com/api/pay/createOrder', {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify({
       orderParams: result.OrderParams,
       requestParams: result.RequestParams
     })
   })
   .then(r => r.json())
   .then(data => {
     // 获得 payUrl，调起微信支付
     const payUrl = data.payUrl;
     // ...继续支付流程
   })
   ```

---

### 方案 B: 快速原型验证（测试用）

如果你想快速验证整个流程，可以用简单的服务器：

#### Node.js 快速示例
```javascript
// server.js
const express = require('express');
const axios = require('axios');
const app = express();

app.use(express.json());

app.post('/api/pay/createOrder', async (req, res) => {
  try {
    const { orderParams, requestParams } = req.body;
    
    // 调用农行支付接口
    const abcPayUrl = 'https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet';
    
    const response = await axios.post(abcPayUrl, {
      Order: orderParams,
      ...requestParams
    });
    
    // 返回支付链接给客户端
    res.json({
      payUrl: response.data.PayUrl,
      orderId: response.data.OrderId,
      status: 'success'
    });
    
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
});

app.listen(3000, () => console.log('Server running on :3000'));
```

#### Python 快速示例
```python
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

@app.route('/api/pay/createOrder', methods=['POST'])
def create_order():
    try:
        data = request.json
        order_params = data.get('orderParams')
        request_params = data.get('requestParams')
        
        # 调用农行支付接口
        abc_pay_url = 'https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet'
        
        response = requests.post(abc_pay_url, json={
            'Order': order_params,
            **request_params
        })
        
        return jsonify({
            'payUrl': response.json().get('PayUrl'),
            'orderId': response.json().get('OrderId'),
            'status': 'success'
        })
        
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

if __name__ == '__main__':
    app.run(port=3000)
```

#### Java 快速示例
```java
@RestController
@RequestMapping("/api/pay")
public class PaymentController {
    
    @PostMapping("/createOrder")
    public ResponseEntity<?> createOrder(@RequestBody PaymentRequest request) {
        try {
            // 调用农行支付接口
            String abcPayUrl = "https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet";
            
            // 构建请求
            Map<String, Object> abcRequest = new HashMap<>();
            abcRequest.put("Order", request.getOrderParams());
            abcRequest.putAll(request.getRequestParams());
            
            // 发送 HTTP 请求到农行
            RestTemplate restTemplate = new RestTemplate();
            Map<String, Object> response = restTemplate.postForObject(
                abcPayUrl,
                abcRequest,
                Map.class
            );
            
            // 返回支付链接
            return ResponseEntity.ok(Map.of(
                "payUrl", response.get("PayUrl"),
                "orderId", response.get("OrderId"),
                "status", "success"
            ));
            
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of(
                "status", "error",
                "message", e.getMessage()
            ));
        }
    }
}
```

---

## 📝 重要的参数说明

### OrderParams 中的各字段含义

| 字段 | 含义 | 示例 |
|------|------|------|
| OrderNo | 订单号（唯一） | TEST_1767664893226 |
| OrderDate | 订单日期 | 2026/01/06 |
| OrderTime | 订单时间 | 10:01:33 |
| OrderAmount | 订单金额（元） | 0.01 |
| OrderDesc | 商品描述 | 测试商品 |
| AccountNo | 微信账户/OpenID | wxb4dcf9e2b3c8e5a1 |
| PayTypeID | 支付方式 | APP / JSAPI / NATIVE |
| CurrencyCode | 货币代码 | 156 (人民币) |
| BuyIP | 购买者 IP | 127.0.0.1 |
| ReceiverAddress | 收货地址 | (可选) |

### RequestParams 中的各字段含义

| 字段 | 含义 | 示例 |
|------|------|------|
| TrxType | 交易类型 | UnifiedOrderReq |
| PaymentType | 支付类型 | 8 |
| PaymentLinkType | 支付链接类型 | 4 |
| NotifyType | 通知类型 | 1 |
| CommodityType | 商品类型 | 0101 |
| MerModelFlag | 商户模式标志 | 0 |
| ResultNotifyURL | 结果回调 URL | https://www.qsgl.net/pay/notify |

---

## 🔐 安全考虑

### 客户端应该做的
- ✅ 验证 Bridge 可用
- ✅ 生成订单参数
- ✅ 发送到自己的服务器（不是直接到农行）

### 服务器应该做的
- ✅ 验证订单信息的合法性
- ✅ 验证金额、商户 ID 等
- ✅ 调用农行 API（安全的，有密钥）
- ✅ 签名、加密等安全操作
- ✅ 返回支付链接给客户端
- ✅ 处理回调通知

**重点**: 不要在客户端直接调用农行 API，必须通过服务器中转！

---

## 🚀 完整的端到端流程

### 1. 客户端调用支付（已完成 ✅）
```javascript
const result = AndroidBridge.createWeChatPay(...);
// 返回: { Status: 'NeedServerProxy', OrderParams, RequestParams, ... }
```

### 2. 客户端发送到服务器（待实现）
```javascript
const response = await fetch('https://yourserver.com/api/pay/createOrder', {
  method: 'POST',
  body: JSON.stringify({
    orderParams: result.OrderParams,
    requestParams: result.RequestParams
  })
});
const data = await response.json();
```

### 3. 服务器调用农行（待实现）
```
POST https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
Body: {
  Order: orderParams,
  ...requestParams
}
返回: { PayUrl, OrderId, ... }
```

### 4. 服务器返回支付链接给客户端（待实现）
```javascript
{
  "payUrl": "https://...",
  "orderId": "...",
  "status": "success"
}
```

### 5. 客户端调起微信支付（后续）
```javascript
// 拿到 payUrl 后，调起微信支付
// 需要在 MainActivity 中添加微信支付处理
```

---

## 💬 与后端沟通的话术

给你的后端开发说：

> "我已经在客户端生成了农行支付所需的所有参数。现在需要你创建一个 API 接口，接收这些参数，然后：
> 
> 1. 调用农行的支付接口: `https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet`
> 2. 把结果返回给客户端
> 
> 客户端会发送的参数:
> - OrderParams (订单信息)
> - RequestParams (请求参数)
> 
> 服务器需要返回:
> - payUrl (支付链接)
> - orderId (订单 ID)
> 
> 我可以把详细的参数结构发给你。"

---

## 📊 测试清单

- [ ] 后端接口已创建
- [ ] 后端可以接收 OrderParams 和 RequestParams
- [ ] 后端可以成功调用农行接口
- [ ] 后端可以返回 PayUrl
- [ ] 客户端可以接收 PayUrl
- [ ] 后续可以用 PayUrl 调起微信支付

---

## 🎓 下一步行动

### 立刻（现在）
1. 将这份文档给你的后端开发
2. 告诉他们需要实现一个支付接口

### 今天
1. 后端创建接口
2. 给接口传递这些参数
3. 检查返回结果

### 明天
1. 集成到前端代码中
2. 完整测试端到端流程

### 本周
1. 与农行对接测试账户
2. 测试真实支付流程

---

## ✨ 总结

**您已经完成了：**
- ✅ 客户端支付调用
- ✅ 参数生成
- ✅ 农行接口识别

**还需要做的：**
- ⏳ 后端接口实现
- ⏳ 前后端集成
- ⏳ 微信支付调起

**好消息：**
- 您已经走到了关键的一步！
- 剩下的只是标准的服务器集成
- 没有更多的客户端代码需要改

**这是非常积极的进展！** 🎉

---

## 📞 常见问题

### Q: 为什么不能直接在客户端调用农行接口？
A: 出于安全考虑。农行接口需要密钥、签名等，不能暴露在客户端。

### Q: 服务器需要什么参数调用农行？
A: 就是您现在看到的 OrderParams + RequestParams，加上商户密钥进行签名。

### Q: 这是标准的支付流程吗？
A: 是的，所有支付接口都是这样。客户端生成参数 → 服务器调用接口 → 返回支付链接 → 客户端发起支付。

### Q: 还要改客户端代码吗？
A: 目前不需要。等后端接口好了后，可能需要修改客户端发送参数的逻辑。

---

**下一个检查点：后端接口完成！** ✅

