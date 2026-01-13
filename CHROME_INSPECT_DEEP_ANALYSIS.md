# 深度分析：Chrome Inspect 中的资源加载错误

## 📸 截图中看到的具体错误

### Network 标签中的失败资源（红色标记）

```
❌ index.e4da2d2b.css           - CSS 样式表
❌ chunk-vendors.b7a7584b.js    - Vue.js 和第三方库
❌ index.ac79604b.js            - 应用主脚本
```

### DevTools 右侧错误

```
❌ No resource with given identifier found
```

这个错误通常出现在 DevTools 试图加载某个特定资源的源代码时。

## 🔍 原因分析

### 可能原因 1: Service Worker 缓存策略问题

**症状**: 
- CSS 和 JS 文件返回 200 但内容为空或过期
- 文件名带有 hash（.css、.js）但版本不匹配

**解决方案**:
```javascript
// 在 Console 中执行：清空所有缓存
self.clients.matchAll().then(clients => {
  clients.forEach(client => client.navigate('/'));
});

// 删除所有 Service Workers
navigator.serviceWorker.getRegistrations().then(regs => {
  regs.forEach(reg => reg.unregister());
});
```

### 可能原因 2: PWA Manifest 配置错误

**症状**:
- 资源路径在 manifest.json 中配置不正确
- Base URL 不匹配

**检查方法**:
```javascript
// 在 Console 中查看 manifest
fetch('/manifest.json').then(r => r.json()).then(console.log);
```

### 可能原因 3: CORS 跨域限制

**症状**:
- Network 标签显示资源被阻止
- 控制台有 CORS 相关错误

**解决方案** (在 Network 标签查看):
1. 点击失败的资源
2. 查看 **Headers** 标签
3. 检查 `Access-Control-Allow-Origin` 头
4. 如果缺失，需要服务器添加 CORS 头

### 可能原因 4: 开发构建 vs 生产构建

**症状**:
- 本地开发正常，但在设备上出错
- 资源路径在构建过程中改变

**检查**:
```javascript
// 在 Console 中检查当前 URL
console.log(window.location);
console.log(document.baseURI);
```

## 🛠️ 逐步调试指南

### 步骤 1: 在 Console 中获取错误详情

```javascript
// 检查所有加载的资源
console.log(performance.getEntriesByType('resource'));

// 检查失败的资源
const resources = performance.getEntriesByType('resource');
const failed = resources.filter(r => !r.responseEnd);
console.log('Failed resources:', failed);

// 检查 Service Worker 状态
navigator.serviceWorker.getRegistrations().then(regs => {
  console.log('Service Workers:', regs);
});
```

### 步骤 2: 检查 Network 标签的详细信息

对于每个失败的资源：

1. **点击资源名称** → 查看详情面板
2. **查看 Headers 标签**:
   - Request URL: 确认 URL 正确
   - Status: 应该是 200，不是 404 或 5xx
3. **查看 Response 标签**:
   - 检查响应内容是否为空
   - 检查 Content-Type 是否正确
4. **查看 Timing 标签**:
   - 检查请求是否超时
   - 检查 DNS、连接时间

### 步骤 3: 验证网络连接

```powershell
# 在设备上测试网络
.\adb shell ping -c 3 www.qsgl.net

# 测试 DNS 解析
.\adb shell getprop | grep dns

# 用 curl 测试资源下载
.\adb shell curl -I https://www.qsgl.net/html/365app/
```

### 步骤 4: 检查应用日志

```powershell
# 清空日志
.\adb logcat -c

# 启动应用
.\adb shell am start -n net.qsgl365/.MainActivity

# 等待并获取日志
Start-Sleep -Seconds 3
.\adb logcat -d | Select-String "WebView|chromium|XMLHttpRequest|fetch|ERR_" -Context 3
```

## 🎯 根据错误类型的解决方案

### 如果看到 "ERR_BLOCKED_BY_ORB"

**ORB = Opaque Response Blocking**

这是 Chrome 的安全特性。解决方案：

