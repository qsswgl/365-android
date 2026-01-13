# 微信登录故障排查指南

## 🔍 当前问题诊断

### 症状
- 点击"微信登录"按钮
- 页面显示错误：`NOT_INSTALLED` - "未安装微信客户端"

### 可能原因

#### 1. 微信确实未安装 ⚠️
**检查方法**：
```bash
# 检查设备是否安装微信
adb shell pm list packages | findstr tencent
```

**预期输出**（如果已安装）：
```
package:com.tencent.mm
package:com.tencent.mobileqq  # 如果安装了QQ
```

**解决方法**：
- 在测试设备上安装微信客户端
- 微信下载地址：https://weixin.qq.com/

---

#### 2. 微信API初始化失败 🔧
**可能原因**：
- APPID配置错误
- 微信SDK未正确集成
- 权限不足

**检查步骤**：

**Step 1**: 查看初始化日志
```bash
adb logcat | findstr "微信API"
```

**预期输出**（成功）：
```
D/WebView: ✅ 微信API注册成功，APPID: wx19d89333ff0d3efe
```

**预期输出**（失败）：
```
E/WebView: ❌ 微信API注册失败
E/WebView: ❌ 微信API初始化异常: xxxxx
```

**Step 2**: 检查APPID配置
打开 `MainActivity.java`，确认：
```java
public static final String WECHAT_APP_ID = "wx19d89333ff0d3efe";
```

**Step 3**: 检查微信SDK依赖
打开 `app/build.gradle`，确认：
```gradle
dependencies {
    implementation 'com.tencent.mm.opensdk:wechat-sdk-android:6.8.0'
}
```

---

#### 3. 包名或签名不匹配 🔐
**微信开放平台要求**：
- 应用包名：`net.qsgl365`
- 应用签名：需要在微信开放平台配置

**检查当前包名**：
```bash
adb shell dumpsys package net.qsgl365 | findstr package
```

**检查应用签名**：
```bash
# Debug签名
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release签名
keytool -list -v -keystore app\my-release-key.jks
```

**获取MD5签名**（用于微信开放平台）：
```bash
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore | findstr MD5
```

---

#### 4. WXEntryActivity配置问题 📋
**必需条件**：
- 类必须在 `net.qsgl365.wxapi` 包下
- 类名必须是 `WXEntryActivity`
- AndroidManifest.xml中必须配置

**检查AndroidManifest.xml**：
```xml
<activity
    android:name=".wxapi.WXEntryActivity"
    android:exported="true"
    android:launchMode="singleTask"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```

**验证文件存在**：
```bash
dir app\src\main\java\net\qsgl365\wxapi\WXEntryActivity.java
```

---

## 🛠️ 调试步骤

### Step 1: 启动日志监控
```bash
# 打开一个新终端窗口
cd K:\365-android
.\adb logcat -c
.\adb logcat MainActivity:D WebView:D WXEntryActivity:D *:E
```

### Step 2: 打开APP并测试
1. 在设备上打开365酒水APP
2. 加载测试页面：`file:///android_asset/pwa/wechat-login-test.html`
3. 点击"微信登录"按钮

### Step 3: 观察日志输出

**正常流程日志**：
```
D/WebView: === JavaScript 调用微信登录 ===
D/WebView: 回调函数名: handleWeChatLoginResult
D/WebView: 🔔 准备调用微信登录回调
D/WebView: WebView状态: 已初始化
D/WebView: ✅ 微信登录请求已发送
```

**错误流程日志**：
```
D/WebView: === JavaScript 调用微信登录 ===
E/WebView: ❌ 微信API未初始化，尝试重新初始化
D/WebView: ✅ 微信API注册成功，APPID: wx19d89333ff0d3efe
E/WebView: ❌ 微信未安装
D/WebView: 🔔 准备调用微信登录回调
D/WebView: 回调数据: {"error":"NOT_INSTALLED","message":"未安装微信客户端"}
```

### Step 4: 根据日志定位问题

| 日志内容 | 问题 | 解决方法 |
|---------|------|---------|
| `❌ 微信API未初始化` | API初始化失败 | 检查APPID配置 |
| `❌ 微信API注册失败` | APPID错误或SDK问题 | 验证APPID、重新编译 |
| `❌ 微信未安装` | 设备未安装微信 | 安装微信客户端 |
| `❌ 微信登录请求发送失败` | 微信SDK调用失败 | 检查包名、签名配置 |

