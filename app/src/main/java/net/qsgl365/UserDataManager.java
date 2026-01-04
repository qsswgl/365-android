package net.qsgl365;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

/**
 * 用户数据管理器
 * 使用 SharedPreferences 保存用户注册信息
 * 应用升级时，注册信息将被保留，不需要重新注册
 */
public class UserDataManager {
    
    private static final String PREF_NAME = "qsgl365_user_data";
    private static final String PREF_PHONE_NUMBER = "phone_number";
    private static final String PREF_USER_ID = "user_id";
    private static final String PREF_USER_NAME = "user_name";
    private static final String PREF_REGISTRATION_TIME = "registration_time";
    private static final String PREF_USER_INFO = "user_info";
    private static final String PREF_APP_VERSION = "app_version";
    
    private SharedPreferences sharedPreferences;
    private SharedPreferences.Editor editor;
    private Context context;
    
    public UserDataManager(Context context) {
        this.context = context;
        this.sharedPreferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        this.editor = sharedPreferences.edit();
    }
    
    /**
     * 保存手机号（从 SIM 卡读取或用户输入）
     */
    public void savePhoneNumber(String phoneNumber) {
        editor.putString(PREF_PHONE_NUMBER, phoneNumber);
        editor.apply();
        Log.d("UserData", "保存手机号: " + phoneNumber);
    }
    
    /**
     * 获取保存的手机号
     */
    public String getPhoneNumber() {
        String phoneNumber = sharedPreferences.getString(PREF_PHONE_NUMBER, "");
        Log.d("UserData", "读取手机号: " + phoneNumber);
        return phoneNumber;
    }
    
    /**
     * 保存用户 ID
     */
    public void saveUserId(String userId) {
        editor.putString(PREF_USER_ID, userId);
        editor.apply();
        Log.d("UserData", "保存用户 ID: " + userId);
    }
    
    /**
     * 获取保存的用户 ID
     */
    public String getUserId() {
        return sharedPreferences.getString(PREF_USER_ID, "");
    }
    
    /**
     * 保存用户名
     */
    public void saveUserName(String userName) {
        editor.putString(PREF_USER_NAME, userName);
        editor.apply();
        Log.d("UserData", "保存用户名: " + userName);
    }
    
    /**
     * 获取保存的用户名
     */
    public String getUserName() {
        return sharedPreferences.getString(PREF_USER_NAME, "");
    }
    
    /**
     * 保存注册时间
     */
    public void saveRegistrationTime(long time) {
        editor.putLong(PREF_REGISTRATION_TIME, time);
        editor.apply();
        Log.d("UserData", "保存注册时间: " + time);
    }
    
    /**
     * 获取注册时间
     */
    public long getRegistrationTime() {
        return sharedPreferences.getLong(PREF_REGISTRATION_TIME, 0);
    }
    
    /**
     * 保存自定义用户信息（JSON 格式）
     */
    public void saveUserInfo(String userInfoJson) {
        editor.putString(PREF_USER_INFO, userInfoJson);
        editor.apply();
        Log.d("UserData", "保存用户信息: " + userInfoJson);
    }
    
    /**
     * 获取保存的用户信息
     */
    public String getUserInfo() {
        return sharedPreferences.getString(PREF_USER_INFO, "");
    }
    
    /**
     * 检查用户是否已注册
     */
    public boolean isUserRegistered() {
        String phoneNumber = sharedPreferences.getString(PREF_PHONE_NUMBER, "");
        boolean registered = !phoneNumber.isEmpty();
        Log.d("UserData", "用户是否已注册: " + registered);
        return registered;
    }
    
    /**
     * 获取所有用户数据（用于调试）
     */
    public String getAllUserData() {
        StringBuilder sb = new StringBuilder();
        sb.append("手机号: ").append(getPhoneNumber()).append("\n");
        sb.append("用户 ID: ").append(getUserId()).append("\n");
        sb.append("用户名: ").append(getUserName()).append("\n");
        sb.append("注册时间: ").append(getRegistrationTime()).append("\n");
        sb.append("用户信息: ").append(getUserInfo());
        return sb.toString();
    }
    
    /**
     * 清除所有用户数据（仅在用户主动注销时调用）
     */
    public void clearAllUserData() {
        editor.clear();
        editor.apply();
        Log.d("UserData", "已清除所有用户数据");
    }
    
    /**
     * 检查应用是否升级（版本号是否改变）
     * 用于在升级时确保数据被正确迁移
     */
    public boolean hasAppUpgraded() {
        String savedVersion = sharedPreferences.getString(PREF_APP_VERSION, "");
        String currentVersion = getAppVersion();
        
        boolean upgraded = !savedVersion.equals(currentVersion);
        if (upgraded) {
            Log.d("UserData", "应用已升级，从 " + savedVersion + " 升级到 " + currentVersion);
            editor.putString(PREF_APP_VERSION, currentVersion);
            editor.apply();
        }
        return upgraded;
    }
    
    /**
     * 获取当前应用版本号
     */
    private String getAppVersion() {
        try {
            return context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0)
                    .versionName;
        } catch (Exception e) {
            Log.e("UserData", "无法获取应用版本号: " + e.getMessage());
            return "1.0.0";
        }
    }
    
}
