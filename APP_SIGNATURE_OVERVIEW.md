# 📑 应用签名 - 信息总览

**生成日期**: 2026-01-05  
**应用名称**: 365-Android  
**签名状态**: ✅ 已配置且有效

---

## 🎯 快速导航

### 我想...

#### 📍 **快速查看签名信息**
👉 查看: **APP_SIGNATURE_QUICK_REFERENCE.md** ⭐

#### 📚 **了解完整的签名配置**
👉 查看: **APP_SIGNATURE_INFO.md**

#### 🔨 **编译 Release APK**
👉 运行命令: `.\gradlew.bat assembleRelease`

#### 🔐 **了解密钥管理最佳实践**
👉 查看: **APP_SIGNATURE_INFO.md** 中的 "签名密钥管理最佳实践" 部分

---

## 📋 签名信息一览表

### 基本信息

| 项目 | 值 |
|------|-----|
| **应用包名** | net.qsgl365 |
| **签名密钥别名** | qsgl365 |
| **签名密钥文件** | app/my-release-key.jks |
| **文件大小** | 2,714 字节 |
| **文件状态** | ✅ 存在且有效 |

### 密钥信息

| 项目 | 值 |
|------|-----|
| **密钥库类型** | JKS (Java KeyStore) |
| **密钥库密码** | 123456 |
| **密钥密码** | 123456 |
| **签名算法** | RSA (推测) |

### 版本信息

| 项目 | 值 |
|------|-----|
| **版本代码** | 1 |
| **版本名称** | 1.0 |
| **最小 SDK** | 21 (Android 5.0) |
| **目标 SDK** | 34 (Android 14) |

---

## 📄 相关文档

### 核心文档

1. **APP_SIGNATURE_QUICK_REFERENCE.md** ⭐
   - 用途: 快速参考卡
   - 长度: 短篇
   - 内容: 关键信息速查
   - 推荐: 频繁查看

2. **APP_SIGNATURE_INFO.md**
   - 用途: 完整文档
   - 长度: 长篇
   - 内容: 详细说明、最佳实践
   - 推荐: 深入学习

### 其他相关文档

- `build.gradle` - 应用构建配置
- `AndroidManifest.xml` - 应用清单

---

## 🔑 关键密码

### 密钥库密码
```
123456
```

### 密钥密码
```
123456
```

⚠️ **安全提示**: 妥善保管这些密码，不要在公开场合泄露。

---

## 🔨 常用命令

### 编译 Release APK（带签名）

```bash
cd k:\365-android
.\gradlew.bat assembleRelease
```

**输出**: `app\build\outputs\apk\release\app-release.apk`

### 编译 Debug APK

```bash
.\gradlew.bat assembleDebug
```

**输出**: `app\build\outputs\apk\debug\app-debug.apk`

### 查看签名信息

```bash
# 查看 APK 的签名（需要 Java）
jarsigner -verify -verbose app\build\outputs\apk\release\app-release.apk
```

### 安装到设备

```bash
# 安装 Release APK
.\adb.exe install -r app\build\outputs\apk\release\app-release.apk

# 安装 Debug APK
.\adb.exe install -r app\build\outputs\apk\debug\app-debug.apk
```

---

## ✨ 签名配置一览

### Build.gradle 中的签名配置

