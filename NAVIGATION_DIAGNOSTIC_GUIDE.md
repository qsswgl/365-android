# 🔍 高德地图导航诊断 - 完整指南

## 核心问题

您的截图表明：

**高德地图应用能启动，但没有显示目的地坐标**

这说明：
- ✅ Android 的 Intent 调用成功了
- ❌ 但坐标参数没有正确传递给高德地图

---

## 我的分析

我之前的修复基于一个假设：**前端页面生成的 URL 已经包含坐标参数**

但从您的测试结果来看，可能有三种情况：

1. **前端没有生成任何坐标参数**
2. **前端生成的参数名称不对**（比如不是 startLat/endLat）
3. **前端根本不是用 amap:// 协议，而是 HTTPS URL**

---

## 解决方案：诊断

我已经在 Android 代码中添加了**详细的日志记录**，可以准确告诉我们：

1. 前端生成的确切 URL 是什么
2. URL 中包含了什么参数
3. 参数的具体值是什么

---

## 📋 诊断步骤（详细版）

### 准备工作

确保您有：
- PowerShell 命令行（已打开）
- ADB 工具（位于 k:\365-android 目录）
- 连接的 Vivo 手机

### 步骤 1：清空日志

```powershell
cd k:\365-android
.\adb.exe -s 192.168.1.75:37547 logcat -c
```

**输出预期：**
```
无输出或显示清空完成
```

### 步骤 2：启动日志记录

```powershell
# 在后台开始记录日志
.\adb.exe -s 192.168.1.75:37547 logcat > diagnostic_log.txt &
```

**或者不后台（更简单）：**
```powershell
# 使用新的PowerShell窗口，运行此命令并保持打开
.\adb.exe -s 192.168.1.75:37547 logcat
```

### 步骤 3：触发导航功能

在您的手机上：

1. 打开 365APP
2. **找到导航功能** - 这是关键，需要确认导航按钮在哪
3. **点击导航按钮**
4. **观察高德地图的行为**
5. **立即返回365APP**

### 步骤 4：导出日志

```powershell
# 如果使用的是后台日志记录，等待5-10秒

# 停止日志记录（如果在前台运行，按 Ctrl+C）

# 导出完整日志
.\adb.exe -s 192.168.1.75:37547 logcat -d > full_log.txt
```

### 步骤 5：查看关键日志

```powershell
# 查看导航相关的所有日志
type diagnostic_log.txt | findstr "WebView"

# 或者更具体地：
type diagnostic_log.txt | findstr "检测到高德地图"
type diagnostic_log.txt | findstr "完整URL"
type diagnostic_log.txt | findstr "参数"
```

---

## 📊 日志解释

### 预期看到的日志格式

```
01-04 09:35:20.123  1234  1234 D/WebView: === 检测到高德地图链接 ===
01-04 09:35:20.124  1234  1234 D/WebView: 完整URL: amap://navi?param1=value1&param2=value2
01-04 09:35:20.125  1234  1234 D/WebView: Scheme: amap
01-04 09:35:20.126  1234  1234 D/WebView: Host: navi
01-04 09:35:20.127  1234  1234 D/WebView: Path: null
01-04 09:35:20.128  1234  1234 D/WebView: Query: param1=value1&param2=value2
01-04 09:35:20.129  1234  1234 D/WebView: 参数个数: 2
01-04 09:35:20.130  1234  1234 D/WebView: 参数: param1 = value1
01-04 09:35:20.131  1234  1234 D/WebView: 参数: param2 = value2
```

### 三种可能的情况分析

#### 情况 A：能看到坐标参数

**日志示例：**
```
D/WebView: 完整URL: amap://navi?startLat=39.9&startLng=116.4&endLat=40.0&endLng=116.5
D/WebView: 参数个数: 4
D/WebView: 参数: startLat = 39.9
D/WebView: 参数: startLng = 116.4
D/WebView: 参数: endLat = 40.0
D/WebView: 参数: endLng = 116.5
```

**分析：**
- ✅ 前端正确生成了包含坐标的 URL
- ✅ Android 代码应该能正确处理
- ❓ 为什么高德地图没有显示？可能是：
  - 高德地图版本不支持这种参数格式
  - 坐标格式不对（需要验证 startLat/endLat 是否是高德期望的）
  - 需要使用不同的参数名

