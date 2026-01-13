package net.qsgl365;

import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebChromeClient;
import android.util.Log;
import android.graphics.Bitmap;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceError;
import android.Manifest;
import android.content.pm.PackageManager;
import android.content.Intent;
import android.net.Uri;
import android.telephony.TelephonyManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.view.GestureDetector;
import android.view.MotionEvent;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Set;

// 微信登录相关导入
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;
import com.tencent.mm.opensdk.modelmsg.SendAuth;

public class MainActivity extends AppCompatActivity {
    
    // 微信开放平台信息
    public static final String WECHAT_APP_ID = "wx19d89333ff0d3efe";
    private static final String WECHAT_APP_SECRET = "f4566a825ef87dbb5add80e4a3c887d1";
    
    // 微信API对象
    private static IWXAPI weChatAPI;
    
    // 微信登录回调（静态变量，用于在WXEntryActivity中调用）
    private static MainActivity instance;
    private static String weChatLoginCallback = null;
    
    private UserDataManager userDataManager;
    private LocalStorageSyncManager localStorageSyncManager;  // LocalStorage 与 SQLite 同步管理器
    private WebView webView;  // 添加为成员变量，使其在整个Activity中可访问
    
    // 手势识别相关成员变量
    private GestureDetector gestureDetector;
    private static final int SWIPE_THRESHOLD = 100;  // 滑动距离阈值（像素）
    private static final int SWIPE_VELOCITY_THRESHOLD = 100;  // 滑动速度阈值
    
    // 扫码相关常量
    private static final int BARCODE_SCANNER_REQUEST_CODE = 200;  // 二维码/条形码扫描请求代码
    
    // JavaScript Bridge 类
    public class JSBridge {
        @android.webkit.JavascriptInterface
        public String getPhoneNumber() {
            // 优先使用保存的手机号，如果没有则从 SIM 卡读取
            String savedPhoneNumber = userDataManager.getPhoneNumber();
            if (savedPhoneNumber != null && !savedPhoneNumber.isEmpty()) {
                Log.d("WebView", "使用保存的手机号: " + savedPhoneNumber);
                return savedPhoneNumber;
            }
            return readPhoneNumber();
        }
        
        @android.webkit.JavascriptInterface
        public String getDeviceInfo() {
            return "Device: " + android.os.Build.DEVICE + ", Model: " + android.os.Build.MODEL;
        }
        
        /**
         * 保存用户注册信息（从 JavaScript 调用）
         * 示例: AndroidBridge.saveUserData('手机号', '用户ID', '用户名', '{"字段":"值"}');
         */
        @android.webkit.JavascriptInterface
        public void saveUserData(String phoneNumber, String userId, String userName, String userInfo) {
            Log.d("WebView", "JavaScript 调用 saveUserData");
            userDataManager.savePhoneNumber(phoneNumber);
            userDataManager.saveUserId(userId);
            userDataManager.saveUserName(userName);
            if (userInfo != null && !userInfo.isEmpty()) {
                userDataManager.saveUserInfo(userInfo);
            }
            Log.d("WebView", "用户数据已保存");
        }
        
        /**
         * 获取保存的用户数据（从 JavaScript 调用）
         * 返回 JSON 字符串
         */
        @android.webkit.JavascriptInterface
        public String getSavedUserData() {
            if (userDataManager.isUserRegistered()) {
                String phoneNumber = userDataManager.getPhoneNumber();
                String userId = userDataManager.getUserId();
                String userName = userDataManager.getUserName();
                // 返回 JSON 格式的用户数据
                return "{\"phoneNumber\":\"" + phoneNumber + "\",\"userId\":\"" + userId + "\",\"userName\":\"" + userName + "\"}";
            }
            return "{}";
        }
        
        /**
         * 检查用户是否已注册
         */
        @android.webkit.JavascriptInterface
        public boolean isUserRegistered() {
            return userDataManager.isUserRegistered();
        }
        
        /**
         * 导航功能 - 从JavaScript直接调用
         * 用于处理前端导航请求，确保坐标被正确传递
         * 
         * 使用示例:
         * AndroidBridge.startNavigation('39.9', '116.4', '40.0', '116.5');
         */
        @android.webkit.JavascriptInterface
        public void startNavigation(String startLat, String startLng, String endLat, String endLng) {
            Log.d("WebView", "=== JavaScript 调用导航 ===");
            Log.d("WebView", "起点: " + startLat + ", " + startLng);
            Log.d("WebView", "终点: " + endLat + ", " + endLng);
            
            // 构建标准的 amap:// 格式
            String amapScheme = String.format(
                "amap://navi?start=%s,%s&end=%s,%s&mode=driving&src=net.qsgl365",
                startLat, startLng, endLat, endLng
            );
            
            Log.d("WebView", "生成的Amap链接: " + amapScheme);
            
            // 尝试启动高德地图
            if (tryOpenWithPackageDirectly("com.autonavi.minimap", amapScheme)) {
                Log.d("WebView", "已通过高德地图启动导航");
                return;
            }
            
            // 备选：尝试其他高德地图包名
            if (tryOpenWithPackageDirectly("com.amap.android.ams", amapScheme)) {
                Log.d("WebView", "已通过高德地图(备选)启动导航");
                return;
            }
            
            // 都失败了，显示错误提示
            Log.w("WebView", "无法启动高德地图，显示错误提示");
            showNavigationError();
        }
        
        /**
         * 直接用指定的URL启动导航应用
         */
        @android.webkit.JavascriptInterface
        public void startNavigationByUrl(String url) {
            Log.d("WebView", "JavaScript 调用导航URL: " + url);
            handleAmapNavigation(url);
        }
        
        /**
         * 从前端获取 LocalStorage 中的所有数据，保存到 SQLite 数据库
         * 前端调用: AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(localStorage))
         */
        @android.webkit.JavascriptInterface
        public void saveAllLocalStorageToDb(String localStorageJson) {
            Log.d("WebView", "=== JavaScript 传来 LocalStorage 数据，准备保存到 SQLite ===");
            try {
                localStorageSyncManager.saveFromLocalStorageJson(localStorageJson);
                Log.d("WebView", "LocalStorage 数据已保存到 SQLite");
                localStorageSyncManager.printAllData();  // 调试：打印所有数据
            } catch (Exception e) {
                Log.e("WebView", "保存 LocalStorage 数据失败: " + e.getMessage(), e);
            }
        }
        
