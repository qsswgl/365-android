365安卓项目文档索引
===================

【快速导航】

🚀 刚开始?
  → 请先阅读: QUICK_START_GUIDE.md

📋 需要了解项目状态?
  → 请查看: PROJECT_SUMMARY.md

📊 需要详细测试报告?
  → 请查看: FINAL_TEST_REPORT.md

❓ 遇到问题?
  → 请查看: QUICK_START_GUIDE.md 的"常见问题"部分
  → 或查看: 相关的 logcat_*.log 文件

🔧 需要修改源代码?
  → 文件位置: k:\365-android\app\src\main\java\net\qsgl365\MainActivity.java

📱 需要重新部署应用?
  → 运行: .\gradlew clean build -x lintVitalRelease
  → 然后: .\adb.exe install -r app/build/outputs/apk/release/app-release.apk

🧪 需要运行测试?
  → 基础测试: python test_amap_navigation.py
  → 完整测试: python test_amap_advanced.py

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【文档清单】

文档名称                          说明
────────────────────────────────────────────────
QUICK_START_GUIDE.md              快速启动指南 [推荐首先阅读]
PROJECT_SUMMARY.md                完整项目总结
FINAL_TEST_REPORT.md              最终测试报告
TEST_REPORT.md                    初始分析报告
README.md                         项目README

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【源代码文件清单】

路径                                          说明
────────────────────────────────────────────────────────
app/src/main/java/net/qsgl365/MainActivity.java  主应用代码
app/src/main/AndroidManifest.xml               应用清单
app/build.gradle                               构建配置

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【可执行文件清单】

文件名                                   说明
────────────────────────────────────────────────────
app-release.apk                        生产版本 APK
app-debug.apk                          调试版本 APK

位置: k:\365-android\app\build\outputs\apk\

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【测试脚本清单】

脚本名称                          说明
────────────────────────────────────────────────
test_amap_navigation.py           基础Intent和URL测试
test_amap_advanced.py             完整场景和HTML加载测试
amap_test.html                    HTML测试页面

使用: python test_amap_*.py

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【日志文件清单】

文件名                                  说明
────────────────────────────────────────────────
logcat_20260102_122748.log            最完整的logcat日志
logcat_20260102_122624.log            早期测试日志
test_results.log                      测试执行日志

查看: type logcat_*.log | more

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【常用命令速查】

编译应用:
  cd k:\365-android
  .\gradlew clean build -x lintVitalRelease

安装到设备:
  .\adb.exe -s 192.168.1.129:46595 install -r ^
    app/build/outputs/apk/release/app-release.apk

启动应用:
  .\adb.exe -s 192.168.1.129:46595 shell am start ^
    -a android.intent.action.MAIN ^
    -n net.qsgl365/.MainActivity

查看日志:
  .\adb.exe -s 192.168.1.129:46595 logcat -v time

清理日志:
  .\adb.exe -s 192.168.1.129:46595 logcat -c

运行测试:
  python test_amap_navigation.py
  python test_amap_advanced.py

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【关键信息】

应用包名: net.qsgl365
主Activity: net.qsgl365.MainActivity
设备ID: 192.168.1.129:46595
最小API: 21 (Android 5.0)
目标API: 34 (Android 14)
APK大小: 4.3 MB (Release)
状态: ✅ Production Ready

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【故障排查指南】

问题: 应用无法启动
  1. 检查设备连接: .\adb.exe devices
  2. 查看错误日志: .\adb.exe logcat | grep ERROR
  3. 重新安装应用: .\adb.exe install -r app-release.apk

问题: 高德地图链接无法调起
  1. 设备上是否安装了高德地图应用?
  2. 查看logcat日志中是否有相关错误
  3. 运行高级测试: python test_amap_advanced.py

问题: WebView加载失败
  1. 检查网络连接
  2. 查看应用日志中的URL加载信息
  3. 尝试加载本地测试页面: amap_test.html

问题: 权限相关错误
  1. 检查AndroidManifest.xml中的权限声明
  2. 查看运行时权限是否已授予
  3. 查阅FINAL_TEST_REPORT.md中的权限部分

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【项目目录结构】

365-android/
├── app/                                  应用模块
│   ├── src/
│   │   └── main/
│   │       ├── java/net/qsgl365/
│   │       │   └── MainActivity.java     主应用代码
│   │       └── AndroidManifest.xml       应用清单
│   ├── build.gradle                      构建配置
│   └── build/outputs/apk/                APK输出目录
│
├── gradle/                               Gradle配置
├── build.gradle                          项目配置
├── settings.gradle                       项目设置
│
├── [文档文件]                            (*.md)
├── [测试脚本]                            (test_*.py)
├── [日志文件]                            (logcat_*.log)
└── [其他工具]                            (adb.exe等)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【版本信息】

应用版本: 1.0
构建日期: 2026-01-02
编译工具: Gradle 8.0+
Android SDK: API 34
Java版本: 11+

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【获取帮助】

1. 查阅文档:
   - QUICK_START_GUIDE.md (最快)
   - PROJECT_SUMMARY.md (全面)
   - FINAL_TEST_REPORT.md (详细)

2. 检查日志:
   - logcat_20260102_122748.log (推荐)
   - .\adb.exe logcat -d (实时)

3. 运行测试:
   - python test_amap_navigation.py (基础)
   - python test_amap_advanced.py (完整)

4. 查看源代码:
   - MainActivity.java (应用逻辑)
   - AndroidManifest.xml (配置)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

最后更新: 2026-01-02
维护者: GitHub Copilot
状态: ✅ 完成并就绪

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
