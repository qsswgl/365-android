# 🚀 扫码功能修复 - 快速命令参考卡

## ⚡ 最常用的命令

### 编译-安装-运行（3 条命令）
```bash
# 1. 编译
cd K:\365-android && .\gradlew.bat assembleDebug

# 2. 安装
.\adb install -r app\build\outputs\apk\debug\app-debug.apk

# 3. 运行
.\adb shell am start -n net.qsgl365/.MainActivity
```

### 日志（2 条命令）
```bash
# 开始监听
.\adb logcat *:V

# 只看扫码相关日志
.\adb logcat | findstr "BarcodeScannerActivity|MainActivity"
```

### 权限（2 条命令）
```bash
# 授予权限
.\adb shell pm grant net.qsgl365 android.permission.CAMERA

# 检查权限
.\adb shell pm list permissions -d | findstr CAMERA
```

---

## 🎯 3 步测试

```
1️⃣  清除日志并启动应用
   .\adb logcat -c
   .\adb shell am start -n net.qsgl365/.MainActivity

2️⃣  访问测试页面
   打开浏览器: http://192.168.1.129:8080/pwa/barcode-test-simple.html

3️⃣  执行测试
   • 点击 "启动扫码"
   • 在权限对话框中选择 "允许"
   • 在摄像头中显示二维码
   • 查看结果
```

---

## 🚨 3 个快速修复

### 问题 1: 权限被拒
```bash
# 快速修复
.\adb shell pm grant net.qsgl365 android.permission.CAMERA
.\adb shell am force-stop net.qsgl365
.\adb shell am start -n net.qsgl365/.MainActivity
```

### 问题 2: 扫码失败
```bash
# 快速修复
.\adb shell pm clear net.qsgl365
.\adb shell pm grant net.qsgl365 android.permission.CAMERA
.\adb shell am start -n net.qsgl365/.MainActivity
```

### 问题 3: 编译错误
```bash
# 快速修复
.\gradlew.bat clean
.\gradlew.bat assembleDebug --stacktrace
```

---

## ✅ 验证清单

- [ ] `.\adb devices` 显示设备已连接
- [ ] `.\gradlew.bat assembleDebug` 成功（BUILD SUCCESSFUL）
- [ ] `.\adb install -r app\build\outputs\apk\debug\app-debug.apk` 成功（Success）
- [ ] 应用启动成功
- [ ] 能访问测试页面
- [ ] 点击"启动扫码"出现权限对话框
- [ ] 授予权限后看到摄像头
- [ ] 扫码成功

---

## 🔍 关键日志指标

| 指标 | 含义 | 状态 |
|-----|------|------|
| `✅ 摄像头权限已授予` | 权限检查成功 | ✅ 正常 |
| `❌ 摄像头权限被拒绝` | 权限被拒 | ⚠️ 需要处理 |
| `条码扫描检测到` | 扫码成功 | ✅ 正常 |
| `ERROR` 或 `CANCELLED` | 扫码失败 | ❌ 异常 |

---

## 📁 关键文件

```
测试页面: app/assets/pwa/barcode-test-simple.html
主 Activity: app/src/main/java/net/qsgl365/MainActivity.java
扫码 Activity: app/src/main/java/net/qsgl365/BarcodeScannerActivity.java
```

---

## 🔗 常用 URLs

```
测试页面: http://192.168.1.129:8080/pwa/barcode-test-simple.html
应用主页: http://192.168.1.129:8080/
```

---

**快速参考卡** | 完成日期: 2025年1月7日 | ✅ 可用