        /**
         * 从 SQLite 数据库读取所有数据，返回给前端写入 LocalStorage
         * 前端调用: AndroidBridge.getAllDataFromDb()
         * 返回值: JSON 字符串 {"key1": "value1", "key2": "value2"}
         */
        @android.webkit.JavascriptInterface
        public String getAllDataFromDb() {
            Log.d("WebView", "=== JavaScript 请求从 SQLite 读取所有数据 ===");
            try {
                String jsonData = localStorageSyncManager.getAllDataAsJson();
                Log.d("WebView", "从 SQLite 读取的数据: " + jsonData.substring(0, Math.min(100, jsonData.length())) + "...");
                return jsonData;
            } catch (Exception e) {
                Log.e("WebView", "读取 SQLite 数据失败: " + e.getMessage(), e);
                return "{}";
            }
        }
        
        /**
         * 获取数据库中的记录数（用于判断是否首次启动）
         */
        @android.webkit.JavascriptInterface
        public int getDbRecordCount() {
            int count = localStorageSyncManager.getRecordCount();
            Log.d("WebView", "SQLite 中的记录数: " + count);
            return count;
        }
        
        // ==================== 农行微信支付相关方法 ====================
        
        /**
         * 创建微信支付订单（APP支付）
         * 
         * 前端调用示例:
         * AndroidBridge.createWeChatPay('ORDER123456', '0.01', '测试商品', 'http://yourserver.com/notify', 'wx1234567890');
         * 
         * @param orderNo 订单号
         * @param amount 金额（元，如 "0.01"）
         * @param orderDesc 订单描述
         * @param notifyUrl 支付结果通知URL
         * @param appId 微信APPID
         * @return 农行平台返回的JSON结果字符串
         */
        @android.webkit.JavascriptInterface
        public String createWeChatPay(String orderNo, String amount, String orderDesc, 
                                      String notifyUrl, String appId) {
            Log.d("WebView", "=== JavaScript 调用微信支付（APP） ===");
            Log.d("WebView", "订单号: " + orderNo);
            Log.d("WebView", "金额: " + amount);
            Log.d("WebView", "描述: " + orderDesc);
            
            try {
                AbcWeChatPayManager payManager = new AbcWeChatPayManager(MainActivity.this);
                String result = payManager.createAppPay(orderNo, amount, orderDesc, notifyUrl, appId);
                
                Log.d("WebView", "支付订单创建成功，返回结果: " + result);
                return result;
                
            } catch (Exception e) {
                Log.e("WebView", "创建支付订单失败: " + e.getMessage(), e);
                return "{\"ReturnCode\":\"Error\",\"ErrorMessage\":\"" + e.getMessage() + "\"}";
            }
        }
        
        /**
         * 创建微信支付订单（公众号/小程序支付）
         * 
         * 前端调用示例:
         * AndroidBridge.createWeChatJsApiPay('ORDER123456', '0.01', '测试商品', 'http://yourserver.com/notify', 'oABC_123xyz');
         * 
         * @param orderNo 订单号
         * @param amount 金额
         * @param orderDesc 订单描述
         * @param notifyUrl 通知URL
         * @param openId 用户OpenID
         * @return 农行平台返回的JSON结果
         */
        @android.webkit.JavascriptInterface
        public String createWeChatJsApiPay(String orderNo, String amount, String orderDesc,
                                           String notifyUrl, String openId) {
            Log.d("WebView", "=== JavaScript 调用微信支付（公众号） ===");
            Log.d("WebView", "订单号: " + orderNo);
            Log.d("WebView", "OpenID: " + openId);
            
            try {
                AbcWeChatPayManager payManager = new AbcWeChatPayManager(MainActivity.this);
                String result = payManager.createJsApiPay(orderNo, amount, orderDesc, notifyUrl, openId);
                
                Log.d("WebView", "支付订单创建成功");
                return result;
                
            } catch (Exception e) {
                Log.e("WebView", "创建支付订单失败: " + e.getMessage(), e);
                return "{\"ReturnCode\":\"Error\",\"ErrorMessage\":\"" + e.getMessage() + "\"}";
            }
        }
        
        /**
         * 创建微信扫码支付订单
         * 
         * 前端调用示例:
         * AndroidBridge.createWeChatNativePay('ORDER123456', '0.01', '测试商品', 'http://yourserver.com/notify');
         * 
         * @param orderNo 订单号
         * @param amount 金额
         * @param orderDesc 订单描述
         * @param notifyUrl 通知URL
         * @return 农行平台返回的JSON结果（包含二维码链接）
         */
        @android.webkit.JavascriptInterface
        public String createWeChatNativePay(String orderNo, String amount, String orderDesc,
                                            String notifyUrl) {
            Log.d("WebView", "=== JavaScript 调用微信支付（扫码） ===");
            Log.d("WebView", "订单号: " + orderNo);
            
            try {
                AbcWeChatPayManager payManager = new AbcWeChatPayManager(MainActivity.this);
                String result = payManager.createNativePay(orderNo, amount, orderDesc, notifyUrl);
                
                Log.d("WebView", "扫码支付订单创建成功");
                return result;
                
            } catch (Exception e) {
                Log.e("WebView", "创建扫码支付订单失败: " + e.getMessage(), e);
                return "{\"ReturnCode\":\"Error\",\"ErrorMessage\":\"" + e.getMessage() + "\"}";
            }
        }
        
        /**
         * 启动二维码/条形码扫描
         * 
         * 前端调用示例:
         * AndroidBridge.startBarcodeScanning();
         * 
         * 扫描完成后，会调用前端的 JavaScript 回调函数：
         * onBarcodeScanned(barcodeValue, barcodeFormat)
         * 
         * 支持的条码格式：
         * - QR_CODE: 二维码
         * - CODE_128: 条形码 Code 128
         * - CODE_39: 条形码 Code 39
         * - CODE_93: 条形码 Code 93
         * - CODABAR: 条形码 CODABAR
         * - DATA_MATRIX: Data Matrix
         * - EAN_13: EAN-13
         * - EAN_8: EAN-8
         * - ITF: ITF
         * - UPC_A: UPC-A
         * - UPC_E: UPC-E
         * - PDF417: PDF-417
         * - AZTEC: Aztec Code
         */
        @android.webkit.JavascriptInterface
        public void startBarcodeScanning() {
            Log.d("WebView", "=== JavaScript 调用启动条码扫描 ===");
            try {
                // 检查权限
                if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.CAMERA)
                        != PackageManager.PERMISSION_GRANTED) {
                    Log.w("WebView", "摄像头权限未授予，正在请求权限");
                    ActivityCompat.requestPermissions(MainActivity.this,
                            new String[]{Manifest.permission.CAMERA},
                            100);
                    // 权限请求后会在 onRequestPermissionsResult 中处理
                    return;
                }

