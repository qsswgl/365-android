# 🔐 应用签名 - 快速参考卡

## 签名基本信息

```
应用包名:        net.qsgl365
命名空间:        net.qsgl365
签名密钥:        qsgl365
密钥文件:        app/my-release-key.jks
文件大小:        2,714 字节
状态:            ✅ 已配置且有效
```

---

## 密钥库密码

```
密钥库类型:      JKS (Java KeyStore)
密钥库密码:      123456
密钥密码:        123456
```

---

## 版本信息

| 项目 | 值 |
|------|-----|
| 版本代码 | 1 |
| 版本名称 | 1.0 |
| 最小 SDK | 21 (Android 5.0) |
| 目标 SDK | 34 (Android 14) |
| 编译工具 | Android Gradle Plugin |

---

## 构建命令

### 编译 Release APK（带签名）

```bash
.\gradlew.bat assembleRelease
```

### 输出文件

```
app\build\outputs\apk\release\app-release.apk
```

### 安装到设备

```bash
.\adb.exe install -r app\build\outputs\apk\release\app-release.apk
```

---

## Build.gradle 签名配置

```gradle
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
```

---

## 🔒 安全提示

| 提示 | 详情 |
|------|------|
| ⚠️ 不要泄露 | 签名密钥是应用的身份证，泄露会失去控制权 |
| ⚠️ 不要上传 | 不要将 JKS 文件提交到公开的 GitHub |
| ⚠️ 需备份 | 丢失密钥后无法更新应用，定期备份 |
| ⚠️ 妥善保管 | 不要在代码中硬编码密码 |

---

## 验证签名

### 查看 APK 签名信息

```bash
# 需要 Java 环境
jarsigner -verify -verbose app\build\outputs\apk\release\app-release.apk
```

---

## 文件位置

```
K:\365-android\
├── app\
│   ├── my-release-key.jks          ← 签名密钥文件
│   ├── build.gradle                ← 签名配置
│   └── build\outputs\apk\release\
│       └── app-release.apk         ← 已签名 APK
└── APP_SIGNATURE_INFO.md           ← 详细文档
```

---

## 关键信息速查

**密钥库密码**: 123456  
**密钥别名**: qsgl365  
**密钥密码**: 123456  
**应用包名**: net.qsgl365  

---

**✅ 应用已准备好进行签名发布！**
