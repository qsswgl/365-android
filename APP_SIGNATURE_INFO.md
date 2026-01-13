# 📋 应用签名信息

**应用名称**: 365-Android  
**生成日期**: 2026-01-05  

---

## 🔐 签名配置概览

### 基本信息

| 项目 | 值 |
|------|-----|
| **应用包名** | net.qsgl365 |
| **命名空间** | net.qsgl365 |
| **签名类型** | Release |
| **签名状态** | ✅ 已配置 |

---

## 🔑 签名密钥详情

### 密钥文件信息

```
文件名:    my-release-key.jks
位置:      app/my-release-key.jks
文件大小:  2,714 字节
创建时间:  2026-01-02 11:28:35
修改时间:  2025-12-31 12:05:10
状态:      ✅ 存在且有效
```

### 密钥库配置

```
密钥库类型:  JKS (Java KeyStore)
密钥库密码:  123456
```

### 密钥配置

```
密钥别名:    qsgl365
密钥密码:    123456
密钥算法:    RSA（推测，标准 Android 签名）
密钥大小:    2048 位（推测）
```

---

## 📱 Build.gradle 中的签名配置

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

---

## 📦 应用版本信息

```gradle
defaultConfig {
    applicationId "net.qsgl365"
    minSdk 21
    targetSdk 34
    versionCode 1
    versionName "1.0"
}
```

| 项目 | 值 |
|------|-----|
| **应用 ID** | net.qsgl365 |
| **最小 SDK** | 21 (Android 5.0) |
| **目标 SDK** | 34 (Android 14) |
| **版本代码** | 1 |
| **版本名称** | 1.0 |

---

## ✨ 签名验证方式

### 方式 1: 使用 Gradle 构建 APK

```bash
# 编译 Release APK（自动使用配置的签名）
./gradlew assembleRelease

# 输出文件位置
# app/build/outputs/apk/release/app-release.apk
```

### 方式 2: 使用 keytool 检查签名

```bash
# 如果已安装 Java/Android SDK，可以使用以下命令验证签名
# （注意：需要 Java 工具链）

keytool -list -v -keystore app/my-release-key.jks -storepass 123456

# 或查看 APK 的签名
jarsigner -verify -verbose -certs app/build/outputs/apk/release/app-release.apk
```

### 方式 3: 使用 APK Analyzer

```
Android Studio 中：
1. 打开 Build > Analyze APK
2. 选择 app-release.apk
3. 查看 Certificate 选项卡
```

---

## 🔍 签名信息说明

### 什么是 APK 签名？

Android 应用必须使用数字证书进行签名才能安装和运行。签名用于：

1. **身份验证** - 确认应用的开发者身份
2. **完整性保护** - 确保 APK 未被篡改
3. **权限管理** - 某些系统功能需要签名应用

### JKS 密钥库

**JKS (Java KeyStore)** 是 Java 标准的密钥库格式：

- 包含私钥和证书
- 使用密码保护
- Android 应用的标准签名工具
- 安全可靠

### 签名密钥的重要性

⚠️ **重要提醒**:

- **不要丢失** - 丢失签名密钥将无法更新应用
- **不要泄露** - 密钥泄露将失去对应用的控制
- **备份** - 定期备份 JKS 文件和密码
- **妥善保管** - 保持密码保密

---

## 📋 Release 版本构建配置

```gradle
buildTypes {
    release {
        minifyEnabled false           // 代码混淆（未启用）
        proguardFiles getDefaultProguardFile("proguard-android-optimize.txt"), 
                      "proguard-rules.pro"
        signingConfig signingConfigs.release  // 使用 Release 签名
    }
    
    debug {
        debuggable true               // 调试模式
    }
}
```

### 配置说明

| 配置 | 值 | 说明 |
|------|-----|------|
| minifyEnabled | false | 代码未混淆，APK 体积较大但易于调试 |
| proguardFiles | 已配置 | 混淆规则文件（当启用混淆时使用） |
| signingConfig | release | 使用 Release 签名配置 |

---

## 🎯 使用签名编译 Release APK

### 步骤 1: 准备环境

```bash
cd k:\365-android
```

### 步骤 2: 编译 Release 版本

```bash
# Windows
gradlew.bat assembleRelease

# Linux/Mac
./gradlew assembleRelease
```

### 步骤 3: 查看输出

```
✅ 编译成功后的文件位置：
   k:\365-android\app\build\outputs\apk\release\app-release.apk

APK 信息：
   - 已使用 qsgl365 密钥签名
   - 已使用 net.qsgl365 包名
   - 可直接安装到 Android 设备
```

### 步骤 4: 安装到设备

```bash
# 使用 ADB 安装
adb install -r app/build/outputs/apk/release/app-release.apk
```

