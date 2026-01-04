# Vue.js 表单数据同步 - 完整集成指南

## 📱 功能概述

完整的 Vue.js + ElementUI 表单组件，可以：

✅ **自动保存表单数据到 LocalStorage**  
✅ **自动同步到 Android SQLite 数据库**  
✅ **应用重启时自动恢复已保存的数据**  
✅ **首次打开应用时使用默认值**  
✅ **升级应用时保留用户数据**

---

## 📦 文件说明

### FormDataSync.vue（完整组件）

这是一个 Vue.js 单文件组件，包含：

- **Template**: ElementUI 表单界面
- **Script**: 完整的数据同步逻辑
- **Style**: 响应式样式设计

### 核心功能

```
表单修改 → 防抖延迟 → 自动保存 LocalStorage → 同步 SQLite
             ↓
         手动保存 → 验证表单 → 保存 LocalStorage → 同步 SQLite
             ↓
         应用启动 → 检查首次 → 恢复数据 → 填充表单
```

---

## 🚀 快速集成（5 分钟）

### 1️⃣ 复制组件文件

将 `FormDataSync.vue` 文件复制到你的 Vue 项目：

```
your-project/
├── src/
│   ├── components/
│   │   └── FormDataSync.vue  ← 放在这里
│   └── ...
```

### 2️⃣ 在 main.js 中注册

```javascript
import Vue from 'vue'
import ElementUI from 'element-ui'
import FormDataSync from '@/components/FormDataSync.vue'

Vue.use(ElementUI)
Vue.component('FormDataSync', FormDataSync)
```

### 3️⃣ 在页面中使用

```vue
<template>
  <div>
    <form-data-sync />
  </div>
</template>

<script>
export default {
  name: 'MyPage'
}
</script>
```

### 4️⃣ 完成！

应用已具备完整的表单数据同步功能。

---

## 🎯 工作流程

### 首次启动应用

```
1. 应用启动
2. FormDataSync 组件 mounted
3. initializeData() 执行
4. 检查 SQLite 记录数（recordCount == 0）
5. 首次启动，使用默认值填充表单
6. 显示提示：「首次启动，使用默认值」
```

### 修改表单数据

```
1. 用户修改表单字段
2. onFormChange() 被触发
3. 设置防抖定时器（1秒）
4. 1秒内无更改时，自动调用 syncToDatabase()
5. 自动保存到 LocalStorage
6. 自动同步到 SQLite
7. 显示提示：「数据已保存」
```

### 点击保存按钮

```
1. 用户点击「保存」按钮
2. submitForm() 验证表单
3. 验证通过，调用 syncToDatabase()
4. 保存到 LocalStorage
5. 同步到 SQLite
6. 显示提示：「数据已保存到数据库」
```

### 再次打开应用

```
1. 应用启动
2. FormDataSync 组件 mounted
3. initializeData() 执行
4. 检查 LocalStorage（找到已保存数据）
5. 恢复保存的数据到表单
6. 显示提示：「数据已恢复」
```

### 应用升级

```
1. 升级应用（adb install -r）
2. 应用启动
3. initializeData() 执行
4. 检查 LocalStorage（找到已保存数据）
5. 恢复保存的数据到表单
6. 原有数据完全保留
```

---

## 📋 表单字段说明

### 用户信息

- **姓名** (name): 必填，2-50 字符
- **邮箱** (email): 可选，格式验证
- **电话** (phone): 可选，中国手机号验证

### 地址信息

- **城市** (city): 可选，选择框
- **详细地址** (address): 可选，最多 500 字符

### 偏好设置

- **接收通知** (notifications): 开关，默认开启
- **主题** (theme): 单选，浅色/深色

### 备注

- **备注** (remarks): 可选，最多 1000 字符

---

## 🔧 核心方法说明

### 初始化

```javascript
initializeData()        // 初始化表单数据
isFirstLaunch()        // 检查是否首次启动
getFormDataFromStorage() // 从 LocalStorage 获取数据
restoreFromDatabase()   // 从 SQLite 恢复数据
```

