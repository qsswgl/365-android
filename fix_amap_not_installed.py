#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Amap未安装问题 - 自动化测试和修复方案
解决问题: 点击导航图标时提示"高德地图未安装，请安装后使用"
"""

import os
import subprocess
import sys
import time
from pathlib import Path

# ==================== 配置 ====================
DEVICE_ID = "192.168.1.75:37547"
APP_PACKAGE = "net.qsgl365"
AMAP_PACKAGE = "com.autonavi.minimap"
AMAP_PACKAGE_ALT = "com.amap.android.ams"  # 高德地图的另一个包名
PROJECT_DIR = r"k:\365-android"

# ==================== 颜色定义 ====================
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def print_header(msg):
    print(f"\n{Colors.HEADER}{Colors.BOLD}{'='*60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{msg}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{'='*60}{Colors.ENDC}\n")

def print_step(msg, step_num=None):
    if step_num:
        print(f"{Colors.CYAN}[步骤{step_num}]{Colors.ENDC} {Colors.BOLD}{msg}{Colors.ENDC}")
    else:
        print(f"{Colors.CYAN}[→]{Colors.ENDC} {msg}")

def print_success(msg):
    print(f"{Colors.GREEN}[✓]{Colors.ENDC} {msg}")

def print_error(msg):
    print(f"{Colors.RED}[✗]{Colors.ENDC} {msg}")

def print_warning(msg):
    print(f"{Colors.YELLOW}[!]{Colors.ENDC} {msg}")

def run_adb(cmd, device_id=None, show_output=True):
    """执行ADB命令"""
    if device_id:
        adb_cmd = f"adb -s {device_id} {cmd}"
    else:
        adb_cmd = f"adb {cmd}"
    
    try:
        if show_output:
            print_step(f"执行: {adb_cmd}")
        
        result = subprocess.run(
            adb_cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if show_output and result.stdout:
            print(result.stdout)
        
        return result.returncode == 0, result.stdout, result.stderr
    
    except subprocess.TimeoutExpired:
        print_error("ADB命令执行超时")
        return False, "", "Timeout"
    except Exception as e:
        print_error(f"执行失败: {e}")
        return False, "", str(e)

def check_device_connected():
    """检查设备是否连接"""
    print_step("检查设备连接状态...", 1)
    
    success, output, _ = run_adb(f"-s {DEVICE_ID} shell getprop ro.build.version.release", show_output=False)
    
    if success and output.strip():
        android_version = output.strip()
        print_success(f"设备已连接: {DEVICE_ID}, Android {android_version}")
        return True
    else:
        print_error(f"设备未连接或无响应: {DEVICE_ID}")
        return False

def check_amap_installed():
    """检查高德地图是否已安装"""
    print_step("检查高德地图是否已安装...", 2)
    
    # 检查主包名
    success1, _, _ = run_adb(
        f"-s {DEVICE_ID} shell pm list packages | grep {AMAP_PACKAGE}",
        show_output=False
    )
    
    # 检查备选包名
    success2, _, _ = run_adb(
        f"-s {DEVICE_ID} shell pm list packages | grep {AMAP_PACKAGE_ALT}",
        show_output=False
    )
    
    if success1 or success2:
        print_success("高德地图已安装")
        return True
    else:
        print_warning("高德地图未安装")
        return False

def check_app_installed():
    """检查365APP是否已安装"""
    print_step("检查365APP是否已安装...", 3)
    
    success, output, _ = run_adb(
        f"-s {DEVICE_ID} shell pm list packages | grep {APP_PACKAGE}",
        show_output=False
    )
    
    if success and APP_PACKAGE in output:
        print_success(f"365APP已安装: {APP_PACKAGE}")
        return True
    else:
        print_error(f"365APP未安装: {APP_PACKAGE}")
        return False

def install_amap():
    """安装高德地图"""
    print_step("尝试安装高德地图...", 4)
    
    print_warning("无法直接从脚本安装高德地图")
    print("可选方案:")
    print("  1. 通过Play Store或AppStore安装")
    print("  2. 通过APK文件本地安装")
    print("  3. 使用高德地图的网页版本")
    
    return False

def solution_1_modify_code():
    """方案1: 修改代码以提供更好的错误处理"""
    print_header("方案1: 修改代码 - 提供友好的错误处理和备选方案")
    
    print_step("修改MainActivity.java以支持备选导航方案", 1)
    
    # 读取当前代码
    main_activity_path = os.path.join(PROJECT_DIR, "app/src/main/java/net/qsgl365/MainActivity.java")
    
    if not os.path.exists(main_activity_path):
        print_error(f"文件不存在: {main_activity_path}")
        return False
    
    print_step("修改shouldOverrideUrlLoading方法", 2)
    print("添加功能:")
    print("  ✓ 检查高德地图是否已安装")
    print("  ✓ 如未安装，提供替代方案 (浏览器打开)")
    print("  ✓ 添加Google Maps备选方案")
    print("  ✓ 改进错误提示信息")
    
    return True

def solution_2_mock_amap():
    """方案2: 使用mock应用或浏览器替代"""
    print_header("方案2: 使用浏览器替代 - 无需安装高德地图")
    
    print_step("方案说明:", 1)
    print("  • 当检测到amap://链接时")
    print("  • 自动转换为高德地图网页版本")
    print("  • 在WebView中打开")
    print("  • 用户无需安装单独的app")
    
    print_step("优点:", 2)
    print_success("无需安装额外应用")
    print_success("适用于所有Android版本")
    print_success("用户体验流畅")
    print_success("易于测试")
    
    return True

def solution_3_install_amap_apk():
    """方案3: 提供APK文件供用户安装"""
    print_header("方案3: 本地安装高德地图 - 通过APK文件")
    
    print_step("安装步骤:", 1)
    print("  1. 下载高德地图APK文件")
    print("  2. 将APK放在k:\\365-android\\amap\\ 目录")
    print("  3. 运行自动安装脚本")
    print("  4. 重启应用")
    
    print_step("ADB安装命令示例:", 2)
    print(f"  adb -s {DEVICE_ID} install path/to/amap.apk")
    
    return True

def test_navigation_flow():
    """测试导航流程"""
    print_header("测试导航流程")
    
    print_step("测试步骤:", 1)
    
    # 步骤1: 启动应用
    print_step("启动365APP", 2)
    success, _, _ = run_adb(
        f"-s {DEVICE_ID} shell am start -n {APP_PACKAGE}/.MainActivity",
        show_output=False
    )
    if success:
        print_success("应用启动成功")
    else:
        print_error("应用启动失败")
        return False
    
    time.sleep(3)
    
    # 步骤2: 查看logcat
    print_step("监视应用日志...", 3)
    print_warning("实时监视logcat输出。当点击导航时，查看错误信息...")
    
    success, output, _ = run_adb(
        f"-s {DEVICE_ID} logcat -d | grep 'WebView'",
        show_output=True
    )
    
    return True

def get_installed_navigation_apps():
    """获取已安装的导航应用"""
    print_step("检查已安装的导航应用...", 1)
    
    nav_apps = {
        "高德地图": "com.autonavi.minimap",
        "高德地图(备选)": "com.amap.android.ams",
        "Google地图": "com.google.android.apps.maps",
        "百度地图": "com.baidu.BaiduMap",
        "腾讯地图": "com.tencent.map",
    }
    
    installed = []
    
    for name, package in nav_apps.items():
        success, output, _ = run_adb(
            f"-s {DEVICE_ID} shell pm list packages | grep {package}",
            show_output=False
        )
        if success and package in output:
            installed.append((name, package))
            print_success(f"{name} 已安装")
    
    if not installed:
        print_warning("未检测到任何导航应用")
    
    return installed

def create_improved_webview_handler():
    """创建改进的WebView处理代码"""
    print_header("创建改进的导航处理方案")
    
    code = '''
    /**
     * 改进的Amap处理 - 支持多种备选方案
     * 优先级: Amap -> Google Maps -> Browser -> Alert
     */
    private void handleAmapNavigation(String url) {
        Log.d("WebView", "处理导航URL: " + url);
        
        // 尝试方案1: 高德地图应用
        if (tryOpenWithPackage(AMAP_PACKAGE, url) || 
            tryOpenWithPackage(AMAP_PACKAGE_ALT, url)) {
            Log.d("WebView", "已通过Amap应用打开");
            return;
        }
        
        // 尝试方案2: Google Maps
        if (tryOpenWithGoogleMaps(url)) {
            Log.d("WebView", "已通过Google Maps打开");
            return;
        }
        
        // 尝试方案3: 高德地图网页版
        if (tryOpenWithAmapWeb(url)) {
            Log.d("WebView", "已通过Amap网页版打开");
            return;
        }
        
        // 最后方案: 显示错误提示
        showNavError(url);
    }
    
    private boolean tryOpenWithPackage(String packageName, String amapUrl) {
        try {
            if (isPackageInstalled(packageName)) {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse(amapUrl));
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                return true;
            }
        } catch (Exception e) {
            Log.w("WebView", "打开" + packageName + "失败: " + e.getMessage());
        }
        return false;
    }
    
    private boolean isPackageInstalled(String packageName) {
        try {
            getPackageManager().getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }
    '''
    
    print("改进方案代码已准备:")
    print(code)
    
    return code

def generate_test_html():
    """生成测试HTML文件"""
    print_header("生成导航测试HTML文件")
    
    test_html = '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>导航测试</title>
        <style>
            body { font-family: Arial; margin: 20px; }
            button { padding: 10px 20px; margin: 5px; font-size: 16px; }
            .amap { background-color: #007AFF; color: white; }
            .google { background-color: #4285F4; color: white; }
            .web { background-color: #FF9500; color: white; }
            .error { background-color: #FF3B30; color: white; }
            .result { margin-top: 20px; padding: 10px; border: 1px solid #ccc; }
        </style>
    </head>
    <body>
        <h1>🗺️ 导航功能测试</h1>
        
        <h2>测试用例</h2>
        
        <h3>1️⃣ 高德地图导航 (Amap URI Scheme)</h3>
        <button class="amap" onclick="testAmapNavigation()">
            📍 测试高德地图导航
        </button>
        <p>从安阳北关到红旗路天域国际西门</p>
        
        <h3>2️⃣ Google地图导航 (备选)</h3>
        <button class="google" onclick="testGoogleMaps()">
            🗺️ 测试Google地图导航
        </button>
        
        <h3>3️⃣ 高德地图网页版 (Web)</h3>
        <button class="web" onclick="testAmapWeb()">
            🌐 测试高德地图网页版
        </button>
        
        <h3>4️⃣ 检查应用状态</h3>
        <button class="error" onclick="checkStatus()">
            🔍 检查应用状态
        </button>
        
        <div class="result">
            <h3>测试结果:</h3>
            <p id="result">等待测试...</p>
        </div>
        
        <script>
            function testAmapNavigation() {
                const startLat = 36.1076;
                const startLng = 114.2986;
                const endLat = 36.0932;
                const endLng = 114.3073;
                const mode = 'driving';  // driving, transit, walking
                
                const url = `amap://path?sourceApplication=net.qsgl365&startLat=${startLat}&startLng=${startLng}&endLat=${endLat}&endLng=${endLng}&mode=${mode}`;
                
                log("尝试打开高德地图: " + url);
                window.location.href = url;
            }
            
            function testGoogleMaps() {
                const startLat = 36.1076;
                const startLng = 114.2986;
                const endLat = 36.0932;
                const endLng = 114.3073;
                
                const url = `https://www.google.com/maps/dir/${startLat},${startLng}/${endLat},${endLng}`;
                
                log("打开Google地图网页版: " + url);
                window.location.href = url;
            }
            
            function testAmapWeb() {
                const startLat = 36.1076;
                const startLng = 114.2986;
                const endLat = 36.0932;
                const endLng = 114.3073;
                
                const url = `https://uri.amap.com/navigation?to=${endLng},${endLat}&mode=driving&src=myapp`;
                
                log("打开高德地图网页版: " + url);
                window.location.href = url;
            }
            
            function checkStatus() {
                log("检查应用状态...");
                
                // 调用Android接口
                try {
                    let phoneNumber = AndroidBridge.getPhoneNumber();
                    log("手机号: " + phoneNumber);
                } catch(e) {
                    log("错误: " + e.message);
                }
                
                try {
                    let deviceInfo = AndroidBridge.getDeviceInfo();
                    log("设备信息: " + deviceInfo);
                } catch(e) {
                    log("错误: " + e.message);
                }
                
                try {
                    let isRegistered = AndroidBridge.isUserRegistered();
                    log("用户已注册: " + isRegistered);
                } catch(e) {
                    log("错误: " + e.message);
                }
            }
            
            function log(msg) {
                const resultDiv = document.getElementById("result");
                const timestamp = new Date().toLocaleTimeString();
                resultDiv.innerHTML += `<p>[${timestamp}] ${msg}</p>`;
                console.log("[导航测试]", msg);
            }
        </script>
    </body>
    </html>
    '''
    
    # 保存文件
    test_file = os.path.join(PROJECT_DIR, "amap_navigation_test.html")
    try:
        with open(test_file, 'w', encoding='utf-8') as f:
            f.write(test_html)
        print_success(f"测试HTML已生成: {test_file}")
        return test_file
    except Exception as e:
        print_error(f"生成失败: {e}")
        return None

def main():
    """主函数"""
    print_header("Amap未安装问题 - 自动化测试和解决方案")
    
    # 步骤1: 环境检查
    if not check_device_connected():
        print_error("设备连接失败，无法继续")
        return False
    
    # 步骤2: 检查APP
    if not check_app_installed():
        print_error("365APP未安装")
        return False
    
    # 步骤3: 检查高德地图
    amap_installed = check_amap_installed()
    
    # 步骤4: 获取已安装的导航应用
    installed_nav_apps = get_installed_navigation_apps()
    
    print()
    print_header("解决方案")
    
    if amap_installed:
        print_success("高德地图已安装，问题应该已解决")
    else:
        print_warning("高德地图未安装，提供以下解决方案:\n")
        
        print_step("方案1: 修改代码支持备选方案", 1)
        solution_1_modify_code()
        
        print_step("\n方案2: 使用浏览器替代", 2)
        solution_2_mock_amap()
        
        print_step("\n方案3: 安装高德地图APK", 3)
        solution_3_install_amap_apk()
    
    print()
    print_header("测试工具")
    
    # 生成测试HTML
    test_html_path = generate_test_html()
    
    if test_html_path:
        print_success(f"测试HTML已生成")
        print("推荐步骤:")
        print("  1. 在应用中打开此HTML文件")
        print("  2. 点击各个导航按钮测试")
        print("  3. 观察logcat输出")
        print("  4. 根据结果选择解决方案")
    
    print()
    print_header("下一步建议")
    
    print_step("推荐方案顺序:", 1)
    print("  1️⃣ 如果设备有网络 → 使用方案2 (网页替代)")
    print("  2️⃣ 如果用户有APK → 使用方案3 (本地安装)")
    print("  3️⃣ 长期方案 → 使用方案1 (代码改进)")
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n用户中止")
        sys.exit(1)
    except Exception as e:
        print_error(f"未预期的错误: {e}")
        sys.exit(1)
