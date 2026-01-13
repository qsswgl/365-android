package net.qsgl365;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import android.util.Log;
import org.json.JSONObject;
import org.json.JSONArray;
import java.util.HashMap;
import java.util.Map;
import android.content.ContentValues;
import android.database.Cursor;

/**
 * LocalStorage 与 SQLite 同步管理器
 * 
 * 功能：
 * 1. 首次启动：将 SQLite 数据写入 WebView LocalStorage
 * 2. 非首次启动：将 WebView LocalStorage 数据写入 SQLite
 * 3. 升级保留：升级后保留原有 SQLite 数据
 */
public class LocalStorageSyncManager extends SQLiteOpenHelper {
    
    private static final String DATABASE_NAME = "qsgl365_localstorage.db";
    private static final int DATABASE_VERSION = 1;
    private static final String TABLE_NAME = "localstorage";
    private static final String COLUMN_KEY = "key";
    private static final String COLUMN_VALUE = "value";
    private static final String COLUMN_TIMESTAMP = "timestamp";
    
    private Context context;
    
    public LocalStorageSyncManager(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context;
        Log.d("LocalStorageSync", "LocalStorageSyncManager 初始化");
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        // 创建数据表
        String createTableSQL = "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                COLUMN_KEY + " TEXT UNIQUE NOT NULL," +
                COLUMN_VALUE + " TEXT," +
                COLUMN_TIMESTAMP + " LONG" +
                ");";
        db.execSQL(createTableSQL);
        Log.d("LocalStorageSync", "数据表已创建: " + TABLE_NAME);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // 升级时保留原有数据，不删除表
        Log.d("LocalStorageSync", "数据库升级: " + oldVersion + " -> " + newVersion);
        Log.d("LocalStorageSync", "原有数据已保留");
    }
    
