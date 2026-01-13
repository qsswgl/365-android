# WebView 远程调试 - 完整解决方案总结

## ✅ 已完成的工作

### 1. WebView 远程调试已启用
在 `MainActivity.java` 第 422 行已添加调试代码：

```java
if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
    WebView.setWebContentsDebuggingEnabled(true);
    Log.d("WebView", "WebView 远程调试已开启，可在 Chrome 中访问 chrome://inspect 查看");
}
```

**验证**:  LogCat 清晰显示:
```
D WebView : WebView 远程调试已开启，可在 Chrome 中访问 chrome://inspect 查看
```

### 2. 应用信息
- **包名**: net.qsgl365
- **主 Activity**: net.qsgl365.MainActivity
- **最新 APK**: app-release.apk (已编译并部署)
- **WebView 版本**: 143.0.7499.35
- **API 级别支持**: KITKAT 及以上（完全支持远程调试）

### 3. 增强的错误日志
以下方法已增强日志记录：
- `onReceivedError()` - 记录网络错误详情
- `onReceivedHttpError()` - 记录 HTTP 错误状态码
- `onConsoleMessage()` - 捕获页面 JavaScript 控制台消息
- `onPageStarted()` - 页面开始加载
- `onPageFinished()` - 页面加载完成

### 4. 页面加载验证
应用成功加载页面：
```
URL: https://www.qsgl.net/html/365app/#/
模式: PWA 模式激活
状态: ✅ 页面加载完成
```

## 🚀 如何使用 Chrome 远程调试

### 快速步骤

#### 第 1 步: 确保应用在运行

**检查应用是否运行**:
```powershell
cd K:\365-android
.\adb devices -l
# 应该看到: 192.168.1.129:42797 device ...
```

**如果设备不在线，重新连接**:
```powershell
.\adb connect 192.168.1.129:42797
```

**启动应用**:
```powershell
.\adb shell am start -n net.qsgl365/.MainActivity
```

#### 第 2 步: 打开 Chrome 调试器

1. 打开 **Google Chrome** 浏览器
2. 在地址栏输入: **`chrome://inspect`**
3. 按下 **Enter** 键

#### 第 3 步: 查看并调试您的应用

在 `chrome://inspect` 页面中，您应该看到：
- **左侧面板**: 您连接的设备和应用
- **右侧面板**: WebView 页面列表（应包含应用加载的页面）

点击 **"inspect"** 按钮即可打开开发者工具，进行以下操作：
- 👁️ **Elements 面板**: 查看和编辑 HTML
- 🔍 **Console 面板**: 查看 JavaScript 日志和错误
- 📱 **Responsive Design**: 调整视口大小  
- 🌐 **Network 标签**: 查看网络请求
- 💾 **Storage 标签**: 查看 LocalStorage、SessionStorage 等

## ⚠️ 如果看不到页面列表

### 问题排查清单

- [ ] **设备未连接**: 运行 `.\adb devices -l` 验证连接
  ```powershell
  # 如果为空，重新连接
  .\adb connect 192.168.1.129:42797
  ```

- [ ] **应用未运行**: 启动应用
  ```powershell
  .\adb shell am start -n net.qsgl365/.MainActivity
  ```

- [ ] **Chrome 缓存**: 清空 Chrome 缓存
  - 关闭所有 Chrome 窗口
  - 在 Windows 中找到 Chrome 数据文件夹: `C:\Users\<用户名>\AppData\Local\Google\Chrome`
  - 删除 `Default\Cache` 文件夹
  - 重启 Chrome 并打开 `chrome://inspect`

- [ ] **ADB 连接不稳定**: 重启 ADB 服务
  ```powershell
  .\adb kill-server
  Start-Sleep -Seconds 2
  .\adb start-server
  Start-Sleep -Seconds 2
  .\adb connect 192.168.1.129:42797
  ```

- [ ] **Chrome 开发者模式**: 确保启用
  - Chrome 菜单 → 更多工具 → 开发者工具（F12）
  - 或直接打开 `chrome://inspect`

- [ ] **防火墙问题**: 确保 Windows 防火墙允许 ADB
  ```powershell
  # 在 Windows 防火墙中允许 adb.exe 通过
  ```

