#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
新设备测试脚本：192.168.1.75:37547
针对高德地图导航链接调起的完整自动化测试
"""

import subprocess
import time
import sys
import os
import io
from datetime import datetime

if sys.stdout.encoding != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

DEVICE_ID = "192.168.1.75:37547"  # 新设备ID
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
    
    if success:
        log_print("SUCCESS", "应用启动成功")
        time.sleep(5)
        return True
    
    log_print("WARNING", "尝试使用monkey启动...")
    success, stdout, stderr = run_shell_command([
        "monkey", "-p", APP_PACKAGE, "-c", "android.intent.category.LAUNCHER", "1"
    ])
    
    if success:
        log_print("SUCCESS", "应用启动成功 (使用monkey)")
        time.sleep(5)
        return True
    
    log_print("ERROR", f"应用启动失败")
    return False

def clear_logcat():
    """清空logcat缓冲区"""
    run_adb_command(["logcat", "-c"])
    time.sleep(1)

def test_amap_link():
    """测试高德地图链接"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "测试: 高德地图导航链接调起")
    log_print("INFO", "=" * 60)
    
    clear_logcat()
    
    amap_url = "amap://path?sourceApplication=net.qsgl365&startLat=39.9489&startLng=116.4387&startName=朝阳公园&endLat=32.0603&endLng=118.7969&endName=南京路&tmode=1"
    
    log_print("INFO", f"目标URL: {amap_url[:80]}...")
    
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.VIEW",
        "-d", amap_url
    ])
    
    if success:
        log_print("SUCCESS", "高德地图Intent执行成功")
    else:
        log_print("WARNING", f"Intent执行可能失败")
    
    time.sleep(5)
    return True

def test_tel_link():
    """测试电话链接"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "测试: 电话链接")
    log_print("INFO", "=" * 60)
    
    clear_logcat()
    
    success, stdout, stderr = run_shell_command([
        "am", "start", "-a", "android.intent.action.CALL",
        "-d", "tel:10086"
    ])
    
    if success:
        log_print("SUCCESS", "电话链接Intent执行成功")
    else:
        log_print("WARNING", f"电话链接可能失败")
    
    time.sleep(3)
    return True

def capture_logcat(duration=10):
    """捕获logcat日志"""
    log_print("INFO", f"捕获logcat日志（{duration}秒）...")
    try:
        result = subprocess.run(
            [ADB_PATH, "-s", DEVICE_ID, "logcat", "-v", "time"],
            capture_output=True,
            text=False,
            timeout=duration + 2
        )
        
        for encoding in ['utf-8', 'gbk', 'latin-1']:
            try:
                return result.stdout.decode(encoding)
            except:
                continue
        return result.stdout.decode('utf-8', errors='ignore')
    except:
        pass
    return ""

def export_logcat(suffix=""):
    """导出完整logcat日志"""
    log_print("INFO", "导出完整logcat日志...")
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = os.path.join(WORKSPACE, f"logcat_new_device_{timestamp}{suffix}.log")
    
    try:
        result = subprocess.run(
            [ADB_PATH, "-s", DEVICE_ID, "logcat", "-d", "-v", "time"],
            capture_output=True,
            text=False,
            timeout=10
        )
        
        content = None
        for encoding in ['utf-8', 'gbk', 'latin-1']:
            try:
                content = result.stdout.decode(encoding)
                break
            except:
                continue
        
        if content is None:
            content = result.stdout.decode('utf-8', errors='ignore')
        
        with open(log_file, "w", encoding="utf-8") as f:
            f.write(content)
        
        log_print("SUCCESS", f"日志已保存: {log_file}")
        return log_file
    except Exception as e:
        log_print("ERROR", f"导出日志失败: {e}")
        return None

def get_device_info():
    """获取设备信息"""
    log_print("INFO", "获取设备信息...")
    
    success, stdout, stderr = run_shell_command(["getprop", "ro.product.model"])
    if success:
        model = stdout.decode('utf-8', errors='ignore').strip()
        log_print("INFO", f"设备型号: {model}")
    
    success, stdout, stderr = run_shell_command(["getprop", "ro.build.version.release"])
    if success:
        version = stdout.decode('utf-8', errors='ignore').strip()
        log_print("INFO", f"Android版本: {version}")

def main():
    """主测试流程"""
    log_print("INFO", "=" * 60)
    log_print("INFO", "365应用 - 新设备测试")
    log_print("INFO", f"设备ID: {DEVICE_ID}")
    log_print("INFO", "=" * 60)
    
    # 步骤1: 验证设备连接
    success, stdout, stderr = run_adb_command(["devices"])
    if DEVICE_ID in stdout.decode('utf-8', errors='ignore'):
        log_print("SUCCESS", "设备已连接")
    else:
        log_print("ERROR", "设备未连接")
        return False
    
    # 步骤2: 获取设备信息
    get_device_info()
    
    # 步骤3: 启动应用
    if not start_app():
        log_print("ERROR", "启动应用失败")
        return False
    
    # 步骤4: 运行测试
    test_amap_link()
    time.sleep(3)
    
    test_tel_link()
    time.sleep(3)
    
    # 步骤5: 检查应用日志
    log_print("INFO", "检查应用日志...")
    success, stdout, stderr = run_adb_command([
        "logcat", "-d", "-v", "time", "-s", "qsgl365:*"
    ])
    
    if success:
        try:
            output = stdout.decode('utf-8', errors='ignore')
            if output.strip():
                log_print("SUCCESS", "找到应用日志")
        except:
            pass
    
    # 步骤6: 导出日志
    export_logcat()
    
    log_print("SUCCESS", "所有测试完成")
    log_print("INFO", "=" * 60)
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        log_print("WARNING", "测试被中断")
        sys.exit(1)
    except Exception as e:
        log_print("ERROR", f"程序异常: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
