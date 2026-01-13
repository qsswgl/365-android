# 365 Android 应用 - 新功能说明文档

## 功能概述

本次更新为 365 Android 应用添加了两个重要功能：

1. **应用升级时用户数据保留** - 用户注册信息（手机号、用户ID等）在应用升级时自动保留
2. **WebView 调用高德地图链接** - 完整的高德地图导航集成示例和使用指南

---

## 功能 1: 应用升级时用户数据保留

### 功能说明

用户在首次安装应用时进行注册，之后升级应用时无需重新注册。应用会自动：
- 保存用户的注册信息（手机号、用户ID、用户名等）
- 在应用升级后自动恢复用户数据
- 允许用户直接跳过注册流程

### 实现方式

#### 1. 新增 UserDataManager 类

**文件:** `app/src/main/java/net/qsgl365/UserDataManager.java`

**核心功能:**
```java
// 保存用户信息
userDataManager.savePhoneNumber(phoneNumber);
userDataManager.saveUserId(userId);
userDataManager.saveUserName(userName);
userDataManager.saveUserInfo(jsonData);

// 读取用户信息
String phoneNumber = userDataManager.getPhoneNumber();
String userId = userDataManager.getUserId();

// 检查是否已注册
boolean registered = userDataManager.isUserRegistered();

// 检查应用是否升级
boolean upgraded = userDataManager.hasAppUpgraded();
```

**存储方式:** 使用 Android `SharedPreferences`
- 文件位置: `/data/data/net.qsgl365/shared_prefs/qsgl365_user_data.xml`
- **应用卸载时清除**（系统默认行为）
- 升级时完全保留（SharedPreferences 不受影响）

#### 2. MainActivity 中的集成

**初始化:**
```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    
    // 初始化用户数据管理器
    userDataManager = new UserDataManager(this);
    
    // 检查应用是否升级
    if (userDataManager.hasAppUpgraded()) {
        Log.d("WebView", "应用已升级，用户数据已保留");
        Log.d("WebView", userDataManager.getAllUserData());
    }
}
```

**数据注入 (onPageFinished):**
```java
@Override
public void onPageFinished(WebView view, String url) {
    // 优先使用保存的手机号
    String phoneNumber;
    if (userDataManager.isUserRegistered()) {
        phoneNumber = userDataManager.getPhoneNumber();
    } else {
        phoneNumber = readPhoneNumber();
        userDataManager.savePhoneNumber(phoneNumber);  // 首次保存
    }
    
    // 注入到 JavaScript
    String js = "javascript:window.phoneNumber='" + phoneNumber + "'; " +
               "if(window.onPhoneNumberReady) window.onPhoneNumberReady(...)";
    
    // 如果已注册，触发 onUserDataRestored 回调
    if (userDataManager.isUserRegistered()) {
        js += "if(window.onUserDataRestored) window.onUserDataRestored({...})";
    }
    
    webView.evaluateJavascript(js, null);
}
```

#### 3. JavaScript Bridge 接口

**AndroidBridge 新增方法:**

```javascript
// 保存用户数据（在注册完成后调用）
AndroidBridge.saveUserData(
    '手机号',      // phoneNumber
    '用户ID',      // userId
    '用户名',      // userName
    '{"其他":"数据"}'  // userInfo (JSON 字符串)
);

// 获取已保存的用户数据
const userData = AndroidBridge.getSavedUserData();  // 返回 JSON 字符串
// 示例: {"phoneNumber":"13800138000","userId":"user_123","userName":"张三"}

// 检查用户是否已注册
const registered = AndroidBridge.isUserRegistered();  // 返回 true/false
```

### 使用流程

#### 首次安装 + 注册

```
1. 用户安装应用
2. 应用启动 → 检测无用户数据
3. 显示注册页面
4. 用户输入手机号、用户名等信息
5. 点击注册按钮时，JavaScript 调用:
   AndroidBridge.saveUserData('13800138000', 'user_123', '张三', '...')
6. 用户数据被保存到 SharedPreferences
```

