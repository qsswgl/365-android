#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
高德地图链接处理诊断脚本
直接测试WebView中的高德地图链接处理
"""

import subprocess
import time
import sys
import os
import io
from datetime import datetime

if sys.stdout.encoding != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

DEVICE_ID = "192.168.1.75:37547"
APP_PACKAGE = "net.qsgl365"
ADB_PATH = r"K:\365-android\adb.exe"

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
    """打印日志"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    prefix = f"[{timestamp}]"
    symbols = {"INFO": "[*]", "SUCCESS": "[+]", "WARNING": "[!]", "ERROR": "[-]", "DEBUG": "[?]"}
    symbol = symbols.get(level, "")
    print(f"{prefix} {symbol} [{level}] {message}")

def clear_and_start_capture():
    """清空日志并开始捕获"""
    run_adb_command(["logcat", "-c"])
    time.sleep(1)

def test_amap_via_intent():
    """通过Intent直接测试高德地图"""
    log_print("INFO", "=" * 70)
    log_print("INFO", "测试1: 直接通过Intent调起高德地图")
    log_print("INFO", "=" * 70)
    
    clear_and_start_capture()
    
    amap_url = "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=朝阳公园&endLat=32.0603&endLng=118.7969&endName=南京路&tmode=1"
    
    log_print("INFO", "执行: am start -a android.intent.action.VIEW -d amap://...")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.VIEW", "-d", amap_url
    ])
    
    if success:
        log_print("SUCCESS", "Intent启动成功")
    else:
        log_print("ERROR", f"Intent启动失败: {stderr.decode('utf-8', errors='ignore')}")
    
    time.sleep(3)
    
    # 检查前景应用
    success, stdout, stderr = run_shell_command(["dumpsys", "window", "windows"])
    output = stdout.decode('utf-8', errors='ignore')
    
    if "amap" in output.lower() or "gaode" in output.lower():
        log_print("SUCCESS", "检测到高德地图应用已启动")
    elif "qsgl365" in output.lower():
        log_print("WARNING", "应用仍在前景，高德地图未启动")
    else:
        log_print("WARNING", "无法确定前景应用")

def test_tel_via_intent():
    """通过Intent测试电话链接"""
    log_print("INFO", "=" * 70)
    log_print("INFO", "测试2: 电话链接Intent")
    log_print("INFO", "=" * 70)
    
    clear_and_start_capture()
    
    log_print("INFO", "执行: am start -a android.intent.action.CALL -d tel:10086")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.CALL", "-d", "tel:10086"
    ])
    
    if success:
        log_print("SUCCESS", "电话Intent启动成功")
    else:
        log_print("WARNING", f"电话Intent可能失败")
    
    time.sleep(2)

def capture_webview_logs():
    """捕获WebView相关日志"""
    log_print("INFO", "=" * 70)
    log_print("INFO", "捕获WebView相关日志")
    log_print("INFO", "=" * 70)
    
    success, stdout, stderr = run_adb_command(["logcat", "-d", "-v", "time"])
    
    if success:
        output = stdout.decode('utf-8', errors='ignore')
        lines = output.split('\n')
        
        log_print("INFO", "WebView日志摘录:")
        count = 0
        for line in lines:
            if any(keyword in line for keyword in ['WebView', 'shouldOverride', 'amap', '加载', '错误', 'Intent']):
                print(line)
                count += 1
                if count >= 20:
                    break

def test_http_navigation():
    """测试HTTP导航"""
    log_print("INFO", "=" * 70)
    log_print("INFO", "测试3: HTTP导航")
    log_print("INFO", "=" * 70)
    
    clear_and_start_capture()
    
    log_print("INFO", "启动应用...")
    run_shell_command(["am", "start", "-a", "android.intent.action.MAIN", "-n", f"{APP_PACKAGE}/.MainActivity"])
    
    time.sleep(5)
    
    log_print("INFO", "执行HTTP链接...")
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.VIEW", "-d", "https://www.baidu.com"
    ])
    
    if success:
        log_print("SUCCESS", "HTTP Intent启动成功")
    
    time.sleep(3)

def main():
    """主测试"""
    log_print("INFO", "=" * 70)
    log_print("INFO", "365应用 - 高德地图链接诊断测试")
    log_print("INFO", f"设备: {DEVICE_ID}")
    log_print("INFO", "=" * 70)
    
    # 验证设备连接
    success, stdout, stderr = run_adb_command(["devices"])
    if DEVICE_ID not in stdout.decode('utf-8', errors='ignore'):
        log_print("ERROR", "设备未连接")
        return False
    
    log_print("SUCCESS", "设备已连接")
    
    # 运行测试
    test_amap_via_intent()
    time.sleep(2)
    
    test_tel_via_intent()
    time.sleep(2)
    
    test_http_navigation()
    time.sleep(2)
    
    # 收集日志
    capture_webview_logs()
    
    log_print("SUCCESS", "诊断完成")
    log_print("INFO", "=" * 70)
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        log_print("WARNING", "被中断")
        sys.exit(1)
    except Exception as e:
        log_print("ERROR", f"异常: {e}")
        sys.exit(1)
