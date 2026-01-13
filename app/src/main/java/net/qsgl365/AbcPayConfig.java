package net.qsgl365;

import android.content.Context;
import android.util.Log;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

/**
 * 农行综合收银台支付配置类
 * 
 * 参考自: TrustMerchant-Demo.properties
 * 用于配置农行线上支付平台的基本信息
 */
public class AbcPayConfig {
    private static final String TAG = "AbcPayConfig";
    
    // ===== 农行支付平台配置 =====
    
    // 生产环境配置
    public static final String TRUST_PAY_CONNECT_METHOD = "https";
    public static final String TRUST_PAY_SERVER_NAME = "pay.abchina.com";
    public static final int TRUST_PAY_SERVER_PORT = 443;
    public static final int TRUST_PAY_NEW_LINE = 2;
    
    // 测试环境配置（可选）
    public static final String TRUST_PAY_CONNECT_METHOD_TEST = "https";
    public static final String TRUST_PAY_SERVER_NAME_TEST = "pay.test.abchina.com";
    public static final int TRUST_PAY_SERVER_PORT_TEST = 443;
    
    // 平台交易接口URL
    public static final String TRUST_PAY_TRX_URL = "/ebus/ReceiveMerchantTrxReqServlet";
    public static final String TRUST_PAY_FILE_TRX_URL = "/ebussettle/ReceiveMerchantFileTrxReqServlet";
    public static final String TRUST_PAY_IE_TRX_URL = "https://pay.abchina.com/ebus/ReceiveMerchantIERequestServlet";
    public static final String MERCHANT_ERROR_URL = "https://pay.abchina.com/ebus/MerchantIEFailure.aspx";
    
    // ===== 商户配置（需要根据实际情况修改） =====
    
    /**
     * 商户编号（由农行提供）
     * 注意：这是示例值，实际使用时必须替换为农行提供的真实商户号
     */
    public static final String MERCHANT_ID = "103881636900016";  // 商户号已配置
    
    /**
     * 商户证书密码（由农行提供）
     * 注意：这是示例值，实际使用时必须替换为真实密码
     */
    public static final String MERCHANT_CERT_PASSWORD = "ay365365";  // 证书密码已配置
    
    // ===== 证书文件配置 =====
    
    /**
     * 农行平台证书文件名（存放在 assets 目录）
     */
    public static final String ABC_CERT_FILE_NAME = "TrustPay.cer";
    
    /**
     * 商户证书文件名（存放在 assets 目录）
     */
    public static final String MERCHANT_CERT_FILE_NAME = "merchant.pfx";
    
    // ===== 其他配置 =====
    
    /**
     * 是否启用日志打印
     */
    public static final boolean PRINT_LOG = true;
    
    /**
     * 超时时间（秒）
     */
    public static final int TIMEOUT = 30;
    
    /**
     * 是否使用测试环境
     */
    public static boolean USE_TEST_ENV = true;  // 默认使用测试环境
    
    // ===== 辅助方法 =====
    
    /**
     * 获取当前使用的服务器地址
     */
    public static String getServerUrl() {
        String method = USE_TEST_ENV ? TRUST_PAY_CONNECT_METHOD_TEST : TRUST_PAY_CONNECT_METHOD;
        String server = USE_TEST_ENV ? TRUST_PAY_SERVER_NAME_TEST : TRUST_PAY_SERVER_NAME;
        int port = USE_TEST_ENV ? TRUST_PAY_SERVER_PORT_TEST : TRUST_PAY_SERVER_PORT;
        return method + "://" + server + ":" + port;
    }
    
    /**
     * 从 assets 复制证书文件到应用内部存储
     * 
     * @param context Android Context
     * @param assetFileName assets中的证书文件名
     * @return 证书文件的绝对路径
     */
    public static String copyCertFromAssets(Context context, String assetFileName) {
        try {
            // 目标文件路径
            File certDir = new File(context.getFilesDir(), "cert");
            if (!certDir.exists()) {
                certDir.mkdirs();
            }
            
            File certFile = new File(certDir, assetFileName);
            
            // 如果文件已存在且不为空，直接返回
            if (certFile.exists() && certFile.length() > 0) {
                Log.d(TAG, "证书文件已存在: " + certFile.getAbsolutePath());
                return certFile.getAbsolutePath();
            }
            
            // 从 assets 复制证书
            InputStream is = context.getAssets().open(assetFileName);
            FileOutputStream fos = new FileOutputStream(certFile);
            
            byte[] buffer = new byte[1024];
            int length;
            while ((length = is.read(buffer)) > 0) {
                fos.write(buffer, 0, length);
            }
            
            fos.flush();
            fos.close();
            is.close();
            
            Log.d(TAG, "证书文件复制成功: " + certFile.getAbsolutePath());
            return certFile.getAbsolutePath();
            
        } catch (Exception e) {
            Log.e(TAG, "复制证书文件失败: " + e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * 获取农行平台证书路径
     */
    public static String getAbcCertPath(Context context) {
        return copyCertFromAssets(context, ABC_CERT_FILE_NAME);
    }
    
    /**
     * 获取商户证书路径
     */
    public static String getMerchantCertPath(Context context) {
        return copyCertFromAssets(context, MERCHANT_CERT_FILE_NAME);
    }
    
    /**
     * 打印当前配置信息（用于调试）
     */
    public static void printConfig() {
        if (!PRINT_LOG) return;
        
        Log.d(TAG, "========== 农行支付配置信息 ==========");
        Log.d(TAG, "环境: " + (USE_TEST_ENV ? "测试环境" : "生产环境"));
        Log.d(TAG, "服务器: " + getServerUrl());
        Log.d(TAG, "商户号: " + MERCHANT_ID);
        Log.d(TAG, "超时时间: " + TIMEOUT + "秒");
        Log.d(TAG, "=====================================");
    }
}
