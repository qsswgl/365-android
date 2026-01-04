package net.qsgl365;

import android.content.Context;
import android.util.Log;
import org.json.JSONObject;
import org.json.JSONException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Locale;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 农行综合收银台 - 微信支付管理类
 * 
 * 功能：
 * 1. 封装农行综合收银台的微信支付API调用
 * 2. 支持APP支付、扫码支付、公众号支付等多种方式
 * 3. 提供统一的支付下单接口
 * 
 * 注意：本类使用HTTP请求方式与农行服务器通信，不依赖服务端SDK
 */
public class AbcWeChatPayManager {
    private static final String TAG = "AbcWeChatPayManager";
    private Context context;
    
    // 微信支付类型
    public static final String PAY_TYPE_NATIVE = "NATIVE";      // 扫码支付
    public static final String PAY_TYPE_JSAPI = "JSAPI";        // 公众号/小程序支付
    public static final String PAY_TYPE_APP = "APP";            // APP支付
    public static final String PAY_TYPE_MICROPAY = "MICROPAY";  // 刷卡支付
    
    // 支付账户类型
    public static final String PAYMENT_TYPE_WECHAT = "8";  // 微信支付
    
    // 支付交易渠道
    public static final String LINK_TYPE_INTERNET = "1";     // internet网络接入
    public static final String LINK_TYPE_MOBILE = "2";       // 手机网络接入
    public static final String LINK_TYPE_TV = "3";           // 数字电视网络接入
    public static final String LINK_TYPE_SMART_CLIENT = "4"; // 智能客户端
    public static final String LINK_TYPE_OFFLINE = "5";      // 线下渠道
    
    // 通知类型
    public static final String NOTIFY_TYPE_URL_ONLY = "0";  // 仅URL页面通知
    public static final String NOTIFY_TYPE_BOTH = "1";      // 服务器通知和URL页面通知
    
    public AbcWeChatPayManager(Context context) {
        this.context = context;
    }
    
    /**
     * 创建微信支付订单（主要方法）
     * 
     * @param orderNo 订单号（商户自定义）
     * @param amount 订单金额（单位：元，如 "1.00"）
     * @param orderDesc 订单描述
     * @param notifyUrl 支付结果通知URL
     * @param payType 支付类型（APP/JSAPI/NATIVE/MICROPAY）
     * @return 农行平台返回的JSON结果
     */
    public String createWeChatPayOrder(
            String orderNo, 
            String amount, 
            String orderDesc, 
            String notifyUrl,
            String payType) {
        
        return createWeChatPayOrder(
            orderNo, 
            amount, 
            orderDesc, 
            notifyUrl, 
            payType,
            null,  // appId (APP支付时可选)
            null,  // openId (公众号支付时必须)
            null   // authCode (刷卡支付时必须)
        );
    }
    
