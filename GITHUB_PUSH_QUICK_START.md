# GitHub推送 - 快速参考

## 🚀 一键推送 (选择一种方式)

### 方式1: PowerShell脚本 (推荐)
```powershell
cd k:\365-android
.\push_to_github.ps1
```

### 方式2: 批处理脚本
```cmd
cd k:\365-android
push_to_github.bat
```

### 方式3: Python脚本
```cmd
cd k:\365-android
python push_to_github.py
```

---

## 📋 提示输入

所有脚本都会提示您输入：
```
请输入GitHub用户名: your-github-username
```

然后脚本会自动完成：
- ✓ Git配置
- ✓ SSH密钥设置
- ✓ GitHub仓库创建
- ✓ 代码提交和推送

---

## 🔧 手动推送 (如果脚本失败)

```powershell
cd k:\365-android

# 1. 初始化Git
git init
git config --global user.name "your-github-username"
git config --global user.email "your-github-username@users.noreply.github.com"

# 2. 配置SSH
git config --global core.sshCommand "ssh -i k:\key\github\id_rsa -o StrictHostKeyChecking=no"

# 3. 添加文件
git add -A
git commit -m "Initial commit: 365 Android App"

# 4. 添加远程仓库
git remote add origin git@github.com:your-github-username/365-android.git

# 5. 推送代码
git push -u origin main
```

---

## 🐛 故障排除

### "git: 无法将"git"项识别"
→ Git未安装，从 https://git-scm.com/download/win 下载安装

### "Permission denied (publickey)"
→ SSH密钥配置问题，检查:
```powershell
Test-Path "k:\key\github\id_rsa"
ssh -i k:\key\github\id_rsa -T git@github.com
```

### "fatal: destination path already exists"
→ Git仓库已存在，删除后重试:
```powershell
Remove-Item "k:\365-android\.git" -Recurse -Force
```

### "Repository creation failed"
→ 仓库已存在，脚本会自动使用现有仓库，继续推送

---

## ✅ 完成检查

推送后访问: https://github.com/your-github-username/365-android

验证：
- [ ] 仓库已创建
- [ ] 所有文件已上传
- [ ] build/ 目录被正确排除
- [ ] 提交历史显示

---

## 📚 更多信息

详见 **GITHUB_PUSH_GUIDE.md** 获取完整说明

---

**配置信息已保存:**
- SSH密钥: `k:\key\github\id_rsa`
- GitHub Token: 已配置 (用于仓库创建)
- 项目目录: `k:\365-android`
- 仓库名称: `365-android`

**注意:** 请将 `your-github-username` 替换为你的实际GitHub用户名
