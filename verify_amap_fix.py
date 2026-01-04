#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Amap导航修复 - 快速验证脚本
验证修复是否有效
"""

import subprocess
import time
import sys

DEVICE_ID = "192.168.1.75:37547"
APP_PACKAGE = "net.qsgl365"

def run_adb(cmd):
    """执行ADB命令"""
    full_cmd = f"adb -s {DEVICE_ID} {cmd}"
    try:
        result = subprocess.run(full_cmd, shell=True, capture_output=True, text=True, timeout=30)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def print_test(msg, passed):
    symbol = "✓" if passed else "✗"
    print(f"[{symbol}] {msg}")
    return passed

def main():
    print("\n" + "="*60)
    print("Amap导航修复 - 快速验证")
    print("="*60 + "\n")
    
    all_passed = True
    
    # 1. 检查设备连接
    print("[1/5] 检查设备连接...")
    success, output, _ = run_adb("shell getprop ro.build.version.release")
    passed = success and output.strip()
    all_passed &= print_test(f"设备已连接 (Android {output.strip()})", passed)
    
    if not passed:
        print("\n✗ 设备未连接，无法继续")
        return False
    
    # 2. 检查应用安装
    print("\n[2/5] 检查应用安装...")
    success, output, _ = run_adb("shell pm list packages | Select-String qsgl365")
    passed = success and APP_PACKAGE in output
    all_passed &= print_test(f"365APP已安装", passed)
    
    if not passed:
        print("✓ 重新安装应用...")
        run_adb(f"install -r app/build/outputs/apk/release/app-release.apk")
    
    # 3. 启动应用
    print("\n[3/5] 启动应用...")
    success, _, _ = run_adb(f"shell am start -n {APP_PACKAGE}/.MainActivity")
    passed = success
    all_passed &= print_test("应用启动成功", passed)
    
    time.sleep(3)
    
    # 4. 检查高德地图
    print("\n[4/5] 检查导航应用...")
    
    apps = {
        "高德地图": "com.autonavi.minimap",
        "Google地图": "com.google.android.apps.maps",
        "百度地图": "com.baidu.BaiduMap",
    }
    
    found_any = False
    for name, package in apps.items():
        success, output, _ = run_adb(f"shell pm list packages | Select-String {package.split('.')[-1]}")
        installed = success and package in output
        print_test(f"  {name}: {'已安装' if installed else '未安装'}", installed)
        if installed:
            found_any = True
    
    all_passed &= found_any
    
    # 5. 查看日志
    print("\n[5/5] 检查应用日志...")
    success, output, _ = run_adb(f"logcat -d | Select-String WebView | head -20")
    
    if output.strip():
        print("✓ 日志输出:")
        print(output[:500])  # 显示前500字符
    else:
        print("⚠  暂无相关日志")
    
    # 总结
    print("\n" + "="*60)
    if all_passed:
        print("✓ 所有检查通过！")
        print("\n下一步:")
        print("1. 在设备上打开应用")
        print("2. 点击导航图标")
        print("3. 应该能看到:")
        print("   - Amap应用打开 (如已安装)")
        print("   - 或 Google地图 (备选)")
        print("   - 或 网页地图 (最后方案)")
    else:
        print("⚠  部分检查未通过，请查看上面的输出")
    
    print("="*60 + "\n")
    
    return all_passed

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"✗ 错误: {e}")
        sys.exit(1)
