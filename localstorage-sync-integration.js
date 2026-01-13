/**
 * LocalStorage 与 SQLite 同步 - 前端集成代码
 * 
 * 使用方法：
 * 1. 复制整个文件内容
 * 2. 粘贴到 index.html 的 <head> 或 </body> 前
 * 3. 根据需要修改 window.onFirstLaunch 和 window.restoreLocalStorage 中的业务逻辑
 */

(function() {
    'use strict';
    
    // ==================== 日志工具 ====================
    const Logger = {
        log: function(message, data) {
            const timestamp = new Date().toLocaleTimeString('zh-CN');
            console.log(`[${timestamp}] [LocalStorage] ${message}`, data || '');
        },
        info: function(message, data) {
            this.log(`ℹ️  ${message}`, data);
        },
        success: function(message, data) {
            this.log(`✅ ${message}`, data);
        },
        error: function(message, data) {
            this.log(`❌ ${message}`, data);
        },
        warn: function(message, data) {
            this.log(`⚠️  ${message}`, data);
        }
    };
    
    // ==================== 核心功能 ====================
    
    /**
     * 从 SQLite 恢复 LocalStorage 数据
     * 由 Android 端调用（非首次启动时）
     */
    window.restoreLocalStorage = function(dbData) {
        Logger.info('从数据库恢复数据');
        
        if (!dbData || typeof dbData !== 'object') {
            Logger.error('接收到的数据无效', dbData);
            return;
        }
        
        try {
            let restoredCount = 0;
            
            // 将数据库中的数据写入 LocalStorage
            for (const key in dbData) {
                if (dbData.hasOwnProperty(key)) {
                    try {
                        localStorage.setItem(key, dbData[key]);
                        restoredCount++;
                    } catch (e) {
                        Logger.warn(`无法恢复键: ${key}`, e.message);
                    }
                }
            }
            
            Logger.success(`恢复完成，共 ${restoredCount} 条记录`);
            
            // 触发自定义事件，通知应用数据已恢复
            const event = new CustomEvent('localStorageRestored', {
                detail: {
                    data: dbData,
                    count: restoredCount,
                    timestamp: new Date().toISOString()
                }
            });
            window.dispatchEvent(event);
            
        } catch (e) {
            Logger.error('恢复失败', e.message);
        }
    };
    
    /**
     * 首次启动应用时调用
     * 由 Android 端调用（SQLite 为空时）
     */
    window.onFirstLaunch = function(launchType) {
        Logger.info(`首次启动应用，类型: ${launchType}`);
        
        try {
            // ==================== 初始化默认数据 ====================
            const defaultData = {
                // 应用信息
                'appInitTime': new Date().toISOString(),
                'appVersion': '1.0.0',
                'installId': generateUniqueId(),
                
                // 用户偏好
                'userPreferences': JSON.stringify({
                    'theme': 'light',
                    'language': 'zh-CN',
                    'fontSize': 'medium',
                    'notifications': true
                }),
                
                // 应用配置
                'appConfig': JSON.stringify({
                    'autoSave': true,
                    'debugMode': false,
                    'offlineMode': false
                })
            };
            
            let initCount = 0;
            
            // 将默认数据写入 LocalStorage
            for (const key in defaultData) {
                if (defaultData.hasOwnProperty(key)) {
                    try {
                        localStorage.setItem(key, defaultData[key]);
                        initCount++;
                        Logger.info(`初始化: ${key}`);
                    } catch (e) {
                        Logger.warn(`初始化失败: ${key}`, e.message);
                    }
                }
            }
            
            Logger.success(`初始化完成，共 ${initCount} 条记录`);
            
            // 触发自定义事件，通知应用已初始化
            const event = new CustomEvent('firstLaunchCompleted', {
                detail: {
                    data: defaultData,
                    count: initCount,
                    timestamp: new Date().toISOString()
                }
            });
            window.dispatchEvent(event);
            
        } catch (e) {
            Logger.error('初始化失败', e.message);
        }
    };
    
    // ==================== 数据保存 ====================
    
    /**
     * 保存 LocalStorage 到 SQLite
     */
    function saveLocalStorageToDb() {
        try {
            // 检查 AndroidBridge 是否可用
            if (typeof AndroidBridge === 'undefined' || !AndroidBridge.saveAllLocalStorageToDb) {
                Logger.warn('AndroidBridge 不可用或不支持 saveAllLocalStorageToDb');
                return;
            }
            
            // 收集所有 LocalStorage 数据
            const allData = {};
            for (let i = 0; i < localStorage.length; i++) {
                const key = localStorage.key(i);
                if (key) {
                    allData[key] = localStorage.getItem(key);
                }
            }
            
            const dataCount = Object.keys(allData).length;
            
            if (dataCount === 0) {
                Logger.info('没有需要保存的数据');
                return;
            }
            
            // 保存到 SQLite
            AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allData));
            Logger.success(`已保存 ${dataCount} 条记录到 SQLite`);
            
            // 触发自定义事件
            const event = new CustomEvent('localStorageSaved', {
                detail: {
                    count: dataCount,
                    timestamp: new Date().toISOString()
                }
            });
            window.dispatchEvent(event);
            
        } catch (e) {
            Logger.error('保存失败', e.message);
        }
    }
    
    // ==================== 事件监听 ====================
    
    /**
     * 页面卸载时保存数据
     */
    window.addEventListener('beforeunload', function() {
        Logger.info('页面即将卸载，保存数据');
        saveLocalStorageToDb();
    });
    
    /**
     * 应用进入后台时保存数据（可选）
     */
    document.addEventListener('visibilitychange', function() {
        if (document.hidden) {
            Logger.info('应用进入后台，保存数据');
            // 防止频繁保存
            if (!window.__saveInProgress) {
                window.__saveInProgress = true;
                setTimeout(function() {
                    saveLocalStorageToDb();
                    window.__saveInProgress = false;
                }, 500);
            }
        } else {
            Logger.info('应用恢复前台');
        }
    });
    
    // ==================== 工具函数 ====================
    
    /**
     * 生成唯一 ID
     */
    function generateUniqueId() {
        return 'id_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }
    
    /**
     * 获取 LocalStorage 中的数据
     */
    window.getLocalStorageData = function(key) {
        try {
            const value = localStorage.getItem(key);
            if (value && (value.startsWith('{') || value.startsWith('['))) {
                return JSON.parse(value);
            }
            return value;
        } catch (e) {
            Logger.warn(`获取数据失败: ${key}`, e.message);
            return null;
        }
    };
    
    /**
     * 设置 LocalStorage 中的数据
     */
    window.setLocalStorageData = function(key, value) {
        try {
            if (typeof value === 'object') {
                value = JSON.stringify(value);
            }
            localStorage.setItem(key, value);
            Logger.info(`设置数据: ${key}`);
            return true;
        } catch (e) {
            Logger.error(`设置数据失败: ${key}`, e.message);
            return false;
        }
    };
    
    /**
     * 删除 LocalStorage 中的数据
     */
    window.deleteLocalStorageData = function(key) {
        try {
            localStorage.removeItem(key);
            Logger.info(`删除数据: ${key}`);
            return true;
        } catch (e) {
            Logger.error(`删除数据失败: ${key}`, e.message);
            return false;
        }
    };
    
    /**
     * 获取数据库状态
     */
    window.checkDbStatus = function() {
        try {
            if (typeof AndroidBridge === 'undefined' || !AndroidBridge.getDbRecordCount) {
                Logger.warn('AndroidBridge 不可用');
                return null;
            }
            
            const count = AndroidBridge.getDbRecordCount();
            Logger.info(`数据库状态: ${count} 条记录`);
            return count;
        } catch (e) {
            Logger.error('检查数据库失败', e.message);
            return null;
        }
    };
    
    /**
     * 从数据库读取所有数据
     */
    window.loadDataFromDb = function() {
        try {
            if (typeof AndroidBridge === 'undefined' || !AndroidBridge.getAllDataFromDb) {
                Logger.warn('AndroidBridge 不可用');
                return null;
            }
            
            const jsonData = AndroidBridge.getAllDataFromDb();
            const data = JSON.parse(jsonData);
            Logger.info(`从数据库读取 ${Object.keys(data).length} 条记录`);
            return data;
        } catch (e) {
            Logger.error('读取数据库失败', e.message);
            return null;
        }
    };
    
    /**
     * 清空所有 LocalStorage 数据
     */
    window.clearAllLocalStorage = function() {
        try {
            const count = localStorage.length;
            localStorage.clear();
            Logger.success(`已清空 ${count} 条 LocalStorage 数据`);
            return true;
        } catch (e) {
            Logger.error('清空失败', e.message);
            return false;
        }
    };
    
    /**
     * 打印所有 LocalStorage 数据（调试用）
     */
    window.printAllLocalStorage = function() {
        const data = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            data[key] = localStorage.getItem(key);
        }
        console.table(data);
        Logger.info(`LocalStorage 中有 ${Object.keys(data).length} 条记录`);
        return data;
    };
    
    // ==================== 初始化 ====================
    
    Logger.info('LocalStorage 同步脚本已加载');
    Logger.info('可用方法: restoreLocalStorage, onFirstLaunch, saveLocalStorageToDb');
    
    // 检查 AndroidBridge 可用性
    if (typeof AndroidBridge === 'undefined') {
        Logger.warn('AndroidBridge 未定义，可能在浏览器中运行');
    } else {
        Logger.success('AndroidBridge 可用');
    }
    
})();

