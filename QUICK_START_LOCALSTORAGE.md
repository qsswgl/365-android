# LocalStorage 与 SQLite 同步 - 快速集成指南

## 🚀 快速开始（5 分钟）

### 第 1 步：在 HTML 中添加初始化脚本（复制粘贴即可）

在你的 `index.html` 的 `<head>` 或 `</body>` 前添加以下代码：

```html
<script>
    // ========== LocalStorage 同步初始化 ==========
    
    /**
     * 从 SQLite 恢复 LocalStorage 数据（非首次启动调用）
     */
    window.restoreLocalStorage = function(dbData) {
        console.log('[LocalStorage] 从数据库恢复数据:', dbData);
        
        // 将数据库中的数据写入 LocalStorage
        for (const key in dbData) {
            if (dbData.hasOwnProperty(key)) {
                localStorage.setItem(key, dbData[key]);
            }
        }
        
        console.log('[LocalStorage] 恢复完成，共 ' + Object.keys(dbData).length + ' 条记录');
        
        // 触发自定义事件，通知应用数据已恢复
        window.dispatchEvent(new CustomEvent('localStorageRestored', { detail: dbData }));
    };
    
    /**
     * 首次启动应用时调用，初始化默认数据
     */
    window.onFirstLaunch = function(launchType) {
        console.log('[LocalStorage] 首次启动应用，启动类型: ' + launchType);
        
        // 初始化应用的默认配置和数据
        const defaultData = {
            'appInitTime': new Date().toISOString(),
            'appVersion': '1.0.0',
            'userPreferences': JSON.stringify({
                'theme': 'light',
                'language': 'zh-CN',
                'notifications': true
            })
        };
        
        for (const key in defaultData) {
            if (defaultData.hasOwnProperty(key)) {
                localStorage.setItem(key, defaultData[key]);
            }
        }
        
        console.log('[LocalStorage] 初始化完成，共 ' + Object.keys(defaultData).length + ' 条记录');
        
        // 触发自定义事件，通知应用已初始化
        window.dispatchEvent(new CustomEvent('firstLaunchCompleted'));
    };
    
    /**
     * 保存 LocalStorage 到 SQLite（页面卸载时调用）
     */
    function saveLocalStorageToDb() {
        try {
            const allData = {};
            for (let i = 0; i < localStorage.length; i++) {
                const key = localStorage.key(i);
                allData[key] = localStorage.getItem(key);
            }
            
            // 检查 AndroidBridge 是否可用
            if (typeof AndroidBridge !== 'undefined' && AndroidBridge.saveAllLocalStorageToDb) {
                AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allData));
                console.log('[LocalStorage] 已保存 ' + Object.keys(allData).length + ' 条记录到 SQLite');
            } else {
                console.warn('[LocalStorage] AndroidBridge 不可用');
            }
        } catch (e) {
            console.error('[LocalStorage] 保存失败:', e.message);
        }
    }
    
    // 页面卸载时保存数据
    window.addEventListener('beforeunload', saveLocalStorageToDb);
    
    // 应用进入后台时也保存数据（可选）
    document.addEventListener('visibilitychange', function() {
        if (document.hidden) {
            console.log('[LocalStorage] 应用进入后台，保存数据');
            saveLocalStorageToDb();
        }
    });
    
    console.log('[LocalStorage] 初始化脚本已加载');
</script>
```

### 第 2 步：处理数据恢复完成后的业务逻辑

```html
<script>
    // 监听 LocalStorage 恢复完成事件
    window.addEventListener('localStorageRestored', function(event) {
        const dbData = event.detail;
        console.log('数据已恢复，共', Object.keys(dbData).length, '条记录');
        
        // 在这里添加你的业务逻辑，例如：
        // 1. 重新加载应用状态
        // 2. 更新 UI 显示
        // 3. 恢复用户在上次使用中的位置
        
        if (window.myApp && window.myApp.restoreState) {
            window.myApp.restoreState(dbData);
        }
    });
    
    // 监听首次启动事件
    window.addEventListener('firstLaunchCompleted', function() {
        console.log('首次启动完成，应用已初始化');
        
        // 在这里添加首次启动的业务逻辑
        if (window.myApp && window.myApp.initialize) {
            window.myApp.initialize();
        }
    });
</script>
```

---

## 📝 常见使用场景

### 场景 1：保存用户输入的表单数据

```javascript
// 用户填写表单
function saveFormData(formData) {
    // 保存到 LocalStorage
    for (const [key, value] of Object.entries(formData)) {
        localStorage.setItem('form_' + key, JSON.stringify(value));
    }
    console.log('表单数据已保存');
}

// 表单提交前保存
document.getElementById('myForm').addEventListener('submit', function(e) {
    const formData = {
        'name': document.getElementById('name').value,
        'email': document.getElementById('email').value,
        'phone': document.getElementById('phone').value
    };
    saveFormData(formData);
});
```

### 场景 2：保存用户偏好设置

```javascript
// 设置用户偏好
function setUserPreferences(prefs) {
    localStorage.setItem('userPreferences', JSON.stringify(prefs));
}

// 获取用户偏好
function getUserPreferences() {
    const prefs = localStorage.getItem('userPreferences');
    return prefs ? JSON.parse(prefs) : {};
}

// 应用主题切换
function switchTheme(theme) {
    const prefs = getUserPreferences();
    prefs.theme = theme;
    setUserPreferences(prefs);
    
    // 应用主题
    document.documentElement.setAttribute('data-theme', theme);
}
```

### 场景 3：保存导航历史

