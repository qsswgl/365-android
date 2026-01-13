# ✅ 农行微信支付集成检查清单

## 📦 集成完成情况

### 第一阶段：代码集成 ✅ 已完成

#### SDK库文件
- [x] TrustPayClient-V3.3.3.jar (194 KB) - 已复制到 app/libs/
- [x] commons-codec-1.3.jar (46 KB) - 已复制到 app/libs/
- [x] commons-httpclient-3.0.1.jar (282 KB) - 已复制到 app/libs/
- [x] commons-logging.jar (60 KB) - 已复制到 app/libs/

#### Java核心类
- [x] AbcPayConfig.java - 农行支付配置类
- [x] AbcWeChatPayManager.java - 微信支付管理类
- [x] AbcPayResultActivity.java - 支付结果回调Activity

#### MainActivity更新
- [x] createWeChatPay() - APP支付JSBridge方法
- [x] createWeChatJsApiPay() - 公众号支付JSBridge方法
- [x] createWeChatNativePay() - 扫码支付JSBridge方法

#### 配置文件
- [x] build.gradle - 已添加4个JAR依赖
- [x] AndroidManifest.xml - 已添加网络权限、文件权限、Activity声明

#### 文档
- [x] ABC_WECHAT_PAY_INTEGRATION.md - 详细集成文档（22 KB）
- [x] ABC_PAY_QUICK_REFERENCE.md - 快速参考卡（4 KB）
- [x] ABC_PAY_INTEGRATION_SUMMARY.md - 集成完成报告
- [x] abc_pay_test.html - 前端测试页面

---

### 第二阶段：配置商户信息 ⏳ 待完成

#### 需要从农行获取
- [ ] **商户号** (MerchantID)
  - 位置：`AbcPayConfig.java` 第73行
  - 当前值：`"103881909990001"` (示例值，需替换)
  
- [ ] **商户证书密码** (MerchantCertPassword)
  - 位置：`AbcPayConfig.java` 第78行
  - 当前值：`"changeit"` (示例值，需替换)
  
- [ ] **商户证书文件** (merchant.pfx)
  - 目标位置：`app/src/main/assets/merchant.pfx`
  - 状态：未放置
  
- [ ] **农行平台证书** (TrustPay.cer)
  - 目标位置：`app/src/main/assets/TrustPay.cer`
  - 状态：未放置

#### 配置步骤

**步骤1**: 联系农行获取商户资料
```
联系方式：农行技术支持
需要提供：公司营业执照、法人信息
获取内容：商户号、证书文件、证书密码
```

**步骤2**: 修改配置文件
```java
// 编辑 app/src/main/java/net/qsgl365/AbcPayConfig.java

// 第73行：替换商户号
public static final String MERCHANT_ID = "你从农行获取的商户号";

// 第78行：替换证书密码
public static final String MERCHANT_CERT_PASSWORD = "你从农行获取的密码";
```

**步骤3**: 放置证书文件
```bash
# Windows PowerShell

# 1. 确保assets目录存在
mkdir app\src\main\assets -Force

# 2. 复制证书文件（从农行获取的位置）
Copy-Item "你的证书路径\TrustPay.cer" "app\src\main\assets\"
Copy-Item "你的证书路径\merchant.pfx" "app\src\main\assets\"

# 3. 验证文件是否存在
dir app\src\main\assets\
```

---

### 第三阶段：编译测试 ⏳ 待完成

#### 编译APK
- [ ] 清理项目
  ```bash
  .\gradlew.bat clean
  ```

- [ ] 编译Release版本
  ```bash
  .\gradlew.bat assembleRelease
  ```

- [ ] 验证编译成功
  ```
  期望看到：BUILD SUCCESSFUL
  APK位置：app/build/outputs/apk/release/app-release.apk
  ```

#### 安装测试
- [ ] 安装APK到测试设备
  ```bash
  adb install -r app/build/outputs/apk/release/app-release.apk
  ```

- [ ] 启动应用
  ```bash
  adb shell am start -n net.qsgl365/.MainActivity
  ```

- [ ] 查看启动日志
  ```bash
  adb logcat | findstr "AbcPay"
  ```
  期望看到：
  ```
  AbcPayConfig: ========== 农行支付配置信息 ==========
  AbcPayConfig: 商户号: 你的商户号
  ```

---

### 第四阶段：功能测试 ⏳ 待完成

#### 测试1：打开测试页面
- [ ] 在WebView中访问：`file:///android_asset/pwa/abc_pay_test.html`
- [ ] 页面正常显示
- [ ] 表单字段可以填写

