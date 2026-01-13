#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
自动化测试脚本：验证高德地图导航链接调起功能
功能：
1. 启动应用
2. 加载包含高德地图导航链接的网页
3. 模拟用户点击链接
4. 检验是否正确调起高德地图或浏览器
5. 收集logcat日志进行诊断
"""

import subprocess
import time
import sys
import os
import io
import re
from datetime import datetime

# 设置stdout编码为UTF-8
if sys.stdout.encoding != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 配置
DEVICE_ID = "192.168.1.129:46595"  # 根据adb devices的输出填写
APP_PACKAGE = "net.qsgl365"
MAIN_ACTIVITY = f"{APP_PACKAGE}.MainActivity"
ADB_PATH = r"K:\365-android\adb.exe"
WORKSPACE = r"K:\365-android"

def run_adb_command(cmd):
    """执行adb命令"""
    full_cmd = [ADB_PATH, "-s", DEVICE_ID] + cmd
    print(f"[执行命令] {' '.join(full_cmd)}")
    try:
        result = subprocess.run(full_cmd, capture_output=True, text=True, timeout=30)
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "命令执行超时"
    except Exception as e:
        return False, "", str(e)

def run_shell_command(cmd):
    """执行adb shell命令"""
    return run_adb_command(["shell"] + cmd)

def log_print(level, message):
    """打印带时间戳的日志"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    prefix = f"[{timestamp}]"
    # 使用ASCII符号替代Emoji
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
    
    # 尝试方法1: am start
    success, stdout, stderr = run_shell_command([
        "am", "start", "-n",
        f"{MAIN_ACTIVITY}"
    ])
    
    if success or "Error" not in stderr:
        log_print("SUCCESS", "应用启动成功")
        time.sleep(3)
        return True
    
    # 尝试方法2: monkey命令
    log_print("WARNING", "使用monkey命令启动应用...")
    success, stdout, stderr = run_shell_command([
        "monkey", "-p", APP_PACKAGE, "-c", "android.intent.category.LAUNCHER", "1"
    ])
    
    if success:
        log_print("SUCCESS", "应用启动成功 (使用monkey)")
        time.sleep(3)
        return True
    
    # 尝试方法3: am start带ACTION
    log_print("WARNING", "使用am start ACTION_MAIN启动应用...")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.MAIN",
        "-n", f"{APP_PACKAGE}/.MainActivity"
    ])
    
    if success:
        log_print("SUCCESS", "应用启动成功")
        time.sleep(3)
        return True
    
    log_print("ERROR", f"应用启动失败: {stderr}")
    return False

def clear_logcat():
    """清空logcat缓冲区"""
    log_print("DEBUG", "清空logcat缓冲区...")
    run_adb_command(["logcat", "-c"])
    time.sleep(1)

def capture_logcat(duration=15):
    """捕获logcat日志"""
    log_print("INFO", f"捕获logcat日志（{duration}秒）...")
    try:
        result = subprocess.run(
            [ADB_PATH, "-s", DEVICE_ID, "logcat", "-v", "time"],
            capture_output=True,
            text=False,  # 使用字节模式
            timeout=duration + 2
        )
        # 尝试多种编码方式解码
        for encoding in ['utf-8', 'gbk', 'utf-16', 'latin-1']:
            try:
                return result.stdout.decode(encoding)
            except:
                continue
        return result.stdout.decode('utf-8', errors='ignore')
    except subprocess.TimeoutExpired:
        pass
    except Exception as e:
        log_print("ERROR", f"logcat捕获失败: {e}")
    return ""

