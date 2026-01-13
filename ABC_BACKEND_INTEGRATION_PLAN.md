# 🔄 农行微信支付 - 后端集成行动计划

## 📋 概览

您的客户端测试成功，现在需要后端来完成支付流程。本文档是一份**清晰的行动计划**，可以直接交给后端开发。

---

## 🎯 任务目标

创建一个 API 接口，接收客户端发来的支付参数，调用农行支付接口，并返回支付链接。

**预期时间**: 1-2 小时（取决于现有代码框架）

---

## 📦 客户端会发来什么

### 请求

```
POST /api/pay/createWeChatOrder
Content-Type: application/json

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

### 预期返回

```json
{
  "status": "success",
  "payUrl": "https://...",
  "orderId": "...",
  "message": "订单创建成功"
}
```

---

## 🛠️ 开发步骤

### 步骤 1: 创建 Controller 接收请求

#### Java Spring Boot 示例
```java
@RestController
@RequestMapping("/api/pay")
public class PaymentController {
    
    @PostMapping("/createWeChatOrder")
    public ResponseEntity<?> createWeChatOrder(
        @RequestBody PaymentRequest request
    ) {
        try {
            // 步骤 2-4 放这里
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of(
                "status", "error",
                "message", e.getMessage()
            ));
        }
    }
}
```

#### 请求和响应模型
```java
@Data
public class PaymentRequest {
    private Map<String, Object> orderParams;
    private Map<String, Object> requestParams;
}

@Data
public class PaymentResponse {
    private String status;
    private String payUrl;
    private String orderId;
    private String message;
}
```

---

### 步骤 2: 验证订单信息

```java
// 验证必要字段
String orderNo = (String) request.getOrderParams().get("OrderNo");
String amount = (String) request.getOrderParams().get("OrderAmount");
String accountNo = (String) request.getOrderParams().get("AccountNo");

if (orderNo == null || amount == null || accountNo == null) {
    throw new IllegalArgumentException("缺少必要参数");
}

// 验证金额格式
try {
    Double.parseDouble(amount);
} catch (NumberFormatException e) {
    throw new IllegalArgumentException("金额格式错误");
}

// 验证订单号唯一性（可选）
// if (orderExists(orderNo)) {
//     throw new IllegalArgumentException("订单号重复");
// }
```

---

### 步骤 3: 调用农行支付接口

#### 农行接口信息
```
URL: https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
方法: POST
Content-Type: application/json
```

#### Java 实现
```java
import org.springframework.web.client.RestTemplate;

String abcPayUrl = "https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet";

// 构建农行请求体
Map<String, Object> abcRequest = new HashMap<>();
abcRequest.put("Order", request.getOrderParams());
abcRequest.putAll(request.getRequestParams());

// 添加商户信息（从配置文件读取）
abcRequest.put("MerchantId", "103881636900016");
abcRequest.put("Password", "ay365365");  // 从环境变量或配置文件读取

// 可能需要签名（根据农行文档）
// String signature = generateSignature(abcRequest);
// abcRequest.put("Signature", signature);

// 发送请求
RestTemplate restTemplate = new RestTemplate();
Map<String, Object> abcResponse = restTemplate.postForObject(
    abcPayUrl,
    abcRequest,
    Map.class
);
```

---

### 步骤 4: 处理农行返回

```java
// 解析农行响应
String returnCode = (String) abcResponse.get("ReturnCode");
String payUrl = (String) abcResponse.get("PayUrl");
String orderId = (String) abcResponse.get("OrderId");

