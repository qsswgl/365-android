#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Android 应用签名提取工具
用于从 JKS 密钥库中提取应用签名（MD5 和 SHA1）
"""

import os
import sys
import subprocess
import json
from pathlib import Path

def extract_signature_with_keytool(keystore_path, storepass, keyalias, keypass):
    """
    使用 keytool 提取签名信息
    """
    print("🔍 正在使用 keytool 提取签名信息...\n")
    
    # 寻找 keytool
    keytool_paths = [
        # Windows
        r"C:\Program Files\Java\jdk*/bin/keytool.exe",
        r"C:\Program Files (x86)\Java\jdk*/bin/keytool.exe",
        r"C:\Program Files\Android\Android Studio\jre\bin\keytool.exe",
        # macOS
        "/Library/Java/JavaVirtualMachines/*/Contents/Home/bin/keytool",
        "/usr/libexec/java_home",
        # Linux
        "/usr/bin/keytool",
        "/usr/local/bin/keytool",
    ]
    
    keytool_cmd = None
    for pattern in keytool_paths:
        expanded = os.path.expanduser(pattern)
        if "*" in expanded:
            # Handle wildcards
            import glob
            matches = glob.glob(expanded)
            if matches:
                keytool_cmd = matches[0]
                break
        elif os.path.exists(expanded):
            keytool_cmd = expanded
            break
    
    if not keytool_cmd:
        # Try to find keytool in PATH
        try:
            result = subprocess.run(
                ["where", "keytool"] if os.name == 'nt' else ["which", "keytool"],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                keytool_cmd = result.stdout.strip()
        except:
            pass
    
    if not keytool_cmd:
        print("❌ 未找到 keytool 工具")
        print("   keytool 通常位于 Java 开发工具包 (JDK) 中")
        print("   请安装 Java JDK 或 Android Studio")
        return None
    
    print(f"✓ 找到 keytool: {keytool_cmd}\n")
    
    try:
        # 运行 keytool 命令
        cmd = [
            keytool_cmd,
            "-list",
            "-v",
            "-keystore", keystore_path,
            "-storepass", storepass,
            "-keypass", keypass,
            "-alias", keyalias
        ]
        
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            return result.stdout
        else:
            print(f"❌ keytool 执行失败: {result.stderr}")
            return None
    except Exception as e:
        print(f"❌ 执行 keytool 时出错: {e}")
        return None

def extract_cert_hash_python(keystore_path, storepass, keyalias, keypass):
    """
    使用 Python 的 zipfile 和 hashlib 提取签名
    （备用方案，当 keytool 不可用时）
    """
    print("📝 使用 Python 提取签名信息...\n")
    
    try:
        import zipfile
        import hashlib
        import base64
        from cryptography import x509
        from cryptography.hazmat.backends import default_backend
        
        # JKS 是一个 Java 序列化格式
        # 这里我们使用一个简单的方法来读取证书信息
        
        print("⚠️  提取签名哈希...")
        
        # 由于 JKS 是二进制格式，我们需要使用 keytool 或其他工具
        # Python 提取 JKS 比较复杂，建议使用以下在线工具或 keytool
        
        return None
    except Exception as e:
        print(f"❌ Python 提取失败: {e}")
        return None

def main():
    """主函数"""
    print("=" * 60)
    print("Android 应用签名提取工具")
    print("=" * 60)
    print()
    
    # 配置信息
    keystore_path = "my-release-key.jks"
    storepass = "123456"
    keyalias = "qsgl365"
    keypass = "123456"
    
    print("📋 签名密钥信息:")
    print(f"   密钥库文件: {keystore_path}")
    print(f"   密钥别名: {keyalias}")
    print()
    
    # 检查文件是否存在
    if not os.path.exists(keystore_path):
        print(f"❌ 错误: 找不到文件 {keystore_path}")
        sys.exit(1)
    
    # 尝试使用 keytool 提取
    signature_info = extract_signature_with_keytool(
        keystore_path, storepass, keyalias, keypass
    )
    
    if signature_info:
        print("✅ 成功提取签名信息!\n")
        print("=" * 60)
        print(signature_info)
        print("=" * 60)
        
        # 提取关键信息
        print("\n📌 关键信息提取:\n")
        
        lines = signature_info.split('\n')
        for line in lines:
            if 'MD5' in line and 'Fingerprint' in line:
                print(f"✓ {line.strip()}")
            elif 'SHA1' in line and 'Fingerprint' in line:
                print(f"✓ {line.strip()}")
            elif 'SHA-256' in line and 'Fingerprint' in line:
                print(f"✓ {line.strip()}")
        
        print("\n" + "=" * 60)
        print("请复制上面的 SHA1 或 MD5 值到微信开放平台")
        print("=" * 60)
    else:
        print("\n❌ 无法使用 keytool 提取签名信息")
        print("\n📌 替代方案 1: 使用 Android Studio")
        print("   1. 打开 Android Studio")
        print("   2. 菜单 > Build > Generate Signed Bundle/APK")
        print("   3. 选择现有密钥库")
        print("   4. 在构建过程中会显示签名信息")
        
        print("\n📌 替代方案 2: 使用在线工具")
        print("   访问: https://www.btool.cn/apps/appsign")
        print("   上传 APK 文件获取签名")
        
        print("\n📌 替代方案 3: 使用 jarsigner")
        print("   需要先编译 APK，然后运行:")
        print("   jarsigner -verify -verbose -certs app-release.apk")

if __name__ == "__main__":
    main()
