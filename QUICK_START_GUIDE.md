365安卓应用 - 快速使用指南
============================

✅ 应用状态: 已编译、已安装、已测试

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【快速开始】

1. 重新编译应用
   cd k:\365-android
   .\gradlew clean build -x lintVitalRelease

2. 安装到设备
   .\adb.exe -s 192.168.1.129:46595 install -r ^
     app/build/outputs/apk/release/app-release.apk

3. 启动应用
   .\adb.exe -s 192.168.1.129:46595 shell am start ^
     -a android.intent.action.MAIN ^
     -n net.qsgl365/.MainActivity

4. 查看日志
   .\adb.exe -s 192.168.1.129:46595 logcat -v time

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【自动化测试】

运行基础测试:
  python test_amap_navigation.py

运行高级测试 (包括HTML加载):
  python test_amap_advanced.py

查看测试结果:
  type logcat_*.log

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【文件位置】

源代码:
  k:\365-android\app\src\main\java\net\qsgl365\MainActivity.java

配置文件:
  k:\365-android\app\src\main\AndroidManifest.xml
  k:\365-android\app\build.gradle

APK输出:
  Debug: k:\365-android\app\build\outputs\apk\debug\app-debug.apk
  Release: k:\365-android\app\build\outputs\apk\release\app-release.apk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【应用功能】

✓ WebView 网页浏览
✓ 高德地图导航链接调起 (amap://)
✓ 电话链接处理 (tel://)
✓ 短信链接处理 (sms://)
✓ GPS定位权限
✓ 摄像头权限
✓ 通话权限
✓ PWA 离线支持

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【常见问题】

Q: 如何改变应用加载的URL?
A: 编辑 MainActivity.java，找到:
   String pwaPwaUrl = "https://www.qsgl.net/html/365app/#/";
   修改这个URL即可。

Q: 如何添加新的权限?
A: 1. 在 AndroidManifest.xml 中添加 <uses-permission>
   2. 在 MainActivity.java 中添加权限检查代码
   3. 重新编译和部署

Q: 如何调试高德地图链接?
A: 1. 运行: python test_amap_advanced.py
   2. 查看日志: .\adb.exe logcat | findstr "qsgl365"
   3. 检查HTML测试文件: amap_test.html

Q: 应用崩溃了怎么办?
A: 1. 查看logcat日志找到崩溃堆栈
   2. 检查权限是否齐全
   3. 确保网络连接正常
   4. 查看 FINAL_TEST_REPORT.md 中的建议

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【性能参考】

应用大小: ~50-60 MB (Release APK)
最小API: 21 (Android 5.0)
目标API: 34 (Android 14)
启动时间: ~5秒 (包括网络加载)
内存占用: ~150-200 MB

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【重要注意事项】

1. 高德地图链接调起
   - 需要设备上安装高德地图应用
   - 应用包名: com.autonavi.minimap (通常)
   - 如果未安装，系统会显示"无法处理此链接"

2. 网络连接
   - 应用启动时会加载远程URL
   - 如果网络不可用，将自动降级为离线模式
   - 确保设备连接到有效的网络

3. 权限管理
   - 所有权限已在AndroidManifest.xml中声明
   - 部分权限需要在运行时请求 (Android 6.0+)
   - 用户拒绝权限后，相关功能可能不可用

4. 日志安全
   - logcat日志包含敏感信息，定期清理
   - 不要在生产环境中启用详细日志

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【技术栈】

- 语言: Java
- Framework: Android SDK
- 构建工具: Gradle
- 网络框架: WebView
- 地图服务: 高德地图 (amap://)
- 测试工具: Python + adb

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【联系与支持】

对于任何问题或建议，请查阅:
- FINAL_TEST_REPORT.md (详细测试报告)
- TEST_REPORT.md (初始测试分析)
- MainActivity.java 中的代码注释

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

最后更新: 2026-01-02
版本: Release 1.0
状态: ✅ Production Ready
