# 🎯 农行微信支付 - 后端开发快速卡

> 👋 给后端开发的快速参考卡。复制这些代码，5 分钟内就能完成接口。

---

## 📋 一句话总结

**创建一个 API 接口，接收客户端发来的支付参数，转发给农行，返回支付链接。**

---

## 📥 接口定义

```
请求方法: POST
接口地址: /api/pay/createWeChatOrder
请求格式: application/json
```

---

## 🔹 请求示例

```json
{
  "orderParams": {
    "OrderNo": "TEST_1767664893226",
    "OrderDate": "2026/01/06",
    "OrderTime": "10:01:33",
    "OrderAmount": "0.01",
    "OrderDesc": "测试商品",
    "AccountNo": "wxb4dcf9e2b3c8e5a1",
    "PayTypeID": "APP",
    "CurrencyCode": "156",
    "BuyIP": "127.0.0.1",
    "ReceiverAddress": ""
  },
  "requestParams": {
    "TrxType": "UnifiedOrderReq",
    "PaymentType": "8",
    "PaymentLinkType": "4",
    "NotifyType": "1",
    "CommodityType": "0101",
    "MerModelFlag": "0",
    "MerchantRemarks": "",
    "ResultNotifyURL": "https://www.qsgl.net/pay/notify"
  }
}
```

---

## 🔹 返回示例

**成功:**
```json
{
  "status": "success",
  "payUrl": "https://...",
  "orderId": "xxx",
  "message": "订单创建成功"
}
```

**失败:**
```json
{
  "status": "error",
  "message": "错误信息"
}
```

---

## 💻 Java Spring Boot 代码（复制即用）

```java
@RestController
@RequestMapping("/api/pay")
@CrossOrigin(origins = "*")
public class WeChatPaymentController {
    
    @PostMapping("/createWeChatOrder")
    public ResponseEntity<?> createWeChatOrder(@RequestBody Map<String, Object> request) {
        try {
            // 1. 提取参数
            Map<String, Object> orderParams = (Map<String, Object>) request.get("orderParams");
            Map<String, Object> requestParams = (Map<String, Object>) request.get("requestParams");
            
            // 2. 验证参数
            if (orderParams == null || orderParams.get("OrderNo") == null) {
                return ResponseEntity.badRequest().body(Map.of("status", "error", "message", "缺少必要参数"));
            }
            
            // 3. 构建农行请求
            Map<String, Object> abcRequest = new HashMap<>(orderParams);
            abcRequest.putAll(requestParams);
            abcRequest.put("MerchantId", "103881636900016");
            
            // 4. 调用农行接口
            RestTemplate restTemplate = new RestTemplate();
            String abcUrl = "https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet";
            
            @SuppressWarnings("unchecked")
            Map<String, Object> abcResponse = restTemplate.postForObject(abcUrl, abcRequest, Map.class);
            
            // 5. 检查返回码
            if (!"Success".equals(abcResponse.get("ReturnCode"))) {
                return ResponseEntity.status(500).body(Map.of(
                    "status", "error",
                    "message", "农行返回错误: " + abcResponse.get("ReturnCode")
                ));
            }
            
            // 6. 返回结果
            return ResponseEntity.ok(Map.of(
                "status", "success",
                "payUrl", abcResponse.get("PayUrl"),
                "orderId", abcResponse.get("OrderId"),
                "message", "订单创建成功"
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

## 🐍 Python Flask 代码（复制即用）

```python
from flask import Flask, request, jsonify
import requests
import json

app = Flask(__name__)

@app.route('/api/pay/createWeChatOrder', methods=['POST'])
def create_order():
    try:
        data = request.json
        order_params = data.get('orderParams')
        request_params = data.get('requestParams')
        
        # 验证参数
        if not order_params or not order_params.get('OrderNo'):
            return jsonify({"status": "error", "message": "缺少必要参数"}), 400
        
        # 构建农行请求
        abc_request = {**order_params, **request_params}
        abc_request['MerchantId'] = '103881636900016'
        
        # 调用农行接口
        abc_url = 'https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet'
        abc_response = requests.post(abc_url, json=abc_request)
        abc_data = abc_response.json()
        
        # 检查返回码
        if abc_data.get('ReturnCode') != 'Success':
            return jsonify({
                "status": "error",
                "message": f"农行返回错误: {abc_data.get('ReturnCode')}"
            }), 500
        
        # 返回结果
        return jsonify({
            "status": "success",
            "payUrl": abc_data.get('PayUrl'),
            "orderId": abc_data.get('OrderId'),
            "message": "订单创建成功"
        })
        
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(port=5000)
```

---

## 🟢 Node.js Express 代码（复制即用）

```javascript
const express = require('express');
const axios = require('axios');
const app = express();

app.use(express.json());