                // 权限已授予，启动扫码 Activity
                Intent intent = new Intent(MainActivity.this, BarcodeScannerActivity.class);
                Log.d("WebView", "启动 BarcodeScannerActivity");
                startActivityForResult(intent, BARCODE_SCANNER_REQUEST_CODE);
                Log.d("WebView", "BarcodeScannerActivity 已启动");
            } catch (Exception e) {
                Log.e("WebView", "启动条码扫描时发生异常: " + e.getMessage(), e);
                e.printStackTrace();
                // 调用 JavaScript 错误回调
                invokeBarcodeScannedCallback(null, "ERROR");
            }
        }
        
        /**
         * 微信登录
         * 
         * 前端调用示例:
         * AndroidBridge.weChatLogin('callbackFunctionName');
         * 
         * 登录完成后，会调用前端指定的回调函数：
         * callbackFunctionName({code: 'wx_code', state: 'wx_state'})  // 成功
         * callbackFunctionName({error: 'CANCEL'})  // 用户取消
         * callbackFunctionName({error: 'DENIED'})  // 用户拒绝
         * callbackFunctionName({error: 'ERROR', message: 'xxx'})  // 其他错误
         * 
         * @param callbackName JavaScript回调函数名称
         */
        @android.webkit.JavascriptInterface
        public void weChatLogin(String callbackName) {
            Log.d("WebView", "=== JavaScript 调用微信登录 ===");
            Log.d("WebView", "回调函数名: " + callbackName);
            
            // 保存回调函数名
            weChatLoginCallback = callbackName;
            
            // 检查微信API是否初始化
            if (weChatAPI == null) {
                Log.e("WebView", "❌ 微信API未初始化，尝试重新初始化");
                initWeChat();
                if (weChatAPI == null) {
                    Log.e("WebView", "❌ 微信API初始化失败");
                    invokeWeChatLoginCallback("{\"error\":\"API_INIT_FAILED\",\"message\":\"微信API初始化失败\"}");
                    return;
                }
            }
            
            // 检查微信是否安装
            if (!weChatAPI.isWXAppInstalled()) {
                Log.e("WebView", "❌ 微信未安装");
                invokeWeChatLoginCallback("{\"error\":\"NOT_INSTALLED\",\"message\":\"未安装微信客户端\"}");
                return;
            }
            
            // 发起微信登录请求
            try {
                SendAuth.Req req = new SendAuth.Req();
                req.scope = "snsapi_userinfo";  // 获取用户信息的权限
                req.state = "wechat_login_" + System.currentTimeMillis();  // 用于验证请求合法性
                
                boolean result = weChatAPI.sendReq(req);
                
                if (result) {
                    Log.d("WebView", "✅ 微信登录请求已发送");
                } else {
                    Log.e("WebView", "❌ 微信登录请求发送失败");
                    invokeWeChatLoginCallback("{\"error\":\"SEND_FAILED\",\"message\":\"发送登录请求失败\"}");
                }
            } catch (Exception e) {
                Log.e("WebView", "❌ 微信登录异常: " + e.getMessage(), e);
                invokeWeChatLoginCallback("{\"error\":\"EXCEPTION\",\"message\":\"" + e.getMessage() + "\"}");
            }
        }
    }
    
    // 读取手机号（兼容多种 Android 版本）
    private String readPhoneNumber() {
        TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        String phoneNumber = "";
        
        try {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                // 方式1：尝试 getLine1Number()
                try {
                    phoneNumber = telephonyManager.getLine1Number();
                    Log.d("WebView", "方式1 getLine1Number: " + phoneNumber);
                } catch (SecurityException se) {
                    // 即使权限检查通过，某些系统（如 Vivo）仍可能抛出 SecurityException
                    Log.w("WebView", "getLine1Number SecurityException (权限检查已通过): " + se.getMessage());
                }
                
                // 方式2：如果为空，尝试读取 SIM 卡信息
                if (phoneNumber == null || phoneNumber.isEmpty()) {
                    try {
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
                            android.telephony.SubscriptionManager subscriptionManager = android.telephony.SubscriptionManager.from(this);
                            java.util.List<android.telephony.SubscriptionInfo> subscriptionInfoList = subscriptionManager.getActiveSubscriptionInfoList();
                            if (subscriptionInfoList != null && subscriptionInfoList.size() > 0) {
                                phoneNumber = subscriptionInfoList.get(0).getNumber();
                                Log.d("WebView", "方式2 SubscriptionInfo: " + phoneNumber);
                            }
                        }
                    } catch (Exception e) {
                        Log.e("WebView", "读取 SubscriptionInfo 失败: " + e.getMessage());
                    }
                }
                
                // 方式3：如果仍为空，返回提示信息（某些系统无法读取）
                if (phoneNumber == null || phoneNumber.isEmpty()) {
                    phoneNumber = "未能获取手机号";
                    Log.w("WebView", "无法读取手机号，可能是系统限制或未插入 SIM 卡");
                }
            } else {
                Log.w("WebView", "未获得 READ_PHONE_STATE 权限");
                phoneNumber = "需要权限";
            }
        } catch (Exception e) {
            // 捕获其他异常
            Log.e("WebView", "获取手机号时发生异常: " + e.getMessage(), e);
            phoneNumber = "读取失败";
        }
        
        return phoneNumber;
    }
    
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Log.d("WebView", "onRequestPermissionsResult - requestCode: " + requestCode);
        
        if (requestCode == 1) {
            Log.d("WebView", "基础权限请求回调");
            for (int i = 0; i < permissions.length; i++) {
                if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                    Log.d("WebView", "已授予权限: " + permissions[i]);
                } else {
                    Log.e("WebView", "权限被拒绝: " + permissions[i]);
                }
            }
        }
        
        if (requestCode == 2) {
            Log.d("WebView", "拨打电话权限回调");
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d("WebView", "已授予 CALL_PHONE 权限，现在可以拨打电话");
            } else {
                Log.e("WebView", "CALL_PHONE 权限被拒绝");
            }
        }
        
        if (requestCode == 3) {
            Log.d("WebView", "READ_PHONE_STATE 权限处理完成");
        }
        
        // 扫码权限请求回调（requestCode = 100）
        if (requestCode == 100) {
            Log.d("WebView", "📸 扫码权限请求回调");
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d("WebView", "✅ 摄像头权限已授予，启动扫码 Activity");
                Intent intent = new Intent(MainActivity.this, BarcodeScannerActivity.class);
                startActivityForResult(intent, BARCODE_SCANNER_REQUEST_CODE);
            } else {
                Log.e("WebView", "❌ 摄像头权限被拒绝，扫码无法进行");
                invokeBarcodeScannedCallback(null, "PERMISSION_DENIED");
            }
        }
    }
    
    /**
     * 处理各个 Activity 的返回结果
     * 包括：二维码/条形码扫描、拍照等
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        
        if (requestCode == BARCODE_SCANNER_REQUEST_CODE) {
            Log.d("WebView", "=== 二维码/条形码扫描结果回调 ===");
            
            if (resultCode == RESULT_OK && data != null) {
                // 获取扫描结果
                String barcodeValue = data.getStringExtra("barcode_value");
                String barcodeFormat = data.getStringExtra("barcode_format");
                String barcodeFormatName = data.getStringExtra("barcode_format_name");
                
                Log.d("WebView", "扫描成功: " + barcodeValue);
                Log.d("WebView", "格式: " + barcodeFormatName + " (" + barcodeFormat + ")");
                
                // 调用 JavaScript 回调函数将扫描结果返回给前端
                invokeBarcodeScannedCallback(barcodeValue, barcodeFormatName);
                
            } else if (resultCode == RESULT_CANCELED) {
                Log.d("WebView", "用户取消了扫描");
                invokeBarcodeScannedCallback(null, "CANCELLED");
                
            } else {
                Log.e("WebView", "扫描失败或发生错误，resultCode: " + resultCode);
                invokeBarcodeScannedCallback(null, "ERROR");
            }
        }
    }
    
    /**
     * 调用 JavaScript 中的回调函数来处理扫描结果
     * 
     * @param barcodeValue 扫描到的条码值（如果为 null 表示取消或失败）
     * @param barcodeFormat 条码格式名称（如 QR_CODE, CODE_128 等）
     */
    private void invokeBarcodeScannedCallback(String barcodeValue, String barcodeFormat) {
        if (webView == null) {
            Log.e("WebView", "WebView 未初始化，无法调用回调函数");
            return;
        }

        try {
            if (barcodeValue == null) {
                // 扫描被取消或出错
                Log.d("WebView", "调用 JavaScript 回调: onBarcodeScanned(null, '" + barcodeFormat + "')");
                final String cancelFormat = barcodeFormat;
                webView.post(() -> {
                    try {
                        webView.evaluateJavascript(
                            "javascript:if(typeof onBarcodeScanned === 'function') { onBarcodeScanned(null, '" + cancelFormat + "'); } else { console.error('[扫码测试] onBarcodeScanned 函数不存在'); }",
                            new android.webkit.ValueCallback<String>() {
                                @Override
                                public void onReceiveValue(String value) {
                                    Log.d("WebView", "JavaScript 回调执行完成，返回值: " + value);
                                }
                            }
                        );
                    } catch (Exception e) {
                        Log.e("WebView", "evaluateJavascript 执行异常: " + e.getMessage(), e);
                    }
                });
            } else {
                // 扫描成功，转义特殊字符
                String escapedValue = barcodeValue
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r");
                Log.d("WebView", "调用 JavaScript 回调: onBarcodeScanned('" + escapedValue + "', '" + barcodeFormat + "')");
                final String value = escapedValue;
                final String format = barcodeFormat;
                webView.post(() -> {
                    try {
                        webView.evaluateJavascript(
                            "javascript:if(typeof onBarcodeScanned === 'function') { onBarcodeScanned('" + value + "', '" + format + "'); } else { console.error('[扫码测试] onBarcodeScanned 函数不存在'); }",
                            new android.webkit.ValueCallback<String>() {
                                @Override
                                public void onReceiveValue(String result) {
                                    Log.d("WebView", "JavaScript 回调执行完成，返回值: " + result);
                                }
                            }
                        );
                    } catch (Exception e) {
                        Log.e("WebView", "evaluateJavascript 执行异常: " + e.getMessage(), e);
                    }
                });
            }
        } catch (Exception e) {
            Log.e("WebView", "调用 JavaScript 回调函数异常: " + e.getMessage(), e);
            e.printStackTrace();
        }
    }
    
    /**
     * 初始化微信API
     */
    private void initWeChat() {
        try {
            weChatAPI = WXAPIFactory.createWXAPI(this, WECHAT_APP_ID, true);
            boolean registered = weChatAPI.registerApp(WECHAT_APP_ID);
            
            if (registered) {
                Log.d("WebView", "✅ 微信API注册成功，APPID: " + WECHAT_APP_ID);
            } else {
                Log.e("WebView", "❌ 微信API注册失败");
            }
        } catch (Exception e) {
            Log.e("WebView", "❌ 微信API初始化异常: " + e.getMessage(), e);
        }
    }
    
    /**
     * 微信登录成功回调（由WXEntryActivity调用）
     */
    public static void onWeChatLoginSuccess(String code, String state) {
        Log.d("WebView", "微信登录成功回调: code=" + code + ", state=" + state);
        
        if (instance != null) {
            String json = String.format("{\"code\":\"%s\",\"state\":\"%s\"}", code, state);
            instance.invokeWeChatLoginCallback(json);
        }
    }
    
    /**
     * 微信登录取消回调（由WXEntryActivity调用）
     */
    public static void onWeChatLoginCancel() {
        Log.d("WebView", "微信登录取消回调");
        
        if (instance != null) {
            instance.invokeWeChatLoginCallback("{\"error\":\"CANCEL\",\"message\":\"用户取消了登录\"}");
        }
    }
    
    /**
     * 微信登录拒绝回调（由WXEntryActivity调用）
     */
    public static void onWeChatLoginDenied() {
        Log.d("WebView", "微信登录拒绝回调");
        
        if (instance != null) {
            instance.invokeWeChatLoginCallback("{\"error\":\"DENIED\",\"message\":\"用户拒绝了授权\"}");
        }
    }
    
    /**
     * 微信登录错误回调（由WXEntryActivity调用）
     */
    public static void onWeChatLoginError(int errCode, String errStr) {
        Log.d("WebView", "微信登录错误回调: errCode=" + errCode + ", errStr=" + errStr);
        
        if (instance != null) {
            String json = String.format("{\"error\":\"ERROR\",\"errCode\":%d,\"message\":\"%s\"}", 
                errCode, errStr != null ? errStr : "未知错误");
            instance.invokeWeChatLoginCallback(json);
        }
    }
    
    /**
     * 调用JavaScript中的微信登录回调函数
     */
    private void invokeWeChatLoginCallback(final String jsonResult) {
        Log.d("WebView", "🔔 准备调用微信登录回调");
        Log.d("WebView", "WebView状态: " + (webView != null ? "已初始化" : "未初始化"));
        Log.d("WebView", "回调函数名: " + weChatLoginCallback);
        Log.d("WebView", "回调数据: " + jsonResult);
        
        if (webView == null) {
            Log.e("WebView", "WebView未初始化，无法调用回调函数");
            return;
        }
        
        if (weChatLoginCallback == null || weChatLoginCallback.isEmpty()) {
            Log.e("WebView", "微信登录回调函数名为空");
            return;
        }
        
        final String callback = weChatLoginCallback;
        weChatLoginCallback = null;  // 清空回调，防止重复调用
        
        webView.post(() -> {
            try {
                String js = String.format("javascript:if(typeof %s === 'function') { %s(%s); } else { console.error('[微信登录] 回调函数不存在: %s'); }",
                    callback, callback, jsonResult, callback);
                
                Log.d("WebView", "调用微信登录回调: " + callback + "(" + jsonResult + ")");
                
                webView.evaluateJavascript(js, value -> {
                    Log.d("WebView", "微信登录回调执行完成");
                });
            } catch (Exception e) {
                Log.e("WebView", "调用微信登录回调异常: " + e.getMessage(), e);
            }
        });
    }
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.d("WebView", "=== APP 启动 ===");
        
        // 保存实例引用（用于微信登录回调）
        instance = this;
        
        // 初始化微信API
        initWeChat();
        
        // 初始化用户数据管理器
        userDataManager = new UserDataManager(this);
        
        // 初始化 LocalStorage 与 SQLite 同步管理器
        localStorageSyncManager = new LocalStorageSyncManager(this);
        Log.d("WebView", "LocalStorageSyncManager 已初始化");
        
        // 检查应用是否升级，输出升级提示
        if (userDataManager.hasAppUpgraded()) {
            Log.d("WebView", "应用已升级，用户数据已保留");
            Log.d("WebView", userDataManager.getAllUserData());
        }
        
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        // 动态请求权限（包括拨打电话）
        String[] permissions = {
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.CAMERA,
                Manifest.permission.CALL_PHONE,
                Manifest.permission.READ_PHONE_STATE
        };
        
        // 检查是否需要请求权限
        boolean needRequestPermissions = false;
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                Log.d("WebView", "需要请求权限: " + permission);
                needRequestPermissions = true;
            } else {
                Log.d("WebView", "已有权限: " + permission);
            }
        }
        
        if (needRequestPermissions) {
            Log.d("WebView", "正在请求权限...");
            ActivityCompat.requestPermissions(this, permissions, 1);
        } else {
            Log.d("WebView", "所有权限都已授予");
        }
        
        webView = findViewById(R.id.webview);  // 使用成员变量而不是局部变量
        Log.d("WebView", "WebView 已初始化");
        
        // 开启 WebView 远程调试（Chrome DevTools）
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
            Log.d("WebView", "WebView 远程调试已开启，可在 Chrome 中访问 chrome://inspect 查看");
        }
        
        // 注入 JavaScript Bridge
        webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");
        
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onConsoleMessage(android.webkit.ConsoleMessage consoleMessage) {
                Log.d("WebViewConsole", consoleMessage.message() + " -- From line "
                        + consoleMessage.lineNumber() + " of "
                        + consoleMessage.sourceId());
                return true;
            }

            @Override
            public void onGeolocationPermissionsShowPrompt(String origin, android.webkit.GeolocationPermissions.Callback callback) {
                callback.invoke(origin, true, false);
            }

            @Override
            public void onPermissionRequest(final android.webkit.PermissionRequest request) {
                runOnUiThread(() -> {
                    request.grant(request.getResources());
                });
            }
        });
        
        webView.setWebViewClient(new WebViewClient() {
            private boolean isPwaMode = true;  // 标记是否处于 PWA 模式
            private String remoteUrl = "https://www.qsgl.net/html/365app/#/";
            private String h5FallbackUrl = "https://www.qsgl.net/html/365app/h5/index.html";
            
            @Override
            public void onPageFinished(WebView view, String url) {
                Log.d("WebView", "页面加载完成: " + url);
                Log.d("WebView", "当前模式: " + (isPwaMode ? "PWA" : "H5"));
                
                // 页面加载完成后，注入用户数据和手机号
                try {
                    // 1. 首先检查是否有保存的用户数据
                    String phoneNumber;
                    if (userDataManager.isUserRegistered()) {
                        phoneNumber = userDataManager.getPhoneNumber();
                        Log.d("WebView", "使用保存的手机号: " + phoneNumber);
                    } else {
                        phoneNumber = readPhoneNumber();
                        Log.d("WebView", "从 SIM 卡读取手机号: " + phoneNumber);
                        // 保存手机号以供升级时使用
                        userDataManager.savePhoneNumber(phoneNumber);
                    }
                    
                    // 2. 注入手机号和用户数据到页面
                    String js = "javascript:window.phoneNumber='" + phoneNumber + "'; " +
                               "if(window.onPhoneNumberReady) window.onPhoneNumberReady('" + phoneNumber + "');";
                    
                    // 3. 如果用户已注册，自动跳过注册流程
                    if (userDataManager.isUserRegistered()) {
                        String userId = userDataManager.getUserId();
                        String userName = userDataManager.getUserName();
                        js += "if(window.onUserDataRestored) window.onUserDataRestored({" +
                              "phoneNumber:'" + phoneNumber + "'," +
                              "userId:'" + userId + "'," +
                              "userName:'" + userName + "'});";
                        Log.d("WebView", "已注册用户数据已注入，用户可跳过注册");
                    }
                    
                    // 4. LocalStorage 与 SQLite 同步逻辑
                    int recordCount = localStorageSyncManager.getRecordCount();
                    Log.d("WebView", "SQLite 中的记录数: " + recordCount);
                    
                    if (recordCount == 0) {
                        // 首次启动：SQLite 为空，将 SQLite 数据写入 LocalStorage
                        Log.d("WebView", "首次启动（SQLite 为空），注入同步脚本");
                        js += "if(window.onFirstLaunch) window.onFirstLaunch('first_launch');";
                    } else {
                        // 非首次启动：从 SQLite 读取数据写入 LocalStorage
                        String dbData = localStorageSyncManager.getAllDataAsJson();
                        Log.d("WebView", "非首次启动（SQLite 有数据），准备恢复 LocalStorage");
                        
                        // 转义 JSON 中的引号，以便在 JavaScript 中使用
                        String escapedJson = dbData.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
                        js += "if(window.restoreLocalStorage) {" +
                              "  var dbData = JSON.parse('" + escapedJson + "');" +
                              "  window.restoreLocalStorage(dbData);" +
                              "} else {" +
                              "  console.warn('restoreLocalStorage 方法未定义');" +
                              "}";
                    }
                    
                    webView.evaluateJavascript(js, null);
                } catch (Exception e) {
                    Log.e("WebView", "在 onPageFinished 中注入数据失败: " + e.getMessage(), e);
                }
                super.onPageFinished(view, url);
            }
            

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                String url = request.getUrl().toString();
                Log.d("WebView", "=== shouldOverrideUrlLoading 被调用 ===");
                Log.d("WebView", "URL 被点击: " + url);
                
                if (url.startsWith("tel:")) {
                    Log.d("WebView", "检测到拨电话链接: " + url);
                    Intent intent = new Intent(Intent.ACTION_CALL);
                    intent.setData(Uri.parse(url));
                    
                    if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
                        Log.d("WebView", "已有 CALL_PHONE 权限，正在启动拨号");
                        try {
                            startActivity(intent);
                            Log.d("WebView", "拨号 Intent 启动成功");
                        } catch (Exception e) {
                            Log.e("WebView", "启动拨号失败: " + e.getMessage());
                        }
                    } else {
                        Log.w("WebView", "缺少 CALL_PHONE 权限，正在请求");
                        ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CALL_PHONE}, 2);
                    }
                    return true;
                }
                
                if (url.startsWith("amap://") || url.startsWith("androidamap://")) {
                    Log.d("WebView", "=== 检测到高德地图链接 ===");
                    Log.d("WebView", "完整URL: " + url);
                    
                    // 解析URL的各个部分，用于诊断
                    Uri uri = Uri.parse(url);
                    Log.d("WebView", "Scheme: " + uri.getScheme());
                    Log.d("WebView", "Host: " + uri.getHost());
                    Log.d("WebView", "Path: " + uri.getPath());
                    Log.d("WebView", "Query: " + uri.getQuery());
                    
                    // 查看所有参数
                    Set<String> paramNames = uri.getQueryParameterNames();
                    Log.d("WebView", "参数个数: " + paramNames.size());
                    for (String paramName : paramNames) {
                        String paramValue = uri.getQueryParameter(paramName);
                        Log.d("WebView", "参数: " + paramName + " = " + paramValue);
                    }
                    
                    handleAmapNavigation(url);
                    return true;
                }
                
                if (!url.startsWith("http://") && !url.startsWith("https://")) {
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(Uri.parse(url));
                    try {
                        startActivity(intent);
                        return true;
                    } catch (Exception e) {
                        Log.e("WebView", "无法打开应用: " + e.getMessage());
                    }
                }
                
                return false;
            }
            
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                Log.d("WebView", "Page started: " + url);
                super.onPageStarted(view, url, favicon);
            }
            
            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                String errorMsg = "";
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    errorMsg = error.getDescription().toString();
                }
                Log.e("WebView", "========== 网络错误详情 ==========");
                Log.e("WebView", "错误描述: " + errorMsg);
                Log.e("WebView", "请求 URL: " + request.getUrl());
                Log.e("WebView", "请求是否为主框架: " + request.isForMainFrame());
                Log.e("WebView", "请求方法: " + request.getMethod());
                Log.e("WebView", "=====================================");
                
                // PWA 模式下，如果加载失败，自动降级为 H5 模式
                if (isPwaMode && request.getUrl().toString().contains("365app")) {
                    Log.w("WebView", "PWA 模式加载失败，正在降级为 H5 模式...");
                    isPwaMode = false;
                    view.loadUrl(h5FallbackUrl);
                    Log.d("WebView", "已切换到 H5 模式，URL: " + h5FallbackUrl);
                }
                
                super.onReceivedError(view, request, error);
            }
            
            @Override
            public void onReceivedHttpError(WebView view, WebResourceRequest request, android.webkit.WebResourceResponse errorResponse) {
                Log.e("WebView", "========== HTTP 错误详情 ==========");
                Log.e("WebView", "HTTP 状态码: " + errorResponse.getStatusCode());
                Log.e("WebView", "错误原因: " + errorResponse.getReasonPhrase());
                Log.e("WebView", "请求 URL: " + request.getUrl());
                Log.e("WebView", "请求是否为主框架: " + request.isForMainFrame());
                Log.e("WebView", "=====================================");
                
                // PWA 模式下，HTTP 错误也触发降级
                if (isPwaMode && errorResponse.getStatusCode() >= 400 && request.getUrl().toString().contains("365app")) {
                    Log.w("WebView", "PWA 模式 HTTP 错误（" + errorResponse.getStatusCode() + "），正在降级为 H5 模式...");
                    isPwaMode = false;
                    view.loadUrl(h5FallbackUrl);
                    Log.d("WebView", "已切换到 H5 模式，URL: " + h5FallbackUrl);
                }
                
                super.onReceivedHttpError(view, request, errorResponse);
            }
        });
        
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setAllowFileAccess(true);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        webSettings.setGeolocationEnabled(true);
        webView.clearCache(true);
        webView.clearHistory();
        
        // 加载远程资源，支持 PWA 模式，若失败则自动降级为 H5 模式
        String remoteUrl = "https://www.qsgl.net/html/365app/#/";
        webView.loadUrl(remoteUrl);
        Log.d("WebView", "=== 开始加载远程 PWA 资源 ===");
        Log.d("WebView", "URL: " + remoteUrl);
        Log.d("WebView", "如果 PWA 模式加载失败，将自动降级为 H5 模式");
        
        // 初始化手势识别器
        initializeGestureDetector();
    }
    
    /**
     * 初始化手势识别器
     * 用于识别左滑手势（从屏幕左侧向右滑动）
     */
    private void initializeGestureDetector() {
        gestureDetector = new GestureDetector(this, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
                try {
                    // 获取滑动距离
                    float diffX = e2.getX() - e1.getX();
                    float diffY = e2.getY() - e1.getY();
                    
                    // 检查是否从左侧开始滑动（e1.getX() < 100 意味着在屏幕左侧）
                    // 检查是否向右滑动（diffX > 0）
                    // 检查滑动距离是否足够（diffX > SWIPE_THRESHOLD）
                    if (Math.abs(diffY) < Math.abs(diffX) &&  // 水平滑动比竖直滑动多
                        diffX > SWIPE_THRESHOLD &&            // 向右滑动足够距离
                        Math.abs(velocityX) > SWIPE_VELOCITY_THRESHOLD &&  // 速度足够快
                        e1.getX() < 100) {                    // 从左侧开始
                        
                        Log.d("WebView", "=== 检测到左滑返回手势 ===");
                        Log.d("WebView", "起始X: " + e1.getX() + ", 结束X: " + e2.getX());
                        Log.d("WebView", "滑动距离: " + diffX + ", 速度: " + velocityX);
                        
                        // 触发 WebView 返回
                        handleSwipeBackGesture();
                        return true;
                    }
                } catch (Exception e) {
                    Log.e("WebView", "手势识别出错: " + e.getMessage());
                }
                return false;
            }
        });
        
        Log.d("WebView", "手势识别器已初始化");
    }
    
    /**
     * 处理左滑返回手势
     * 触发 WebView 返回上一页功能
     */
    private void handleSwipeBackGesture() {
        if (webView != null && webView.canGoBack()) {
            Log.d("WebView", "执行左滑返回操作");
            webView.goBack();
        } else {
            Log.d("WebView", "无法返回（已在首页或WebView为空）");
            // 可选：显示提示信息
            android.widget.Toast.makeText(MainActivity.this, "已是首页，无法继续返回", 
                android.widget.Toast.LENGTH_SHORT).show();
        }
    }
    
    /**
     * 处理触摸事件
     * 将触摸事件传递给手势识别器
     */
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (gestureDetector != null && gestureDetector.onTouchEvent(event)) {
            return true;
        }
        return super.onTouchEvent(event);
    }
    
    /**
     * 处理Activity从后台恢复到前台
     * 用于修复从Amap返回后的白屏问题
     * 重新加载WebView并恢复JavaScript状态
     */
    @Override
    protected void onResume() {
        super.onResume();
        Log.d("WebView", "=== Activity onResume 被调用 ===");
        
        // 检查WebView是否仍然有效
        if (webView != null) {
            // 恢复WebView的JavaScript执行
            webView.onResume();
            
            // 重新注入JavaScript Bridge（防止返回后失效）
            webView.addJavascriptInterface(new JSBridge(), "AndroidBridge");
            Log.d("WebView", "已重新注入JavaScript Bridge");
            
            // 重新加载当前页面状态（不丢失用户数据）
            String reloadScript = "javascript:" +
                    "if(typeof window.pageResumeHandler === 'function') {" +
                    "    window.pageResumeHandler();" +
                    "} else {" +
                    "    console.log('Page已恢复');" +
                    "}";
            
            webView.evaluateJavascript(reloadScript, null);
            Log.d("WebView", "已执行页面恢复脚本");
        }
        
        Log.d("WebView", "Activity已从后台恢复");
    }
    
    /**
     * 处理Activity暂停（进入后台）
     * 用于保存WebView状态
     */
    @Override
    protected void onPause() {
        if (webView != null) {
            webView.onPause();
            Log.d("WebView", "WebView已暂停");
        }
        super.onPause();
        Log.d("WebView", "=== Activity onPause 被调用 ===");
    }
    
    /**
     * 处理高德地图导航链接
     * 支持多种备选方案: Amap应用 -> Google地图 -> 高德网页版 -> 提示用户
     */
    private void handleAmapNavigation(String amapUrl) {
        Log.d("WebView", "处理Amap导航请求");
        
        // 方案1: 尝试使用高德地图应用
        if (tryOpenWithPackage("com.autonavi.minimap", amapUrl)) {
            Log.d("WebView", "已通过Amap应用打开导航");
            return;
        }
        
        // 备选包名
        if (tryOpenWithPackage("com.amap.android.ams", amapUrl)) {
            Log.d("WebView", "已通过Amap(备选)应用打开导航");
            return;
        }
        
        // 方案2: 尝试使用Google地图
        if (tryOpenWithGoogleMaps(amapUrl)) {
            Log.d("WebView", "已通过Google地图打开导航");
            return;
        }
        
        // 方案3: 尝试使用高德地图网页版
        if (tryOpenWithAmapWeb(amapUrl)) {
            Log.d("WebView", "已通过高德地图网页版打开导航");
            return;
        }
        
        // 最后方案: 显示友好的错误提示，建议用户安装高德地图
        showAmapErrorDialog();
    }
    
    /**
     * 尝试使用指定包名的应用打开Amap链接
     * 正确格式化Amap URI Scheme以自动绑定目的地
     */
    private boolean tryOpenWithPackage(String packageName, String amapUrl) {
        try {
            if (isPackageInstalled(packageName)) {
                // 从原URL中提取坐标
                String[] coords = extractCoordinatesFromAmapUrl(amapUrl);
                
                // 构建正确的Amap URI Scheme格式
                String amapScheme;
                if (coords != null && coords.length >= 4) {
                    // 格式: amap://navi?start=起点&destination=终点&mode=mode&sourceApplication=app
                    // 或: amap://navigation?start=起点&destination=终点&mode=driving&src=app
                    amapScheme = String.format(
                        "amap://navi?start=%s,%s&destination=%s,%s&mode=driving&sourceApplication=net.qsgl365",
                        coords[0], coords[1], coords[2], coords[3]
                    );
                    Log.d("WebView", "使用坐标构建Amap Scheme: " + amapScheme);
                } else {
                    // 如果无法提取坐标，使用原始URL
                    amapScheme = amapUrl;
                    Log.w("WebView", "无法提取坐标，使用原始URL");
                }
                
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse(amapScheme));
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                Log.d("WebView", "已启动应用: " + packageName);
                return true;
            }
        } catch (Exception e) {
            Log.w("WebView", "启动应用失败 (" + packageName + "): " + e.getMessage());
        }
        return false;
    }
    
    /**
     * 尝试使用Google地图打开导航
     */
    private boolean tryOpenWithGoogleMaps(String amapUrl) {
        try {
            if (isPackageInstalled("com.google.android.apps.maps")) {
                // 从Amap链接提取坐标
                String[] coords = extractCoordinatesFromAmapUrl(amapUrl);
                if (coords != null && coords.length >= 4) {
                    String googleMapsUrl = String.format(
                        "https://www.google.com/maps/dir/%s,%s/%s,%s",
                        coords[0], coords[1], coords[2], coords[3]
                    );
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(Uri.parse(googleMapsUrl));
                    startActivity(intent);
                    Log.d("WebView", "已启动Google地图");
                    return true;
                }
            }
        } catch (Exception e) {
            Log.w("WebView", "启动Google地图失败: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * 尝试使用高德地图网页版打开导航
     */
    private boolean tryOpenWithAmapWeb(String amapUrl) {
        try {
            String[] coords = extractCoordinatesFromAmapUrl(amapUrl);
            if (coords != null && coords.length >= 4) {
                // 使用高德地图网页版URI Scheme
                String webUrl = String.format(
                    "https://uri.amap.com/navigation?to=%s,%s&mode=driving&src=net.qsgl365",
                    coords[2], coords[3]
                );
                webView.loadUrl(webUrl);
                Log.d("WebView", "已在WebView中打开高德地图网页版");
                return true;
            }
        } catch (Exception e) {
            Log.w("WebView", "打开高德地图网页版失败: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * 显示高德地图未安装的错误对话框
     */
    private void showAmapErrorDialog() {
        String message = "检测到高德地图未安装。请选择:\n\n" +
                        "1. 从Play Store/应用商店安装高德地图\n" +
                        "2. 使用浏览器打开地图网页版\n" +
                        "3. 使用其他导航应用\n\n" +
                        "点击确定关闭此提示";
        
        webView.evaluateJavascript(
            "javascript:alert('" + message + "');",
            null
        );
        Log.w("WebView", "已显示高德地图未安装提示");
    }
    
    /**
     * 检查应用是否已安装
     */
    private boolean isPackageInstalled(String packageName) {
        try {
            getPackageManager().getPackageInfo(packageName, 0);
            Log.d("WebView", "应用已安装: " + packageName);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            Log.d("WebView", "应用未安装: " + packageName);
            return false;
        }
    }
    
    /**
     * 从Amap URL中提取坐标
     * 格式: amap://path?...&startLat=X&startLng=Y&endLat=Z&endLng=W&...
     */
    private String[] extractCoordinatesFromAmapUrl(String amapUrl) {
        try {
            // 使用正则表达式提取坐标
            String[] coords = new String[4];
            
            // 提取起始点坐标
            coords[0] = extractQueryParameter(amapUrl, "startLat");
            coords[1] = extractQueryParameter(amapUrl, "startLng");
            // 提取目标点坐标
            coords[2] = extractQueryParameter(amapUrl, "endLat");
            coords[3] = extractQueryParameter(amapUrl, "endLng");
            
            if (coords[0] != null && coords[1] != null && coords[2] != null && coords[3] != null) {
                Log.d("WebView", String.format("提取坐标成功: (%s,%s) -> (%s,%s)", 
                    coords[0], coords[1], coords[2], coords[3]));
                return coords;
            }
        } catch (Exception e) {
            Log.e("WebView", "提取坐标失败: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * 从URL查询参数中提取值
     */
    private String extractQueryParameter(String url, String paramName) {
        try {
            int index = url.indexOf(paramName + "=");
            if (index != -1) {
                int start = index + paramName.length() + 1;
                int end = url.indexOf("&", start);
                if (end == -1) {
                    end = url.length();
                }
                return url.substring(start, end);
            }
        } catch (Exception e) {
            Log.e("WebView", "提取参数失败: " + paramName);
        }
        return null;
    }
    
    /**
     * 直接用指定的URL启动导航应用（不需要从URL提取坐标）
     * 用于JavaScript直接调用的场景
     */
    private boolean tryOpenWithPackageDirectly(String packageName, String amapUrl) {
        try {
            if (isPackageInstalled(packageName)) {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse(amapUrl));
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                Log.d("WebView", "已启动应用: " + packageName);
                return true;
            }
        } catch (Exception e) {
            Log.w("WebView", "启动应用失败 (" + packageName + "): " + e.getMessage());
        }
        return false;
    }
    
    /**
     * 显示导航错误提示
     */
    private void showNavigationError() {
        String errorMsg = "高德地图未安装，请从应用商店安装\n" +
                         "或尝试其他导航应用";
        
        webView.evaluateJavascript(
            "javascript:alert('" + errorMsg + "');",
            null
        );
        Log.w("WebView", "显示导航错误提示");
    }
    
    /**
     * 处理系统返回按钮
     * 当用户点击返回按钮时，优先让 WebView 返回上一页
     * 如果 WebView 已经是最顶层页面，才会关闭应用
     */
    @Override
    public void onBackPressed() {
        Log.d("WebView", "=== 返回按钮被点击 ===");
        
        // 检查 WebView 是否可以返回上一个页面
        if (webView != null && webView.canGoBack()) {
            Log.d("WebView", "WebView 可以返回，执行返回操作");
            webView.goBack();
            return;
        }
        
        Log.d("WebView", "WebView 无法返回，保持应用打开（不关闭）");
        // 不调用 super.onBackPressed()，这样就不会关闭应用
        // 可选：显示 Toast 提示用户已到最顶层
        android.widget.Toast.makeText(this, "已是首页，无法继续返回", android.widget.Toast.LENGTH_SHORT).show();
    }
}

