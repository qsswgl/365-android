package net.qsgl365.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import net.qsgl365.MainActivity;

/**
 * 微信登录回调Activity
 * 
 * 注意：
 * 1. 此Activity必须放在应用包名+.wxapi包下（即：net.qsgl365.wxapi）
 * 2. 类名必须是WXEntryActivity
 * 3. 必须在AndroidManifest.xml中注册，并设置exported=true
 * 
 * 微信OpenSDK会在用户授权后自动调用此Activity
 */
public class WXEntryActivity extends Activity implements IWXAPIEventHandler {
    
    private static final String TAG = "WXEntryActivity";
    
    // 微信API对象
    private IWXAPI api;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        Log.d(TAG, "WXEntryActivity onCreate");
        
        // 初始化微信API
        api = WXAPIFactory.createWXAPI(this, MainActivity.WECHAT_APP_ID, false);
        
        // 处理微信发送的Intent
        try {
            api.handleIntent(getIntent(), this);
        } catch (Exception e) {
            Log.e(TAG, "处理微信Intent失败: " + e.getMessage(), e);
            finish();
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
    }

    /**
     * 微信发送请求到第三方应用的回调
     */
    @Override
    public void onReq(BaseReq req) {
        Log.d(TAG, "onReq: " + req.getType());
        finish();
    }

    /**
     * 第三方应用发送请求到微信的响应回调
     * 用于接收微信登录授权的结果
     */
    @Override
    public void onResp(BaseResp resp) {
        Log.d(TAG, "onResp: errCode=" + resp.errCode + ", type=" + resp.getType());
        
        switch (resp.errCode) {
            case BaseResp.ErrCode.ERR_OK:
                // 用户同意授权
                if (resp instanceof SendAuth.Resp) {
                    SendAuth.Resp authResp = (SendAuth.Resp) resp;
                    String code = authResp.code;
                    String state = authResp.state;
                    
                    Log.d(TAG, "✅ 微信登录成功，code=" + code + ", state=" + state);
                    
                    // 将code传递给MainActivity
                    MainActivity.onWeChatLoginSuccess(code, state);
                }
                break;
                
            case BaseResp.ErrCode.ERR_USER_CANCEL:
                // 用户取消授权
                Log.d(TAG, "❌ 用户取消了微信登录");
                MainActivity.onWeChatLoginCancel();
                break;
                
            case BaseResp.ErrCode.ERR_AUTH_DENIED:
                // 用户拒绝授权
                Log.d(TAG, "❌ 用户拒绝了微信授权");
                MainActivity.onWeChatLoginDenied();
                break;
                
            default:
                // 其他错误
                Log.e(TAG, "❌ 微信登录失败，errCode=" + resp.errCode + ", errStr=" + resp.errStr);
                MainActivity.onWeChatLoginError(resp.errCode, resp.errStr);
                break;
        }
        
        finish();
    }
}