**建议修复：**
```java
// 在 tryOpenWithPackage 中修改为：
String amapScheme = "amap://navi?start=" + coords[0] + "," + coords[1] 
                  + "&end=" + coords[2] + "," + coords[3]
                  + "&mode=driving&src=net.qsgl365";
```

#### 情况 B：看不到坐标参数

**日志示例：**
```
D/WebView: 完整URL: amap://navi?
D/WebView: 参数个数: 0
```

**分析：**
- ❌ 前端没有生成任何坐标参数
- ❌ 这是根本问题，需要找到前端代码

**建议修复：**
1. 需要找到远程服务器上的前端页面代码
2. 检查导航按钮的 click 事件处理
3. 验证如何生成导航 URL

#### 情况 C：看不到 amap:// 格式

**日志示例：**
```
D/WebView: 完整URL: https://uri.amap.com/navigation?to=40.0,116.5&mode=driving
D/WebView: Scheme: https
D/WebView: Query: to=40.0,116.5&mode=driving
D/WebView: 参数: to = 40.0,116.5
```

**分析：**
- 前端使用的是高德地图的网页版 URL
- 不是 amap:// 协议，而是 HTTPS
- 这种情况下，Android 代码中的 `shouldOverrideUrlLoading` 不会拦截，会直接用 WebView 打开

**建议修复：**
需要添加 HTTPS URL 的处理：
```java
if (url.startsWith("https://uri.amap.com/")) {
    // 从 HTTPS URL 中提取坐标
    // 转换为 amap:// 格式启动应用
    handleAmapWebUrl(url);
    return true;
}
```

---

## 🛠️ 根据诊断结果的修复方向

### 如果是情况 A

修改 `tryOpenWithPackage()` 中的参数格式：

```java
private boolean tryOpenWithPackage(String packageName, String amapUrl) {
    try {
        if (isPackageInstalled(packageName)) {
            // 尝试多种 amap:// 格式
            String amapScheme1 = "amap://navi?start=X,Y&end=Z,W&mode=driving";
            String amapScheme2 = "amap://navi?startLat=X&startLng=Y&endLat=Z&endLng=W";
            String amapScheme3 = "amap://navigation?from=X,Y&to=Z,W&mode=driving";
            
            // 尝试第一种格式
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(amapScheme1));
            startActivity(intent);
            return true;
        }
    } catch (Exception e) {
        Log.w("WebView", "启动失败: " + e.getMessage());
    }
    return false;
}
```

### 如果是情况 B

需要在前端修改，或者在 Android 中为 JavaScript Bridge 添加导航方法：

```java
public class JSBridge {
    @android.webkit.JavascriptInterface
    public void startNavigation(String startLat, String startLng, 
                               String endLat, String endLng) {
        Log.d("WebView", "JavaScript 调用导航: " 
              + startLat + "," + startLng + " -> " + endLat + "," + endLng);
        
        String[] coords = new String[]{startLat, startLng, endLat, endLng};
        tryOpenWithPackageDirectly("com.autonavi.minimap", coords);
    }
    
    private void tryOpenWithPackageDirectly(String packageName, String[] coords) {
        // 直接使用传入的坐标，不需要提取
    }
}
```

### 如果是情况 C

添加 HTTPS URL 处理：

```java
@Override
public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
    String url = request.getUrl().toString();
    
    // ... 现有的 amap:// 处理 ...
    
    // 新增：处理 HTTPS 网页版高德地图
    if (url.contains("uri.amap.com") || url.contains("amap.com/direction")) {
        Log.d("WebView", "检测到高德地图网页版: " + url);
        handleAmapWebUrl(url);
        return true;
    }
    
    return false;
}

private void handleAmapWebUrl(String url) {
    // 从 URL 中提取坐标
    // 然后启动 amap:// 应用
}
```

---

## 📞 下一步

### 立即行动

1. **按照上面的步骤运行诊断**
2. **获取日志输出**
3. **告诉我看到的日志内容**

### 我需要的信息

请粘贴或截图这些日志行：
- "完整URL:" 那一行
- "参数个数:" 那一行
- 所有 "参数:" 开头的行

---

## 总结

**您的问题不是我想象的那样简单**，因此：

1. ✅ 我已经为您准备了诊断工具
2. ⏳ 现在需要您运行诊断
3. 📊 根据结果，我会提供具体的修复

**这是解决问题的正确方法：先诊断，再治疗。** 🏥