#### 测试2：APP支付
- [ ] 填写测试数据：
  - 金额：0.01
  - 商品描述：测试商品
  - 微信APPID：（替换为真实APPID）
- [ ] 点击"发起支付"按钮
- [ ] 查看返回结果
- [ ] 期望：ReturnCode = "0000"（成功）

#### 测试3：公众号支付
- [ ] 选择支付类型：公众号/小程序支付
- [ ] 填写用户OpenID
- [ ] 点击"发起支付"
- [ ] 验证返回结果

#### 测试4：扫码支付
- [ ] 选择支付类型：扫码支付
- [ ] 点击"发起支付"
- [ ] 验证返回二维码链接
- [ ] 期望：CodeUrl字段有值

#### 查看日志
- [ ] 打开日志监控
  ```bash
  adb logcat | findstr "WebView\|AbcPay"
  ```

- [ ] 期望看到的日志：
  ```
  WebView: === JavaScript 调用微信支付（APP） ===
  WebView: 订单号: ORDER...
  WebView: 金额: 0.01
  AbcWeChatPayManager: 请求参数构建完成，准备发送到农行服务器...
  AbcWeChatPayManager: 农行服务器返回: {...}
  WebView: 支付订单创建成功
  ```

---

## 🚨 常见问题检查

### 问题1：编译失败
```bash
# 检查：JAR包是否存在
dir app\libs\

# 应该看到4个JAR文件
# 如果缺少，重新执行：
Copy-Item "综合收银台接口包_V3.3.3软件包\WEB-INF\lib\*.jar" "app\libs\"
```

### 问题2：证书文件未找到
```bash
# 检查：assets目录中的证书
dir app\src\main\assets\

# 应该看到：
# TrustPay.cer
# merchant.pfx

# 如果没有，需要从农行获取并放置
```

### 问题3：商户号错误
```java
// 检查：AbcPayConfig.java 第73行
public static final String MERCHANT_ID = "你的商户号";

// 确认：
// 1. 商户号是从农行获取的真实值
// 2. 没有多余的空格或特殊字符
// 3. 与证书文件匹配
```

### 问题4：AndroidBridge未定义
```java
// 检查：MainActivity.java 中是否有以下代码
webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");

// 检查：WebView是否启用JavaScript
settings.setJavaScriptEnabled(true);
```

---

## 📊 进度统计

| 阶段 | 任务数 | 已完成 | 待完成 | 完成率 |
|------|--------|--------|--------|--------|
| 代码集成 | 13 | 13 | 0 | 100% ✅ |
| 配置商户 | 4 | 0 | 4 | 0% ⏳ |
| 编译测试 | 6 | 0 | 6 | 0% ⏳ |
| 功能测试 | 9 | 0 | 9 | 0% ⏳ |
| **总计** | **32** | **13** | **19** | **41%** |

---

## 🎯 立即可做的事情

### 优先级1：获取农行商户资料（最重要）
```
1. 联系农行技术支持
2. 申请测试环境商户号
3. 获取证书文件和密码
4. 预计时间：1-3个工作日
```

### 优先级2：配置商户信息
```
1. 修改 AbcPayConfig.java（5分钟）
2. 放置证书文件（2分钟）
3. 总计时间：10分钟
```

### 优先级3：编译和测试
```
1. 编译APK（5分钟）
2. 安装到设备（2分钟）
3. 功能测试（30分钟）
4. 总计时间：40分钟
```

---

## 📞 需要帮助？

### 查看文档
- 详细说明：`ABC_WECHAT_PAY_INTEGRATION.md`
- 快速参考：`ABC_PAY_QUICK_REFERENCE.md`
- 完成报告：`ABC_PAY_INTEGRATION_SUMMARY.md`

### 查看日志
```bash
# 实时监控
adb logcat | findstr "AbcPay\|WebView"

# 保存到文件
adb logcat > abc_pay_debug.txt
```

### 农行技术支持
- 测试环境：https://pay.test.abchina.com/easyebus/
- 备用地址：https://bank.u51.com/ebus-two/docs/#/

---

## ✨ 集成亮点总结

✅ **完整封装** - 3个简洁的JavaScript API  
✅ **参数简化** - 最少5个参数即可发起支付  
✅ **多种支付** - APP、公众号、扫码全支持  
✅ **错误处理** - 完善的异常捕获  
✅ **环境切换** - 测试/生产一键切换  
✅ **文档齐全** - 详细文档+快速参考+测试页面  
✅ **调试友好** - 详细日志输出  

---

**当前状态**: 代码集成完成 ✅，等待配置商户信息 ⏳

**下一步**: 联系农行获取商户号和证书文件

**预计完成时间**: 获得商户资料后1小时内可完成配置和测试