### 保存和同步

```javascript
onFormChange()         // 表单修改时调用
autoSyncToDatabase()   // 自动同步（防抖）
syncToDatabase()       // 手动同步
submitForm()           // 提交表单
saveFormDataToStorage() // 保存到 LocalStorage
```

### UI 交互

```javascript
showSyncStatus()       // 显示同步状态提示
resetForm()            // 重置表单
showFormData()         // 查看表单数据（调试）
clearData()            // 清空所有数据
```

### 工具方法

```javascript
checkDatabaseStatus()  // 检查数据库状态
getLocalStorageSize()  // 获取 LocalStorage 大小
updateLastSaveTime()   // 更新最后保存时间
logFormData()          // 记录表单数据（调试）
```

---

## 💾 数据存储说明

### LocalStorage

```javascript
// 表单数据存储键名
localStorage['form_data_sync'] = JSON.stringify({
  name: '张三',
  email: 'zhangsan@example.com',
  phone: '13800138000',
  city: 'beijing',
  address: '中国北京市...',
  notifications: true,
  theme: 'light',
  remarks: '备注信息'
})

// 最后保存时间
localStorage['form_data_last_save_time'] = '2026-01-04T10:30:00.000Z'
```

### SQLite

```sql
-- 数据保存位置
/data/data/net.qsgl365/databases/qsgl365_localstorage.db

-- 表结构（由 Android 端管理）
CREATE TABLE localstorage (
  id INTEGER PRIMARY KEY,
  key TEXT UNIQUE,
  value TEXT,
  timestamp LONG
)

-- 表单数据记录
INSERT INTO localstorage(key, value) VALUES(
  'form_data_sync',
  '{"name":"张三","email":"...","phone":"...","...":"..."}'
)
```

---

## 🎨 UI 功能说明

### 同步状态提示

- **成功**（绿色）：`数据已保存`、`数据已恢复`
- **错误**（红色）：`同步失败`、`表单验证失败`
- **警告**（橙色）：`所有数据已清空`
- **信息**（灰色）：`首次启动，使用默认值`

提示会在 3 秒后自动关闭。

### 数据统计卡片

显示四个关键指标：

1. **LocalStorage 大小** - 已用空间（单位 KB）
2. **数据库记录数** - SQLite 中的总记录数
3. **最后保存时间** - 上次保存的时间
4. **同步状态** - 已同步/未同步

### 操作按钮

| 按钮 | 功能 |
|------|------|
| 💾 保存 | 验证表单，保存到 LocalStorage 和 SQLite |
| 🔄 重置 | 重置表单到初始状态 |
| 👁️ 查看数据 | 打开对话框查看当前表单和数据库数据（调试用） |
| 📤 手动同步 | 强制同步 LocalStorage 到 SQLite |
| 🗑️ 清空 | 清空所有表单数据和 LocalStorage |

---

## 🔐 数据保护

### 自动保存时机

1. **表单修改后 1 秒** - 自动调用 `autoSyncToDatabase()`
2. **点击保存按钮** - 立即调用 `syncToDatabase()`
3. **页面卸载前** - `beforeunload` 事件触发
4. **应用进入后台** - `visibilitychange` 事件触发
5. **组件销毁前** - `beforeDestroy` 生命周期

### 防止数据丢失

```javascript
// 页面卸载时
window.addEventListener('beforeunload', () => {
  if (this.hasUnsavedChanges) {
    this.syncToDatabase(); // 立即保存
  }
});

// 应用后台时
document.addEventListener('visibilitychange', () => {
  if (document.hidden && this.hasUnsavedChanges) {
    this.syncToDatabase(); // 立即保存
  }
});
```

---

## 📊 数据流图