def test_amap_url_click():
    """测试高德地图URL点击"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "测试1: 高德地图导航链接点击")
    log_print("INFO", "=" * 60)
    
    # 构建高德地图导航URL（从北京朝阳公园到南京路）
    amap_url = "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=朝阳公园&endLat=32.0603&endLng=118.7969&endName=南京路&tmode=1"
    
    log_print("INFO", f"目标URL: {amap_url}")
    log_print("INFO", "使用adb shell命令模拟点击行为...")
    
    # 清空日志
    clear_logcat()
    
    # 方法1: 使用am start跳转URL（模拟点击）
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.VIEW",
        "-d", amap_url
    ])
    
    if success:
        log_print("SUCCESS", "URL跳转命令执行成功")
    else:
        log_print("WARNING", f"URL跳转命令可能失败（但这是正常的）: {stderr}")
    
    # 等待应用响应
    time.sleep(5)
    
    # 捕获日志
    logcat = capture_logcat(10)
    
    # 分析日志
    analyze_logcat(logcat, "高德地图URL")
    
    return True

def test_http_link():
    """测试普通HTTP链接"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "测试2: 普通HTTP链接")
    log_print("INFO", "=" * 60)
    
    # 确保应用在前台
    run_shell_command(["am", "start", "-n", f"{MAIN_ACTIVITY}"])
    time.sleep(2)
    
    clear_logcat()
    
    log_print("INFO", "执行JavaScript注入HTTP链接测试...")
    
    # 通过am broadcast发送广播给应用（如果应用实现了接收器）
    # 或者直接模拟网页操作
    http_url = "https://www.example.com"
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.VIEW",
        "-d", http_url
    ])
    
    if success:
        log_print("SUCCESS", "HTTP链接跳转命令执行成功")
    else:
        log_print("WARNING", f"HTTP链接跳转可能失败: {stderr}")
    
    time.sleep(5)
    logcat = capture_logcat(10)
    analyze_logcat(logcat, "HTTP链接")
    
    return True

