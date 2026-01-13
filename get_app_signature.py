#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Android 应用签名提取 - 通过编译 APK 获取签名
"""

import os
import sys
import subprocess
import re
from pathlib import Path

def build_and_extract_signature():
    """编译 Release APK 并提取签名"""
    
    print("=" * 70)
    print("Android 应用签名提取工具 - APK 编译方案")
    print("=" * 70)
    print()
    
    # 配置信息
    print("📋 应用信息:")
    print("   应用包名: net.qsgl365")
    print("   签名别名: qsgl365")
    print("   版本: 1.0")
    print()
    
    # 检查是否存在签名密钥
    keystore_path = Path("app/my-release-key.jks")
    if not keystore_path.exists():
        print(f"❌ 错误: 找不到签名密钥 {keystore_path}")
        return False
    
    print(f"✓ 找到签名密钥: {keystore_path} ({keystore_path.stat().st_size} 字节)")
    print()
    
    # 步骤 1: 编译 Release APK
    print("📦 步骤 1: 编译 Release APK")
    print("-" * 70)
    print("正在构建 Release APK（这将使用签名密钥进行签名）...")
    print()
    
    try:
        # 运行 gradlew assembleRelease
        cmd = ["./gradlew.bat", "assembleRelease", "--no-daemon"]
        
        result = subprocess.run(
            cmd,
            cwd="..",
            capture_output=True,
            text=True,
            timeout=600
        )
        
        if result.returncode == 0:
            print("✅ Release APK 编译成功!")
            apk_path = Path("../app/build/outputs/apk/release/app-release.apk")
            
            if apk_path.exists():
                apk_size = apk_path.stat().st_size
                print(f"   APK 文件: {apk_path}")
                print(f"   文件大小: {apk_size / (1024*1024):.2f} MB")
                print()
                return True
        else:
            print(f"❌ APK 编译失败:")
            print(result.stderr[-500:] if len(result.stderr) > 500 else result.stderr)
            return False
            
    except subprocess.TimeoutExpired:
        print("❌ 编译超时（超过 10 分钟）")
        return False
    except Exception as e:
        print(f"❌ 编译过程中出错: {e}")
        return False

def show_signature_extraction_guide():
    """显示签名提取指南"""
    
    print()
    print("=" * 70)
    print("📌 应用签名提取指南")
    print("=" * 70)
    print()
    
    print("✨ 方案 1: 使用 Android Studio（推荐）")
    print("-" * 70)
    print("""
1. 打开 Android Studio
2. 打开项目: k:\\365-android
3. 菜单 > Build > Generate Signed Bundle/APK
4. 选择 "APK"
5. 选择现有密钥库:
   - 位置: k:\\365-android\\app\\my-release-key.jks
   - 密码: 123456
   - 密钥别名: qsgl365
   - 密钥密码: 123456
6. 完成构建后，会显示签名指纹信息
7. 复制 SHA1 和 MD5 指纹到微信开放平台
""")
    
    print()
    print("✨ 方案 2: 使用在线工具（快速）")
    print("-" * 70)
    print("""
1. 访问: https://www.btool.cn/apps/appsign
2. 或访问: https://wximg.qq.com/wxdoc/certification_tools/
3. 上传编译好的 app-release.apk 文件
4. 工具会自动提取 MD5 和 SHA1 签名
5. 复制到微信开放平台
""")
    
    print()
    print("✨ 方案 3: 使用命令行（需要 Java）")
    print("-" * 70)
    print("""
# 如果已安装 Java/keytool，运行:
keytool -list -v -keystore app\\my-release-key.jks -storepass 123456 -keyalias qsgl365 -keypass 123456

# 或使用 jarsigner（需要先编译 APK）:
jarsigner -verify -verbose -certs app\\build\\outputs\\apk\\release\\app-release.apk
""")
    
    print()
    print("=" * 70)
    print("📝 密钥信息（用于上述方案）")
    print("=" * 70)
    print("""
密钥库文件: k:\\365-android\\app\\my-release-key.jks
密钥库密码: 123456
密钥别名: qsgl365
密钥密码: 123456

应用包名: net.qsgl365
APK 文件: app\\build\\outputs\\apk\\release\\app-release.apk
""")
    
    print()
    print("=" * 70)
    print("💡 提示")
    print("=" * 70)
    print("""
1. 微信开放平台通常需要 MD5 或 SHA1 签名
2. 建议使用方案 1（Android Studio）最准确
3. 在线工具（方案 2）最便捷，上传 APK 即可
4. 不同的应用包名需要不同的签名
5. 不要丢失签名密钥，否则无法更新应用

""")

def main():
    """主函数"""
    
    print()
    print("🔍 开始提取应用签名...")
    print()
    
    # 编译 APK
    if build_and_extract_signature():
        print()
        print("✅ 编译完成！现在可以提取签名了")
    else:
        print()
        print("⚠️  APK 编译失败，但仍可使用其他方式提取签名")
    
    # 显示提取指南
    show_signature_extraction_guide()

if __name__ == "__main__":
    main()