```
用户输入
  ↓
onFormChange()
  ↓
设置防抖定时器 (1s)
  ↓
[1秒内有新输入？]
  ├─ 是 → 清除定时器，重新设置
  └─ 否 → 继续执行
  ↓
autoSyncToDatabase()
  ↓
saveFormDataToStorage()
  ├─ ✅ 保存到 LocalStorage
  └─ ❌ 显示错误
  ↓
syncToDatabase()
  ├─ 检查 AndroidBridge
  ├─ 收集 LocalStorage 全部数据
  ├─ 调用 AndroidBridge.saveAllLocalStorageToDb()
  │    ↓
  │ Android SQLite 保存（使用事务）
  └─ 显示同步状态
  ↓
更新 UI 状态
  ├─ isSynced = true
  ├─ lastSaveTime 更新
  └─ syncStatus 提示
```

---

## 🧪 测试场景

### 场景 1：首次打开应用

```
1. 卸载应用：adb uninstall net.qsgl365
2. 重新安装：adb install app-release.apk
3. 打开应用，打开表单页面
4. 预期：
   - 显示提示「首次启动，使用默认值」
   - 表单显示默认数据
   - 数据库记录数：0
```

### 场景 2：修改表单并自动保存

```
1. 打开应用
2. 修改表单字段（例如：名字改为「张三」）
3. 停止输入，等待 1 秒
4. 预期：
   - 显示提示「数据已保存到数据库」
   - LocalStorage 大小增加
   - 数据库记录数增加
```

### 场景 3：手动点击保存

```
1. 打开应用
2. 修改多个表单字段
3. 点击「保存」按钮
4. 预期：
   - 表单验证
   - 显示提示「数据已保存到数据库」
   - 数据持久化
```

### 场景 4：重新打开应用

```
1. 修改表单数据并保存
2. 关闭应用
3. 重新打开应用，打开表单页面
4. 预期：
   - 显示提示「数据已恢复」
   - 表单显示上次保存的数据
   - 数据库记录数保持不变
```

### 场景 5：查看数据（调试）

```
1. 打开表单页面
2. 点击「👁️ 查看数据」按钮
3. 预期：
   - 打开对话框
   - 显示当前表单数据（JSON 格式）
   - 显示 LocalStorage 中的数据
   - 显示最后保存时间
```

### 场景 6：清空数据

```
1. 打开表单页面（表单有数据）
2. 点击「🗑️ 清空」按钮
3. 确认清空
4. 预期：
   - 显示提示「所有数据已清空」
   - 表单清空
   - LocalStorage 中的数据被删除
   - 可以重新输入默认值
```

### 场景 7：应用升级

```
1. 修改表单数据并保存
2. 修改 AndroidManifest.xml 版本号
3. 编译新 APK
4. 升级安装：adb install -r app-release.apk
5. 打开应用，打开表单页面
6. 预期：
   - 显示提示「数据已恢复」
   - 表单显示升级前保存的数据
   - 所有数据完全保留
```

---

## 📱 浏览器环境支持

组件支持在浏览器中运行（用于开发调试）：

```javascript
// 检查 AndroidBridge 是否可用
if (typeof AndroidBridge !== 'undefined') {
  // Android 环境，使用 SQLite 同步
} else {
  // 浏览器环境，仅使用 LocalStorage
  // 功能完全正常，只是不会同步到 SQLite
}
```

---

## 🔍 调试工具

### 查看表单数据

点击「👁️ 查看数据」按钮，查看：
- 当前表单数据
- LocalStorage 中的数据
- 最后保存时间
- 同步状态

### 查看日志

打开浏览器开发者工具（F12），查看 Console：

```javascript
// 所有操作都会输出日志，格式如下：
[10:30:45] [Info] 初始化表单数据
[10:30:45] [Success] ✅ 已从 LocalStorage 恢复数据
[10:30:50] [Info] 表单已修改，将在 1 秒后自动同步
[10:30:51] [Success] ✅ 表单数据已保存到 LocalStorage
[10:30:51] [Success] ✅ 数据已同步到数据库
```

### 手动同步

点击「📤 手动同步」按钮，立即将数据同步到数据库。

### 检查 LocalStorage

在浏览器开发者工具中：
```
Application → LocalStorage → 应用地址
```