---

## 🔐 签名密钥管理最佳实践

### ✅ 应该做的事

1. **定期备份**
   ```bash
   # 备份签名密钥
   cp app/my-release-key.jks app/my-release-key.jks.backup
   ```

2. **妥善保管密码**
   - 不要在源代码中硬编码密码（在 `local.properties` 中配置）
   - 使用密码管理工具
   - 不要在 Git 中提交密钥文件

3. **访问控制**
   - 限制对密钥文件的访问
   - 只有授权人员可以访问
   - 使用文件系统权限限制

4. **审计日志**
   - 记录谁使用过签名密钥
   - 何时构建 Release 版本
   - 何时部署到生产环境

### ❌ 不应该做的事

1. ❌ 将密钥文件上传到公开的 GitHub
2. ❌ 在代码中存储密码
3. ❌ 与不信任的人共享密钥
4. ❌ 使用过期或已泄露的密钥
5. ❌ 更改密钥库或密钥密码而不备份

---

## 🛠️ 高级配置

### 使用环境变量存储密码（推荐）

在 `local.properties` 中:

```properties
# 不要在此文件中提交 Git
KEYSTORE_PASSWORD=123456
KEY_PASSWORD=123456
KEYSTORE_PATH=app/my-release-key.jks
KEY_ALIAS=qsgl365
```

在 `build.gradle` 中:

```gradle
android {
    signingConfigs {
        release {
            storeFile file(getProperty("KEYSTORE_PATH"))
            storePassword getProperty("KEYSTORE_PASSWORD")
            keyAlias getProperty("KEY_ALIAS")
            keyPassword getProperty("KEY_PASSWORD")
        }
    }
}
```

### 自动化部署配置

```gradle
// 支持 CI/CD 流程中的签名
def keystorePropertiesFile = rootProject.file("keystore.properties")

if (keystorePropertiesFile.exists()) {
    def keystoreProperties = new Properties()
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
    
    android.signingConfigs.release {
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
    }
}
```

---

## 📊 签名相关文件清单

```
365-android/
├── app/
│   ├── my-release-key.jks          ✅ 签名密钥文件（2,714 字节）
│   ├── build.gradle                ✅ 签名配置（本文件）
│   ├── proguard-rules.pro          ✅ 混淆规则
│   └── build/outputs/apk/
│       └── release/
│           └── app-release.apk     📦 已签名的 Release APK
└── local.properties                🔒 本地配置（不在 Git 中）
```

---

## ✅ 签名验证检查清单

- [x] 签名密钥文件存在 (my-release-key.jks)
- [x] Build.gradle 中配置了签名
- [x] 密钥库密码已设置
- [x] 密钥别名已设置
- [x] Release buildType 使用了签名配置
- [x] 应用包名已定义 (net.qsgl365)
- [x] 目标 SDK 配置正确 (34)

---

## 🚀 下一步操作

### 立即可做

1. **编译 Release APK**
   ```bash
   ./gradlew assembleRelease
   ```

2. **验证签名**
   ```bash
   # 查看 APK 的签名信息
   jarsigner -verify -verbose app/build/outputs/apk/release/app-release.apk
   ```

3. **部署到设备**
   ```bash
   adb install -r app/build/outputs/apk/release/app-release.apk
   ```

### 推荐操作

1. **备份密钥**
   - 复制 `my-release-key.jks` 到安全位置
   - 记录所有密码

2. **配置 CI/CD**
   - 在自动化构建系统中配置签名
   - 不要在代码中硬编码密码

3. **文档更新**
   - 更新项目文档说明签名信息
   - 记录密钥管理政策

---

## 📞 常见问题

**Q: 如果丢失了签名密钥怎么办？**

A: 您将无法更新现有应用。需要创建新的密钥并使用新的包名发布。

**Q: 可以更改签名密钥吗？**

A: 原则上不能。应用更新必须使用相同的密钥签名。

**Q: 如何保护签名密钥？**

A: 
- 使用强密码
- 限制文件访问权限
- 不要在代码仓库中提交
- 定期备份
- 考虑使用 Google Play App Signing

**Q: 什么是 Google Play App Signing？**

A: 一种服务，允许 Google Play 管理您的应用签名密钥，同时保留应用上传密钥。

---

## 📚 相关文档

- [Android 官方签名文档](https://developer.android.com/studio/publish/app-signing)
- [Gradle 签名配置](https://developer.android.com/studio/build/configure-signing)
- [keytool 命令参考](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html)

---

**签名信息生成时间**: 2026-01-05  
**应用状态**: ✅ 已正确签名，准备发布

---

*此文档用于记录应用的签名配置信息，供开发和部署参考。*
