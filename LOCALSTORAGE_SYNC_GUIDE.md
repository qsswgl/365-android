# LocalStorage 与 SQLite 同步使用指南

## 概述

Android 应用现已支持 WebView 中 LocalStorage 与 SQLite 数据库的自动同步。功能包括：

1. **首次启动**：SQLite 为空 → 将数据写入 LocalStorage
2. **非首次启动**：SQLite 有数据 → 将 SQLite 数据恢复到 LocalStorage
3. **升级保留**：应用升级后原有 SQLite 数据保留，用户数据不丢失

---

## 架构设计

```
┌─────────────────────────────────────────┐
│         前端 JavaScript                  │
│      (WebView LocalStorage)              │
└─────────────────────────────────────────┘
              ↕ (JavaScript Bridge)
┌─────────────────────────────────────────┐
│  Android MainActivity                    │
│  - LocalStorageSyncManager (SQLite DB)   │
│  - UserDataManager (SharedPreferences)   │
└─────────────────────────────────────────┘
              ↕ (升级检测)
┌─────────────────────────────────────────┐
│  SharedPreferences                       │
│  (记录首次启动状态和版本号)             │
└─────────────────────────────────────────┘
```

---

## 前端集成方式

### 1. 获取数据库中的记录数（判断首次启动）

```javascript
// 获取数据库中的记录数
const recordCount = AndroidBridge.getDbRecordCount();

if (recordCount === 0) {
    console.log('首次启动应用');
    // 首次启动逻辑：从本地初始化数据到 LocalStorage
} else {
    console.log('非首次启动，有' + recordCount + '条记录');
    // 非首次启动逻辑：恢复数据
}
```

### 2. 从 SQLite 读取所有数据到 LocalStorage（非首次启动）

```javascript
// 从 SQLite 数据库读取所有数据
const dbData = AndroidBridge.getAllDataFromDb();
const parsedData = JSON.parse(dbData);

console.log('从数据库恢复的数据:', parsedData);

// 将数据写入 LocalStorage
for (const [key, value] of Object.entries(parsedData)) {
    localStorage.setItem(key, value);
}

console.log('LocalStorage 已恢复');
```

### 3. 将 LocalStorage 保存到 SQLite（应用关闭/页面卸载时）

```javascript
// 获取所有 LocalStorage 数据
const allLocalStorage = {};
for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    allLocalStorage[key] = localStorage.getItem(key);
}

// 保存到 SQLite
AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allLocalStorage));

console.log('LocalStorage 已保存到 SQLite');
```

### 4. 完整的初始化脚本（放在 HTML 中）

```html
<script>
// 在 LocalStorage 恢复完成时调用的方法（由 Android 端调用）
window.restoreLocalStorage = function(dbData) {
    console.log('开始恢复 LocalStorage:', dbData);
    
    // 将数据库数据写入 LocalStorage
    for (const [key, value] of Object.entries(dbData)) {
        localStorage.setItem(key, value);
    }
    
    console.log('LocalStorage 恢复完成，共 ' + Object.keys(dbData).length + ' 条记录');
    
    // 触发应用的数据恢复事件
    if (window.onLocalStorageRestored) {
        window.onLocalStorageRestored(dbData);
    }
};

// 首次启动时调用的方法（由 Android 端调用）
window.onFirstLaunch = function(launchType) {
    console.log('首次启动应用，启动类型:', launchType);
    
    // 首次启动的初始化逻辑
    // 例如：加载默认数据，初始化配置等
    
    if (window.initializeDefaultData) {
        window.initializeDefaultData();
    }
};

// 页面卸载时，将 LocalStorage 保存到 SQLite
window.addEventListener('beforeunload', function() {
    console.log('页面卸载，保存 LocalStorage 到 SQLite');
    
    const allLocalStorage = {};
    for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        allLocalStorage[key] = localStorage.getItem(key);
    }
    
    // 保存到数据库
    AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allLocalStorage));
});

// 或者在应用进入后台时保存
document.addEventListener('visibilitychange', function() {
    if (document.hidden) {
        console.log('应用进入后台，保存 LocalStorage');
        
        const allLocalStorage = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            allLocalStorage[key] = localStorage.getItem(key);
        }
        
        AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allLocalStorage));
    }
});
</script>
```

---

## JavaScript Bridge API 参考

### 获取数据库记录数

```javascript
/**
 * 获取 SQLite 数据库中的记录数
 * @returns {number} 记录数，0 表示数据库为空（首次启动）
 */
const count = AndroidBridge.getDbRecordCount();
```

### 从数据库读取所有数据

```javascript
/**
 * 从 SQLite 数据库读取所有数据
 * @returns {string} JSON 字符串 {"key1": "value1", "key2": "value2"}
 */
const jsonData = AndroidBridge.getAllDataFromDb();
const data = JSON.parse(jsonData);
```

### 保存 LocalStorage 到数据库

```javascript
/**
 * 将 LocalStorage 中的所有数据保存到 SQLite 数据库
 * @param {string} localStorageJson - JSON 字符串 {"key1": "value1"}
 */
const allData = {};
for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    allData[key] = localStorage.getItem(key);
}
AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allData));
```

---

## 数据流程详解

### 场景 1：首次安装应用

```
用户安装并启动应用
    ↓
Android 检查 SQLite 数据库（为空）
    ↓
Android 调用 window.onFirstLaunch('first_launch')
    ↓
前端初始化默认数据，写入 LocalStorage
    ↓
用户使用应用，数据保存在 LocalStorage
    ↓
用户关闭应用或进入后台
    ↓
前端调用 AndroidBridge.saveAllLocalStorageToDb()
    ↓
数据保存到 SQLite
```