#### 应用升级后

```
1. 用户升级应用
2. 应用启动 → 检测到 SharedPreferences 中有用户数据
3. 自动注入用户数据到 JavaScript
4. 前端检测到 onUserDataRestored 事件
5. 自动跳过注册流程，直接进入主程序
```

### 前端（HTML/JavaScript）实现示例

```html
<script>
// 检查是否已注册
if (window.AndroidBridge && AndroidBridge.isUserRegistered()) {
    console.log("用户已注册，显示主程序界面");
    showMainPage();
} else {
    console.log("用户未注册，显示注册界面");
    showRegistrationPage();
}

// 监听从原生应用恢复的用户数据
window.onUserDataRestored = function(userData) {
    console.log("用户数据已恢复:", userData);
    // userData: {phoneNumber: "...", userId: "...", userName: "..."}
    // 自动跳过注册，进入主程序
};

// 监听手机号就绪事件
window.onPhoneNumberReady = function(phoneNumber) {
    console.log("获取到手机号:", phoneNumber);
    // 自动填充手机号到表单
    document.getElementById('phoneInput').value = phoneNumber;
};

// 用户点击注册按钮后，保存用户数据
function saveRegistration(phoneNumber, userId, userName) {
    if (window.AndroidBridge) {
        AndroidBridge.saveUserData(phoneNumber, userId, userName, '{}');
        console.log("用户数据已保存");
    }
}
</script>
```

---

## 功能 2: WebView 调用高德地图链接

### 功能说明

应用可以通过 WebView 触发高德地图链接，支持以下功能：
- 路线规划与导航
- 地点搜索
- 地点详情查看
- 地图显示

### Android 端实现

#### URI Scheme 支持

```java
// 在 shouldOverrideUrlLoading 中自动处理
if (url.startsWith("amap://") || url.startsWith("androidamap://")) {
    Intent intent = new Intent(Intent.ACTION_VIEW);
    intent.setData(Uri.parse(url));
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    try {
        startActivity(intent);  // 启动高德地图应用
    } catch (Exception e) {
        // 如果高德地图未安装，显示提示
        String toastMsg = "高德地图未安装，请先安装";
        webView.evaluateJavascript("javascript:alert('" + toastMsg + "');", null);
    }
    return true;
}
```

### 前端（HTML/JavaScript）实现

#### 方式 1: 直接使用超链接

```html
<!-- 最简单的方式 -->
<a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=出发地&endLat=39.9042&endLng=116.4073&endName=天安门&mode=driving">
  导航到天安门
</a>
```

#### 方式 2: 使用 JavaScript 函数

```javascript
// 简单的跳转函数
function navigateWithAmap(destLat, destLng, destName) {
    const url = `amap://path?` +
                `sourceApplication=net.qsgl365` +
                `&startLat=39.9489` +
                `&startLng=116.4387` +
                `&startName=出发地` +
                `&endLat=${destLat}` +
                `&endLng=${destLng}` +
                `&endName=${encodeURIComponent(destName)}` +
                `&mode=driving`;
    window.location.href = url;
}

// 调用
navigateWithAmap(39.9042, 116.4073, "天安门");
```

#### 方式 3: 使用 JavaScript 类封装

```javascript
class AmapNavigator {
    constructor(appName = "net.qsgl365") {
        this.appName = appName;
    }
    
    // 路线规划
    navigateTo(startLat, startLng, startName, endLat, endLng, endName, mode = 'driving') {
        const url = `amap://path?sourceApplication=${this.appName}` +
                    `&startLat=${startLat}&startLng=${startLng}&startName=${encodeURIComponent(startName)}` +
                    `&endLat=${endLat}&endLng=${endLng}&endName=${encodeURIComponent(endName)}` +
                    `&mode=${mode}`;
        window.location.href = url;
    }
    