---

## 📱 检查微信安装状态

### 方法1: ADB命令
```bash
# 检查微信是否安装
adb shell pm list packages | findstr tencent

# 检查微信包信息
adb shell dumpsys package com.tencent.mm | findstr versionName
```

### 方法2: 在APP中检查
在Chrome DevTools Console中执行：
```javascript
// 调用Android方法检查
AndroidBridge.weChatLogin('test');

// 查看日志
// 如果看到 "❌ 微信未安装" 则确实未安装
```

### 方法3: 手动验证
- 在设备桌面查找"微信"图标
- 或在应用列表中搜索"WeChat"

---

## 🔧 常见修复方案

### 修复1: 重新安装微信
如果设备未安装微信：
1. 从应用商店下载微信
2. 或访问：https://weixin.qq.com/
3. 安装后重新测试

### 修复2: 重新编译APP
如果微信已安装但仍报错：
```bash
cd K:\365-android
.\gradlew.bat clean
.\gradlew.bat assembleDebug
.\adb install -r app\build\outputs\apk\debug\app-debug.apk
```

### 修复3: 清空APP数据
```bash
# 清空应用数据和缓存
adb shell pm clear net.qsgl365

# 重新安装
.\adb install -r app\build\outputs\apk\debug\app-debug.apk
```

### 修复4: 检查权限
确保AndroidManifest.xml中有必需的权限：
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 修复5: 更新微信SDK
如果使用较旧的设备，可能需要降级SDK：
```gradle
// 尝试使用较旧版本
implementation 'com.tencent.mm.opensdk:wechat-sdk-android:6.6.4'
```

---

## 🧪 测试清单

在报告问题前，请完成以下检查：

- [ ] 设备已安装微信客户端（版本 > 6.0）
- [ ] 微信已登录账号
- [ ] APP已正确安装（显示365酒水图标）
- [ ] WebView已正确加载测试页面
- [ ] Chrome DevTools显示无JavaScript错误
- [ ] AndroidBridge已成功注入（`typeof AndroidBridge !== 'undefined'`）
- [ ] 已查看logcat日志输出
- [ ] 已尝试重新安装APP

---

## 📊 收集诊断信息

如果问题仍未解决，请收集以下信息：

### 1. 设备信息
```bash
adb shell getprop ro.build.version.release  # Android版本
adb shell getprop ro.product.model          # 设备型号
```

### 2. APP信息
```bash
adb shell dumpsys package net.qsgl365 | findstr version
```

### 3. 微信信息
```bash
adb shell dumpsys package com.tencent.mm | findstr versionName
```

### 4. 完整日志
```bash
adb logcat -d > logcat.txt
```

### 5. 截图
- 测试页面错误截图
- Chrome DevTools Console截图
- 设备应用列表截图（显示微信已安装）

---

## 🎯 快速验证命令

复制以下命令一键检查所有项目：

```bash
# === 1. 检查微信是否安装 ===
echo "检查微信安装..."
adb shell pm list packages | findstr tencent

# === 2. 检查APP是否安装 ===
echo "检查365酒水APP..."
adb shell pm list packages | findstr qsgl365

# === 3. 检查设备信息 ===
echo "设备信息..."
adb shell getprop ro.build.version.release
adb shell getprop ro.product.model

# === 4. 启动日志监控 ===
echo "启动日志监控..."
adb logcat -c
adb logcat MainActivity:D WebView:D WXEntryActivity:D *:E
```

---

## 💡 提示

### Debug版本 vs Release版本
- **Debug版本**：使用debug签名，微信可能需要单独配置
- **Release版本**：使用正式签名，需要在微信开放平台配置MD5签名

### 测试建议
1. 先确保设备已安装微信并登录
2. 使用真机测试（模拟器可能不支持微信登录）
3. 查看logcat实时日志
4. 使用Chrome DevTools查看JavaScript错误

### 微信开放平台配置
在正式使用前，需要在微信开放平台配置：
- 应用包名：`net.qsgl365`
- 应用签名：从keystore获取的MD5值
- 配置地址：https://open.weixin.qq.com/

---

**文档更新**: 2024年  
**适用版本**: 微信SDK 6.8.0, Android 5.0+