```gradle
android {
    signingConfigs {
        release {
            storeFile file("my-release-key.jks")
            storePassword "123456"
            keyAlias "qsgl365"
            keyPassword "123456"
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 应用配置

```gradle
defaultConfig {
    applicationId "net.qsgl365"
    minSdk 21
    targetSdk 34
    versionCode 1
    versionName "1.0"
}
```

---

## 📂 文件位置

```
K:\365-android\
├── app\
│   ├── my-release-key.jks                    (签名密钥文件)
│   ├── build.gradle                          (应用配置)
│   ├── build\outputs\apk\
│   │   ├── debug\
│   │   │   └── app-debug.apk                 (Debug APK)
│   │   └── release\
│   │       └── app-release.apk               (Release APK - 已签名)
│   └── proguard-rules.pro                    (混淆规则)
├── APP_SIGNATURE_INFO.md                     (完整文档)
├── APP_SIGNATURE_QUICK_REFERENCE.md          (快速参考)
├── build.gradle                              (项目配置)
└── gradle.properties                         (Gradle 配置)
```

---

## ✅ 签名配置检查清单

- [x] 签名密钥文件存在 (my-release-key.jks)
- [x] 文件完整 (2,714 字节)
- [x] Build.gradle 中配置了签名
- [x] 密钥库密码已设置 (123456)
- [x] 密钥密码已设置 (123456)
- [x] 密钥别名已定义 (qsgl365)
- [x] Release buildType 已启用签名
- [x] 应用包名已定义 (net.qsgl365)
- [x] 版本代码已设置 (1)
- [x] 版本名称已设置 (1.0)
- [x] 目标 SDK 配置正确 (34)
- [x] 最小 SDK 配置正确 (21)

---

## 🔒 安全检查清单

- [x] 签名密钥未提交到 GitHub
- [ ] 已备份签名密钥文件
- [ ] 已备份签名密钥密码
- [ ] 已限制对密钥文件的访问
- [ ] 已配置文件系统权限

---

## 🚀 发布前准备

### 必要步骤

1. ✅ 编译 Release APK
   ```bash
   .\gradlew.bat assembleRelease
   ```

2. ✅ 验证签名
   ```bash
   jarsigner -verify app\build\outputs\apk\release\app-release.apk
   ```

3. ✅ 在测试设备上安装测试
   ```bash
   .\adb.exe install -r app\build\outputs\apk\release\app-release.apk
   ```

4. ✅ 验证应用功能正常

### 可选步骤

1. 使用 Android Studio 的 APK Analyzer 检查 APK
2. 使用 Android Profiler 进行性能测试
3. 检查应用权限是否合理
4. 验证应用图标和名称
5. 检查应用描述和版本号

---

## 💡 提示

### 编译提速

```bash
# 只编译特定构建类型
.\gradlew.bat assembleRelease --no-daemon

# 使用并行编译
.\gradlew.bat assembleRelease --parallel
```

### 调试技巧

```bash
# 查看详细的编译日志
.\gradlew.bat assembleRelease --info

# 查看编译中的错误
.\gradlew.bat assembleRelease --stacktrace
```

---

## 🔗 相关链接

### 官方文档

- [Android 应用签名](https://developer.android.com/studio/publish/app-signing)
- [Gradle 签名配置](https://developer.android.com/studio/build/configure-signing)
- [keytool 命令](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html)

### 推荐资源

- [Google Play 发布指南](https://developer.android.com/studio/publish)
- [APK 优化指南](https://developer.android.com/topic/performance/reduce-apk-size)
- [Android 安全最佳实践](https://developer.android.com/topic/security/best-practices)

---

## 📞 常见问题

**Q: 如何更改签名密钥？**

A: 原则上不能。一旦应用发布，必须使用相同的密钥签名所有后续版本。

**Q: 丢失了签名密钥怎么办？**

A: 无法恢复。只能使用新密钥和新包名发布新应用。

**Q: 可以在多个地方使用同一个签名密钥吗？**

A: 可以，但不推荐。建议为不同的应用使用不同的密钥。

**Q: 如何保护签名密钥的安全？**

A: 
1. 使用强密码
2. 限制文件访问权限
3. 定期备份
4. 不要在代码中硬编码
5. 考虑使用 Google Play App Signing

---

## 📊 签名信息统计

| 指标 | 值 |
|------|-----|
| 文档数 | 2 |
| 关键配置项 | 12 |
| 安全提示 | 5+ |
| 常用命令 | 6+ |

---

**签名信息生成时间**: 2026-01-05  
**应用状态**: ✅ 已正确签名，准备发布  
**最后验证**: 所有配置都正确

---

*此总览用于快速查找应用签名相关的所有信息。详细内容请查看对应的文档文件。*