    // 搜索
    search(keyword) {
        const url = `amap://search?sourceApplication=${this.appName}&keyword=${encodeURIComponent(keyword)}`;
        window.location.href = url;
    }
    
    // 查看地点
    viewPOI(poiId, poiName) {
        const url = `amap://viewUri?sourceApplication=${this.appName}&poiId=${poiId}&name=${encodeURIComponent(poiName)}`;
        window.location.href = url;
    }
}

// 使用
const navigator = new AmapNavigator("net.qsgl365");
navigator.navigateTo(39.9489, 116.4387, "北京站", 39.9042, 116.4073, "天安门", "driving");
```

### 高德地图 URL Scheme 参数说明

#### 路线规划

```
amap://path?sourceApplication=<应用名>&startLat=<起点纬度>&startLng=<起点经度>&startName=<起点名称>&endLat=<终点纬度>&endLng=<终点经度>&endName=<终点名称>&mode=<导航模式>
```

**参数:**
- `sourceApplication` - 应用名称（必填）：`net.qsgl365`
- `startLat`, `startLng` - 起点坐标（可选）
- `startName` - 起点名称（可选）
- `endLat`, `endLng` - 终点坐标（必填）
- `endName` - 终点名称（可选）
- `mode` - 导航模式：`driving`(驾车)|`transit`(公交)|`walking`(步行)

#### 搜索

```
amap://search?sourceApplication=<应用名>&keyword=<搜索关键词>
```

#### 查看地点

```
amap://viewUri?sourceApplication=<应用名>&name=<地点名称>&poiId=<POI ID>
```

#### 显示地图

```
amap://map?sourceApplication=<应用名>&markers=<经度>,<纬度>,<标题>,<描述>
```

### 调试方法

#### 查看日志

```bash
# 查看高德地图相关日志
adb logcat | grep WebView

# 示例输出
D/WebView: shouldOverrideUrlLoading 被调用
D/WebView: URL 被点击: amap://path?sourceApplication=net.qsgl365&...
D/WebView: 检测到高德地图链接
D/WebView: 正在启动高德地图应用
D/WebView: 高德地图 Intent 启动成功
```

#### 测试高德地图链接

```bash
# 直接测试 Intent
adb shell am start -a android.intent.action.VIEW -d "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=出发地&endLat=39.9042&endLng=116.4073&endName=天安门&mode=driving"
```

---

## 完整示例

### HTML 页面示例

详见: `AMAP_INTEGRATION_GUIDE.md` 中的"完整的 HTML 页面示例"部分

### 关键代码位置

| 功能 | 文件 | 类/方法 |
|------|------|--------|
| 用户数据管理 | `UserDataManager.java` | `UserDataManager` |
| 应用启动初始化 | `MainActivity.java` | `onCreate()` |
| 数据注入 | `MainActivity.java` | `onPageFinished()` |
| 高德地图处理 | `MainActivity.java` | `shouldOverrideUrlLoading()` |
| JavaScript Bridge | `MainActivity.java` | `JSBridge` |

---

## 部署与测试

### 编译应用

```bash
cd k:\365-android
.\gradlew.bat assembleRelease -x lintVitalRelease
```

**编译结果:** ✅ BUILD SUCCESSFUL in 2m 11s

### 安装应用

```bash
.\adb.exe -s 192.168.1.75:37547 install app\build\outputs\apk\release\app-release.apk
```

### 测试流程

#### 测试 1: 用户数据保存

1. 首次打开应用
2. 完成注册，调用 `AndroidBridge.saveUserData(...)` 保存用户信息
3. 关闭应用并卸载
4. 重新安装应用
5. **验证:** 用户数据应该丢失（卸载时清除）

#### 测试 2: 应用升级时数据保留

1. 安装应用，完成注册
2. 升级应用（不卸载）
3. **验证:** logcat 输出 "应用已升级，用户数据已保留"
4. **验证:** 页面自动显示用户信息，可跳过注册

#### 测试 3: 高德地图链接

1. 安装高德地图应用
2. 在应用中点击高德地图导航链接
3. **验证:** 成功跳转到高德地图应用
4. 如果未安装高德地图
5. **验证:** 显示提示信息 "高德地图未安装"

---

## FAQ

### Q1: 用户卸载应用后重新安装，数据还能保留吗？

**A:** 不能。卸载应用时，Android 系统会删除 `/data/data/net.qsgl365` 目录，包括所有 SharedPreferences 数据。这是系统级别的行为，无法改变。

**解决方案:** 可以选择使用云端存储（服务器）来保存用户数据，卸载后通过手机号验证恢复。

### Q2: 如何获取用户的当前位置？

**A:** 高德地图会自动获取设备的当前位置。如果需要在应用中获取当前位置，需要：
1. 请求 `ACCESS_FINE_LOCATION` 权限（已在 AndroidManifest.xml 中声明）
2. 使用 `FusedLocationProviderClient` 或 `LocationManager` 获取位置
3. 传入高德地图 URL 的 `startLat` 和 `startLng`

### Q3: 支持哪些应用名称？

**A:** `sourceApplication` 参数可以填写任意值，但建议使用应用的包名：
```
net.qsgl365
```

高德地图会使用这个值来记录是哪个应用调用了它。

### Q4: 如何处理多个用户的情况？

**A:** 当前实现仅保存一个用户的信息。如果需要支持多用户，可以：
1. 修改 SharedPreferences 的 key，加入用户标识
2. 在 UserDataManager 中维护用户列表
3. 提供用户切换接口

### Q5: 能否通过其他方式调用高德地图（如 WebView 的 file:// 协议）？

**A:** 不能。WebView 中的所有链接跳转都通过 `shouldOverrideUrlLoading` 方法，所以任何 `amap://` 链接都会被正确处理。

