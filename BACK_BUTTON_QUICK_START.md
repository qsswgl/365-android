# 📱 返回按钮功能 - 快速参考

## ⚡ 一句话总结
点击手机返回按钮时，WebView 自动返回上一个页面，而不是关闭应用。

---

## 🎯 核心代码

```java
@Override
public void onBackPressed() {
    if (webView != null && webView.canGoBack()) {
        webView.goBack();  // 返回上一个页面
        return;
    }
    // 到达首页时，显示提示但不关闭应用
    android.widget.Toast.makeText(this, "已是首页，无法继续返回", 
        android.widget.Toast.LENGTH_SHORT).show();
}
```

---

## 📍 代码位置

文件：`app/src/main/java/net/qsgl365/MainActivity.java`  
位置：类的末尾（第 920+ 行）

---

## 🧪 工作原理

| 场景 | 操作 | 结果 |
|------|------|------|
| 有返回历史 | 点击返回 | 返回上一页 |
| 在首页 | 点击返回 | 显示 Toast，保持打开 |
| 连续返回 | 多次点击 | 逐个返回，最后停留首页 |

---

## ✅ 关键方法解释

### `webView.canGoBack()`
- **作用**：判断是否有上一个页面可以返回
- **返回值**：true（可以返回） / false（已在首页）

### `webView.goBack()`
- **作用**：返回到上一个访问过的页面
- **注意**：必须先检查 canGoBack() 的结果

---

## 🚀 快速测试

```bash
# 编译
.\gradlew.bat assembleDebug

# 安装
adb install app\build\outputs\apk\debug\app-debug.apk

# 测试：打开应用 → 点击多个链接 → 点击返回按钮 → 验证效果
```

---

## 💡 扩展用法

### 1️⃣ 双击返回才关闭应用

```java
private long lastBackTime = 0;

@Override
public void onBackPressed() {
    if (webView != null && webView.canGoBack()) {
        webView.goBack();
        return;
    }
    
    if (System.currentTimeMillis() - lastBackTime < 2000) {
        super.onBackPressed();  // 双击后关闭应用
    } else {
        lastBackTime = System.currentTimeMillis();
        android.widget.Toast.makeText(this, "再按一次返回键退出应用", 
            android.widget.Toast.LENGTH_SHORT).show();
    }
}
```

### 2️⃣ 返回前保存数据

```java
@Override
public void onBackPressed() {
    if (webView != null && webView.canGoBack()) {
        saveUserData();  // 保存数据
        webView.goBack();
        return;
    }
    // ...
}
```

### 3️⃣ 通知 H5 页面返回事件

```javascript
// Android 侧
@Override
public void onBackPressed() {
    if (webView != null && webView.canGoBack()) {
        // 通知 H5 即将返回
        webView.evaluateJavascript(
            "javascript:window.onAndroidBackPressed && window.onAndroidBackPressed();",
            null
        );
        webView.goBack();
        return;
    }
    // ...
}

// H5 侧
window.onAndroidBackPressed = function() {
    // 保存表单或清理数据
    console.log('Android 返回按钮被点击');
};
```

---

## 🔧 调试技巧

### 模拟返回按钮
```bash
adb shell input keyevent 4
```

### 查看日志
```bash
adb logcat | findstr "WebView"
```

### 检查 WebView 状态
```java
Log.d("WebView", "Can go back: " + webView.canGoBack());
Log.d("WebView", "Can go forward: " + webView.canGoForward());
```

---

## ❓ 常见问题

**Q: 为什么返回不工作？**  
A: 检查 webView 是否为 null，或检查页面是否有历史记录。

**Q: 能否防止返回某个特定页面？**  
A: 可以通过在 H5 中处理返回事件，或重写 shouldOverrideUrlLoading。

**Q: 如何获知用户点击了返回？**  
A: 通过 onBackPressed 拦截事件，或在 H5 中监听 popstate。

---

## 📊 编译状态
✅ BUILD SUCCESSFUL in 2m 28s

## 🎉 完成日期
2026-01-04
