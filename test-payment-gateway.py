#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
农行支付网关 API 测试脚本 - Python
基于 Swagger 文档: https://payment.qsgl.net/swagger.json
测试所有支付相关的 API 端点
"""

import requests
import json
import time
from datetime import datetime
from typing import Dict, Tuple, Optional

# 配置
GATEWAY_URL = "https://payment.qsgl.net"
MERCHANT_ID = "103881636900016"
NOTIFY_URL = "https://your-backend.com/api/payment/notify"
RETURN_URL = "https://your-frontend.com/payment/result"

# 颜色定义（ANSI 颜色代码）
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

class TestResults:
    """存储测试结果"""
    def __init__(self):
        self.results = {}
    
    def add(self, name: str, passed: bool):
        self.results[name] = passed
    
    def get_summary(self) -> Tuple[int, int]:
        passed = sum(1 for v in self.results.values() if v)
        failed = len(self.results) - passed
        return passed, failed
    
    def print_summary(self):
        """打印测试结果汇总"""
        print_header("📊 测试结果汇总")
        
        for name, passed in self.results.items():
            status = "✓ PASS" if passed else "✗ FAIL"
            color = Colors.GREEN if passed else Colors.RED
            print(f"{color}{status}{Colors.RESET} - {name}")
        
        passed, failed = self.get_summary()
        color = Colors.GREEN if failed == 0 else Colors.RED
        print(f"\n总计: {Colors.GREEN}{passed}{Colors.RESET} 通过, {Colors.RED}{failed}{Colors.RESET} 失败")

def print_header(title: str):
    """打印标题"""
    print()
    print(f"{Colors.HEADER}{'=' * 45}{Colors.RESET}")
    print(f"{Colors.HEADER}{title:^45}{Colors.RESET}")
    print(f"{Colors.HEADER}{'=' * 45}{Colors.RESET}")

def print_success(message: str):
    """打印成功消息"""
    print(f"{Colors.GREEN}✓ {message}{Colors.RESET}")

def print_error(message: str):
    """打印错误消息"""
    print(f"{Colors.RED}✗ {message}{Colors.RESET}")

def print_info(message: str):
    """打印信息消息"""
    print(f"{Colors.CYAN}  {message}{Colors.RESET}")

def print_warning(message: str):
    """打印警告消息"""
    print(f"{Colors.YELLOW}⚠ {message}{Colors.RESET}")

def make_request(method: str, endpoint: str, data: Optional[Dict] = None, timeout: int = 10) -> Optional[Dict]:
    """
    发送 HTTP 请求
    """
    url = f"{GATEWAY_URL}{endpoint}"
    
    try:
        if method.upper() == "GET":
            if endpoint.endswith((".ping",)):
                # Ping 返回纯文本
                response = requests.get(url, timeout=timeout)
                response.raise_for_status()
                return {"text": response.text}
            else:
                response = requests.get(url, timeout=timeout)
                response.raise_for_status()
                return response.json()
        elif method.upper() == "POST":
            response = requests.post(
                url,
                json=data,
                headers={"Content-Type": "application/json"},
                timeout=timeout
            )
            response.raise_for_status()
            return response.json()
    except requests.exceptions.Timeout:
        print_error(f"请求超时: {url}")
        return None
    except requests.exceptions.ConnectionError:
        print_error(f"连接失败: {url}")
        return None
    except requests.exceptions.HTTPError as e:
        print_error(f"HTTP 错误: {e.response.status_code} - {e.response.text}")
        return None
    except requests.exceptions.JSONDecodeError:
        print_error(f"响应不是有效的 JSON")
        return None
    except Exception as e:
        print_error(f"请求失败: {str(e)}")
        return None

def test_ping() -> bool:
    """测试 Ping"""
    print_header("1️⃣  Ping 测试")
    
    response = make_request("GET", "/ping")
    if response and "text" in response:
        print_success(f"Ping 成功: {response['text']}")
        return True
    else:
        print_error("Ping 失败")
        return False

def test_health() -> bool:
    """测试健康检查"""
    print_header("2️⃣  健康检查")
    
    response = make_request("GET", "/health")
    if not response:
        print_error("健康检查失败")
        return False
    
    status = response.get("status", "unknown")
    uptime = response.get("uptime", 0)
    timestamp = response.get("timestamp", "")
    
    if status == "healthy":
        print_success(f"健康状态: {status}")
    elif status == "degraded":
        print_warning(f"健康状态: {status} (性能下降)")
    else:
        print_error(f"健康状态: {status}")
    
    print_info(f"运行时间: {uptime} 秒")
    print_info(f"时间戳: {timestamp}")
    
    return status == "healthy"

def test_root_info() -> bool:
    """测试 API 信息"""
    print_header("3️⃣  API 信息")
    
    response = make_request("GET", "/")
    if not response:
        print_error("API 信息获取失败")
        return False
    
    name = response.get("name", "N/A")
    version = response.get("version", "N/A")
    status = response.get("status", "N/A")
    environment = response.get("environment", "N/A")
    timestamp = response.get("timestamp", "N/A")
    
    print_success("API 信息获取成功")
    print_info(f"名称: {name}")
    print_info(f"版本: {version}")
    print_info(f"状态: {status}")
    print_info(f"环境: {environment}")
    print_info(f"时间戳: {timestamp}")
    
    return True

def test_qrcode_payment() -> Optional[str]:
    """测试创建扫码支付订单"""
    print_header("4️⃣  创建扫码支付订单 (/api/payment/qrcode)")
    
    order_no = f"TEST_{int(time.time())}"
    
    payment_request = {
        "orderNo": order_no,
        "amount": 0.01,
        "merchantId": MERCHANT_ID,
        "goodsName": "测试商品",
        "notifyUrl": NOTIFY_URL,
        "returnUrl": RETURN_URL,
        "remarks": "Python 自动化测试"
    }
    
    print_info("发送请求:")
    print_info(json.dumps(payment_request, ensure_ascii=False, indent=2))
    
    response = make_request("POST", "/api/payment/qrcode", payment_request)
    if not response:
        print_error("订单创建失败")
        return None
    
    is_success = response.get("isSuccess", False)
    if is_success:
        order_no_resp = response.get("orderNo", "N/A")
        status = response.get("status", "N/A")
        transaction_id = response.get("transactionId", "N/A")
        message = response.get("message", "")
        qr_code = response.get("qrCode", "")
        
        print_success("订单创建成功")
        print_info(f"订单号: {order_no_resp}")
        print_info(f"状态: {status}")
        print_info(f"交易 ID: {transaction_id}")
        print_info(f"消息: {message}")
        if qr_code:
            print_info(f"二维码: {qr_code}")
        
        return order_no_resp
    else:
        message = response.get("message", "未知错误")
        print_error(f"订单创建失败: {message}")
        return None

def test_ewallet_payment() -> Optional[str]:
    """测试创建电子钱包支付订单"""
    print_header("5️⃣  创建电子钱包支付订单 (/api/payment/ewallet)")
    
    order_no = f"EWALLET_{int(time.time())}"
    
    payment_request = {
        "orderNo": order_no,
        "amount": 0.01,
        "merchantId": MERCHANT_ID,
        "goodsName": "电子钱包测试",
        "notifyUrl": NOTIFY_URL,
        "returnUrl": RETURN_URL
    }
    
    print_info("发送请求:")
    print_info(json.dumps(payment_request, ensure_ascii=False, indent=2))
    
    response = make_request("POST", "/api/payment/ewallet", payment_request)
    if not response:
        print_error("订单创建失败")
        return None
    
    is_success = response.get("isSuccess", False)
    if is_success:
        order_no_resp = response.get("orderNo", "N/A")
        status = response.get("status", "N/A")
        transaction_id = response.get("transactionId", "N/A")
        redirect_url = response.get("redirectUrl", "")
        
        print_success("订单创建成功")
        print_info(f"订单号: {order_no_resp}")
        print_info(f"状态: {status}")
        print_info(f"交易 ID: {transaction_id}")
        if redirect_url:
            print_info(f"跳转 URL: {redirect_url}")
        
        return order_no_resp
    else:
        message = response.get("message", "未知错误")
        print_error(f"订单创建失败: {message}")
        return None

def test_query_order(order_no: str) -> bool:
    """测试查询订单状态"""
    print_header("6️⃣  查询订单状态 (/api/payment/query/{orderNo})")
    
    if not order_no:
        print_warning("跳过：无可用的订单号")
        return False
    
    print_info(f"查询订单: {order_no}")
    
    response = make_request("GET", f"/api/payment/query/{order_no}")
    if not response:
        print_error("订单查询失败")
        return False
    
    is_success = response.get("isSuccess", False)
    if is_success:
        status = response.get("status", "N/A")
        transaction_id = response.get("transactionId", "N/A")
        amount = response.get("amount", "N/A")
        
        print_success("查询成功")
        print_info(f"订单号: {response.get('orderNo', 'N/A')}")
        print_info(f"状态: {status}")
        print_info(f"交易 ID: {transaction_id}")
        print_info(f"金额: {amount}")
        
        return True
    else:
        message = response.get("message", "未知错误")
        print_error(f"查询失败: {message}")
        return False

def test_payment_health() -> bool:
    """测试支付服务健康检查"""
    print_header("7️⃣  支付服务健康检查 (/api/payment/health)")
    
    response = make_request("GET", "/api/payment/health")
    if not response:
        print_error("支付服务健康检查失败")
        return False
    
    status = response.get("status", "unknown")
    service = response.get("service", "N/A")
    timestamp = response.get("timestamp", "N/A")
    
    if status == "healthy":
        print_success("支付服务健康")
    else:
        print_warning(f"支付服务状态: {status}")
    
    print_info(f"服务: {service}")
    print_info(f"时间戳: {timestamp}")
    
    return status == "healthy"

def main():
    """主测试流程"""
    print()
    print(f"{Colors.HEADER}{Colors.BOLD}╔════════════════════════════════════════╗{Colors.RESET}")
    print(f"{Colors.HEADER}{Colors.BOLD}║   农行支付网关 API 完整测试套件        ║{Colors.RESET}")
    print(f"{Colors.HEADER}{Colors.BOLD}║   时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}          ║{Colors.RESET}")
    print(f"{Colors.HEADER}{Colors.BOLD}╚════════════════════════════════════════╝{Colors.RESET}")
    
    results = TestResults()
    
    # 基础测试
    results.add("Ping", test_ping())
    results.add("Health", test_health())
    results.add("RootInfo", test_root_info())
    
    # 支付服务健康检查
    results.add("PaymentHealth", test_payment_health())
    
    # 支付订单创建测试
    qrcode_order_no = test_qrcode_payment()
    results.add("QRCodePayment", qrcode_order_no is not None)
    
    ewallet_order_no = test_ewallet_payment()
    results.add("EWalletPayment", ewallet_order_no is not None)
    
    # 订单查询测试
    if qrcode_order_no:
        results.add("QueryOrder", test_query_order(qrcode_order_no))
    else:
        results.add("QueryOrder", False)
    
    # 打印结果汇总
    results.print_summary()
    
    # 故障排查建议
    passed, failed = results.get_summary()
    if failed > 0:
        print_header("⚠️  故障排查建议")
        
        if not results.results.get("Ping", False):
            print_error("Ping 失败:")
            print_info("• 检查网络连接是否正常")
            print_info("• 检查防火墙设置")
            print_info(f"• 确认网关地址是否正确: {GATEWAY_URL}")
        
        if not results.results.get("Health", False):
            print_error("健康检查失败:")
            print_info("• 网关服务可能未启动")
            print_info("• 检查网关日志了解详情")
        
        if not results.results.get("PaymentHealth", False):
            print_error("支付服务健康检查失败:")
            print_info("• 支付服务可能有问题")
            print_info("• 检查支付服务依赖项（数据库、农行 API 等）")
        
        if not results.results.get("QRCodePayment", False) or not results.results.get("EWalletPayment", False):
            print_error("支付订单创建失败:")
            print_info("• 检查请求参数是否正确")
            print_info(f"• 确认商户 ID ({MERCHANT_ID}) 是否有效")
            print_info("• 检查回调 URL 是否可访问")
    else:
        print_header("🎉 所有测试通过！")
        print(f"{Colors.GREEN}网关完全正常，可以进行生产环境集成。{Colors.RESET}")
    
    print()

if __name__ == "__main__":
    main()