// ==================== 使用示例 ====================

/*

// 1. 监听 LocalStorage 恢复完成
window.addEventListener('localStorageRestored', function(event) {
    console.log('LocalStorage 已恢复，共', event.detail.count, '条记录');
    
    // 在这里添加你的业务逻辑
    // 例如：重新加载页面数据、更新 UI 等
});

// 2. 监听首次启动完成
window.addEventListener('firstLaunchCompleted', function(event) {
    console.log('首次启动完成，已初始化', event.detail.count, '条记录');
    
    // 在这里添加你的业务逻辑
    // 例如：显示欢迎页面、引导用户设置等
});

// 3. 监听数据保存完成
window.addEventListener('localStorageSaved', function(event) {
    console.log('数据已保存，共', event.detail.count, '条记录');
});

// 4. 手动保存数据到 LocalStorage
setLocalStorageData('userName', '张三');
setLocalStorageData('userConfig', { theme: 'dark', language: 'en' });

// 5. 读取数据
const userName = getLocalStorageData('userName');
const userConfig = getLocalStorageData('userConfig');

// 6. 检查数据库状态
const dbCount = checkDbStatus();
console.log('数据库中有', dbCount, '条记录');

// 7. 从数据库读取所有数据
const dbData = loadDataFromDb();
console.log('数据库数据:', dbData);

*/
