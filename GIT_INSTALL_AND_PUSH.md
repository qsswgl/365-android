# 完整的GitHub推送步骤 (适用于Git未安装的环境)

## 📌 当前状态

- **Git状态**: ❌ 未安装
- **项目目录**: ✅ `k:\365-android` 存在
- **SSH密钥**: ✅ `k:\key\github\id_rsa` 存在  
- **GitHub Token**: ✅ 已配置
- **脚本**: ✅ 已创建 (3种选择)

---

## 🔧 Step 1: 安装Git

### 方法1: 自动下载安装 (推荐)

复制以下命令到PowerShell：

```powershell
# 下载Git安装程序
$url = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
$output = "$env:TEMP\Git-2.43.0-64-bit.exe"
Write-Host "正在下载Git..."
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $url -OutFile $output
Write-Host "开始安装..."
& $output /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS /ALLUSERS /COMPONENTS="icons,ext\reg\context,ext\reg\shellhere,assoc,assoc_sh"
Write-Host "Git安装完成！请重启PowerShell后继续"
```

### 方法2: 手动下载安装

1. 访问 https://git-scm.com/download/win
2. 点击"Click here to download"下载最新版本
3. 运行安装程序
4. 安装过程中勾选"Add Git to PATH"
5. 重启PowerShell

### 方法3: 使用Chocolatey (如果已安装)

```powershell
choco install git -y
```

---

## ⚙️ Step 2: 验证Git安装

重启PowerShell后运行：

```powershell
git --version
```

如果看到类似 `git version 2.43.0.windows.1` 的输出，说明安装成功。

---

## 🚀 Step 3: 运行推送脚本

### 选项A: PowerShell脚本 (推荐)

```powershell
# 进入项目目录
cd k:\365-android

# 如果遇到执行策略错误，先运行:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# 运行推送脚本
.\push_to_github.ps1
```

### 选项B: 批处理脚本

```cmd
cd k:\365-android
push_to_github.bat
```

### 选项C: Python脚本

```cmd
cd k:\365-android
python push_to_github.py
```

---

## 📝 Step 4: 按照提示操作

脚本会提示您：

```
请输入GitHub用户名: your-github-username
```

输入您的GitHub用户名（例如: `octocat`）

脚本会自动完成：
1. ✓ 初始化Git仓库
2. ✓ 配置SSH密钥
3. ✓ 创建/验证GitHub仓库
4. ✓ 提交代码
5. ✓ 推送到GitHub

---

## ✅ Step 5: 验证推送结果

推送完成后，访问：
```
https://github.com/your-github-username/365-android
```

检查：
- ✓ 仓库已创建
- ✓ 所有文件已上传
- ✓ build/ 目录被排除
- ✓ 提交消息显示

---

## 🆘 常见错误解决

### 错误1: "无法连接到github.com"

```powershell
# 测试SSH连接
ssh -i k:\key\github\id_rsa -T git@github.com

# 如果失败，检查SSH密钥权限
icacls "k:\key\github\id_rsa" /reset
```

### 错误2: "Repository creation failed"

说明仓库已存在，这是正常的。脚本会使用现有仓库继续推送。

### 错误3: "fatal: not a git repository"

Git仓库初始化失败，尝试手动初始化：

```powershell
cd k:\365-android
git init
git config --global user.name "your-github-username"
git config --global user.email "your-github-username@users.noreply.github.com"
git add -A
git commit -m "Initial commit"
git remote add origin git@github.com:your-github-username/365-android.git
git push -u origin main
```

### 错误4: 无法找到脚本

确保您在 `k:\365-android` 目录中：

```powershell
cd k:\365-android
ls -Name push_to_github.*  # 应该看到3个文件
```

---

## 🔐 安全检查清单

在推送前确认：

- [ ] SSH密钥存在: `Test-Path k:\key\github\id_rsa`
- [ ] SSH密钥权限正确
- [ ] GitHub Token有效（已在脚本中配置）
- [ ] GitHub账户可以登录
- [ ] 知道您的GitHub用户名

---

## 📊 完成标志

成功完成后，您会看到：

```
============================================================
✓ 推送完成！
  GitHub仓库: https://github.com/your-github-username/365-android
============================================================

后续步骤:
1. 访问 https://github.com/your-github-username/365-android
2. 配置仓库设置 (Settings)
3. 添加协作者或生成发行版本
```

---

## 📚 后续操作

推送完成后，建议：

1. **配置仓库**
   - 添加仓库描述
   - 添加主题标签: `android`, `amap`, `webview`
   - 选择License

2. **团队协作**
   - 邀请团队成员
   - 配置保护分支
   - 设置PR审查规则

3. **版本管理**
   - 创建Release版本
   - 标记主要更新
   - 编写更新日志

4. **持续集成** (可选)
   - 配置GitHub Actions
   - 自动化构建和测试
   - 自动部署

---

## 💡 提示

- **脚本可以重复运行**: 如果推送失败，修复问题后再运行脚本即可
- **自动跳过已提交**: 如果代码已提交，脚本会跳过提交步骤
- **支持多个分支**: 脚本会自动检测当前分支并推送

---

## 📞 获取帮助

如果遇到问题，请提供以下信息：

1. 完整的错误消息
2. Git版本: `git --version`
3. PowerShell版本: `$PSVersionTable.PSVersion`
4. 系统信息: `[System.Environment]::OSVersion`

---

**提示**: 除了安装Git外，脚本已经为您准备好了所有需要的配置和密钥！

**建议流程**:
1. 安装Git (5分钟)
2. 重启PowerShell
3. 运行脚本 (2-3分钟)
4. 输入GitHub用户名
5. 验证推送结果

总耗时: 约 10-15 分钟