if ("Success".equals(returnCode)) {
    // 成功
    PaymentResponse response = new PaymentResponse();
    response.setStatus("success");
    response.setPayUrl(payUrl);
    response.setOrderId(orderId);
    response.setMessage("订单创建成功");
    
    // 保存订单到数据库（可选）
    // saveOrder(request.getOrderParams(), payUrl);
    
    return response;
} else {
    // 失败
    throw new RuntimeException("农行支付接口返回错误: " + returnCode);
}
```

---

### 步骤 5: 处理错误和日志

```java
@PostMapping("/createWeChatOrder")
public ResponseEntity<?> createWeChatOrder(@RequestBody PaymentRequest request) {
    logger.info("收到支付请求: {}", request.getOrderParams().get("OrderNo"));
    
    try {
        // 验证
        validateRequest(request);
        logger.debug("参数验证通过");
        
        // 调用农行
        Map<String, Object> abcResponse = callAbcPaymentAPI(request);
        logger.info("农行返回: {}", abcResponse.get("ReturnCode"));
        
        // 构建响应
        PaymentResponse response = buildResponse(abcResponse);
        
        logger.info("支付请求成功, OrderNo: {}", request.getOrderParams().get("OrderNo"));
        return ResponseEntity.ok(response);
        
    } catch (Exception e) {
        logger.error("支付请求失败", e);
        return ResponseEntity.status(500).body(Map.of(
            "status", "error",
            "message": e.getMessage()
        ));
    }
}
```

---

## 💻 完整代码示例

### Java Spring Boot 完整实现

```java
package com.qsgl365.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

@RestController
@RequestMapping("/api/pay")
@CrossOrigin(origins = "*")
public class WeChatPaymentController {
    
    private static final Logger logger = LoggerFactory.getLogger(WeChatPaymentController.class);
    
    @Value("${abc.merchant.id:103881636900016}")
    private String merchantId;
    
    @Value("${abc.merchant.password:ay365365}")
    private String merchantPassword;
    
    @Value("${abc.payment.url:https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet}")
    private String abcPaymentUrl;
    
    private RestTemplate restTemplate = new RestTemplate();
    
    @PostMapping("/createWeChatOrder")
    public ResponseEntity<?> createWeChatOrder(@RequestBody PaymentRequest request) {
        String orderNo = null;
        
        try {
            orderNo = (String) request.getOrderParams().get("OrderNo");
            logger.info("========== 开始处理支付请求 ==========");
            logger.info("订单号: {}", orderNo);
            
            // 1. 验证请求
            validateRequest(request);
            logger.debug("✓ 参数验证通过");
            
            // 2. 调用农行接口
            Map<String, Object> abcResponse = callAbcPaymentAPI(request);
            logger.info("✓ 农行接口调用成功, 返回码: {}", abcResponse.get("ReturnCode"));
            
            // 3. 解析返回结果
            String returnCode = (String) abcResponse.get("ReturnCode");
            if (!"Success".equals(returnCode)) {
                throw new RuntimeException("农行返回错误: " + returnCode);
            }
            
            String payUrl = (String) abcResponse.get("PayUrl");
            String responseOrderId = (String) abcResponse.get("OrderId");
            
            // 4. 保存订单（可选）
            // saveOrder(request.getOrderParams(), payUrl);
            
            // 5. 返回结果
            PaymentResponse response = new PaymentResponse();
            response.setStatus("success");
            response.setPayUrl(payUrl);
            response.setOrderId(responseOrderId);
            response.setMessage("订单创建成功");
            
            logger.info("========== 支付请求处理完成 ==========");
            logger.info("返回支付链接: {}", payUrl);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("支付请求处理失败, 订单号: {}", orderNo, e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", e.getMessage());
            
            return ResponseEntity.status(500).body(errorResponse);
        }
    }
    
    private void validateRequest(PaymentRequest request) {
        Map<String, Object> orderParams = request.getOrderParams();
        
        String orderNo = (String) orderParams.get("OrderNo");
        String amount = (String) orderParams.get("OrderAmount");
        String accountNo = (String) orderParams.get("AccountNo");
        
        if (orderNo == null || orderNo.trim().isEmpty()) {
            throw new IllegalArgumentException("缺少 OrderNo");
        }
        if (amount == null || amount.trim().isEmpty()) {
            throw new IllegalArgumentException("缺少 OrderAmount");
        }
        if (accountNo == null || accountNo.trim().isEmpty()) {
            throw new IllegalArgumentException("缺少 AccountNo");
        }
        
        try {
            Double.parseDouble(amount);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("金额格式错误");
        }
        
        if (Double.parseDouble(amount) <= 0) {
            throw new IllegalArgumentException("金额必须大于 0");
        }
    }
    
    private Map<String, Object> callAbcPaymentAPI(PaymentRequest request) {
        logger.debug("准备调用农行支付接口");
        logger.debug("接口地址: {}", abcPaymentUrl);
        
        // 构建请求
        Map<String, Object> abcRequest = new HashMap<>();
        abcRequest.put("Order", request.getOrderParams());
        abcRequest.putAll(request.getRequestParams());
        abcRequest.put("MerchantId", merchantId);
        
        // 如果需要签名，在这里添加
        // String signature = generateSignature(abcRequest);
        // abcRequest.put("Signature", signature);
        
        logger.debug("请求体: {}", abcRequest);
        
        // 调用接口
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> response = restTemplate.postForObject(
                abcPaymentUrl,
                abcRequest,
                Map.class
            );
            
            logger.debug("农行返回: {}", response);
            
            return response;
            
        } catch (Exception e) {
            logger.error("调用农行接口失败", e);
            throw new RuntimeException("调用农行接口失败: " + e.getMessage(), e);
        }
    }
}

