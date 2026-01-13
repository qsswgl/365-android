# 微信登录功能实现文档

## 📋 目录
- [功能概述](#功能概述)
- [技术架构](#技术架构)
- [前端调用方法](#前端调用方法)
- [回调数据格式](#回调数据格式)
- [错误处理](#错误处理)
- [测试指南](#测试指南)
- [常见问题](#常见问题)

---

## 功能概述

### 实现内容
在365酒水Android APP中，通过JSBridge方式为WebView中的H5页面提供**微信登录**功能。

### 业务流程
```
┌─────────┐      ①调用JSBridge       ┌─────────┐
│ H5页面  │ ───────────────────────> │ Android │
│         │                          │   APP   │
└─────────┘                          └─────────┘
                                          │
                                          │ ②调起微信SDK
                                          ▼
                                     ┌─────────┐
                                     │  微信   │
                                     │ 客户端  │
                                     └─────────┘
                                          │
                                          │ ③用户授权
                                          │
                                          ▼
                                     ┌──────────┐
                                     │接收回调  │
                                     │获取code  │
                                     └──────────┘
                                          │
                                          │ ④回传给H5
┌─────────┐      ⑤JS回调执行        ┌─────────┐
│ H5页面  │ <─────────────────────  │ Android │
│         │                          │   APP   │
└─────────┘                          └─────────┘
```

### 微信开放平台信息
- **应用名称**: 365酒水（移动应用）
- **APPID**: `wx19d89333ff0d3efe`
- **AppSecret**: `f4566a825ef87dbb5add80e4a3c887d1` ⚠️ 仅在服务器端使用

---

## 技术架构

### 1. SDK集成
```gradle
// app/build.gradle
dependencies {
    implementation 'com.tencent.mm.opensdk:wechat-sdk-android:6.8.0'
}
```

### 2. 核心组件

#### MainActivity.java
- 初始化微信API
- 提供JSBridge接口 `weChatLogin()`
- 处理回调并执行JS回调函数

#### WXEntryActivity.java
- **路径**: `net.qsgl365.wxapi.WXEntryActivity`（强制要求）
- **作用**: 接收微信客户端的授权回调
- **配置**: `exported="true"`, `launchMode="singleTask"`

### 3. AndroidManifest配置
```xml
<activity
    android:name=".wxapi.WXEntryActivity"
    android:exported="true"
    android:launchMode="singleTask"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```

---

## 前端调用方法

### 基础调用
```javascript
// H5页面中调用
AndroidBridge.weChatLogin('onWeChatLoginResult');
```

### 完整示例
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>微信登录示例</title>
</head>
<body>
    <button onclick="startLogin()">微信登录</button>
    
    <script>
        // 启动微信登录
        function startLogin() {
            try {
                // 调用Android方法，传入回调函数名
                AndroidBridge.weChatLogin('handleLoginResult');
            } catch (e) {
                alert('调用失败: ' + e.message);
            }
        }
        
        // 处理登录结果（由Android回调）
        function handleLoginResult(result) {
            if (result.code) {
                // 登录成功
                console.log('授权码:', result.code);
                console.log('状态值:', result.state);
                
                // 将code发送到服务器
                sendCodeToServer(result.code);
                
            } else if (result.error) {
                // 登录失败
                switch(result.error) {
                    case 'CANCEL':
                        alert('您取消了登录');
                        break;
                    case 'DENIED':
                        alert('您拒绝了授权');
                        break;
                    case 'NOT_INSTALLED':
                        alert('请先安装微信客户端');
                        break;
                    default:
                        alert('登录失败: ' + result.message);
                }
            }
        }
        
        // 发送code到服务器换取access_token
        function sendCodeToServer(code) {
            fetch('/api/wechat/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ code: code })
            })
            .then(response => response.json())
            .then(data => {
                console.log('用户信息:', data);
                // 登录成功，跳转到个人中心等
            })
            .catch(error => {
                console.error('服务器请求失败:', error);
            });
        }
    </script>
</body>
</html>
```

### 调用参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| callbackName | String | 是 | JS全局回调函数名，登录完成后会调用此函数 |

**注意事项**:
- 回调函数名必须是**全局函数**（挂载在window上）
- 函数名只传字符串，不要加括号
- ✅ 正确: `'handleLoginResult'`
- ❌ 错误: `handleLoginResult()` 或 `'handleLoginResult()'`

---

## 回调数据格式

### 成功响应
```json
{
    "code": "wx_authorization_code_here",
    "state": "wechat_login_1702345678901"
}
```

**字段说明**:
- `code`: 微信授权码，有效期5分钟，用于换取access_token
- `state`: 状态标识，用于验证请求来源（时间戳格式）

**后续步骤**:
1. 将`code`发送到服务器
2. 服务器调用微信接口换取`access_token`
   ```
   GET https://api.weixin.qq.com/sns/oauth2/access_token?
       appid=wx19d89333ff0d3efe&
       secret=f4566a825ef87dbb5add80e4a3c887d1&
       code={code}&
       grant_type=authorization_code
   ```
3. 使用`access_token`获取用户信息

### 失败响应

#### 用户取消
```json
{
    "error": "CANCEL",
    "message": "用户取消了登录"
}
```

#### 用户拒绝
```json
{
    "error": "DENIED",
    "message": "用户拒绝了授权"
}
```

#### 微信未安装
```json
{
    "error": "NOT_INSTALLED",
    "message": "未安装微信客户端"
}
```

#### 其他错误
```json
{
    "error": "ERROR",
    "errCode": -1,
    "message": "微信登录失败"
}
```

---

## 错误处理

### 前端防护性编程

```javascript
function safeWeChatLogin(callbackName) {
    // 检查1: AndroidBridge是否存在
    if (typeof AndroidBridge === 'undefined') {
        alert('此功能仅在365酒水APP中可用');
        return;
    }
    
    // 检查2: weChatLogin方法是否存在
    if (typeof AndroidBridge.weChatLogin !== 'function') {
        alert('当前APP版本不支持微信登录');
        return;
    }
    
    // 检查3: 回调函数是否存在
    if (typeof window[callbackName] !== 'function') {
        console.error('回调函数不存在:', callbackName);
        return;
    }
    
    // 执行登录
    try {
        AndroidBridge.weChatLogin(callbackName);
    } catch (e) {
        console.error('调用异常:', e);
        alert('调用失败: ' + e.message);
    }
}

// 使用
safeWeChatLogin('myCallback');
```

### 错误码对照表

| 错误码 | 常量 | 说明 | 处理建议 |
|--------|------|------|----------|
| CANCEL | 用户取消 | 用户主动取消登录 | 不做处理或提示"取消了登录" |
| DENIED | 用户拒绝 | 用户拒绝授权 | 提示"需要授权才能使用" |
| NOT_INSTALLED | 未安装微信 | 设备未安装微信客户端 | 引导用户安装微信 |
| ERROR | 其他错误 | 网络、配置等错误 | 提示用户稍后重试 |

---

## 测试指南

### 1. 环境准备

#### 必需条件
- ✅ Android设备（真机，微信登录不支持模拟器）
- ✅ 已安装微信客户端（任意版本）
- ✅ 微信已登录账号

#### 安装APP
```bash
# 方法1: 通过ADB安装
cd K:\365-android
adb install -r app/build/outputs/apk/debug/app-debug.apk

# 方法2: 直接传文件到手机安装
# 将 app/build/outputs/apk/debug/app-debug.apk 复制到手机安装
```

### 2. 测试页面

#### 使用内置测试页面
APP已内置测试页面: `app/src/main/assets/pwa/wechat-login-test.html`

在WebView中访问:
```
file:///android_asset/pwa/wechat-login-test.html
```

或在MainActivity中加载:
```java
webView.loadUrl("file:///android_asset/pwa/wechat-login-test.html");
```

#### 测试页面功能
- ✅ 环境检测（AndroidBridge、方法可用性）
- ✅ 一键微信登录
- ✅ 实时操作日志
- ✅ 完整结果展示（JSON格式）
- ✅ 错误处理演示

### 3. 测试步骤

#### Step 1: 正常流程测试
1. 打开365酒水APP
2. 在WebView中加载测试页面
3. 点击"微信登录"按钮
4. 观察微信客户端是否启动
5. 在微信中点击"授权"
6. 检查是否返回APP并收到code

**预期结果**:
```json
{
    "code": "0616M9Ga1G3sGP05NNIa1....",
    "state": "wechat_login_1702345678901"
}
```

#### Step 2: 取消场景测试
1. 点击"微信登录"
2. 在微信授权页面点击"取消"
3. 检查返回结果

**预期结果**:
```json
{
    "error": "CANCEL",
    "message": "用户取消了登录"
}
```

#### Step 3: 拒绝场景测试
1. 点击"微信登录"
2. 在微信授权页面点击"拒绝"
3. 检查返回结果

**预期结果**:
```json
{
    "error": "DENIED",
    "message": "用户拒绝了授权"
}
```

#### Step 4: 未安装微信测试
1. 在未安装微信的设备上运行APP
2. 点击"微信登录"

**预期结果**:
```json
{
    "error": "NOT_INSTALLED",
    "message": "未安装微信客户端"
}
```

### 4. 调试技巧

#### 查看Android日志
```bash
# 过滤微信相关日志
adb logcat | grep -i wechat

# 过滤WebView日志
adb logcat | grep WebView

# 完整日志
adb logcat MainActivity:D WXEntryActivity:D *:S
```

**关键日志标识**:
- `🚀 启动微信登录` - 开始调用
- `✅ 微信登录成功` - 获取到code
- `⚠️ 用户取消登录` - 用户取消
- `❌ 微信登录失败` - 出现错误

#### Chrome DevTools调试
1. 启用WebView调试（已在MainActivity中启用）
2. Chrome浏览器打开 `chrome://inspect`
3. 选择365酒水APP的WebView
4. 在Console中查看日志

```javascript
// 查看回调数据
console.log(result);

// 检查AndroidBridge
console.log(typeof AndroidBridge);
console.log(typeof AndroidBridge.weChatLogin);
```

---

## 常见问题

### Q1: 点击登录后没有反应
**可能原因**:
- 微信未安装
- AndroidBridge未注入
- 回调函数名错误

**排查方法**:
```javascript
// 检查AndroidBridge
if (typeof AndroidBridge === 'undefined') {
    console.error('AndroidBridge不存在');
}

// 检查方法
if (typeof AndroidBridge.weChatLogin !== 'function') {
    console.error('weChatLogin方法不存在');
}

// 检查回调函数
if (typeof window['myCallback'] !== 'function') {
    console.error('回调函数不存在');
}
```

---

### Q2: 微信打开后没有返回APP
**可能原因**:
- WXEntryActivity未正确配置
- 包名不匹配
- APPID配置错误

**解决方法**:
1. 检查AndroidManifest.xml中的WXEntryActivity配置
2. 确认WXEntryActivity在 `net.qsgl365.wxapi` 包下
3. 验证APPID: `wx19d89333ff0d3efe`

---

### Q3: 收到错误 "微信版本过低"
**原因**: 微信版本太旧，不支持OpenSDK

**解决方法**: 
- 提示用户更新微信到最新版本
- 或移除版本检查（当前已移除）

---

### Q4: 回调函数没有执行
**可能原因**:
- 函数名拼写错误
- 函数不在全局作用域
- 函数定义在调用之后

**正确示例**:
```javascript
// ✅ 正确：全局函数
function myCallback(result) {
    console.log(result);
}

// ✅ 正确：挂载到window
window.myCallback = function(result) {
    console.log(result);
};

// ❌ 错误：局部函数
{
    function myCallback(result) {
        console.log(result);
    }
}

// ❌ 错误：箭头函数（虽然可用，但不推荐）
const myCallback = (result) => {
    console.log(result);
};
```

---

### Q5: 如何获取用户信息？
**流程**:
1. H5获取到`code`后发送给服务器
2. 服务器调用微信接口换取`access_token`
3. 使用`access_token`获取用户信息

**服务器端示例** (Node.js):
```javascript
// 1. 换取access_token
const tokenUrl = `https://api.weixin.qq.com/sns/oauth2/access_token?` +
    `appid=wx19d89333ff0d3efe&` +
    `secret=f4566a825ef87dbb5add80e4a3c887d1&` +
    `code=${code}&` +
    `grant_type=authorization_code`;

const tokenRes = await fetch(tokenUrl);
const tokenData = await tokenRes.json();

// 2. 获取用户信息
const userUrl = `https://api.weixin.qq.com/sns/userinfo?` +
    `access_token=${tokenData.access_token}&` +
    `openid=${tokenData.openid}&` +
    `lang=zh_CN`;

const userRes = await fetch(userUrl);
const userData = await userRes.json();

console.log('用户信息:', userData);
// {
//   openid: "o6_bmjrPTlm6...",
//   nickname: "张三",
//   sex: 1,
//   province: "广东",
//   city: "深圳",
//   country: "中国",
//   headimgurl: "http://...",
//   unionid: "oGRTfjP8h..."
// }
```

**⚠️ 安全提示**: 
- `AppSecret`（f4566a825ef87dbb5add80e4a3c887d1）**绝不能**暴露在前端
- **必须**在服务器端换取access_token
- 前端只传递`code`给服务器

---

### Q6: 如何在生产环境使用？
**检查清单**:
- [ ] 在微信开放平台配置应用包名
- [ ] 配置应用签名（MD5）
- [ ] 使用正式版APPID和AppSecret
- [ ] 测试正式版APK（签名后）
- [ ] 配置服务器回调接口
- [ ] 实现服务器端token换取逻辑

**获取应用签名**:
```bash
# 方法1: 使用微信提供的工具
# 下载：https://developers.weixin.qq.com/doc/oplatform/Downloads/Android_Resource.html

# 方法2: 使用keytool
keytool -list -v -keystore app/my-release-key.jks
```

---

## 附录

### A. 相关文档
- [微信开放平台官方文档](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html)
- [Android接入指南](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/Android.html)
- [微信登录流程说明](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Wechat_Login.html)

### B. 文件清单
| 文件路径 | 说明 |
|---------|------|
| `app/build.gradle` | 添加微信SDK依赖 |
| `app/AndroidManifest.xml` | 注册WXEntryActivity |
| `app/src/main/java/net/qsgl365/MainActivity.java` | JSBridge实现 |
| `app/src/main/java/net/qsgl365/wxapi/WXEntryActivity.java` | 微信回调Activity |
| `app/src/main/assets/pwa/wechat-login-test.html` | 测试页面 |
| `WECHAT_LOGIN_GUIDE.md` | 本文档 |

### C. 版本信息
- **SDK版本**: com.tencent.mm.opensdk:wechat-sdk-android:6.8.0
- **实现日期**: 2024年
- **Android版本**: minSdk 21, targetSdk 34
- **微信APPID**: wx19d89333ff0d3efe

---

**文档编写**: GitHub Copilot  
**最后更新**: 2024年