### 完全重启流程

如果上述步骤都不能解决，尝试完全重启：

```powershell
# 1. 停止应用
.\adb shell am force-stop net.qsgl365

# 2. 重启 ADB 守护进程
.\adb kill-server
Start-Sleep -Seconds 3
.\adb start-server

# 3. 重新连接设备
.\adb connect 192.168.1.129:42797
Start-Sleep -Seconds 2

# 4. 验证连接
.\adb devices -l

# 5. 启动应用
.\adb shell am start -n net.qsgl365/.MainActivity

# 6. 在 Chrome 中打开 chrome://inspect
# 7. 刷新页面（F5 或 Ctrl+R）
```

## 📊 JavaScript Bridge - 可用方法

您可以在 Chrome DevTools Console 中调用以下方法来测试应用功能：

```javascript
// 获取手机号
AndroidBridge.getPhoneNumber()

// 获取设备信息
AndroidBridge.getDeviceInfo()

// 保存用户数据
AndroidBridge.saveUserData(
  '18567860365',  // 手机号
  '234884',       // 用户 ID
  '用户昵称',      // 用户名
  '{}'            // 用户信息 JSON
)

// 获取保存的用户数据
AndroidBridge.getSavedUserData()

// 检查用户是否已注册
AndroidBridge.isUserRegistered()

// 启动导航
AndroidBridge.startNavigation(
  '36.1157543367609',    // 起点纬度
  '114.35459875650236',  // 起点经度
  '36.1157543367609',    // 终点纬度
  '114.35459875650236'   // 终点经度
)

// 微信支付
AndroidBridge.createWeChatPay(JSON.stringify({
  appid: 'xxx',
  noncestr: 'xxx',
  package: 'xxx',
  // ... 其他参数
}))

// 农行支付
AndroidBridge.createAbcPay(JSON.stringify({
  // 支付参数
}))
```

## 📱 当前应用状态

| 项目 | 状态 | 详情 |
|------|------|------|
| WebView 调试 | ✅ 启用 | 可在 Chrome DevTools 中访问 |
| 应用加载 | ✅ 成功 | URL: https://www.qsgl.net/html/365app/#/ |
| PWA 模式 | ✅ 激活 | 应用工作在 PWA 模式 |
| JavaScript Bridge | ✅ 就绪 | 所有方法可用 |
| 日志记录 | ✅ 完整 | LogCat 中记录了详细信息 |
| 设备连接 | ⚠️ 需要重连 | 最后一次成功连接: 192.168.1.129:42797 |

## 🔗 相关文件

- **主活动**: `app/src/main/java/net/qsgl365/MainActivity.java`
- **调试指南**: `WEBVIEW_DEBUGGING_GUIDE.md`（本目录）
- **APK 位置**: `app/build/outputs/apk/release/app-release.apk`
- **诊断脚本**: `quick_debug_check.ps1`

## 💡 常见用例

### 调试 JavaScript 错误
1. 打开 `chrome://inspect`
2. 点击应用旁的 "inspect"
3. 切换到 **Console** 标签
4. 查看错误消息和日志

### 审查 HTML 结构
1. 打开 `chrome://inspect`
2. 点击应用旁的 "inspect"  
3. 在 **Elements** 标签中查看 DOM
4. 修改元素即时查看效果（仅在调试会话中）

### 监控网络请求
1. 打开 `chrome://inspect`
2. 点击应用旁的 "inspect"
3. 切换到 **Network** 标签
4. 刷新应用页面查看所有网络请求

### 测试支付流程
1. 在 Console 中执行 JavaScript Bridge 方法
2. 查看 LogCat 日志了解应用响应
3. 验证支付接口调用是否正确

## 📞 支持

如有问题，请查看以下日志来源：
- **Chrome DevTools Console**: 页面 JavaScript 错误和日志
- **Android Logcat**: 应用错误和调试信息
  ```powershell
  .\adb logcat -d | Select-String "WebView|net.qsgl365"
  ```

---

**最后更新**: 2026-01-05 17:09:37  
**APK 版本**: app-release.apk (已验证)