@Data
class PaymentRequest {
    private Map<String, Object> orderParams;
    private Map<String, Object> requestParams;
}

@Data
class PaymentResponse {
    private String status;
    private String payUrl;
    private String orderId;
    private String message;
}
```

---

## ⚙️ 配置文件

在 `application.properties` 或 `application.yml` 中添加：

```properties
# 农行支付配置
abc.merchant.id=103881636900016
abc.merchant.password=ay365365
abc.payment.url=https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet
```

或 YAML:
```yaml
abc:
  merchant:
    id: "103881636900016"
    password: "ay365365"
  payment:
    url: "https://pay.test.abchina.com:443/ebus/ReceiveMerchantTrxReqServlet"
```

---

## 🧪 测试方法

### 使用 curl 测试

```bash
curl -X POST http://localhost:8080/api/pay/createWeChatOrder \
  -H "Content-Type: application/json" \
  -d '{
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
  }'
```

### 使用 Postman 测试

1. 新建 POST 请求
2. URL: `http://localhost:8080/api/pay/createWeChatOrder`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON): 上面的 curl 请求体

### 预期返回

```json
{
  "status": "success",
  "payUrl": "https://...",
  "orderId": "...",
  "message": "订单创建成功"
}
```

---

## ⚠️ 注意事项

1. **商户信息**: 使用正确的商户 ID 和密码
2. **签名**: 检查农行文档，可能需要对请求签名
3. **HTTPS**: 农行接口必须用 HTTPS
4. **异常处理**: 要处理网络超时、农行返回错误等情况
5. **日志**: 记录所有请求和响应，方便调试
6. **环境变量**: 不要在代码里硬编码敏感信息

---

## 🔐 安全建议

1. ✅ 商户密码从环境变量读取，不写在代码里
2. ✅ 验证所有输入参数
3. ✅ 只返回必要的信息给客户端
4. ✅ 记录所有支付相关的操作
5. ✅ 使用 HTTPS
6. ✅ 验证请求来源（如果需要）
7. ✅ 实现请求签名和验证

---

## 🐛 常见问题

### 农行接口返回超时
- 检查网络连接
- 检查防火墙设置
- 增加超时时间

### 返回错误代码
- 检查参数格式
- 检查商户信息
- 查看农行的错误文档

### PayUrl 为 null
- 检查农行返回的完整响应
- 查看农行日志
- 联系农行技术支持

---

## ✅ 验收标准

- [ ] 接口能正确接收客户端请求
- [ ] 参数验证工作正常
- [ ] 能成功调用农行接口
- [ ] 能正确解析农行响应
- [ ] 能返回 PayUrl 给客户端
- [ ] 错误处理完善
- [ ] 日志记录完整

---

## 📞 后续步骤

1. ✅ 后端实现上述接口
2. ✅ 测试接口
3. ⏳ 前端调用该接口
4. ⏳ 完整端到端测试
5. ⏳ 处理支付回调

---

**预计完成时间: 1-2 小时**

**祝实现顺利！** 🚀