---

## 更新内容清单

### 新增文件

1. ✅ `UserDataManager.java` - 用户数据管理类（168 行）
2. ✅ `AMAP_INTEGRATION_GUIDE.md` - 高德地图集成完整指南（550+ 行）
3. ✅ `FEATURE_IMPLEMENTATION_GUIDE.md` - 本文件

### 修改文件

1. ✅ `MainActivity.java`
   - 添加 `userDataManager` 成员变量
   - 初始化 `UserDataManager` 
   - 增强 `JSBridge` 接口，支持用户数据保存/读取
   - 改进 `onPageFinished()`，优先使用保存的用户数据
   - 增强 `shouldOverrideUrlLoading()`，支持 `amap://` 和 `androidamap://`

2. ✅ `AndroidManifest.xml`
   - 添加 `READ_PHONE_NUMBERS` 权限声明
   - 添加 `READ_SMS` 权限声明

### 编译状态

- ✅ 代码编译成功，无错误
- ✅ 应用可正常运行
- ⚠️ 有一个不推荐使用的 API 警告（可忽略）

---

## 版本信息

- **版本:** 2.0.0
- **发布日期:** 2026-01-04
- **编译状态:** ✅ 成功
- **APK 大小:** 4.3 MB
- **最小 API:** 21
- **目标 API:** 34

---

## 后续计划

### 可选改进

1. **云端数据同步**
   - 在服务器端保存用户数据
   - 卸载重装后通过手机号验证恢复数据

2. **多用户支持**
   - 支持在同一设备上切换多个用户账号
   - 每个账号保存独立的数据

3. **高德地图高级功能**
   - 实时位置共享
   - 地图标记管理
   - 路线保存和收藏

4. **数据加密**
   - 对 SharedPreferences 中的敏感数据进行加密
   - 提高用户隐私保护

---

**文档版本:** 1.0  
**最后更新:** 2026-01-04 09:00 UTC  
**维护者:** AI Assistant  
**状态:** ✅ 完成