```javascript
// 记录用户访问的页面
function recordPageVisit(pageName) {
    let history = localStorage.getItem('pageHistory');
    history = history ? JSON.parse(history) : [];
    
    history.push({
        'page': pageName,
        'timestamp': new Date().toISOString()
    });
    
    // 只保留最近 50 条记录
    if (history.length > 50) {
        history = history.slice(-50);
    }
    
    localStorage.setItem('pageHistory', JSON.stringify(history));
}

// 页面加载时记录
document.addEventListener('DOMContentLoaded', function() {
    recordPageVisit('index');
});
```

### 场景 4：保存未提交的草稿

```javascript
// 自动保存草稿（每 30 秒）
function autoSaveDraft(content) {
    localStorage.setItem('draft_' + new Date().getDate(), content);
    console.log('草稿已自动保存');
}

// 编辑器内容变化时启动自动保存
const editor = document.getElementById('editor');
let autosaveTimer;

editor.addEventListener('input', function() {
    clearTimeout(autosaveTimer);
    autosaveTimer = setTimeout(function() {
        autoSaveDraft(editor.value);
    }, 30000); // 30 秒后保存
});

// 页面加载时恢复草稿
document.addEventListener('DOMContentLoaded', function() {
    const draft = localStorage.getItem('draft_' + new Date().getDate());
    if (draft && editor) {
        editor.value = draft;
        console.log('草稿已恢复');
    }
});
```

---

## 🔍 调试技巧

### 查看 LocalStorage 中的所有数据

```javascript
// 在浏览器控制台运行
console.table(Object.entries(localStorage).map(([k, v]) => ({key: k, value: v})));
```

### 检查数据库状态

```javascript
// 获取数据库中的记录数
if (typeof AndroidBridge !== 'undefined') {
    const count = AndroidBridge.getDbRecordCount();
    console.log('数据库中的记录数:', count);
}
```

### 手动同步数据到 SQLite

```javascript
// 立即保存到 SQLite（不等待页面卸载）
const allData = {};
for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    allData[key] = localStorage.getItem(key);
}
AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allData));
```

### 从 SQLite 手动读取数据

```javascript
// 读取数据库中的所有数据
const dbData = AndroidBridge.getAllDataFromDb();
console.log('数据库内容:', JSON.parse(dbData));
```

---

## ⚠️ 注意事项

### 1. AndroidBridge 可用性检查

始终检查 AndroidBridge 是否存在：

```javascript
if (typeof AndroidBridge === 'undefined') {
    console.warn('AndroidBridge 不可用，可能在浏览器中运行');
} else {
    // 使用 AndroidBridge
}
```

### 2. 数据大小限制

- **单个 value**：建议不超过 1MB
- **LocalStorage 总大小**：通常 5-10MB（取决于浏览器/WebView）
- **SQLite 数据库**：可以存储数百 MB 的数据

### 3. 特殊字符处理

LocalStorage 会自动处理大多数字符，但以下情况需注意：

```javascript
// ✅ 正确：使用 JSON 序列化存储对象
const obj = { name: '张三', age: 25 };
localStorage.setItem('user', JSON.stringify(obj));

// ❌ 错误：直接存储对象（会转换为 [object Object]）
localStorage.setItem('user', obj);

// ✅ 正确：中文和特殊字符都支持
localStorage.setItem('description', '这是一个测试 😀');
```

### 4. 性能考虑

```javascript
// ❌ 低效：每次存储都立即同步到 SQLite
function inefficientSave(key, value) {
    localStorage.setItem(key, value);
    AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(localStorage));
}

// ✅ 高效：使用防抖，延迟同步
let saveTimer;
function efficientSave(key, value) {
    localStorage.setItem(key, value);
    clearTimeout(saveTimer);
    saveTimer = setTimeout(() => {
        const allData = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            allData[key] = localStorage.getItem(key);
        }
        AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allData));
    }, 1000); // 1 秒后同步
}
```

---

## 🧪 测试清单

- [ ] 首次安装应用，观察 `window.onFirstLaunch` 是否被调用
- [ ] 在 LocalStorage 中添加测试数据
- [ ] 关闭应用，重新打开
- [ ] 验证数据是否被恢复到 LocalStorage
- [ ] 检查 logcat 中是否有错误
- [ ] 升级应用（修改版本号后重装）
- [ ] 验证升级后原有数据是否保留
- [ ] 测试大量数据（100+ 条记录）

---

## 📚 完整文档

详细信息请参考：
- **完整集成指南**：`LOCALSTORAGE_SYNC_GUIDE.md`
- **实现总结**：`LOCALSTORAGE_SYNC_IMPLEMENTATION.md`
- **演示页面**：访问 `localstorage-sync-demo.html`

---

## 💡 最佳实践

1. **始终检查 AndroidBridge 可用性**
   ```javascript
   if (typeof AndroidBridge !== 'undefined') {
       // 使用 Android 功能
   }
   ```

2. **使用 JSON 序列化存储复杂数据**
   ```javascript
   localStorage.setItem('config', JSON.stringify(configObj));
   ```

3. **实现错误处理**
   ```javascript
   try {
       // 执行操作
   } catch (e) {
       console.error('操作失败:', e.message);
   }
   ```

4. **监听关键事件**
   ```javascript
   window.addEventListener('localStorageRestored', handleRestore);
   window.addEventListener('firstLaunchCompleted', handleFirstLaunch);
   ```

5. **定期清理过期数据**
   ```javascript
   function cleanupOldData() {
       const now = new Date().getTime();
       for (let i = localStorage.length - 1; i >= 0; i--) {
           const key = localStorage.key(i);
           const item = localStorage.getItem(key);
           // 检查数据是否过期，如过期则删除
       }
   }
   ```

---

现在可以开始在你的项目中使用这个功能了！🎉
