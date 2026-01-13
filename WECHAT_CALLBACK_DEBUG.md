# 🔍 微信登录回调调试指南

## 📱 当前状态

✅ 微信客户端成功启动  
✅ 点击授权后微信关闭  
❌ Chrome调试界面没有收到code

## 🎯 问题分析

授权成功后，流程应该是：
1. 微信客户端关闭
2. 返回365酒水APP
3. **WXEntryActivity被调用**（关键！）
4. WXEntryActivity调用MainActivity的静态方法
5. MainActivity执行JS回调
6. Chrome看到code

**可能的问题**：WXEntryActivity没有被正确调用

---

## 🔍 调试步骤

### Step 1: 查看实时日志

打开一个新的PowerShell窗口：

```powershell
cd K:\365-android
.\adb logcat -c
.\adb logcat | Select-String -Pattern "WXEntry|MainActivity|微信|code"
```

保持这个窗口开着。

### Step 2: 重新测试微信登录

1. 在手机上点击"微信登录"
2. 在微信中点击"授权"
3. 观察PowerShell窗口的日志输出

### Step 3: 查看预期日志

**成功的日志应该包含**：

```
D/WebView: === JavaScript 调用微信登录 ===
D/WebView: 回调函数名: handleWeChatLoginResult
D/WebView: ✅ 微信登录请求已发送

[用户在微信中授权]

D/WXEntryActivity: WXEntryActivity onCreate
D/WXEntryActivity: onResp: errCode=0, type=...
D/WXEntryActivity: ✅ 微信登录成功，code=061xxx..., state=wechat_login_xxx
D/WebView: 微信登录成功回调: code=061xxx...
D/WebView: 🔔 准备调用微信登录回调
D/WebView: 调用微信登录回调: handleWeChatLoginResult({...})
D/WebView: 微信登录回调执行完成
```

**如果没有看到WXEntryActivity的日志**：
- 说明WXEntryActivity没有被调用
- 可能是AndroidManifest配置问题

---

## 🛠️ 快速修复方案

### 方案1: 检查AndroidManifest配置

WXEntryActivity必须正确配置：

```xml
<activity
    android:name=".wxapi.WXEntryActivity"
    android:exported="true"
    android:launchMode="singleTask"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```

### 方案2: 验证包名结构

WXEntryActivity必须在：
```
app/src/main/java/net/qsgl365/wxapi/WXEntryActivity.java
```

包名必须是：`net.qsgl365.wxapi`

### 方案3: 重新编译并安装

```powershell
cd K:\365-android
.\gradlew.bat clean assembleDebug
.\adb uninstall net.qsgl365
.\adb install app\build\outputs\apk\debug\app-debug.apk
```

---

## 📋 手动测试步骤（详细）

### 测试1: 基础调试

1. **打开ADB日志监控**
   ```powershell
   .\adb logcat -c
   .\adb logcat *:D | Select-String "net.qsgl365"
   ```

2. **点击微信登录**
   - 观察是否有 "微信登录请求已发送" 的日志

3. **在微信中授权**
   - 观察是否有 "WXEntryActivity onCreate" 的日志
   - 观察是否有 "微信登录成功，code=xxx" 的日志

4. **查看Chrome Console**
   - 是否有回调执行的日志？

### 测试2: 检查Activity返回

授权后：
1. 手机是否返回到365酒水APP？
2. 还是停留在微信或桌面？

**如果没有返回APP**：
- 可能是WXEntryActivity配置问题
- 或者launchMode设置不对

### 测试3: 手动检查签名

使用微信签名生成工具验证：
1. 安装工具APK
2. 输入包名：`net.qsgl365`
3. 获取签名
4. 对比是否为：`6c43d323ce2e7f35ae5d28551627b414`

**如果签名不匹配**：
- 微信会拒绝回调
- WXEntryActivity不会被调用

---

## 🎯 Chrome调试查看code的方法

### 方法1: Console日志

在Chrome DevTools Console中应该能看到：

```javascript
// 测试页面的日志
[微信登录] 收到回调: {code: "061xxx...", state: "wechat_login_xxx"}
✅ 微信登录成功
```

如果没有，说明JS回调没有执行。

### 方法2: 检查Network

Chrome DevTools → Network标签
- 看是否有发送code到服务器的请求？

### 方法3: 手动执行回调

如果怀疑回调函数有问题，在Console中手动测试：

```javascript
// 测试回调函数是否存在
console.log(typeof handleWeChatLoginResult);

// 手动调用回调
handleWeChatLoginResult({
    code: "test_code_123",
    state: "test_state"
});
```

如果手动调用成功，说明：
- 回调函数本身没问题
- 问题出在Android端没有调用JS回调

---

## 🔧 增强调试日志

如果仍然无法定位问题，我可以添加更多调试日志。

在测试页面的Console中执行：

```javascript
// 覆盖回调函数，添加详细日志
window.handleWeChatLoginResult = function(result) {
    console.log('🔔 收到微信登录回调！');
    console.log('📦 回调数据:', JSON.stringify(result, null, 2));
    console.log('📍 调用栈:', new Error().stack);
    
    if (result.code) {
        alert('成功！Code: ' + result.code);
    } else {
        alert('失败：' + JSON.stringify(result));
    }
};

console.log('✅ 回调函数已重新定义，请再次测试微信登录');
```

然后重新测试微信登录。

---

## 💡 常见问题排查

### Q1: 授权后微信直接退出，没有返回APP

**原因**: WXEntryActivity配置问题

**解决**: 检查AndroidManifest.xml中的配置

### Q2: 返回了APP但没有任何反应

**原因**: WXEntryActivity被调用但回调失败

**解决**: 查看logcat日志中的错误信息

### Q3: Chrome Console完全没有任何输出

**原因**: 
- JS回调函数不存在
- 或者WebView和Chrome没有正确连接

**解决**: 
1. 刷新Chrome DevTools连接
2. 检查回调函数是否定义
3. 手动测试回调函数

### Q4: 看到"签名不对"错误

**原因**: APK签名与微信开放平台不匹配

**解决**: 
1. 卸载重装最新版本
2. 验证签名是否正确

---

## 🚀 立即行动

**请执行以下操作**：

1. **打开PowerShell，启动日志监控**：
   ```powershell
   cd K:\365-android
   .\adb logcat -c
   .\adb logcat | Select-String "WXEntry|微信登录|code="
   ```

2. **在手机上重新测试**：
   - 点击"微信登录"
   - 在微信中点击"授权"

3. **观察日志输出**：
   - 是否有 "WXEntryActivity onCreate"？
   - 是否有 "微信登录成功，code=xxx"？
   - 是否有 "调用微信登录回调"？

4. **查看Chrome Console**：
   - 是否有收到回调的日志？

5. **截图并反馈**：
   - PowerShell日志截图
   - Chrome Console截图
   - 手机屏幕截图

---

**下一步**：根据日志输出判断问题在哪个环节

- 如果没有看到WXEntryActivity日志 → AndroidManifest配置问题
- 如果看到WXEntryActivity但没有回调 → MainActivity回调机制问题
- 如果看到回调执行但Chrome没显示 → WebView/JS回调问题
