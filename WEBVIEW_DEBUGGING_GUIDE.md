# WebView 远程调试指南

## ✅ 调试功能状态

### 已启用功能
- **WebView 远程调试**: ✅ 已在 MainActivity.onCreate() 中启用
  ```java
  if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
      WebView.setWebContentsDebuggingEnabled(true);
      Log.d("WebView", "WebView 远程调试已开启，可在 Chrome 中访问 chrome://inspect 查看");
  }
  ```

- **LogCat 日志记录**: ✅ 已实现详细的错误日志
  - MainActivity.java 日志标签: "WebView"
  - WebViewClient onReceivedError() 和 onReceivedHttpError() 已增强
  - JavaScript 控制台消息已捕获
  
### LogCat 日志验证
最新启动时的关键日志（01-05 17:09:37）：
```
D WebView : === APP 启动 ===
D WebView : WebView 远程调试已开启，可在 Chrome 中访问 chrome://inspect 查看
D WebView : === 开始加载远程 PWA 资源 ===
D WebView : URL: https://www.qsgl.net/html/365app/#/
D WebView : === Activity onResume 被调用 ===
```

页面加载成功的日志：
```
D WebView : 页面加载完成: https://www.qsgl.net/html/365app/#/
D WebView : 当前模式: PWA
```

## 📊 应用信息
- **包名**: net.qsgl365
- **进程 ID**: 21104（当前运行）
- **SDK 级别**: KITKAT+ (支持 WebView 调试)
- **WebView 版本**: 143.0.7499.35

## 🔧 调试连接方式

### 方法 1: Chrome 远程检查（推荐）
1. **在 Chrome 中打开调试器**:
   ```
   chrome://inspect
   ```

2. **验证 ADB 连接**:
   ```powershell
   .\adb devices -l
   ```
   输出应包含: `192.168.1.129:42797 device ...`

3. **应用必须在运行**:
   ```powershell
   .\adb shell am start -n net.qsgl365/.MainActivity
   ```

4. **故障排查**:
   - 关闭所有 Chrome DevTools 标签页
   - 重启 ADB: `.\adb kill-server && .\adb start-server`
   - 重新连接: `.\adb connect 192.168.1.129:42797`
   - 刷新 chrome://inspect 页面

### 方法 2: 本地端口转发（备选）
```powershell
# 设置 forward（如果需要）
.\adb forward --remove-all
.\adb forward tcp:9222 localabstract:net.qsgl365_devtools_remote

# 然后在 Chrome 中打开（基于实际端口）
chrome://inspect/#devices
```

## 📱 当前网络状态
- **应用 URL**: https://www.qsgl.net/html/365app/#/
- **加载状态**: ✅ 成功加载
- **网络模式**: PWA 模式激活
- **已知网络问题**:
  - ERR_BLOCKED_BY_ORB: 某些资源被 CORS 策略阻止
  - 404 错误: favicon.ico 和某些静态资源

## 🎯 JavaScript Bridge 功能
以下 JavaScript 方法可从网页调用：

```javascript
// 获取手机号
AndroidBridge.getPhoneNumber()

// 获取设备信息
AndroidBridge.getDeviceInfo()

// 保存用户数据
AndroidBridge.saveUserData(phoneNumber, userId, userName, userInfo)

// 获取保存的用户数据
AndroidBridge.getSavedUserData()

// 检查用户注册状态
AndroidBridge.isUserRegistered()

// 启动导航（GPS）
AndroidBridge.startNavigation(lat1, lng1, lat2, lng2)

// 微信支付
AndroidBridge.createWeChatPay(payData)

// 农行支付
AndroidBridge.createAbcPay(payData)
```

## 🐛 常见问题排查

### Q: chrome://inspect 连接成功但看不到页面
**A**: 
1. 确认应用已启动并运行
2. 检查 LogCat 中是否有 "WebView 远程调试已开启" 日志
3. 确保 ADB 连接正常: `.\adb devices`
4. 尝试强制刷新浏览器

### Q: 看不到应用进程
**A**:
```powershell
# 检查应用是否运行
.\adb shell ps | findstr qsgl365

# 启动应用
.\adb shell am start -n net.qsgl365/.MainActivity

# 强制停止并重启
.\adb shell am force-stop net.qsgl365
.\adb shell am start -n net.qsgl365/.MainActivity
```

### Q: 网络资源加载失败
**A**:
- 检查设备网络连接: `.\adb shell ping -c 3 8.8.8.8`
- 确认应用有 INTERNET 权限（已配置）
- 检查 HTTPS 证书是否有问题
- 查看 LogCat 中的 HTTP 错误详情

## 📝 最近更改日期
- **最后更新**: 2026-01-05 17:09:37
- **构建时间**: 1m 6s
- **构建状态**: ✅ BUILD SUCCESSFUL

## 🚀 下一步操作

1. **在 Chrome DevTools 中调试**:
   - 打开 `chrome://inspect`
   - 点击 "inspect" 按钮查看应用页面
   - 在 Elements 面板查看 DOM
   - 在 Console 面板执行 JavaScript

2. **测试支付流程**:
   - 检查微信支付 JavaScript 接口是否正确调用
   - 测试农行支付功能
   - 验证支付回调处理

3. **监控网络流量**:
   - 使用 Chrome DevTools 的 Network 标签查看网络请求
   - 检查 API 响应状态和数据

4. **查看实时日志**:
   ```powershell
   .\adb logcat -c
   .\adb shell am start -n net.qsgl365/.MainActivity
   Start-Sleep -Seconds 2
   .\adb logcat -d | Select-String "WebView"
   ```

