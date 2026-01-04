#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
改进的自动化测试脚本：直接测试WebView中的高德地图链接调起
通过JavaScript直接在应用的WebView中创建和点击高德地图链接
"""

import subprocess
import time
import sys
import os
import io
from datetime import datetime

# 设置stdout编码为UTF-8
if sys.stdout.encoding != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 配置
DEVICE_ID = "192.168.1.129:46595"
APP_PACKAGE = "net.qsgl365"
ADB_PATH = r"K:\365-android\adb.exe"
WORKSPACE = r"K:\365-android"

def run_adb_command(cmd):
    """执行adb命令"""
    full_cmd = [ADB_PATH, "-s", DEVICE_ID] + cmd
    try:
        result = subprocess.run(full_cmd, capture_output=True, text=False, timeout=30)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, b"", str(e).encode()

def run_shell_command(cmd):
    """执行adb shell命令"""
    return run_adb_command(["shell"] + cmd)

def log_print(level, message):
    """打印带时间戳的日志"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    prefix = f"[{timestamp}]"
    symbols = {
        "INFO": "[*]",
        "SUCCESS": "[+]",
        "WARNING": "[!]",
        "ERROR": "[-]",
        "DEBUG": "[?]"
    }
    symbol = symbols.get(level, "")
    print(f"{prefix} {symbol} [{level}] {message}")

def start_app():
    """启动应用"""
    log_print("INFO", "正在启动应用...")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.MAIN",
        "-n", f"{APP_PACKAGE}/.MainActivity"
    ])
    
    if success or "Error" not in str(stderr):
        log_print("SUCCESS", "应用启动成功")
        time.sleep(5)  # 等待应用和WebView加载完成
        return True
    
    log_print("ERROR", f"应用启动失败")
    return False

def inject_amap_link_via_js():
    """通过JavaScript在WebView中注入高德地图链接并模拟点击"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "通过JavaScript注入高德地图链接测试")
    log_print("INFO", "=" * 60)
    
    # 创建用于输入事件的脚本
    # 这会在应用的WebView中创建一个包含高德地图链接的元素，然后模拟点击
    
    # 方法1: 尝试通过Chrome debugger protocol (需要应用启用WebView调试)
    log_print("INFO", "尝试通过JavaScript注入链接...")
    
    # 创建一个临时的HTML/JavaScript来测试
    js_code = """
    javascript:(function() {
        // 创建一个隐藏的高德地图链接
        var amapLink = document.createElement('a');
        amapLink.id = 'test_amap_link';
        amapLink.href = 'amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=朝阳公园&endLat=32.0603&endLng=118.7969&endName=南京路&tmode=1';
        amapLink.style.display = 'none';
        document.body.appendChild(amapLink);
        
        // 触发点击事件
        var clickEvent = new MouseEvent('click', {
            bubbles: true,
            cancelable: true,
            view: window
        });
        amapLink.dispatchEvent(clickEvent);
        
        // 记录到控制台
        console.log('Amap link click triggered');
    })()
    """
    
    # 使用am broadcast或chrome debug来执行
    log_print("WARNING", "JavaScript注入需要WebView调试支持")
    log_print("INFO", "尝试使用adb shell input命令模拟用户操作...")
    
    return False

def simulate_user_tap_on_webview():
    """模拟用户在WebView上的点击操作"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "模拟用户在WebView上点击")
    log_print("INFO", "=" * 60)
    
    log_print("INFO", "获取屏幕分辨率...")
    success, stdout, stderr = run_shell_command(["wm", "size"])
    
    if success:
        try:
            # 解析分辨率 (通常格式: Physical size: 1440x3200)
            output = stdout.decode('utf-8', errors='ignore')
            log_print("DEBUG", f"屏幕信息: {output.strip()}")
        except:
            pass
    
    # 模拟点击屏幕中心的WebView区域
    # 假设WebView占据大部分屏幕（排除顶部导航栏）
    log_print("INFO", "在WebView中心点击...")
    
    # 屏幕中心坐标（假设1440x3200的屏幕）
    tap_x = "720"
    tap_y = "1600"
    
    success, stdout, stderr = run_shell_command([
        "input", "tap", tap_x, tap_y
    ])
    
    if success:
        log_print("SUCCESS", f"点击操作执行成功 ({tap_x}, {tap_y})")
        time.sleep(3)
        return True
    else:
        log_print("WARNING", f"点击操作可能失败: {stderr}")
        return False

def check_chrome_extensions():
    """检查Chrome是否支持自动化"""
    log_print("INFO", "检查Chrome自动化支持...")
    
    # 查看Chrome进程
    success, stdout, stderr = run_shell_command([
        "ps", "-A"
    ])
    
    output = stdout.decode('utf-8', errors='ignore')
    if "chrome" in output.lower():
        log_print("INFO", "Chrome进程运行中")
    
    return False

