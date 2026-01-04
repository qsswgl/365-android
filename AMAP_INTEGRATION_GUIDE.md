# WebView 调用高德地图链接 - 完整实例指南

## 目录
1. [基础链接格式](#基础链接格式)
2. [HTML 中的调用示例](#html-中的调用示例)
3. [JavaScript 中的调用示例](#javascript-中的调用示例)
4. [Android 端的处理](#android-端的处理)
5. [完整的项目示例](#完整的项目示例)
6. [常见问题](#常见问题)

---

## 基础链接格式

### 高德地图 URI Scheme

高德地图支持两种 URI Scheme：
- `amap://` - 标准高德地图链接
- `androidamap://` - Android 特定的高德地图链接

### 常用功能的 URL 格式

#### 1. 打开地点详情

```
amap://viewUri?sourceApplication=<appName>&name=<POI名称>&poiId=<POI ID>
```

**示例：**
```
amap://viewUri?sourceApplication=net.qsgl365&name=天安门&poiId=B000A8SF1H
```

#### 2. 路线规划（导航）

```
amap://path?sourceApplication=<appName>&startLat=<起点纬度>&startLng=<起点经度>&startName=<起点名称>&endLat=<终点纬度>&endLng=<终点经度>&endName=<终点名称>&mode=<路线类型>
```

**参数说明：**
- `sourceApplication`: 应用名称（必填）
- `startLat`, `startLng`: 起点坐标
- `startName`: 起点名称
- `endLat`, `endLng`: 终点坐标
- `endName`: 终点名称
- `mode`: 路线类型（`driving`=驾车、`transit`=公交、`walking`=步行）

**示例：**
```
amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=我的位置&endLat=39.9042&endLng=116.4073&endName=北京市中心&mode=driving
```

#### 3. 搜索

```
amap://search?sourceApplication=<appName>&keyword=<搜索关键词>
```

**示例：**
```
amap://search?sourceApplication=net.qsgl365&keyword=餐厅
```

#### 4. 显示地图

```
amap://map?sourceApplication=<appName>&markers=<经度>,<纬度>,<标题>,<描述>
```

**示例：**
```
amap://map?sourceApplication=net.qsgl365&markers=116.4073,39.9042,北京市中心,首都
```

---

## HTML 中的调用示例

### 最简单的方式 - 直接使用 href

```html
<!-- 1. 打开地点详情 -->
<a href="amap://viewUri?sourceApplication=net.qsgl365&name=天安门&poiId=B000A8SF1H">
  在高德地图中查看天安门
</a>

<!-- 2. 路线规划 -->
<a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=出发地&endLat=39.9042&endLng=116.4073&endName=目的地&mode=driving">
  导航到目的地
</a>

<!-- 3. 搜索 -->
<a href="amap://search?sourceApplication=net.qsgl365&keyword=餐厅">
  搜索附近餐厅
</a>

<!-- 4. 显示地图 -->
<a href="amap://map?sourceApplication=net.qsgl365&markers=116.4073,39.9042,地标,标题">
  在地图中显示标记
</a>
```

### 完整的 HTML 页面示例

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>高德地图导航示例</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        
        .button {
            display: inline-block;
            padding: 12px 24px;
            margin: 10px 5px;
            background-color: #007AFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .button:hover {
            background-color: #0051D5;
        }
        
        .section {
            margin: 20px 0;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
        }
        
        h2 {
            color: #333;
            border-bottom: 2px solid #007AFF;
            padding-bottom: 10px;
        }
    </style>
</head>
<body>

<h1>365 应用 - 高德地图导航示例</h1>

<div class="section">
    <h2>1. 查看地点详情</h2>
    <a href="amap://viewUri?sourceApplication=net.qsgl365&name=天安门&poiId=B000A8SF1H" class="button">
        查看天安门详情
    </a>
    <p>点击上方按钮，将打开高德地图应用显示天安门的详细信息</p>
</div>

<div class="section">
    <h2>2. 路线规划 - 驾车导航</h2>
    <a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=北京站&endLat=39.9042&endLng=116.4073&endName=天安门&mode=driving" class="button">
        从北京站导航到天安门
    </a>
    <p>点击上方按钮，将在高德地图中规划驾车路线</p>
</div>

<div class="section">
    <h2>3. 路线规划 - 公交导航</h2>
    <a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=北京站&endLat=39.9042&endLng=116.4073&endName=天安门&mode=transit" class="button">
        北京站到天安门 (公交)
    </a>
    <p>点击上方按钮，将在高德地图中规划公交路线</p>
</div>

<div class="section">
    <h2>4. 路线规划 - 步行导航</h2>
    <a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=北京站&endLat=39.9042&endLng=116.4073&endName=天安门&mode=walking" class="button">
        北京站到天安门 (步行)
    </a>
    <p>点击上方按钮，将在高德地图中规划步行路线</p>
</div>

<div class="section">
    <h2>5. 搜索功能</h2>
    <a href="amap://search?sourceApplication=net.qsgl365&keyword=餐厅" class="button">
        搜索附近餐厅
    </a>
    <p>点击上方按钮，将在高德地图中搜索餐厅</p>
</div>

<div class="section">
    <h2>6. 显示地图标记</h2>
    <a href="amap://map?sourceApplication=net.qsgl365&markers=116.4073,39.9042,天安门,中国首都标志" class="button">
        在地图中显示天安门
    </a>
    <p>点击上方按钮，将在高德地图中显示地点标记</p>
</div>

<div class="section">
    <h2>常见场景示例</h2>
    
    <h3>场景 1: 商城导航</h3>
    <a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=我的位置&endLat=39.8686&endLng=116.5516&endName=朝阳大悦城&mode=driving" class="button">
        导航到朝阳大悦城
    </a>
    
    <h3>场景 2: 餐厅查询</h3>
    <a href="amap://search?sourceApplication=net.qsgl365&keyword=火锅" class="button">
        搜索火锅餐厅
    </a>
    
    <h3>场景 3: 酒店查询</h3>
    <a href="amap://search?sourceApplication=net.qsgl365&keyword=五星酒店" class="button">
        搜索五星酒店
    </a>
</div>

</body>
</html>
```

---

## JavaScript 中的调用示例

### 1. 基础的 JavaScript 跳转

```javascript
// 简单的导航链接打开
function navigateToAmap() {
    const amapUrl = "amap://path?sourceApplication=net.qsgl365" +
                    "&startLat=39.9489&startLng=116.4387&startName=起点" +
                    "&endLat=39.9042&endLng=116.4073&endName=终点" +
                    "&mode=driving";
    window.location.href = amapUrl;
}
```

### 2. 动态生成高德地图链接

```javascript
/**
 * 生成高德地图导航链接
 * @param {number} startLat - 起点纬度
 * @param {number} startLng - 起点经度
 * @param {string} startName - 起点名称
 * @param {number} endLat - 终点纬度
 * @param {number} endLng - 终点经度
 * @param {string} endName - 终点名称
 * @param {string} mode - 导航模式 (driving/transit/walking)
 */
function generateAmapNavigationUrl(startLat, startLng, startName, endLat, endLng, endName, mode = 'driving') {
    const baseUrl = "amap://path?";
    const params = [
        "sourceApplication=net.qsgl365",
        `startLat=${startLat}`,
        `startLng=${startLng}`,
        `startName=${encodeURIComponent(startName)}`,
        `endLat=${endLat}`,
        `endLng=${endLng}`,
        `endName=${encodeURIComponent(endName)}`,
        `mode=${mode}`
    ];
    return baseUrl + params.join("&");
}

// 使用示例
const amapUrl = generateAmapNavigationUrl(
    39.9489,      // 北京站纬度
    116.4387,     // 北京站经度
    "北京站",     // 起点名称
    39.9042,      // 天安门纬度
    116.4073,     // 天安门经度
    "天安门",     // 终点名称
    "driving"     // 驾车模式
);

console.log("高德地图链接:", amapUrl);
window.location.href = amapUrl;
```

### 3. 高级的导航函数封装

```javascript
/**
 * 高德地图导航器类
 * 提供更多功能和错误处理
 */
class AmapNavigator {
    constructor(appName = "net.qsgl365") {
        this.appName = appName;
        this.baseUrl = "amap://";
    }
    
    /**
     * 路线规划
     */
    navigateTo(startLat, startLng, startName, endLat, endLng, endName, mode = 'driving') {
        const url = `${this.baseUrl}path?` +
                    `sourceApplication=${this.appName}` +
                    `&startLat=${startLat}` +
                    `&startLng=${startLng}` +
                    `&startName=${encodeURIComponent(startName)}` +
                    `&endLat=${endLat}` +
                    `&endLng=${endLng}` +
                    `&endName=${encodeURIComponent(endName)}` +
                    `&mode=${mode}`;
        
        console.log("打开高德地图导航:", url);
        window.location.href = url;
    }
    
    /**
     * 搜索功能
     */
    search(keyword) {
        const url = `${this.baseUrl}search?` +
                    `sourceApplication=${this.appName}` +
                    `&keyword=${encodeURIComponent(keyword)}`;
        
        console.log("在高德地图中搜索:", url);
        window.location.href = url;
    }
    
    /**
     * 查看地点详情
     */
    viewPOI(poiId, poiName) {
        const url = `${this.baseUrl}viewUri?` +
                    `sourceApplication=${this.appName}` +
                    `&poiId=${poiId}` +
                    `&name=${encodeURIComponent(poiName)}`;
        
        console.log("查看地点详情:", url);
        window.location.href = url;
    }
    
    /**
     * 显示地图
     */
    showMap(lng, lat, title, description = "") {
        const url = `${this.baseUrl}map?` +
                    `sourceApplication=${this.appName}` +
                    `&markers=${lng},${lat},${encodeURIComponent(title)},${encodeURIComponent(description)}`;
        
        console.log("显示地图:", url);
        window.location.href = url;
    }
}

// 使用示例
const navigator = new AmapNavigator("net.qsgl365");

// 路线规划
navigator.navigateTo(39.9489, 116.4387, "北京站", 39.9042, 116.4073, "天安门", "driving");

// 搜索
navigator.search("餐厅");

// 查看地点
navigator.viewPOI("B000A8SF1H", "天安门");

// 显示地图
navigator.showMap(116.4073, 39.9042, "天安门", "中国首都标志");
```

### 4. 与 Android 原生 Bridge 集成

```javascript
/**
 * 与 Android 原生应用集成的高德地图导航
 * 使用 AndroidBridge 获取用户信息
 */
class AmapIntegration {
    
    /**
     * 从用户的当前位置导航到目标地点
     * @param {number} destLat - 目标纬度
     * @param {number} destLng - 目标经度
     * @param {string} destName - 目标名称
     */
    static navigateFromCurrentLocation(destLat, destLng, destName) {
        // 获取用户信息（假设 AndroidBridge 已注入）
        let userPhoneNumber = "未知";
        let userName = "用户";
        
        if (window.AndroidBridge && typeof window.AndroidBridge.getPhoneNumber === 'function') {
            userPhoneNumber = window.AndroidBridge.getPhoneNumber();
            console.log("获取到用户手机号:", userPhoneNumber);
        }
        
        // 构建导航链接
        // 注意：当前位置需要由用户在高德地图中设置
        const amapUrl = `amap://path?` +
                        `sourceApplication=net.qsgl365` +
                        `&startLat=39.9489` +
                        `&startLng=116.4387` +
                        `&startName=我的位置` +
                        `&endLat=${destLat}` +
                        `&endLng=${destLng}` +
                        `&endName=${encodeURIComponent(destName)}` +
                        `&mode=driving`;
        
        console.log("用户手机号:", userPhoneNumber);
        console.log("打开高德地图:", amapUrl);
        window.location.href = amapUrl;
    }
    
    /**
     * 检查用户是否已注册，如果未注册则先进行注册
     */
    static navigateWithRegistration(destLat, destLng, destName) {
        if (window.AndroidBridge && typeof window.AndroidBridge.isUserRegistered === 'function') {
            if (window.AndroidBridge.isUserRegistered()) {
                console.log("用户已注册，直接导航");
                this.navigateFromCurrentLocation(destLat, destLng, destName);
            } else {
                console.log("用户未注册，显示注册界面");
                alert("请先完成注册，然后再使用导航功能");
                // 显示注册界面...
            }
        }
    }
}

// 使用示例
AmapIntegration.navigateFromCurrentLocation(39.9042, 116.4073, "天安门");
AmapIntegration.navigateWithRegistration(39.9042, 116.4073, "天安门");
```

---

## Android 端的处理

### MainActivity.java 中的关键代码

应用已通过 `shouldOverrideUrlLoading` 方法自动处理所有 Amap 链接：

```java
@Override
public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
    String url = request.getUrl().toString();
    Log.d("WebView", "=== shouldOverrideUrlLoading 被调用 ===");
    Log.d("WebView", "URL 被点击: " + url);
    
    // 检测高德地图链接
    if (url.startsWith("amap://") || url.startsWith("androidamap://")) {
        Log.d("WebView", "检测到高德地图链接: " + url);
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(url));
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            Log.d("WebView", "正在启动高德地图应用");
            startActivity(intent);
            Log.d("WebView", "高德地图 Intent 启动成功");
        } catch (Exception e) {
            Log.e("WebView", "高德地图未安装或启动失败: " + e.getMessage());
            String toastMsg = "高德地图未安装，请先安装高德地图应用";
            webView.evaluateJavascript("javascript:alert('" + toastMsg + "');", null);
        }
        return true;  // 告诉 WebView 链接已被处理
    }
    
    return false;  // 其他链接由 WebView 默认处理
}
```

### 调试高德地图链接

```bash
# 查看 WebView 相关的日志
adb logcat | grep WebView

# 输出示例
D/WebView: shouldOverrideUrlLoading 被调用
D/WebView: URL 被点击: amap://path?sourceApplication=net.qsgl365&startLat=39.9489...
D/WebView: 检测到高德地图链接
D/WebView: 正在启动高德地图应用
D/WebView: 高德地图 Intent 启动成功
```

---

## 完整的项目示例

### 文件结构

```
app/src/main/assets/pwa/
├── index.html (主页面)
├── navigation.html (导航页面)
└── js/
    └── amap-integration.js (高德地图集成脚本)
```

### index.html - 主页面

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>365 应用</title>
    <style>
        * { margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f0f0; }
        .header { 
            background: #007AFF; 
            color: white; 
            padding: 15px;
            text-align: center;
        }
        .content { padding: 20px; }
        .menu { margin-bottom: 20px; }
        .menu a {
            display: block;
            padding: 12px;
            margin: 5px 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #007AFF;
            text-align: center;
        }
        .menu a:hover { background: #f5f5f5; }
    </style>
</head>
<body>
    <div class="header">
        <h1>365 应用 - 导航中心</h1>
    </div>
    
    <div class="content">
        <div class="menu">
            <a href="javascript:navigateToPOI()">查看地点</a>
            <a href="javascript:navigateWithRoute()">规划路线</a>
            <a href="javascript:searchNearby()">搜索附近</a>
            <a href="javascript:viewUserProfile()">用户信息</a>
        </div>
    </div>
    
    <script>
        /**
         * 查看地点详情
         */
        function navigateToPOI() {
            const poiId = "B000A8SF1H";
            const poiName = "天安门";
            const url = `amap://viewUri?sourceApplication=net.qsgl365&poiId=${poiId}&name=${encodeURIComponent(poiName)}`;
            console.log("打开地点:", url);
            window.location.href = url;
        }
        
        /**
         * 规划路线
         */
        function navigateWithRoute() {
            const url = `amap://path?` +
                        `sourceApplication=net.qsgl365` +
                        `&startLat=39.9489&startLng=116.4387&startName=出发地` +
                        `&endLat=39.9042&endLng=116.4073&endName=天安门` +
                        `&mode=driving`;
            console.log("规划路线:", url);
            window.location.href = url;
        }
        
        /**
         * 搜索附近
         */
        function searchNearby() {
            const keyword = prompt("请输入搜索关键词:", "餐厅");
            if (keyword) {
                const url = `amap://search?sourceApplication=net.qsgl365&keyword=${encodeURIComponent(keyword)}`;
                console.log("搜索:", url);
                window.location.href = url;
            }
        }
        
        /**
         * 显示用户信息
         */
        function viewUserProfile() {
            if (window.AndroidBridge && typeof window.AndroidBridge.getPhoneNumber === 'function') {
                const phoneNumber = window.AndroidBridge.getPhoneNumber();
                const deviceInfo = window.AndroidBridge.getDeviceInfo();
                alert(`手机号: ${phoneNumber}\n设备信息: ${deviceInfo}`);
            } else {
                alert("无法获取用户信息");
            }
        }
        
        // 页面加载完成时调用
        window.addEventListener('load', function() {
            console.log("页面已加载，高德地图导航已就绪");
        });
    </script>
</body>
</html>
```

---

## 常见问题

### Q1: 为什么点击链接没有跳转到高德地图？

**A:** 可能原因：
1. **高德地图未安装** - 需要先安装高德地图应用
2. **链接格式错误** - 检查 URI Scheme 是否正确（`amap://` 或 `androidamap://`）
3. **参数编码问题** - 中文字符需要 URL 编码

**解决方案：**
```javascript
// 使用 encodeURIComponent 进行 URL 编码
const name = "北京站";
const encodedName = encodeURIComponent(name);
const url = `amap://viewUri?sourceApplication=net.qsgl365&name=${encodedName}`;
```

### Q2: 如何处理高德地图未安装的情况？

**A:** 在 Android 端的 `shouldOverrideUrlLoading` 中已经有处理：

```java
try {
    startActivity(intent);
} catch (Exception e) {
    // 高德地图未安装
    String toastMsg = "高德地图未安装，请先安装高德地图应用";
    webView.evaluateJavascript("javascript:alert('" + toastMsg + "');", null);
}
```

### Q3: 如何在高德地图中显示用户的当前位置？

**A:** 高德地图会自动获取用户的当前位置。在导航时，可以设置 `startLat` 和 `startLng` 为当前位置的坐标（需要通过定位服务获取）。

### Q4: 支持哪些导航模式？

**A:** 支持以下三种模式：
- `driving` - 驾车（默认）
- `transit` - 公交
- `walking` - 步行

### Q5: 如何在同一页面中使用多个高德地图链接？

**A:** 每个链接独立工作，可以直接使用多个 `<a>` 标签或 `<button>` 元素：

```html
<a href="amap://...">链接1</a>
<a href="amap://...">链接2</a>
<button onclick="navigateToAmap()">链接3</button>
```

### Q6: 如何保存用户的导航历史？

**A:** 使用 `UserDataManager` 类保存用户信息：

```javascript
// 在 JavaScript 中调用
if (window.AndroidBridge && typeof window.AndroidBridge.saveUserData === 'function') {
    window.AndroidBridge.saveUserData(
        '手机号',
        '用户ID',
        '用户名',
        '{"导航历史":"..."}'
    );
}
```

---

## 总结

1. **基础链接** - 使用 `amap://` 或 `androidamap://` URI Scheme
2. **HTML 集成** - 直接在 `<a>` 标签的 `href` 中使用 Amap URL
3. **JavaScript 集成** - 使用 `window.location.href` 或 `window.open()` 打开链接
4. **Android 处理** - 自动通过 `shouldOverrideUrlLoading` 处理所有 Amap 链接
5. **用户数据** - 使用 `UserDataManager` 保存用户信息，升级时保留数据

---

**文档版本:** 2.0  
**最后更新:** 2026-01-04  
**状态:** ✅ 完成
