# 修复快速参考

## 两个问题的解决

### ❌ 问题1：Amap未自动绑定目的地

**原因：** URI Scheme格式错误

**修复：**
```java
// 原来
intent.setData(Uri.parse(amapUrl));  // ❌ 错误的格式

// 修复后
String amapScheme = String.format(
    "amap://navi?start=%s,%s&destination=%s,%s&mode=driving&sourceApplication=net.qsgl365",
    lat1, lng1, lat2, lng2  // ✅ 正确的Amap格式
);
intent.setData(Uri.parse(amapScheme));
```

**效果：** ✅ Amap自动显示导航坐标

---

### ❌ 问题2：返回后白屏

**原因：** 缺少Activity生命周期管理

**修复：**
```java
// 新增onResume()方法
@Override
protected void onResume() {
    super.onResume();
    if (webView != null) {
        webView.onResume();  // ✅ 恢复WebView
        webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");  // ✅ 重新注入
    }
}
```

**效果：** ✅ 返回后App正常显示

---

## 代码改动统计

| 项目 | 内容 |
|------|------|
| **文件修改** | `MainActivity.java` |
| **新增方法** | `onResume()`, `onPause()` |
| **修改方法** | `tryOpenWithPackage()` |
| **总改动** | ~50 行代码 |
| **编译状态** | ✅ BUILD SUCCESSFUL |

---

## 验证步骤（5分钟）

### 验证问题1
```
1. 打开365APP
2. 点击导航
3. 高德地图启动 → 坐标已显示 ✅
```

### 验证问题2
```
1. 在Amap中操作
2. 返回APP
3. 界面正常显示 ✅
```

---

## 日志关键字

### 问题1修复日志
```
"使用坐标构建Amap Scheme"
"amap://navi?start=X,Y&destination=Z,W"
"已启动应用: com.autonavi.minimap"
```

### 问题2修复日志
```
"Activity onResume 被调用"
"已重新注入JavaScript Bridge"
"已执行页面恢复脚本"
```

---

## 关键方法说明

### tryOpenWithPackage()
```
作用：启动高德地图并传递坐标
改进：
  • 提取URL中的坐标参数
  • 转换为Amap期望的URI Scheme格式
  • 自动绑定导航目的地
```

### onResume()
```
作用：从后台返回时恢复App状态
改进：
  • 恢复WebView JavaScript执行
  • 重新注入JavaScript Bridge
  • 执行页面恢复脚本
```

---

## 常见问题速查

| 问题 | 解决方案 |
|------|---------|
| Amap仍未显示坐标 | 检查日志"无法提取坐标" → 确认URL参数格式 |
| 返回后仍白屏 | 检查logcat是否有onResume()日志 → 重启App |
| 导航功能不可用 | 检查高德地图应用是否安装 |

---

## 部署命令

```powershell
# 编译
./gradlew assembleRelease

# 卸载旧版
adb uninstall net.qsgl365

# 安装新版
adb install app/build/outputs/apk/release/app-release.apk

# 启动测试
adb shell am start -n net.qsgl365/.MainActivity
```

---

## 📊 修复对比

### 修复前
```
点击导航 → Amap启动 → ❌ 无坐标 → 需手动输入
返回App → ❌ 白屏 → 需重启
```

### 修复后
```
点击导航 → Amap启动 → ✅ 自动显示坐标 → 直接导航
返回App → ✅ 正常显示 → 继续使用
```

---

**修复完成日期：** 2026年1月4日

**APK版本：** app-release.apk (29.55 MB)

**编译状态：** ✅ BUILD SUCCESSFUL in 2m 29s

