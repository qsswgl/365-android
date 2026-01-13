# 🔧 农行支付网关 - 后端集成代码（Java/Spring Boot）

> 基于最新的 Swagger 文档，提供完整的后端集成模板

---

## 📦 集成步骤

### 1. 添加依赖 (pom.xml)

```xml
<!-- Spring Boot REST Client -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>

<!-- JSON 处理 -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>

<!-- HTTPS 支持 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

---

### 2. 创建数据模型

#### PaymentRequest.java

```java
package com.qsgl365.payment.model;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentRequest {
    
    /** 订单号，商户系统内唯一 */
    private String orderNo;
    
    /** 支付金额，单位：元 */
    private Double amount;
    
    /** 商户 ID，由农行分配 */
    private String merchantId;
    
    /** 商品名称 */
    private String goodsName;
    
    /** 回调地址 */
    private String notifyUrl;
    
    /** 返回地址 */
    private String returnUrl;
    
    /** 备注 */
    private String remarks;
}
```

#### PaymentResponse.java

```java
package com.qsgl365.payment.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResponse {
    
    /** 是否成功 */
    @JsonProperty("isSuccess")
    private Boolean isSuccess;
    
    /** 订单号 */
    private String orderNo;
    
    /** 农行交易流水号 */
    private String transactionId;
    
    /** 订单状态: PENDING/SUCCESS/FAILED/EXPIRED */
    private String status;
    
    /** 二维码内容 */
    private String qrCode;
    
    /** 跳转 URL */
    private String redirectUrl;
    
    /** 返回信息 */
    private String message;
    
    /** 错误代码 */
    private String errorCode;
    
    /** 响应时间戳 */
    private String timestamp;
    
    /** 金额 */
    private Double amount;
}
```

#### HealthStatus.java

```java
package com.qsgl365.payment.model;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HealthStatus {
    
    /** 状态: healthy/degraded/unhealthy */
    private String status;
    
    /** 时间戳 */
    private String timestamp;
    
    /** 运行时间（秒） */
    private Long uptime;
    
    /** 状态信息 */
    private String message;
}
```

---

### 3. 创建支付网关服务

#### PaymentGatewayService.java

```java
package com.qsgl365.payment.service;

import com.qsgl365.payment.model.PaymentRequest;
import com.qsgl365.payment.model.PaymentResponse;
import com.qsgl365.payment.model.HealthStatus;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.HttpClientErrorException;

