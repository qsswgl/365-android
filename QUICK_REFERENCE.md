# 快速参考卡片 - 365 应用新功能

## 🎯 功能 1: 升级时保留用户注册信息

### 快速集成

#### Android 端（已完成）✅
```java
// 1. 初始化（onCreate 中）
userDataManager = new UserDataManager(this);

// 2. 保存用户数据（从 JavaScript 调用）
if (userDataManager.isUserRegistered()) {
    // 用户已注册，自动跳过注册
}
```

#### JavaScript 端

```javascript
// 1. 检查用户是否已注册
if (AndroidBridge.isUserRegistered()) {
    showMainPage();  // 显示主程序
} else {
    showRegistrationPage();  // 显示注册界面
}

// 2. 用户完成注册后，保存数据
AndroidBridge.saveUserData(
    '13800138000',    // 手机号
    'user_123',       // 用户ID
    '张三',           // 用户名
    '{}'              // 自定义信息（JSON）
);

// 3. 监听升级后的数据恢复
window.onUserDataRestored = function(userData) {
    console.log("用户已恢复:", userData);
    // 自动进入主程序
};
```

---

## 🌍 功能 2: WebView 调用高德地图

### 最简单的使用方式

#### HTML 链接（推荐用于简单场景）

```html
<!-- 导航到目的地 -->
<a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=出发&endLat=39.9042&endLng=116.4073&endName=天安门&mode=driving">
  导航到天安门
</a>

<!-- 搜索 -->
<a href="amap://search?sourceApplication=net.qsgl365&keyword=餐厅">
  搜索餐厅
</a>

<!-- 查看地点 -->
<a href="amap://viewUri?sourceApplication=net.qsgl365&name=天安门&poiId=B000A8SF1H">
  天安门详情
</a>
```

#### JavaScript 函数（推荐用于动态场景）

```javascript
class AmapNavigator {
    constructor(appName = "net.qsgl365") {
        this.appName = appName;
    }
    
    // 导航
    navigateTo(sLat, sLng, sName, eLat, eLng, eName, mode = 'driving') {
        const url = `amap://path?sourceApplication=${this.appName}` +
                    `&startLat=${sLat}&startLng=${sLng}&startName=${encodeURIComponent(sName)}` +
                    `&endLat=${eLat}&endLng=${eLng}&endName=${encodeURIComponent(eName)}` +
                    `&mode=${mode}`;
        window.location.href = url;
    }
    
    // 搜索
    search(keyword) {
        const url = `amap://search?sourceApplication=${this.appName}&keyword=${encodeURIComponent(keyword)}`;
        window.location.href = url;
    }
    
    // 地点详情
    viewPOI(poiId, poiName) {
        const url = `amap://viewUri?sourceApplication=${this.appName}&poiId=${poiId}&name=${encodeURIComponent(poiName)}`;
        window.location.href = url;
    }
}

// 使用示例
const nav = new AmapNavigator("net.qsgl365");
nav.navigateTo(39.9489, 116.4387, "北京站", 39.9042, 116.4073, "天安门", "driving");
nav.search("餐厅");
nav.viewPOI("B000A8SF1H", "天安门");
```

---

## 📋 高德地图 URL 参数速查表

### 路线规划 (mode 参数)

| mode 值 | 含义 | 使用场景 |
|---------|------|---------|
| `driving` | 驾车 | 开车导航（默认） |
| `transit` | 公交 | 公共交通 |
| `walking` | 步行 | 步行导航 |

### 必填参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `sourceApplication` | 应用名称（必填） | `net.qsgl365` |
| `endLat`, `endLng` | 目标位置（必填） | `39.9042,116.4073` |

### 可选参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `startLat`, `startLng` | 起点位置 | `39.9489,116.4387` |
| `startName` | 起点名称 | `北京站` |
| `endName` | 终点名称 | `天安门` |

---

## 🔍 API 参考

### UserDataManager 核心方法

```java
// 保存数据
userDataManager.savePhoneNumber(String)
userDataManager.saveUserId(String)
userDataManager.saveUserName(String)
userDataManager.saveUserInfo(String)

// 读取数据
userDataManager.getPhoneNumber()
userDataManager.getUserId()
userDataManager.getUserName()
userDataManager.getUserInfo()

// 检查状态
userDataManager.isUserRegistered()       // 检查是否注册
userDataManager.hasAppUpgraded()         // 检查是否升级