```javascript
// 使用正确的 fetch 选项
fetch(url, {
  mode: 'cors',
  credentials: 'include'
})
.then(r => r.json())
.catch(e => console.error('CORS error:', e));
```

### 如果看到 "net::ERR_NAME_NOT_RESOLVED"

**DNS 解析失败**

解决方案：
```powershell
# 检查 DNS 设置
.\adb shell getprop net.dns1
.\adb shell getprop net.dns2

# 测试 DNS
.\adb shell nslookup www.qsgl.net

# 切换到 Google DNS
.\adb shell setprop net.dns1 8.8.8.8
.\adb shell setprop net.dns2 8.8.4.4
```

### 如果看到 "net::ERR_HTTP2_PROTOCOL_ERROR"

**HTTP/2 问题**

解决方案：
1. 检查服务器 HTTP/2 配置
2. 尝试降级到 HTTP/1.1
3. 在应用中添加：
   ```java
   webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
   ```

## 📊 问题严重程度评估

| 问题 | 严重程度 | 影响范围 | 解决时间 |
|------|---------|---------|---------|
| CSS 加载失败 | 中等 | 页面样式 | 5-10 分钟 |
| JS 加载失败 | 高 | 功能障碍 | 10-20 分钟 |
| CORS 错误 | 中等 | 数据请求 | 15-30 分钟 |
| DNS 失败 | 高 | 全局 | 5 分钟 |
| Service Worker 问题 | 中等 | 离线功能 | 10-15 分钟 |

## ✅ 完整修复流程

### 第 1 轮: 快速清理

```javascript
// 在 Console 中执行
navigator.serviceWorker.getRegistrations()
  .then(registrations => {
    Promise.all(registrations.map(r => r.unregister()));
  });

localStorage.clear();
sessionStorage.clear();

// 2 秒后刷新
setTimeout(() => location.reload(true), 2000);
```

### 第 2 轮: 验证网络

```powershell
# 检查网络连接
.\adb shell ping -c 3 8.8.8.8

# 测试资源服务器
.\adb shell ping -c 3 www.qsgl.net

# 如果 ping 失败，尝试切换 DNS
.\adb shell setprop net.dns1 8.8.8.8
.\adb shell setprop net.dns2 114.114.114.114
```

### 第 3 轮: 清空应用缓存

```powershell
# 清空应用数据
.\adb shell pm clear net.qsgl365

# 重启应用
.\adb shell am start -n net.qsgl365/.MainActivity
```

### 第 4 轮: 验证修复

刷新 chrome://inspect 页面，检查：
- [ ] Network 标签中无红色项
- [ ] Console 中无红色错误
- [ ] 页面完整加载
- [ ] 所有功能可用

## 🔗 相关资源

- **Chrome DevTools Network 文档**: https://developer.chrome.com/docs/devtools/network/
- **Service Worker 缓存策略**: https://web.dev/workbox/modules/
- **CORS 解决方案**: https://enable-cors.org/

## 📋 检查清单

- [ ] 验证网络连接（ping 测试）
- [ ] 清空 Service Worker
- [ ] 清空浏览器缓存
- [ ] 清空应用数据
- [ ] 检查 DNS 配置
- [ ] 验证 HTTPS 证书
- [ ] 查看详细的 Network 日志
- [ ] 检查 Console 中的错误
- [ ] 测试应用所有功能

## 🎯 预防措施

为了避免将来出现这些问题：

1. **启用 CORS 调试**
   ```javascript
   // 在应用启动时
   console.log('CORS configuration:', {
     'Access-Control-Allow-Origin': '*',
     'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE'
   });
   ```

2. **监控资源加载**
   ```javascript
   document.addEventListener('error', (e) => {
     console.error('Resource load error:', e);
   }, true);
   ```

3. **Service Worker 更新检查**
   ```javascript
   navigator.serviceWorker.addEventListener('controllerchange', () => {
     console.log('Service Worker updated');
     window.location.reload();
   });
   ```

---

**最后更新**: 2026-01-06
**诊断工具**: Chrome DevTools + ADB + 网络分析工具