@Slf4j
@Service
public class PaymentGatewayService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Value("${payment.gateway.url:https://payment.qsgl.net}")
    private String gatewayUrl;
    
    @Value("${payment.merchant.id:103881636900016}")
    private String merchantId;
    
    @Value("${payment.notify.url}")
    private String notifyUrl;
    
    @Value("${payment.return.url}")
    private String returnUrl;
    
    /**
     * 创建扫码支付订单
     * @param request 支付请求参数
     * @return 支付响应
     */
    public PaymentResponse createQRCodePayment(PaymentRequest request) {
        try {
            // 填充默认值
            if (request.getMerchantId() == null) {
                request.setMerchantId(merchantId);
            }
            if (request.getNotifyUrl() == null) {
                request.setNotifyUrl(notifyUrl);
            }
            if (request.getReturnUrl() == null) {
                request.setReturnUrl(returnUrl);
            }
            
            // 构建请求头
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<PaymentRequest> httpEntity = new HttpEntity<>(request, headers);
            
            // 调用网关
            ResponseEntity<PaymentResponse> response = restTemplate.exchange(
                gatewayUrl + "/api/payment/qrcode",
                HttpMethod.POST,
                httpEntity,
                PaymentResponse.class
            );
            
            PaymentResponse result = response.getBody();
            log.info("✓ 扫码支付订单创建成功: orderNo={}, transactionId={}", 
                result.getOrderNo(), result.getTransactionId());
            
            return result;
            
        } catch (HttpClientErrorException e) {
            log.error("✗ 扫码支付创建失败 [{}]: {}", e.getRawStatusCode(), e.getResponseBodyAsString());
            throw new PaymentException("扫码支付创建失败: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            log.error("✗ 扫码支付创建异常", e);
            throw new PaymentException("扫码支付创建异常: " + e.getMessage());
        }
    }
    
    /**
     * 创建电子钱包支付订单
     * @param request 支付请求参数
     * @return 支付响应
     */
    public PaymentResponse createEWalletPayment(PaymentRequest request) {
        try {
            // 填充默认值
            if (request.getMerchantId() == null) {
                request.setMerchantId(merchantId);
            }
            if (request.getNotifyUrl() == null) {
                request.setNotifyUrl(notifyUrl);
            }
            if (request.getReturnUrl() == null) {
                request.setReturnUrl(returnUrl);
            }
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<PaymentRequest> httpEntity = new HttpEntity<>(request, headers);
            
            ResponseEntity<PaymentResponse> response = restTemplate.exchange(
                gatewayUrl + "/api/payment/ewallet",
                HttpMethod.POST,
                httpEntity,
                PaymentResponse.class
            );
            
            PaymentResponse result = response.getBody();
            log.info("✓ 电子钱包支付订单创建成功: orderNo={}, transactionId={}", 
                result.getOrderNo(), result.getTransactionId());
            
            return result;
            
        } catch (HttpClientErrorException e) {
            log.error("✗ 电子钱包支付创建失败 [{}]: {}", e.getRawStatusCode(), e.getResponseBodyAsString());
            throw new PaymentException("电子钱包支付创建失败: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            log.error("✗ 电子钱包支付创建异常", e);
            throw new PaymentException("电子钱包支付创建异常: " + e.getMessage());
        }
    }
    
    /**
     * 查询订单状态
     * @param orderNo 订单号
     * @return 订单信息
     */
    public PaymentResponse queryOrderStatus(String orderNo) {
        try {
            ResponseEntity<PaymentResponse> response = restTemplate.exchange(
                gatewayUrl + "/api/payment/query/" + orderNo,
                HttpMethod.GET,
                null,
                PaymentResponse.class
            );
            
            PaymentResponse result = response.getBody();
            log.info("✓ 订单查询成功: orderNo={}, status={}", result.getOrderNo(), result.getStatus());
            
            return result;
            
        } catch (HttpClientErrorException e) {
            log.error("✗ 订单查询失败 [{}]: {}", e.getRawStatusCode(), e.getResponseBodyAsString());
            throw new PaymentException("订单查询失败: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            log.error("✗ 订单查询异常", e);
            throw new PaymentException("订单查询异常: " + e.getMessage());
        }
    }
    
    /**
     * 检查网关健康状态
     * @return 健康状态
     */
    public HealthStatus checkGatewayHealth() {
        try {
            ResponseEntity<HealthStatus> response = restTemplate.exchange(
                gatewayUrl + "/api/payment/health",
                HttpMethod.GET,
                null,
                HealthStatus.class
            );
            
            HealthStatus result = response.getBody();
            log.info("✓ 支付网关健康状态: {}", result.getStatus());
            
            return result;
            
        } catch (Exception e) {
            log.warn("⚠ 支付网关健康检查失败: {}", e.getMessage());
            return null;
        }
    }
    
    /**
     * 检查基础网关连接
     * @return true 表示可连接
     */
    public boolean isGatewayAvailable() {
        try {
            // 尝试 Ping
            String response = restTemplate.getForObject(gatewayUrl + "/ping", String.class);
            boolean available = "pong".equalsIgnoreCase(response.trim());
            
            if (available) {
                log.info("✓ 支付网关可用");
            } else {
                log.warn("⚠ 支付网关响应异常");
            }
            
            return available;
            
        } catch (Exception e) {
            log.error("✗ 支付网关不可用: {}", e.getMessage());
            return false;
        }
    }
}
```

#### PaymentException.java

```java
package com.qsgl365.payment.service;

public class PaymentException extends RuntimeException {
    
    public PaymentException(String message) {
        super(message);
    }
    
    public PaymentException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

---

### 4. 创建 REST 控制器

#### PaymentController.java

```java
package com.qsgl365.payment.controller;

import com.qsgl365.payment.model.PaymentRequest;
import com.qsgl365.payment.model.PaymentResponse;
import com.qsgl365.payment.service.PaymentGatewayService;
import com.qsgl365.payment.service.PaymentException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/payment")
public class PaymentController {
    
    @Autowired
    private PaymentGatewayService paymentGatewayService;
    
    /**
     * 创建扫码支付订单
     */
    @PostMapping("/qrcode")
    public ResponseEntity<?> createQRCodePayment(@RequestBody PaymentRequest request) {
        try {
            // 验证请求参数
            validatePaymentRequest(request);
            
            // 如果没有订单号，自动生成
            if (request.getOrderNo() == null || request.getOrderNo().isEmpty()) {
                request.setOrderNo("ORD_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8));
            }
            
            log.info("创建扫码支付订单: orderNo={}, amount={}", request.getOrderNo(), request.getAmount());
            
            PaymentResponse response = paymentGatewayService.createQRCodePayment(request);
            
            return ResponseEntity.ok(response);
            
        } catch (PaymentException e) {
            log.error("扫码支付创建失败: {}", e.getMessage());
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", e.getMessage(),
                "errorCode", "PAYMENT_ERROR"
            ));
        } catch (Exception e) {
            log.error("扫码支付创建异常", e);
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", "系统错误: " + e.getMessage(),
                "errorCode", "SYSTEM_ERROR"
            ));
        }
    }
    
    /**
     * 创建电子钱包支付订单
     */
    @PostMapping("/ewallet")
    public ResponseEntity<?> createEWalletPayment(@RequestBody PaymentRequest request) {
        try {
            validatePaymentRequest(request);
            
            if (request.getOrderNo() == null || request.getOrderNo().isEmpty()) {
                request.setOrderNo("EWALLET_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8));
            }
            
            log.info("创建电子钱包支付订单: orderNo={}, amount={}", request.getOrderNo(), request.getAmount());
            
            PaymentResponse response = paymentGatewayService.createEWalletPayment(request);
            
            return ResponseEntity.ok(response);
            
        } catch (PaymentException e) {
            log.error("电子钱包支付创建失败: {}", e.getMessage());
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", e.getMessage(),
                "errorCode", "PAYMENT_ERROR"
            ));
        } catch (Exception e) {
            log.error("电子钱包支付创建异常", e);
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", "系统错误: " + e.getMessage(),
                "errorCode", "SYSTEM_ERROR"
            ));
        }
    }
    
    /**
     * 查询订单状态
     */
    @GetMapping("/query/{orderNo}")
    public ResponseEntity<?> queryOrder(@PathVariable String orderNo) {
        try {
            if (orderNo == null || orderNo.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "isSuccess", false,
                    "message", "订单号不能为空",
                    "errorCode", "INVALID_ORDER_NO"
                ));
            }
            
            log.info("查询订单: orderNo={}", orderNo);
            
            PaymentResponse response = paymentGatewayService.queryOrderStatus(orderNo);
            
            return ResponseEntity.ok(response);
            
        } catch (PaymentException e) {
            log.error("订单查询失败: {}", e.getMessage());
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", e.getMessage(),
                "errorCode", "QUERY_ERROR"
            ));
        } catch (Exception e) {
            log.error("订单查询异常", e);
            return ResponseEntity.status(500).body(Map.of(
                "isSuccess", false,
                "message", "系统错误: " + e.getMessage(),
                "errorCode", "SYSTEM_ERROR"
            ));
        }
    }
    
    /**
     * 支付回调接口（农行服务器调用）
     */
    @PostMapping("/notify")
    public String handlePaymentNotify(HttpServletRequest request) {
        try {
            // 获取回调参数
            String orderNo = request.getParameter("OrderNo");
            String transactionId = request.getParameter("TransactionId");
            String status = request.getParameter("Status");
            String amount = request.getParameter("Amount");
            String sign = request.getParameter("Sign");
            
            log.info("收到支付回调: orderNo={}, status={}, transactionId={}", orderNo, status, transactionId);
            
            // 1. 验证签名（需要使用农行提供的公钥）
            // boolean isSignValid = verifySignature(request, sign);
            // if (!isSignValid) {
            //     log.warn("❌ 回调签名验证失败");
            //     return "FAIL";
            // }
            
            // 2. 根据状态更新订单
            if ("SUCCESS".equals(status)) {
                log.info("✓ 支付成功: orderNo={}, amount={}", orderNo, amount);
                // TODO: 更新数据库中的订单状态为已支付
                // updateOrderStatus(orderNo, "PAID", transactionId);
            } else if ("FAILED".equals(status)) {
                log.warn("⚠ 支付失败: orderNo={}", orderNo);
                // TODO: 更新数据库中的订单状态为已失败
                // updateOrderStatus(orderNo, "FAILED", transactionId);
            }
            
            // 3. 返回 SUCCESS
            return "SUCCESS";
            
        } catch (Exception e) {
            log.error("处理支付回调异常", e);
            return "FAIL";
        }
    }
    
    /**
     * 验证支付请求参数
     */
    private void validatePaymentRequest(PaymentRequest request) {
        if (request.getAmount() == null || request.getAmount() <= 0) {
            throw new PaymentException("支付金额必须大于 0");
        }
        
        if (request.getGoodsName() == null || request.getGoodsName().trim().isEmpty()) {
            throw new PaymentException("商品名称不能为空");
        }
        
        // 验证金额格式（最多 2 位小数）
        String amountStr = String.format("%.2f", request.getAmount());
        if (Double.parseDouble(amountStr) != request.getAmount()) {
            throw new PaymentException("支付金额最多只能有 2 位小数");
        }
    }
}
```

---

### 5. 配置文件 (application.yml)

```yaml
spring:
  application:
    name: payment-service
  
  # 数据库配置（如需）
  datasource:
    url: jdbc:mysql://localhost:3306/payment_db
    username: root
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver

logging:
  level:
    root: INFO
    com.qsgl365.payment: DEBUG
    org.springframework.web.client.RestTemplate: DEBUG

# 支付网关配置
payment:
  gateway:
    url: https://payment.qsgl.net
  merchant:
    id: 103881636900016
  notify:
    url: https://your-backend.com/api/payment/notify
  return:
    url: https://your-frontend.com/payment/result

# 服务器配置
server:
  port: 8080
  servlet:
    context-path: /
```

---

### 6. RestTemplate 配置

#### RestTemplateConfig.java

```java
package com.qsgl365.config;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import java.time.Duration;

@Configuration
public class RestTemplateConfig {
    
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder
            .setConnectTimeout(Duration.ofSeconds(10))
            .setReadTimeout(Duration.ofSeconds(10))
            .requestFactory(this::clientHttpRequestFactory)
            .build();
    }
    
    private ClientHttpRequestFactory clientHttpRequestFactory() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(10000);
        factory.setReadTimeout(10000);
        factory.setBufferRequestBody(true);
        return factory;
    }
}
```

---

### 7. 测试类

#### PaymentControllerTest.java

```java
package com.qsgl365.payment.controller;

import com.qsgl365.payment.model.PaymentRequest;
import com.qsgl365.payment.service.PaymentGatewayService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import com.fasterxml.jackson.databind.ObjectMapper;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(PaymentController.class)
public class PaymentControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private PaymentGatewayService paymentGatewayService;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    @Test
    public void testCreateQRCodePayment() throws Exception {
        PaymentRequest request = new PaymentRequest();
        request.setOrderNo("TEST_20260106_001");
        request.setAmount(100.00);
        request.setMerchantId("103881636900016");
        request.setGoodsName("测试商品");
        
        mockMvc.perform(post("/api/payment/qrcode")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.isSuccess").exists());
    }
}
```

---

## 📊 集成检查清单

- [ ] 添加了所有必要的 Maven 依赖
- [ ] 创建了所有数据模型类
- [ ] 实现了 `PaymentGatewayService`
- [ ] 创建了 `PaymentController`
- [ ] 配置了 `RestTemplate`
- [ ] 配置了 `application.yml`
- [ ] 实现了支付回调接口
- [ ] 编写了单元测试
- [ ] 测试了与网关的连接
- [ ] 验证了所有端点的功能

---

## 🚀 本地测试

### 1. 启动应用

```bash
mvn spring-boot:run
```

### 2. 测试创建订单

```bash
curl -X POST http://localhost:8080/api/payment/qrcode \
  -H "Content-Type: application/json" \
  -d '{
    "orderNo": "TEST_'$(date +%s)'",
    "amount": 0.01,
    "merchantId": "103881636900016",
    "goodsName": "测试商品"
  }' | jq '.'
```

### 3. 查询订单状态

```bash
curl -X GET http://localhost:8080/api/payment/query/TEST_1234567890 | jq '.'
```

---

## ⚙️ 生产环境部署

### 环境变量

```bash
export PAYMENT_GATEWAY_URL=https://payment.qsgl.net
export PAYMENT_MERCHANT_ID=103881636900016
export PAYMENT_NOTIFY_URL=https://your-production-domain.com/api/payment/notify
export PAYMENT_RETURN_URL=https://your-production-domain.com/payment/result
```

### Docker 容器化

```dockerfile
FROM openjdk:11-jre-slim

COPY target/payment-service-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

构建镜像：
```bash
docker build -t payment-service:1.0 .
```

运行容器：
```bash
docker run -d \
  -p 8080:8080 \
  -e PAYMENT_GATEWAY_URL=https://payment.qsgl.net \
  -e PAYMENT_MERCHANT_ID=103881636900016 \
  --name payment-service \
  payment-service:1.0
```

---

## 📞 故障排查

| 问题 | 解决方案 |
|------|---------|
| SSL 证书错误 | 确保 Java 信任了农行的 SSL 证书 |
| 连接超时 | 检查防火墙，确认网络连接 |
| 签名验证失败 | 使用正确的农行公钥进行验证 |
| 订单重复 | 确保订单号的唯一性 |

---

**集成指南版本**: 1.0  
**最后更新**: 2026-01-06