### 场景 2：再次打开应用

```
用户打开已安装的应用
    ↓
Android 检查 SQLite 数据库（有数据）
    ↓
Android 从 SQLite 读取数据
    ↓
Android 调用 window.restoreLocalStorage(dbData)
    ↓
前端将数据恢复到 LocalStorage
    ↓
应用恢复到之前的状态
```

### 场景 3：应用升级

```
用户升级应用
    ↓
Android 检测到版本号变化（hasAppUpgraded() == true）
    ↓
原有 SQLite 数据保留（不删除数据库）
    ↓
升级后首次启动应用
    ↓
Android 检查 SQLite（有旧数据）
    ↓
Android 调用 window.restoreLocalStorage(dbData)
    ↓
前端恢复旧数据
    ↓
用户数据完全保留
```

---

## Android 端代码细节

### LocalStorageSyncManager 类

创建于：`app/src/main/java/net/qsgl365/LocalStorageSyncManager.java`

主要功能：
- 创建和管理 SQLite 数据库表 `localstorage`
- 支持 CRUD 操作（增删改查）
- 提供 JSON 导入导出功能
- 自动处理数据库升级

### MainActivity 中的集成

**初始化：**
```java
localStorageSyncManager = new LocalStorageSyncManager(this);
```

**在 onPageFinished 中的逻辑：**
```java
int recordCount = localStorageSyncManager.getRecordCount();

if (recordCount == 0) {
    // 首次启动
    js += "if(window.onFirstLaunch) window.onFirstLaunch('first_launch');";
} else {
    // 非首次启动，恢复数据
    String dbData = localStorageSyncManager.getAllDataAsJson();
    js += "if(window.restoreLocalStorage) {" +
          "  var dbData = JSON.parse('" + escapedJson + "');" +
          "  window.restoreLocalStorage(dbData);" +
          "}";
}
```

---

## 测试建议

### 测试 1：首次启动

1. 卸载应用
2. 重新安装应用
3. 打开应用，观察 logcat 输出
4. 确认 `window.onFirstLaunch` 被调用
5. 在前端初始化一些数据到 LocalStorage

### 测试 2：数据保存

1. 在前端 LocalStorage 中添加测试数据
2. 关闭应用
3. 观察 logcat，确认 `saveAllLocalStorageToDb` 被调用
4. 检查 SQLite 数据库中是否有数据

### 测试 3：数据恢复

1. 重新打开应用
2. 观察 logcat，确认 `restoreLocalStorage` 被调用
3. 前端检查 LocalStorage 中的数据是否被正确恢复

### 测试 4：应用升级

1. 修改 `AndroidManifest.xml` 中的 versionCode 或 versionName
2. 重新编译 APK
3. 使用"升级安装"而不是卸载重装
4. 打开应用，确认原有数据仍然存在

---

## 常见问题

### Q1: 如何查看数据库中的数据？

使用 Android Studio 或 SQLite 工具查看设备文件系统中的数据库：
```
/data/data/net.qsgl365/databases/qsgl365_localstorage.db
```

或在 logcat 中观察日志输出：
```
D/LocalStorageSync: 保存键值: key1 = value1
D/LocalStorageSync: 读取所有数据，共 5 条记录
```

### Q2: LocalStorage 中有大量数据，会影响性能吗？

LocalStorageSyncManager 使用数据库事务批量操作，性能优化：
- 批量插入使用 `INSERT OR REPLACE`
- 读取所有数据只需一次 SELECT 查询
- 建议 LocalStorage 中单个值不超过 1MB

### Q3: 如何清空所有数据？

前端方式：
```javascript
localStorage.clear();
```

后端方式：
```java
localStorageSyncManager.clearAll();
```

### Q4: 升级后如何处理数据库架构变更？

在 `LocalStorageSyncManager.onUpgrade()` 中处理：
```java
@Override
public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    if (oldVersion < 2) {
        // 添加新列
        db.execSQL("ALTER TABLE localstorage ADD COLUMN new_column TEXT;");
    }
}
```

---

## 安全建议

1. **不要在 LocalStorage 中存储敏感信息**（密码、Token 等）
2. **使用 SharedPreferences 存储敏感用户数据**，已有 UserDataManager 类
3. **定期验证数据完整性**，检查 SQLite 中的数据是否被篡改
4. **考虑添加数据加密**，尤其是敏感数据

---

## 性能考虑

- **数据库大小**：SQLite 可以轻松处理 MB 级别的数据
- **同步频率**：建议在应用进入后台时同步，而非实时同步
- **批量操作**：使用事务进行大量数据插入
- **索引**：表已在 `key` 列上创建 UNIQUE 约束（相当于索引）

---

## 版本兼容性

- **Android 最低版本**：API 21 (Android 5.0)
- **SQLite 版本**：Android 内置，无需额外依赖
- **JSON 支持**：使用系统 org.json 库

---

## 升级日志

### v1.0 (当前版本)

✅ 首次实现 LocalStorage ↔ SQLite 双向同步
✅ 支持首次启动和非首次启动自动处理
✅ 应用升级时自动保留原有数据
✅ 提供完整的 JavaScript Bridge API

---

## 下一步计划

- [ ] 添加数据加密选项
- [ ] 支持增量同步（只同步修改的数据）
- [ ] 添加数据版本控制
- [ ] 提供数据备份和恢复功能
