package net.qsgl365;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.webkit.JavascriptInterface;
import androidx.appcompat.app.AppCompatActivity;

/**
 * 农行支付结果回调Activity
 * 
 * 用于接收农行综合收银台的支付结果通知
 * 支付完成后，农行会跳转到这个Activity并携带支付结果参数
 */
public class AbcPayResultActivity extends AppCompatActivity {
    private static final String TAG = "AbcPayResult";
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        Log.d(TAG, "========== 接收农行支付结果 ==========");
        
        // 获取支付结果数据
        Intent intent = getIntent();
        if (intent != null) {
            Bundle extras = intent.getExtras();
            if (extras != null) {
                // 打印所有返回参数
                for (String key : extras.keySet()) {
                    Object value = extras.get(key);
                    Log.d(TAG, "参数: " + key + " = " + value);
                }
                
                // 获取常见的支付结果参数
                String returnCode = intent.getStringExtra("ReturnCode");
                String errorMessage = intent.getStringExtra("ErrorMessage");
                String orderNo = intent.getStringExtra("OrderNo");
                String trxId = intent.getStringExtra("TrxId");
                String amount = intent.getStringExtra("OrderAmount");
                
                Log.d(TAG, "返回码: " + returnCode);
                Log.d(TAG, "错误信息: " + errorMessage);
                Log.d(TAG, "订单号: " + orderNo);
                Log.d(TAG, "交易流水号: " + trxId);
                Log.d(TAG, "订单金额: " + amount);
                
                // 构建结果JSON
                String resultJson = buildResultJson(returnCode, errorMessage, orderNo, trxId, amount);
                
                // 将支付结果传递回WebView
                notifyWebView(resultJson);
            } else {
                Log.w(TAG, "未接收到支付结果参数");
            }
        }
        
        Log.d(TAG, "=====================================");
        
        // 返回主Activity
        finish();
    }
    
    /**
     * 构建支付结果JSON
     */
    private String buildResultJson(String returnCode, String errorMessage, 
                                   String orderNo, String trxId, String amount) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"returnCode\":\"").append(returnCode != null ? returnCode : "").append("\",");
        json.append("\"errorMessage\":\"").append(errorMessage != null ? errorMessage : "").append("\",");
        json.append("\"orderNo\":\"").append(orderNo != null ? orderNo : "").append("\",");
        json.append("\"trxId\":\"").append(trxId != null ? trxId : "").append("\",");
        json.append("\"amount\":\"").append(amount != null ? amount : "").append("\"");
        json.append("}");
        return json.toString();
    }
    
    /**
     * 通知WebView支付结果
     */
    private void notifyWebView(String resultJson) {
        try {
            // 通过Intent传递结果回MainActivity
            Intent resultIntent = new Intent();
            resultIntent.putExtra("paymentResult", resultJson);
            setResult(RESULT_OK, resultIntent);
            
            Log.d(TAG, "支付结果已设置，JSON: " + resultJson);
            
        } catch (Exception e) {
            Log.e(TAG, "通知WebView失败: " + e.getMessage(), e);
        }
    }
}