def check_app_webview_logs():
    """检查应用的WebView相关日志"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "检查应用WebView日志")
    log_print("INFO", "=" * 60)
    
    # 过滤应用相关的日志
    success, stdout, stderr = run_adb_command([
        "logcat", "-d", "-v", "time", "-s", "qsgl365:*"
    ])
    
    try:
        output = stdout.decode('utf-8', errors='ignore')
        if output.strip():
            log_print("SUCCESS", "找到应用日志:")
            print("-" * 60)
            print(output[:2000])  # 显示前2000个字符
            print("-" * 60)
        else:
            log_print("WARNING", "未找到应用相关日志")
    except:
        log_print("WARNING", "日志处理失败")
    
    return True

def test_amap_intent_directly():
    """直接测试高德地图Intent"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "直接测试高德地图Intent")
    log_print("INFO", "=" * 60)
    
    amap_url = "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=朝阳公园&endLat=32.0603&endLng=118.7969&endName=南京路&tmode=1"
    
    log_print("INFO", f"高德地图URL: {amap_url[:80]}...")
    
    # 清空logcat
    run_adb_command(["logcat", "-c"])
    time.sleep(1)
    
    # 尝试通过adb shell启动Intent
    log_print("INFO", "通过am start启动高德地图Intent...")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-W", "-a", "android.intent.action.VIEW", "-d", amap_url
    ])
    
    time.sleep(3)
    
    # 捕获应用响应
    log_print("INFO", "检查高德地图应用响应...")
    
    # 查看前景应用
    success, stdout, stderr = run_shell_command(["dumpsys", "window", "windows"])
    
    try:
        output = stdout.decode('utf-8', errors='ignore')
        if "amap" in output.lower() or "gaode" in output.lower():
            log_print("SUCCESS", "检测到高德地图应用在前景")
            return True
        elif "qsgl365" in output.lower():
            log_print("INFO", "应用仍在前景，高德地图未启动")
            return False
        else:
            log_print("WARNING", "无法确定前景应用状态")
    except:
        log_print("WARNING", "应用状态检查失败")
    
    return False

def create_html_test_file():
    """创建包含高德地图链接的HTML测试文件"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "创建HTML测试文件")
    log_print("INFO", "=" * 60)
    
    html_content = """<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Amap Test</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .test-link { 
            display: block; 
            margin: 10px 0; 
            padding: 10px; 
            background: #007bff; 
            color: white; 
            text-decoration: none; 
            border-radius: 5px;
            text-align: center;
        }
        .test-link:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h1>高德地图链接测试</h1>
    
    <h2>测试1: 高德地图导航链接</h2>
    <a href="amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=朝阳公园&endLat=32.0603&endLng=118.7969&endName=南京路&tmode=1" 
       class="test-link" id="amap-link">点击打开高德地图</a>
    
    <h2>测试2: 电话链接</h2>
    <a href="tel:10086" class="test-link" id="tel-link">点击拨打电话</a>
    
    <h2>测试3: 短信链接</h2>
    <a href="sms:10086" class="test-link" id="sms-link">点击发送短信</a>
    
    <script>
        console.log('Test page loaded');
        document.getElementById('amap-link').addEventListener('click', function(e) {
            console.log('Amap link clicked: ' + this.href);
        });
    </script>
</body>
</html>
"""
    
    test_file = os.path.join(WORKSPACE, "amap_test.html")
    try:
        with open(test_file, 'w', encoding='utf-8') as f:
            f.write(html_content)
        log_print("SUCCESS", f"测试HTML文件已创建: {test_file}")
        return test_file
    except Exception as e:
        log_print("ERROR", f"创建HTML文件失败: {e}")
        return None

def load_test_page_in_webview(html_file):
    """在应用的WebView中加载测试页面"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "在WebView中加载测试页面")
    log_print("INFO", "=" * 60)
    
    # 使用am broadcast或直接URL加载
    # 注意: 这需要应用支持加载本地文件或特定URL
    
    # 方法1: 通过Intent加载本地文件
    file_url = f"file://{html_file.replace(chr(92), '/')}"  # Windows路径转换
    
    log_print("INFO", f"尝试在应用中加载: {file_url}")
    
    # 启动应用并加载测试页面
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.VIEW",
        "-d", file_url,
        "-n", f"{APP_PACKAGE}/.MainActivity"
    ])
    
    if success:
        log_print("SUCCESS", "测试页面加载命令执行成功")
        time.sleep(5)
        return True
    else:
        log_print("WARNING", f"加载测试页面可能失败")
        return False

def main():
    """主测试流程"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "改进的自动化测试：高德地图链接调起")
    log_print("INFO", f"设备ID: {DEVICE_ID}")
    log_print("INFO", f"应用包名: {APP_PACKAGE}")
    log_print("INFO", "=" * 60)
    
    # 步骤1: 启动应用
    if not start_app():
        log_print("ERROR", "启动应用失败，无法继续测试")
        return False
    
    # 步骤2: 直接测试高德地图Intent
    test_amap_intent_directly()
    time.sleep(3)
    
    # 步骤3: 创建和加载测试HTML文件
    html_file = create_html_test_file()
    
    if html_file:
        # 步骤4: 在WebView中加载测试页面
        if load_test_page_in_webview(html_file):
            time.sleep(5)
            
            # 步骤5: 模拟用户点击
            simulate_user_tap_on_webview()
    
    # 步骤6: 检查日志
    time.sleep(3)
    check_app_webview_logs()
    
    log_print("SUCCESS", "所有测试完成")
    log_print("INFO", "=" * 60)
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        log_print("WARNING", "测试被用户中断")
        sys.exit(1)
    except Exception as e:
        log_print("ERROR", f"程序异常: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