    /**
     * 保存单个键值对到数据库
     */
    public void saveKeyValue(String key, String value) {
        try {
            SQLiteDatabase db = this.getWritableDatabase();
            ContentValues values = new ContentValues();
            values.put(COLUMN_KEY, key);
            values.put(COLUMN_VALUE, value);
            values.put(COLUMN_TIMESTAMP, System.currentTimeMillis());
            
            // INSERT OR REPLACE 用于覆盖已存在的键
            db.insertWithOnConflict(TABLE_NAME, null, values, SQLiteDatabase.CONFLICT_REPLACE);
            Log.d("LocalStorageSync", "保存键值: " + key + " = " + value.substring(0, Math.min(50, value.length())) + "...");
        } catch (Exception e) {
            Log.e("LocalStorageSync", "保存键值失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 从数据库获取单个值
     */
    public String getValue(String key) {
        try {
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.query(TABLE_NAME, new String[]{COLUMN_VALUE}, 
                    COLUMN_KEY + "=?", new String[]{key}, null, null, null);
            
            if (cursor != null && cursor.moveToFirst()) {
                String value = cursor.getString(0);
                cursor.close();
                Log.d("LocalStorageSync", "读取键值: " + key);
                return value;
            }
            if (cursor != null) {
                cursor.close();
            }
        } catch (Exception e) {
            Log.e("LocalStorageSync", "读取键值失败: " + e.getMessage(), e);
        }
        return null;
    }
    
    /**
     * 从数据库读取所有键值对，返回 JSON 字符串
     * 格式: {"key1": "value1", "key2": "value2", ...}
     */
    public String getAllDataAsJson() {
        try {
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.query(TABLE_NAME, new String[]{COLUMN_KEY, COLUMN_VALUE}, 
                    null, null, null, null, null);
            
            JSONObject jsonObject = new JSONObject();
            if (cursor != null) {
                while (cursor.moveToNext()) {
                    String key = cursor.getString(0);
                    String value = cursor.getString(1);
                    jsonObject.put(key, value);
                }
                cursor.close();
            }
            
            String result = jsonObject.toString();
            Log.d("LocalStorageSync", "读取所有数据，共 " + jsonObject.length() + " 条记录");
            return result;
        } catch (Exception e) {
            Log.e("LocalStorageSync", "读取所有数据失败: " + e.getMessage(), e);
            return "{}";
        }
    }
    
    /**
     * 从 WebView LocalStorage JSON 批量保存到数据库
     * 格式: {"key1": "value1", "key2": "value2", ...}
     */
    public void saveFromLocalStorageJson(String jsonString) {
        try {
            JSONObject jsonObject = new JSONObject(jsonString);
            SQLiteDatabase db = this.getWritableDatabase();
            
            // 使用事务提高性能
            db.beginTransaction();
            try {
                for (String key : getJsonKeys(jsonObject)) {
                    String value = jsonObject.optString(key, "");
                    ContentValues values = new ContentValues();
                    values.put(COLUMN_KEY, key);
                    values.put(COLUMN_VALUE, value);
                    values.put(COLUMN_TIMESTAMP, System.currentTimeMillis());
                    db.insertWithOnConflict(TABLE_NAME, null, values, SQLiteDatabase.CONFLICT_REPLACE);
                }
                db.setTransactionSuccessful();
                Log.d("LocalStorageSync", "批量保存 " + getJsonKeys(jsonObject).size() + " 条记录到数据库");
            } finally {
                db.endTransaction();
            }
        } catch (Exception e) {
            Log.e("LocalStorageSync", "批量保存失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 清空所有数据
     */
    public void clearAll() {
        try {
            SQLiteDatabase db = this.getWritableDatabase();
            db.delete(TABLE_NAME, null, null);
            Log.d("LocalStorageSync", "已清空所有数据");
        } catch (Exception e) {
            Log.e("LocalStorageSync", "清空数据失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 获取数据库中的记录数
     */
    public int getRecordCount() {
        try {
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.rawQuery("SELECT COUNT(*) FROM " + TABLE_NAME, null);
            if (cursor != null && cursor.moveToFirst()) {
                int count = cursor.getInt(0);
                cursor.close();
                return count;
            }
            if (cursor != null) {
                cursor.close();
            }
        } catch (Exception e) {
            Log.e("LocalStorageSync", "获取记录数失败: " + e.getMessage(), e);
        }
        return 0;
    }
    
    /**
     * 删除指定的键
     */
    public void deleteKey(String key) {
        try {
            SQLiteDatabase db = this.getWritableDatabase();
            db.delete(TABLE_NAME, COLUMN_KEY + "=?", new String[]{key});
            Log.d("LocalStorageSync", "已删除键: " + key);
        } catch (Exception e) {
            Log.e("LocalStorageSync", "删除键失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 获取 JSONObject 中所有的 key
     */
    private java.util.List<String> getJsonKeys(JSONObject jsonObject) {
        java.util.List<String> keys = new java.util.ArrayList<>();
        JSONArray names = jsonObject.names();
        if (names != null) {
            for (int i = 0; i < names.length(); i++) {
                keys.add(names.optString(i));
            }
        }
        return keys;
    }
    
    /**
     * 打印数据库中所有数据（调试用）
     */
    public void printAllData() {
        try {
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.query(TABLE_NAME, null, null, null, null, null, null);
            
            Log.d("LocalStorageSync", "========== 数据库内容 ==========");
            if (cursor != null && cursor.moveToFirst()) {
                int count = 0;
                do {
                    String key = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_KEY));
                    String value = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_VALUE));
                    long timestamp = cursor.getLong(cursor.getColumnIndexOrThrow(COLUMN_TIMESTAMP));
                    Log.d("LocalStorageSync", "记录 " + (++count) + ": " + key + " = " + value.substring(0, Math.min(50, value.length())) + "...");
                } while (cursor.moveToNext());
                cursor.close();
            }
            Log.d("LocalStorageSync", "========== 数据库内容结束 ==========");
        } catch (Exception e) {
            Log.e("LocalStorageSync", "打印数据失败: " + e.getMessage(), e);
        }
    }
}
