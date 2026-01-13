# 📋 扫码失败错误诊断和修复指南

## 🔴 问题现象

从Chrome DevTools的Console看到以下错误：
```
[11:08:05] 扫码已取消
[11:08:05] ✖️ 扫码失败: ERROR
内容: value=null, format=CANCELLED 或 format=ERROR
```

---

## 🔍 根本原因分析

### 原因 1: 权限被拒绝
- 用户点击"启动扫码"时，Android系统弹出摄像头权限请求
- 用户选择了"拒绝"或"取消"
- 导致 `onRequestPermissionsResult()` 返回 `PERMISSION_DENIED`
- 扫码无法继续，返回 `format=CANCELLED` 或 `format=ERROR`

### 原因 2: localStorage相关的Warning（非关键）
- 控制台出现 `+restoreLocalStorage 为未定义`
- 这是来自于某个全局脚本，不影响扫码功能
- 可以忽略此警告

---

## ✅ 解决方案

### 📌 方案 1: 手动授予权限（推荐）

**步骤 1 - 打开应用设置**
```bash
步骤详解:
1. 打开设备上的"设置"应用
2. 搜索或导航到"应用" > "应用管理"
3. 找到"365农行"应用
4. 点击"权限"或"应用权限"
5. 找到"摄像头"权限
6. 设置为"允许"
```

**步骤 2 - 通过命令行授予权限**
```powershell
# 直接授予摄像头权限（推荐）
.\adb shell pm grant net.qsgl365 android.permission.CAMERA

# 查看权限是否已授予
.\adb shell pm list permissions -g | grep net.qsgl365
```

**步骤 3 - 重新启动应用**
```powershell
# 关闭应用
.\adb shell am force-stop net.qsgl365

# 重新启动
.\adb shell am start -n net.qsgl365/.MainActivity
```

**步骤 4 - 再次测试**
```
1. 打开测试页面: http://192.168.1.129:8080/pwa/barcode-test-simple.html
2. 点击"🔍 启动扫码"按钮
3. 这次应该【不会】弹出权限请求了
4. 直接看到摄像头预览
5. 扫描二维码/条形码
```

---

### 📌 方案 2: 自动化脚本一键修复

创建批处理脚本 `fix_barcode_permissions.bat`:

```batch
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ====================================
echo 扫码权限一键修复工具
echo ====================================
echo.

REM 检查 ADB 是否可用
.\adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到 adb.exe
    echo 请确保在 365-android 目录中运行此脚本
    pause
    exit /b 1
)

echo ✓ ADB 连接正常

REM 授予权限
echo.
echo [1/4] 正在授予摄像头权限...
.\adb shell pm grant net.qsgl365 android.permission.CAMERA
echo ✓ 权限已授予

REM 清空应用数据（可选）
echo.
echo [2/4] 清空应用缓存...
.\adb shell pm clear net.qsgl365
echo ✓ 缓存已清空

REM 关闭应用
echo.
echo [3/4] 关闭应用...
.\adb shell am force-stop net.qsgl365
timeout /t 2 >nul
echo ✓ 应用已关闭

REM 启动应用
echo.
echo [4/4] 重新启动应用...
.\adb shell am start -n net.qsgl365/.MainActivity
timeout /t 3 >nul
echo ✓ 应用已启动

echo.
echo ====================================
echo ✅ 修复完成！
echo ====================================
echo.
echo 现在请:
echo 1. 打开浏览器
echo 2. 访问: http://192.168.1.129:8080/pwa/barcode-test-simple.html
echo 3. 点击"启动扫码"按钮测试
echo.
pause
```

**使用方法：**
```powershell
cd K:\365-android
.\fix_barcode_permissions.bat
```

---

## 🔧 完整故障排除流程

### 检查 1: 权限状态
```powershell
# 查看应用的所有权限
.\adb shell pm list permissions -g | grep -A 20 net.qsgl365
```

预期输出应包含：
```
...
android.permission.CAMERA: ✓ (已授予)
...
```

### 检查 2: 查看 logcat 中的权限相关日志
```powershell
# 清空旧日志
.\adb logcat -c

# 重新启动应用
.\adb shell am start -n net.qsgl365/.MainActivity

# 等待权限对话框出现，然后点击允许或拒绝

# 查看日志
.\adb logcat -v threadtime | Select-String "权限|Permission|BarcodeScannerActivity"
```

预期看到的日志：
```
[✅ 成功情况]
01-07 11:15:30.123  2024  2024 D BarcodeScannerActivity: ✅ 摄像头权限已授予
01-07 11:15:30.234  2024  2024 D BarcodeScannerActivity: 启动摄像头...

[❌ 失败情况]
01-07 11:15:30.123  2024  2024 D BarcodeScannerActivity: ❌ 摄像头权限被拒绝
01-07 11:15:30.234  2024  2024 D BarcodeScannerActivity: 设置返回结果为 RESULT_CANCELED
```

### 检查 3: WebView Bridge 连接
```powershell
# 查看 WebView 相关日志
.\adb logcat -v threadtime | Select-String "WebView|JavascriptInterface|onBarcodeScanned"
```

---

## 💡 常见问题

### Q: 为什么显示 `format=CANCELLED`?
**A:** 用户在权限请求对话框中点击了"拒绝"或"取消"按钮。

**解决：** 在系统设置中手动授予权限，或运行自动脚本 `fix_barcode_permissions.bat`

### Q: 为什么显示 `format=ERROR`?
**A:** 可能的原因：
1. 权限被拒绝
2. 摄像头无法打开（摄像头被其他应用占用）
3. ML Kit 初始化失败

**解决：**
1. 授予权限
2. 关闭其他使用摄像头的应用
3. 清空应用缓存后重试

### Q: 能否跳过权限检查？
**A:** 不能跳过，这是 Android 安全机制。但您可以：
1. 使用 ADB 命令自动授予权限（开发用途）
2. 在应用首次启动时就请求权限（已实现）

### Q: JavaScript 中的 `+restoreLocalStorage 为未定义` 是什么?
**A:** 这是来自页面其他脚本的警告，与扫码功能无关。可以安全忽略。

---

## 📊 验证清单

- [ ] 已在系统设置中授予"摄像头"权限
- [ ] 已运行 `adb shell pm grant net.qsgl365 android.permission.CAMERA` 命令
- [ ] 已重新启动应用
- [ ] 打开测试页面时没有权限弹窗出现
- [ ] 点击"启动扫码"后能看到摄像头预览
- [ ] 能够成功扫描二维码/条形码
- [ ] logcat 中显示 `✅ 摄像头权限已授予` 日志

---

## 🔗 相关文档

- **快速命令参考**: `BARCODE_QUICK_COMMAND_CARD.md`
- **完整测试指南**: `BARCODE_TESTING_GUIDE.md`
- **技术报告**: `BARCODE_FINAL_COMPREHENSIVE_REPORT.md`
- **项目完成报告**: `PROJECT_COMPLETION_REPORT.md`

---

## ⏱️ 预计修复时间

| 方案 | 时间 | 难度 |
|-----|------|------|
| 系统设置授权 | 5 分钟 | ⭐ 简单 |
| ADB 命令授权 | 2 分钟 | ⭐⭐ 中等 |
| 自动脚本授权 | 1 分钟 | ⭐ 简单 |

---

**最后更新**: 2026年1月7日 11:12  
**状态**: ✅ 就绪  
**建议**: 立即使用方案 1 或方案 2 授予权限，然后重新测试