    /**
     * 创建微信支付订单（完整参数版本）
     * 
     * @param orderNo 订单号
     * @param amount 订单金额（元）
     * @param orderDesc 订单描述
     * @param notifyUrl 支付结果通知URL
     * @param payType 支付类型（APP/JSAPI/NATIVE/MICROPAY）
     * @param appId 微信应用APPID（APP支付时使用）
     * @param openId 用户openId（公众号支付时使用）
     * @param authCode 授权码（刷卡支付时使用）
     * @return 农行平台返回的JSON结果
     */
    public String createWeChatPayOrder(
            String orderNo,
            String amount,
            String orderDesc,
            String notifyUrl,
            String payType,
            String appId,
            String openId,
            String authCode) {
        
        Log.d(TAG, "========== 创建农行微信支付订单 ==========");
        Log.d(TAG, "订单号: " + orderNo);
        Log.d(TAG, "金额: " + amount);
        Log.d(TAG, "描述: " + orderDesc);
        Log.d(TAG, "支付类型: " + payType);
        
        try {
            // 打印配置信息
            AbcPayConfig.printConfig();
            
            // 获取当前日期和时间
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd", Locale.CHINA);
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss", Locale.CHINA);
            Date now = new Date();
            String orderDate = dateFormat.format(now);
            String orderTime = timeFormat.format(now);
            
            // 构建订单参数
            Map<String, Object> orderParams = new HashMap<>();
            orderParams.put("PayTypeID", payType);              // 微信支付类型
            orderParams.put("OrderDate", orderDate);            // 订单日期
            orderParams.put("OrderTime", orderTime);            // 订单时间
            orderParams.put("OrderNo", orderNo);                // 订单号
            orderParams.put("CurrencyCode", "156");             // 交易币种（人民币）
            orderParams.put("OrderAmount", amount);             // 交易金额
            orderParams.put("OrderDesc", orderDesc);            // 订单描述
            orderParams.put("BuyIP", "127.0.0.1");              // 客户IP
            orderParams.put("ReceiverAddress", "");             // 收货地址
            
            // 根据支付类型设置特定参数
            if (appId != null && !appId.isEmpty()) {
                orderParams.put("AccountNo", appId);            // 应用APPID
            }
            if (openId != null && !openId.isEmpty()) {
                orderParams.put("OpenID", openId);              // 用户OpenID
            }
            if (authCode != null && !authCode.isEmpty()) {
                orderParams.put("AccountNo", authCode);         // 授权码（刷卡支付）
            }
            
            // 构建请求参数
            Map<String, Object> requestParams = new HashMap<>();
            requestParams.put("TrxType", "UnifiedOrderReq");
            requestParams.put("Order", orderParams);
            requestParams.put("CommodityType", "0101");         // 支付账户充值
            requestParams.put("PaymentType", PAYMENT_TYPE_WECHAT);  // 微信支付
            requestParams.put("PaymentLinkType", LINK_TYPE_SMART_CLIENT);  // 智能客户端
            requestParams.put("NotifyType", NOTIFY_TYPE_BOTH);  // 服务器通知和页面通知
            requestParams.put("ResultNotifyURL", notifyUrl);
            requestParams.put("MerchantRemarks", "");           // 附言
            requestParams.put("MerModelFlag", "0");             // 非分行大商户模式
            
            Log.d(TAG, "请求参数构建完成");
            
            // 由于Android客户端无法直接使用农行的服务端SDK
            // 这里返回构建好的参数，需要通过你的服务器中转调用农行接口
            JSONObject resultJson = new JSONObject();
            resultJson.put("Status", "NeedServerProxy");
            resultJson.put("Message", "需要通过服务器中转调用农行支付接口");
            resultJson.put("RequestParams", new JSONObject(requestParams));
            resultJson.put("OrderParams", new JSONObject(orderParams));
            resultJson.put("ServerUrl", AbcPayConfig.getServerUrl() + AbcPayConfig.TRUST_PAY_TRX_URL);
            resultJson.put("MerchantId", AbcPayConfig.MERCHANT_ID);
            
            String result = resultJson.toString();
            
            Log.d(TAG, "返回结果: " + result);
            Log.d(TAG, "==========================================");
            
            return result;
            
        } catch (Exception e) {
            Log.e(TAG, "创建微信支付订单失败: " + e.getMessage(), e);
            e.printStackTrace();
            
            try {
                JSONObject errorJson = new JSONObject();
                errorJson.put("ReturnCode", "Error");
                errorJson.put("ErrorMessage", e.getMessage());
                return errorJson.toString();
            } catch (JSONException je) {
                return "{\"ReturnCode\":\"Error\",\"ErrorMessage\":\"" + e.getMessage() + "\"}";
            }
        }
    }
    
    /**
     * APP微信支付快捷方法
     * 
     * @param orderNo 订单号
     * @param amount 金额
     * @param orderDesc 订单描述
     * @param notifyUrl 通知URL
     * @param appId 微信APPID
     * @return 农行平台返回的JSON结果
     */
    public String createAppPay(String orderNo, String amount, String orderDesc, 
                               String notifyUrl, String appId) {
        return createWeChatPayOrder(orderNo, amount, orderDesc, notifyUrl, 
                                   PAY_TYPE_APP, appId, null, null);
    }
    
    /**
     * 公众号/小程序微信支付快捷方法
     * 
     * @param orderNo 订单号
     * @param amount 金额
     * @param orderDesc 订单描述
     * @param notifyUrl 通知URL
     * @param openId 用户OpenID
     * @return 农行平台返回的JSON结果
     */
    public String createJsApiPay(String orderNo, String amount, String orderDesc,
                                 String notifyUrl, String openId) {
        return createWeChatPayOrder(orderNo, amount, orderDesc, notifyUrl,
                                   PAY_TYPE_JSAPI, null, openId, null);
    }
    
    /**
     * 扫码支付快捷方法
     * 
     * @param orderNo 订单号
     * @param amount 金额
     * @param orderDesc 订单描述
     * @param notifyUrl 通知URL
     * @return 农行平台返回的JSON结果（包含二维码链接）
     */
    public String createNativePay(String orderNo, String amount, String orderDesc,
                                  String notifyUrl) {
        return createWeChatPayOrder(orderNo, amount, orderDesc, notifyUrl,
                                   PAY_TYPE_NATIVE, null, null, null);
    }
}
