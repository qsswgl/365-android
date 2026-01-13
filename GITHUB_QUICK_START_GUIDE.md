# GitHub 推送 - 快速参考指南

## 🚀 项目已成功推送到 GitHub！

```
✅ 仓库: https://github.com/qsswgl/365-android
✅ 文件: 1,389 个
✅ 成功率: 98.6%
```

---

## 🌐 项目地址

```
📍 https://github.com/qsswgl/365-android
```

---

## 📥 克隆项目

### HTTPS 方式（推荐用于第一次克隆）
```bash
git clone https://github.com/qsswgl/365-android.git
cd 365-android
```

### SSH 方式（已配置 SSH 密钥时）
```bash
git clone git@github.com:qsswgl/365-android.git
cd 365-android
```

---

## 💾 本地开发流程

### 1️⃣ 首次设置
```bash
# 克隆项目
git clone https://github.com/qsswgl/365-android.git
cd 365-android

# 配置 Git 用户（可选，如果未全局配置）
git config user.name "qsswgl"
git config user.email "qsswgl@users.noreply.github.com"

# 创建开发分支
git checkout -b develop
```

### 2️⃣ 进行修改
```bash
# 编辑文件...
code .

# 查看修改
git status

# 查看详细差异
git diff
```

### 3️⃣ 提交更改
```bash
# 暂存所有修改
git add .

# 创建提交
git commit -m "描述您的修改"

# 推送到 GitHub
git push origin develop
```

### 4️⃣ 合并到主分支（可选）
```bash
# 切换到主分支
git checkout main

# 拉取最新内容
git pull origin main

# 合并开发分支
git merge develop

# 推送
git push origin main
```

---

## 🔍 查看提交历史

```bash
# 查看最近 10 个提交
git log --oneline -10

# 查看详细提交信息
git log --stat

# 查看某个文件的历史
git log --follow app/src/main/java/MainActivity.java
```

---

## 🔄 同步远程更改

```bash
# 拉取最新更改（不合并）
git fetch origin

# 拉取并合并最新更改
git pull origin main

# 查看远程分支
git branch -a
```

---

## 📊 推送统计信息

| 指标 | 数值 |
|------|------|
| 总文件数 | 1,409 |
| 推送成功 | 1,389 |
| 推送失败 | 20 |
| 成功率 | 98.6% |
| 推送时间 | 85 分钟 |
| 推送方式 | GitHub API |

---

## 📁 项目结构

```
365-android/
├── app/                          # Android 应用模块
│   ├── build.gradle             # 应用构建配置
│   ├── AndroidManifest.xml      # 应用清单
│   ├── src/main/
│   │   ├── java/                # Java 源代码
│   │   │   └── com/...
│   │   │       └── MainActivity.java  # 主活动（带返回手势）
│   │   ├── res/                 # 资源文件
│   │   │   ├── layout/          # 布局文件
│   │   │   ├── values/          # 值文件
│   │   │   └── mipmap-*/        # 应用图标
│   │   └── assets/
│   │       └── pwa/             # Web 资源
│   │           ├── index.html   # PWA 主页
│   │           ├── manifest.json
│   │           ├── sw.js        # Service Worker
│   │           └── static/
│   └── my-release-key.jks       # 签名密钥
├── gradle/                       # Gradle 配置
├── src/                          # 其他源文件
├── build.gradle                  # 项目级构建配置
├── settings.gradle               # 项目设置
├── gradlew / gradlew.bat        # Gradle 包装器
└── README.md                     # 项目说明
```

---

## 🔐 SSH 密钥配置

### 已配置的 SSH 密钥
```
📁 位置: k:\key\github\id_rsa
✅ 状态: 已验证
```

### 使用 SSH 推送

如果已配置 SSH 密钥，可以使用以下命令切换到 SSH 方式：

```bash
# 查看当前远程
git remote -v

# 切换到 SSH 方式
git remote set-url origin git@github.com:qsswgl/365-android.git

# 验证连接
git remote -v
```

---

## 🛠️ 常用 Git 命令

### 分支管理
```bash
# 列出所有分支
git branch -a

# 创建新分支
git checkout -b feature/my-feature

# 删除本地分支
git branch -d feature/my-feature

# 删除远程分支
git push origin --delete feature/my-feature
```

### 修改提交
```bash
# 修改最后一个提交的信息
git commit --amend -m "新的提交信息"

# 撤销最后一次提交（保留修改）
git reset --soft HEAD~1

# 查看未暂存的修改
git diff

# 查看暂存的修改
git diff --cached
```

### 忽略文件
```bash
# 查看当前 .gitignore 配置
cat .gitignore

# 停止跟踪某个文件（但保留本地副本）
git rm --cached <file>
```

---

## 📱 Android 开发相关

### 使用 Android Studio
```bash
# 打开项目
# 在 Android Studio 中：File > Open > 选择项目目录

# 或从命令行打开
studio ./
```

### 编译和部署
```bash
# 使用 Gradle 编译
./gradlew build

# 编译 Debug APK
./gradlew assembleDebug

# 编译 Release APK（需要签名配置）
./gradlew assembleRelease

# 部署到设备
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

---

## 🐛 故障排除

### 问题 1: 克隆超时
**解决方案**:
```bash
# 增加超时时间
git config --global http.postBuffer 524288000

# 使用 SSH 方式
git clone git@github.com:qsswgl/365-android.git
```

### 问题 2: 推送时认证失败
**解决方案**:
```bash
# 使用 HTTPS 并保存凭证
git config --global credential.helper store

# 或使用 SSH 密钥
git remote set-url origin git@github.com:qsswgl/365-android.git
```

### 问题 3: 合并冲突
**解决方案**:
```bash
# 查看冲突文件
git status

# 手动编辑冲突文件，然后：
git add <resolved-files>
git commit -m "Resolve merge conflicts"
git push origin <branch>
```

---

## 📚 更多资源

- **GitHub 帮助**: https://docs.github.com
- **Git 官方文档**: https://git-scm.com/doc
- **Android 开发**: https://developer.android.com
- **WebView 指南**: https://developer.android.com/guide/webapps/webview

---

## ✅ 检查清单

在提交前，确保：

- [ ] 代码已编译无错误
- [ ] 所有测试已通过
- [ ] 提交信息清晰明了
- [ ] 没有提交不必要的文件（检查 .gitignore）
- [ ] 最新的代码已从远程拉取

---

## 🎯 后续步骤建议

1. **设置分支保护** (GitHub 设置 > Branches)
   - 保护 main 分支
   - 要求 Pull Request 审查

2. **启用 CI/CD** (GitHub Actions)
   - 自动测试
   - 自动部署

3. **配置 Issue 模板**
   - Bug 报告模板
   - Feature 请求模板

4. **添加 GitHub Pages**
   - 项目文档网站

5. **启用 GitHub Wiki**
   - 项目知识库

---

**🎉 项目已准备好！开始开发吧！**