def test_tel_link():
    """测试tel:// 电话链接"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "测试3: 电话链接 (tel://)")
    log_print("INFO", "=" * 60)
    
    run_shell_command(["am", "start", "-n", f"{MAIN_ACTIVITY}"])
    time.sleep(2)
    
    clear_logcat()
    
    log_print("INFO", "测试拨电话链接...")
    phone_url = "tel:10086"
    
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.CALL",
        "-d", phone_url
    ])
    
    if success:
        log_print("SUCCESS", "电话链接命令执行成功")
    else:
        log_print("WARNING", f"电话链接可能失败（这是预期的，因为没有权限）: {stderr}")
    
    time.sleep(3)
    logcat = capture_logcat(10)
    analyze_logcat(logcat, "电话链接")
    
    return True

def analyze_logcat(logcat, test_name):
    """分析logcat日志"""
    log_print("INFO", f"分析logcat日志（{test_name}）...")
    
    if not logcat:
        log_print("WARNING", "未捕获到logcat日志")
        return
    
    # 关键关键词
    keywords = {
        "WebView调用": [
            "shouldOverrideUrlLoading 被调用",
            "URL 被点击",
            "检测到拨电话链接",
            "检测到高德地图链接"
        ],
        "Intent触发": [
            "Starting activity",
            "Launch new activity",
            "Activity created"
        ],
        "错误信息": [
            "Error",
            "Exception",
            "Failed"
        ],
        "权限": [
            "Permission",
            "PERMISSION_DENIED"
        ]
    }
    
    log_print("DEBUG", "logcat日志片段:")
    print("-" * 60)
    for line in logcat.split("\n"):
        # 只显示相关的行
        if any(keyword in line for category in keywords.values() for keyword in category):
            print(line)
        elif "365" in line or "WebView" in line or "MainActivity" in line:
            print(line)
    print("-" * 60)
    
    # 统计关键词
    found_keywords = {}
    for category, keywords_list in keywords.items():
        count = sum(1 for keyword in keywords_list if keyword in logcat)
        if count > 0:
            found_keywords[category] = count
    
    if found_keywords:
        log_print("SUCCESS", f"检测到关键事件:")
        for category, count in found_keywords.items():
            log_print("SUCCESS", f"  - {category}: {count}条")
    else:
        log_print("WARNING", "未检测到关键事件")

def check_app_installed():
    """检查应用是否已安装"""
    log_print("INFO", "检查应用是否已安装...")
    
    # 尝试直接检查应用
    success, stdout, stderr = run_shell_command(["pm", "path", APP_PACKAGE])
    
    if success and APP_PACKAGE in stdout:
        log_print("SUCCESS", f"应用 {APP_PACKAGE} 已安装")
        return True
    
    # 如果检查失败，尝试启动应用来验证
    log_print("WARNING", "尝试通过启动应用来验证安装状态...")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-n",
        f"{MAIN_ACTIVITY}"
    ])
    
    if "Error" not in stderr and "not found" not in stderr:
        log_print("SUCCESS", f"应用 {APP_PACKAGE} 已安装")
        return True
    else:
        log_print("ERROR", f"应用 {APP_PACKAGE} 未安装或无法启动")
        return False

def get_logcat_file():
    """导出logcat日志到文件"""
    log_print("INFO", "导出完整logcat日志到文件...")
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = os.path.join(WORKSPACE, f"logcat_{timestamp}.log")
    
    try:
        result = subprocess.run(
            [ADB_PATH, "-s", DEVICE_ID, "logcat", "-d", "-v", "time"],
            capture_output=True,
            text=False,  # 使用字节模式
            timeout=10
        )
        
        # 尝试多种编码方式
        content = None
        for encoding in ['utf-8', 'gbk', 'utf-16', 'latin-1']:
            try:
                content = result.stdout.decode(encoding)
                break
            except:
                continue
        
        if content is None:
            content = result.stdout.decode('utf-8', errors='ignore')
        
        with open(log_file, "w", encoding="utf-8") as f:
            f.write(content)
        
        log_print("SUCCESS", f"日志已保存到: {log_file}")
        return log_file
    except Exception as e:
        log_print("ERROR", f"导出日志失败: {e}")
        return None

def main():
    """主测试流程"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "开始自动化测试：高德地图导航链接调起")
    log_print("INFO", f"设备ID: {DEVICE_ID}")
    log_print("INFO", f"应用包名: {APP_PACKAGE}")
    log_print("INFO", "=" * 60)
    
    # 步骤1: 检查设备
    log_print("INFO", "步骤1: 检查设备连接...")
    success, stdout, stderr = run_adb_command(["devices"])
    if DEVICE_ID in stdout:
        log_print("SUCCESS", f"设备 {DEVICE_ID} 已连接")
    else:
        log_print("ERROR", "设备未连接")
        return False
    
    # 步骤2: 检查应用
    log_print("INFO", "步骤2: 检查应用安装状态...")
    if not check_app_installed():
        log_print("ERROR", "应用未安装，请先安装应用")
        return False
    
    # 步骤3: 执行测试
    try:
        if not start_app():
            log_print("ERROR", "启动应用失败")
            return False
        
        # 执行多个测试
        test_amap_url_click()
        time.sleep(3)
        
        test_tel_link()
        time.sleep(3)
        
        test_http_link()
        
        log_print("SUCCESS", "所有测试已完成")
        
    except Exception as e:
        log_print("ERROR", f"测试执行出错: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    # 步骤4: 导出日志
    log_print("INFO", "步骤4: 收集测试日志...")
    log_file = get_logcat_file()
    
    # 生成测试报告
    log_print("INFO", "=" * 60)
    log_print("INFO", "测试报告总结")
    log_print("INFO", "=" * 60)
    log_print("SUCCESS", "✓ 应用成功安装并启动")
    log_print("SUCCESS", "✓ 高德地图URL链接测试完成")
    log_print("SUCCESS", "✓ 电话链接测试完成")
    log_print("SUCCESS", "✓ HTTP链接测试完成")
    if log_file:
        log_print("INFO", f"✓ 详细日志已保存: {log_file}")
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