查看 `form_data_sync` 键中的数据。

---

## 🛠️ 自定义配置

### 修改存储键名

```javascript
// 在 data() 中修改
STORAGE_KEY: 'form_data_sync',  // ← 改为你的键名
LAST_SAVE_TIME_KEY: 'form_data_last_save_time'
```

### 修改自动保存延迟

```javascript
// 在 data() 中修改
AUTO_SAVE_DELAY: 1000  // 毫秒，默认 1 秒
// 改为 2000 = 2 秒后保存
```

### 修改表单字段

在 `data()` 中的 `formData` 和 `defaultFormData` 中添加新字段：

```javascript
formData: {
  name: '',
  email: '',
  // 添加新字段
  newField: '',
},

defaultFormData: {
  name: '',
  email: '',
  // 添加默认值
  newField: 'default value',
}
```

在 `rules` 中添加验证规则：

```javascript
rules: {
  name: [...],
  email: [...],
  // 添加验证规则
  newField: [
    { required: true, message: '请输入内容', trigger: 'blur' }
  ]
}
```

在 Template 中添加表单项：

```vue
<el-form-item label="新字段" prop="newField">
  <el-input
    v-model="formData.newField"
    placeholder="请输入"
    @change="onFormChange"
  />
</el-form-item>
```

---

## 📚 完整示例

### 在现有 Vue 项目中使用

```vue
<template>
  <div class="page">
    <!-- 其他内容 -->
    
    <!-- 使用表单组件 -->
    <form-data-sync />
  </div>
</template>

<script>
import FormDataSync from '@/components/FormDataSync.vue'

export default {
  name: 'UserPage',
  components: {
    FormDataSync
  }
}
</script>

<style scoped>
.page {
  padding: 20px;
}
</style>
```

### 在路由中使用

```javascript
// router.js
import FormDataSync from '@/components/FormDataSync.vue'

const routes = [
  {
    path: '/user-form',
    component: FormDataSync,
    meta: { title: '用户表单' }
  }
]
```

### 与其他组件交互

```javascript
// 获取表单数据
const formData = this.$refs.formDataSync.formData

// 监听表单数据变化
this.$on('form-data-changed', (data) => {
  console.log('表单数据已变化:', data)
})

// 从外部触发保存
this.$refs.formDataSync.syncToDatabase()
```

---

## 🚀 性能优化

1. **防抖处理** - 修改 1 秒后才自动保存，避免频繁操作
2. **事务处理** - SQLite 使用事务确保数据一致性
3. **异步保存** - 保存操作不阻塞 UI
4. **定期检查** - 每 5 秒检查一次数据库状态（可配置）

---

## ❓ 常见问题

### Q: 表单数据在哪里存储？
A: 两个地方：
1. **LocalStorage** - 用于快速访问和同步
2. **SQLite** - Android 数据库，用于持久化和升级保留

### Q: 如何修改表单字段？
A: 编辑 FormDataSync.vue 中的 `data()` 部分，添加新字段到 `formData`、`defaultFormData`、`rules` 和 Template。

### Q: 首次启动如何判断？
A: 检查 `AndroidBridge.getDbRecordCount()`，如果返回 0 表示首次启动。

### Q: 如何手动清空数据？
A: 点击「🗑️ 清空」按钮，或调用 `clearData()` 方法。

### Q: 支持哪些浏览器？
A: 支持所有现代浏览器和 Android WebView。

### Q: 如何调试？
A: 点击「👁️ 查看数据」按钮，或查看浏览器控制台日志。

---

## ✨ 特色总结

- ✅ 完整的表单管理（8 个字段）
- ✅ 自动保存和同步
- ✅ 数据恢复和升级保留
- ✅ 验证错误提示
- ✅ 同步状态显示
- ✅ 数据统计卡片
- ✅ 调试工具
- ✅ 响应式设计
- ✅ 浏览器和 Android 双环境支持

---

**现在你可以在你的 Vue 项目中使用完整的表单数据同步组件了！** 🎉

祝你开发顺利！💪