// 调试和管理
userDataManager.getAllUserData()         // 获取所有数据
userDataManager.clearAllUserData()       // 清除所有数据
```

### JavaScript Bridge 方法

```javascript
// 保存用户数据
AndroidBridge.saveUserData(phoneNumber, userId, userName, userInfo)

// 获取保存的用户数据（返回 JSON）
const userData = AndroidBridge.getSavedUserData()

// 检查是否已注册
const isRegistered = AndroidBridge.isUserRegistered()

// 获取设备信息
const deviceInfo = AndroidBridge.getDeviceInfo()

// 获取手机号
const phoneNumber = AndroidBridge.getPhoneNumber()
```

---

## 🧪 常见代码片段

### 完整的注册+保存流程

```javascript
// 1. 页面加载时检查状态
window.addEventListener('load', function() {
    if (AndroidBridge && AndroidBridge.isUserRegistered()) {
        console.log("用户已注册，进入主程序");
        showMainPage();
    } else {
        console.log("显示注册界面");
        showRegistrationForm();
    }
});

// 2. 用户提交注册表单
function submitRegistration(formData) {
    // 验证数据
    const phoneNumber = formData.phoneNumber;
    const userId = formData.userId;
    const userName = formData.userName;
    
    // 保存到 Android
    if (window.AndroidBridge) {
        AndroidBridge.saveUserData(phoneNumber, userId, userName, '{}');
        console.log("用户数据已保存");
    }
    
    // 进入主程序
    showMainPage();
}

// 3. 应用升级后
window.onUserDataRestored = function(userData) {
    console.log("升级后自动恢复用户数据:", userData);
    // 自动跳过注册，进入主程序
    showMainPage();
};
```

### 完整的高德地图导航

```javascript
function navigateToDestination() {
    // 方式 1: 直接使用 URL（简单）
    // window.location.href = "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&endLat=39.9042&endLng=116.4073&mode=driving";
    
    // 方式 2: 使用封装的类（推荐）
    const nav = new AmapNavigator("net.qsgl365");
    
    // 从当前位置导航到天安门
    nav.navigateTo(
        39.9489,       // 起点纬度
        116.4387,      // 起点经度
        "我的位置",    // 起点名称
        39.9042,       // 终点纬度
        116.4073,      // 终点经度
        "天安门",      // 终点名称
        "driving"      // 驾车模式
    );
}
```

---

## 📞 调试命令

```bash
# 查看日志
adb logcat | grep WebView

# 查看用户数据存储位置
adb shell ls -la /data/data/net.qsgl365/shared_prefs/

# 查看 SharedPreferences 内容
adb shell cat /data/data/net.qsgl365/shared_prefs/qsgl365_user_data.xml

# 测试高德地图链接（不通过应用）
adb shell am start -a android.intent.action.VIEW -d "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&endLat=39.9042&endLng=116.4073&mode=driving"
```

---

## ⚠️ 常见问题速解

### Q: 用户卸载后数据还存在吗？
**A:** 不存在。卸载时 Android 系统会删除 `/data/data/net.qsgl365`。如需保留，需要云端存储。

### Q: 高德地图链接打不开？
**A:** 
1. 检查高德地图是否安装
2. 检查 URL 格式是否正确
3. 检查坐标是否有效
4. 查看 logcat: `adb logcat | grep WebView`

### Q: 如何清除保存的用户数据？
**A:** 在 Java 中调用: `userDataManager.clearAllUserData()`

### Q: 支持多个用户吗？
**A:** 当前实现只支持单用户。多用户需要修改 SharedPreferences 的 key。

### Q: 能否在后台保存数据？
**A:** 可以。在任何地方调用 `userDataManager.saveXxx()` 都会立即保存。

---

## 📚 相关文档

| 文档 | 用途 |
|------|------|
| `FEATURE_IMPLEMENTATION_GUIDE.md` | 完整的实现说明和代码 |
| `AMAP_INTEGRATION_GUIDE.md` | 高德地图集成详细指南 |
| `NEW_FEATURES_SUMMARY.md` | 新功能总结（本次发布） |

---

## ✅ 验收清单

部署前检查：
- [ ] 编译成功（BUILD SUCCESSFUL）
- [ ] APK 生成（4.3 MB）
- [ ] 可以安装到设备
- [ ] 应用可以启动
- [ ] 没有崩溃日志

功能测试：
- [ ] 首次运行显示注册界面
- [ ] 可以保存用户数据
- [ ] 升级后数据保留
- [ ] 高德地图链接可打开
- [ ] 未安装时有提示

---

**版本:** 2.0.0  
**发布日期:** 2026-01-04  
**状态:** ✅ 完成
