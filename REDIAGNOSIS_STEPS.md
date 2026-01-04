# 🔍 重新诊断导航功能 - 完整步骤

## 问题发现

上次的日志是空的，说明：
1. 可能您在清空日志后，没有立即点击导航
2. 或者导航功能没有被触发

## 重新诊断的完整步骤

### 步骤 1：打开一个新的命令窗口，监听实时日志

```powershell
cd k:\365-android

# 清空所有旧日志
.\adb.exe -s 192.168.1.75:37547 logcat -c

# 开始实时监听日志（这个窗口保持打开）
.\adb.exe -s 192.168.1.75:37547 logcat
```

**不要关闭这个窗口！** 让它保持运行，显示实时日志。

### 步骤 2：在另一个命令窗口中清空日志并等待

```powershell
cd k:\365-android

# 等待大约10秒钟让日志稳定
# （这时您应该看到步骤1的窗口中有很多日志滚动）
```

### 步骤 3：在手机上执行导航操作

**在手机上：**
1. 打开 365APP
2. **找到导航功能** - 通常是地图相关的按钮
3. **点击导航按钮**
4. **观察高德地图的行为**
5. **立即返回APP**

### 步骤 4：在步骤1的日志窗口中查看输出

关注这些日志行：
- 任何包含 "WebView" 的日志
- 任何包含 "amap" 或 "地图" 的日志
- 任何包含 "shouldOverride" 的日志

### 步骤 5：保存日志

```powershell
# 按 Ctrl+C 停止日志，或者打开新窗口运行：
.\adb.exe -s 192.168.1.75:37547 logcat -d > navigation_log.txt

# 然后查看关键日志
type navigation_log.txt | Select-String "WebView"
```

---

## 如果仍然没有日志输出

这意味着**前端页面可能用的是 JavaScript 直接调用，而不是 URL 跳转**。

在这种情况下，我需要添加一个**JavaScript Bridge 诊断方法**，让前端可以直接告诉我坐标信息。

```java
public class JSBridge {
    @android.webkit.JavascriptInterface
    public void debugNavigation(String message) {
        Log.d("WebView", "JavaScript Debug: " + message);
    }
}
```

---

## 备选方案：直接查看高德地图调用

如果仍然没有看到导航相关的日志，说明：

1. **高德地图是通过 Intent 直接启动的**（这是好的迹象）
2. **但坐标参数可能没有被正确传递**

在这种情况下，我会：
1. 修改 `tryOpenWithPackage()` 方法
2. 使用多种参数格式尝试启动高德地图
3. 测试哪种格式能让高德地图显示坐标

---

## 快速诊断清单

- [ ] 清空日志（logcat -c）
- [ ] 打开实时日志监听窗口
- [ ] 在手机上点击导航
- [ ] 查看日志输出
- [ ] 告诉我看到什么日志