app.post('/api/pay/createWeChatOrder', async (req, res) => {
    try {
        const { orderParams, requestParams } = req.body;
        
        // 验证参数
        if (!orderParams || !orderParams.OrderNo) {
            return res.status(400).json({ 
                status: 'error', 
                message: '缺少必要参数' 
            });
        }
        
        // 构建农行请求
        const abcRequest = {
            ...orderParams,
            ...requestParams,
            MerchantId: '103881636900016'
        };
        
        // 调用农行接口
        const abcUrl = 'https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet';
        const abcResponse = await axios.post(abcUrl, abcRequest);
        const abcData = abcResponse.data;
        
        // 检查返回码
        if (abcData.ReturnCode !== 'Success') {
            return res.status(500).json({
                status: 'error',
                message: `农行返回错误: ${abcData.ReturnCode}`
            });
        }
        
        // 返回结果
        res.json({
            status: 'success',
            payUrl: abcData.PayUrl,
            orderId: abcData.OrderId,
            message: '订单创建成功'
        });
        
    } catch (error) {
        res.status(500).json({ 
            status: 'error', 
            message: error.message 
        });
    }
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

---

## ⚙️ 配置文件

### application.properties (Java)
```properties
abc.merchant.id=103881636900016
abc.merchant.password=ay365365
abc.payment.url=https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
```

### .env (Node.js)
```
ABC_MERCHANT_ID=103881636900016
ABC_MERCHANT_PASSWORD=ay365365
ABC_PAYMENT_URL=https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
```

### .env (Python)
```
ABC_MERCHANT_ID=103881636900016
ABC_MERCHANT_PASSWORD=ay365365
ABC_PAYMENT_URL=https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
```

---

## 🧪 测试命令

### curl
```bash
curl -X POST http://localhost:8080/api/pay/createWeChatOrder \
  -H "Content-Type: application/json" \
  -d '{
    "orderParams": {
      "OrderNo": "TEST_'$(date +%s)'",
      "OrderDate": "2026/01/06",
      "OrderTime": "10:01:33",
      "OrderAmount": "0.01",
      "OrderDesc": "测试商品",
      "AccountNo": "wxb4dcf9e2b3c8e5a1",
      "PayTypeID": "APP",
      "CurrencyCode": "156",
      "BuyIP": "127.0.0.1",
      "ReceiverAddress": ""
    },
    "requestParams": {
      "TrxType": "UnifiedOrderReq",
      "PaymentType": "8",
      "PaymentLinkType": "4",
      "NotifyType": "1",
      "CommodityType": "0101",
      "MerModelFlag": "0",
      "MerchantRemarks": "",
      "ResultNotifyURL": "https://www.qsgl.net/pay/notify"
    }
  }'
```

### PowerShell
```powershell
$body = @{
    orderParams = @{
        OrderNo = "TEST_$(Get-Date -UFormat %s)"
        OrderDate = "2026/01/06"
        OrderTime = "10:01:33"
        OrderAmount = "0.01"
        OrderDesc = "测试商品"
        AccountNo = "wxb4dcf9e2b3c8e5a1"
        PayTypeID = "APP"
        CurrencyCode = "156"
        BuyIP = "127.0.0.1"
        ReceiverAddress = ""
    }
    requestParams = @{
        TrxType = "UnifiedOrderReq"
        PaymentType = "8"
        PaymentLinkType = "4"
        NotifyType = "1"
        CommodityType = "0101"
        MerModelFlag = "0"
        MerchantRemarks = ""
        ResultNotifyURL = "https://www.qsgl.net/pay/notify"
    }
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/api/pay/createWeChatOrder" `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

---

## ✅ 检查清单

- [ ] 接口可以接收请求
- [ ] 参数验证工作正常
- [ ] 能调用农行接口
- [ ] 能解析农行返回
- [ ] 返回值格式正确
- [ ] 错误处理完善

---

## ⚠️ 常见错误

| 错误 | 原因 | 解决方案 |
|------|------|--------|
| Connection timeout | 网络问题 | 检查网络，检查防火墙 |
| SSL error | 证书问题 | 跳过证书验证（开发环境） |
| Invalid parameters | 参数格式错误 | 检查字段名和格式 |
| ReturnCode != Success | 农行返回错误 | 查看农行错误信息 |
| PayUrl is null | 农行没返回 | 检查参数，查看农行日志 |

---

## 🎯 完整测试流程

1. **启动服务器**
   ```bash
   java -jar app.jar  # Java
   python app.py       # Python
   node app.js         # Node.js
   ```

2. **发送请求**
   ```bash
   curl ... (见上面的测试命令)
   ```

3. **检查返回**
   ```json
   {
     "status": "success",
     "payUrl": "...",
     "orderId": "..."
   }
   ```

4. **集成前端**
   - 获得 payUrl 和 orderId
   - 调起微信支付

---

## 📞 需要更多信息？

- Java 详细实现: `ABC_BACKEND_INTEGRATION_PLAN.md`
- 后端集成指南: `ABC_PAYMENT_SERVER_INTEGRATION.md`
- 客户端测试结果: `ABC_CLIENT_TEST_SUCCESS.md`

---

## ⏱️ 预计完成时间

- **复制代码**: 1 分钟
- **修改配置**: 2 分钟
- **测试接口**: 2 分钟
- **集成前端**: 10 分钟

**总计: 15 分钟** ⚡

---

## 💡 核心要点

1. ✅ 复制上面任意一种语言的代码
2. ✅ 修改商户 ID 和密码
3. ✅ 启动服务器
4. ✅ 用 curl 或 Postman 测试
5. ✅ 看到成功返回！

**就这么简单！** 🚀

---

**准备好了吗？开始编码吧！** 💻

