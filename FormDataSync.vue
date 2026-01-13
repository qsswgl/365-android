<template>
  <div class="form-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>表单数据管理（自动同步到 SQLite）</span>
      </div>

      <!-- 显示同步状态 -->
      <div v-if="syncStatus.visible" class="sync-status" :class="syncStatus.type">
        <i :class="syncStatus.icon"></i>
        <span>{{ syncStatus.message }}</span>
      </div>

      <!-- 表单 -->
      <el-form
        ref="form"
        :model="formData"
        :rules="rules"
        label-width="120px"
        @submit.native.prevent
      >
        <!-- 用户信息 -->
        <el-form-item label="姓名" prop="name">
          <el-input
            v-model="formData.name"
            placeholder="请输入姓名"
            clearable
            @change="onFormChange"
          />
        </el-form-item>

        <el-form-item label="邮箱" prop="email">
          <el-input
            v-model="formData.email"
            placeholder="请输入邮箱"
            clearable
            @change="onFormChange"
          />
        </el-form-item>

        <el-form-item label="电话" prop="phone">
          <el-input
            v-model="formData.phone"
            placeholder="请输入电话"
            clearable
            @change="onFormChange"
          />
        </el-form-item>

        <!-- 地址信息 -->
        <el-form-item label="城市" prop="city">
          <el-select
            v-model="formData.city"
            placeholder="选择城市"
            clearable
            @change="onFormChange"
          >
            <el-option label="北京" value="beijing" />
            <el-option label="上海" value="shanghai" />
            <el-option label="深圳" value="shenzhen" />
            <el-option label="杭州" value="hangzhou" />
            <el-option label="南京" value="nanjing" />
          </el-select>
        </el-form-item>

        <el-form-item label="详细地址" prop="address">
          <el-input
            v-model="formData.address"
            type="textarea"
            placeholder="请输入详细地址"
            rows="3"
            @change="onFormChange"
          />
        </el-form-item>

        <!-- 偏好设置 -->
        <el-form-item label="接收通知" prop="notifications">
          <el-switch
            v-model="formData.notifications"
            @change="onFormChange"
          />
        </el-form-item>

        <el-form-item label="主题" prop="theme">
          <el-radio-group v-model="formData.theme" @change="onFormChange">
            <el-radio label="light">浅色</el-radio>
            <el-radio label="dark">深色</el-radio>
          </el-radio-group>
        </el-form-item>

        <!-- 备注 -->
        <el-form-item label="备注" prop="remarks">
          <el-input
            v-model="formData.remarks"
            type="textarea"
            placeholder="输入备注信息"
            rows="3"
            @change="onFormChange"
          />
        </el-form-item>

        <!-- 操作按钮 -->
        <el-form-item>
          <el-button
            type="primary"
            @click="submitForm"
            :loading="isSaving"
          >
            💾 保存
          </el-button>
          <el-button @click="resetForm">
            🔄 重置
          </el-button>
          <el-button type="info" @click="showFormData">
            👁️ 查看数据
          </el-button>
          <el-button type="success" @click="syncToDatabase">
            📤 手动同步
          </el-button>
          <el-button type="danger" @click="clearData">
            🗑️ 清空
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 数据统计 -->
      <div class="data-stats">
        <el-row :gutter="20">
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">LocalStorage</div>
              <div class="stat-value">{{ getLocalStorageSize() }} KB</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">数据库记录</div>
              <div class="stat-value">{{ dbRecordCount }}</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">最后保存</div>
              <div class="stat-value">{{ lastSaveTime }}</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">同步状态</div>
              <div class="stat-value">{{ isSynced ? '已同步' : '未同步' }}</div>
            </div>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'FormDataSync',
  data() {
    // 自定义验证器
    const validateEmail = (rule, value, callback) => {
      if (!value) {
        callback();
      } else {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (emailRegex.test(value)) {
          callback();
        } else {
          callback(new Error('请输入有效的邮箱地址'));
        }
      }
    };

    const validatePhone = (rule, value, callback) => {
      if (!value) {
        callback();
      } else {
        const phoneRegex = /^1[3-9]\d{9}$/;
        if (phoneRegex.test(value)) {
          callback();
        } else {
          callback(new Error('请输入有效的手机号码'));
        }
      }
    };

    return {
      // 表单数据
      formData: {
        name: '',
        email: '',
        phone: '',
        city: '',
        address: '',
        notifications: true,
        theme: 'light',
        remarks: ''
      },

      // 默认数据
      defaultFormData: {
        name: '',
        email: '',
        phone: '',
        city: '',
        address: '',
        notifications: true,
        theme: 'light',
        remarks: ''
      },

      // 表单验证规则
      rules: {
        name: [
          { required: true, message: '请输入姓名', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        email: [
          { validator: validateEmail, trigger: 'blur' }
        ],
        phone: [
          { validator: validatePhone, trigger: 'blur' }
        ],
        city: [],
        address: [
          { max: 500, message: '长度不能超过 500 个字符', trigger: 'blur' }
        ],
        remarks: [
          { max: 1000, message: '长度不能超过 1000 个字符', trigger: 'blur' }
        ]
      },

      // UI 状态
      isSaving: false,
      syncStatus: {
        visible: false,
        type: 'success',
        icon: 'el-icon-success',
        message: ''
      },

      // 数据库状态
      dbRecordCount: 0,
      lastSaveTime: '未保存',
      isSynced: false,

      // 防抖和同步控制
      autoSaveTimer: null,
      lastModifyTime: 0,
      AUTO_SAVE_DELAY: 1000, // 1 秒后自动同步
      STORAGE_KEY: 'form_data_sync', // LocalStorage 键名
      LAST_SAVE_TIME_KEY: 'form_data_last_save_time'
    };
  },

  computed: {
    /**
     * 表单是否有未保存的修改
     */
    hasUnsavedChanges() {
      return this.lastModifyTime > 0 && !this.isSynced;
    }
  },

  watch: {
    /**
     * 监听 formData 变化
     */
    formData: {
      deep: true,
      handler() {
        this.onFormChange();
      }
    }
  },

  mounted() {
    this.logger.info('组件已挂载，开始初始化数据');
    this.initializeData();
    this.setupAutoSave();
    this.setupPageUnload();
    this.checkDatabaseStatus();
  },

  beforeDestroy() {
    this.logger.info('组件即将销毁，清理资源');
    this.cleanup();
  },

  methods: {
    /**
     * 初始化数据：从 LocalStorage 恢复或使用默认值
     */
    initializeData() {
      this.logger.info('初始化表单数据');

      try {
        // 1. 检查 LocalStorage 中是否有保存的数据
        const savedData = this.getFormDataFromStorage();

        if (savedData && Object.keys(savedData).length > 0) {
          // 有保存的数据，使用保存的数据
          this.formData = { ...this.defaultFormData, ...savedData };
          this.isSynced = true;
          this.logger.success('已从 LocalStorage 恢复数据');
          this.showSyncStatus('success', '数据已恢复', 'el-icon-success');
        } else {
          // 没有保存的数据，检查是否首次启动
          if (this.isFirstLaunch()) {
            // 首次启动，使用默认值
            this.formData = { ...this.defaultFormData };
            this.logger.info('首次启动，使用默认数据');
            this.showSyncStatus('info', '首次启动，使用默认值', 'el-icon-info');
          } else {
            // 非首次启动但无数据，从数据库恢复
            this.restoreFromDatabase();
          }
        }

        // 标记为已初始化
        this.logFormData('初始化完成');
      } catch (e) {
        this.logger.error('初始化数据失败: ' + e.message);
        this.showSyncStatus('error', '初始化失败', 'el-icon-warning');
      }
    },

    /**
     * 从 LocalStorage 获取表单数据
     */
    getFormDataFromStorage() {
      try {
        const data = localStorage.getItem(this.STORAGE_KEY);
        if (data) {
          const parsed = JSON.parse(data);
          this.logger.info('从 LocalStorage 读取数据成功', parsed);
          return parsed;
        }
      } catch (e) {
        this.logger.error('从 LocalStorage 读取数据失败: ' + e.message);
      }
      return null;
    },

    /**
     * 将表单数据保存到 LocalStorage
     */
    saveFormDataToStorage() {
      try {
        const dataToSave = { ...this.formData };
        localStorage.setItem(this.STORAGE_KEY, JSON.stringify(dataToSave));
        localStorage.setItem(this.LAST_SAVE_TIME_KEY, new Date().toISOString());
        this.logger.success('表单数据已保存到 LocalStorage');
        return true;
      } catch (e) {
        this.logger.error('保存到 LocalStorage 失败: ' + e.message);
        return false;
      }
    },

    /**
     * 检查是否首次启动
     */
    isFirstLaunch() {
      try {
        // 检查 Android 端是否提供了 dbRecordCount
        if (typeof AndroidBridge !== 'undefined' && AndroidBridge.getDbRecordCount) {
          const count = AndroidBridge.getDbRecordCount();
          return count === 0;
        }
        // 浏览器环境中，检查 LocalStorage 中的标记
        return !localStorage.getItem('app_initialized');
      } catch (e) {
        this.logger.warn('检查首次启动失败: ' + e.message);
        return false;
      }
    },

    /**
     * 从 SQLite 数据库恢复数据
     */
    restoreFromDatabase() {
      try {
        if (typeof AndroidBridge !== 'undefined' && AndroidBridge.getAllDataFromDb) {
          const jsonData = AndroidBridge.getAllDataFromDb();
          const dbData = JSON.parse(jsonData);

          // 提取表单相关的数据
          const formDataFromDb = {};
          for (const key of Object.keys(this.defaultFormData)) {
            if (dbData.hasOwnProperty(this.STORAGE_KEY)) {
              try {
                const stored = JSON.parse(dbData[this.STORAGE_KEY]);
                formDataFromDb[key] = stored[key];
              } catch (e) {
                formDataFromDb[key] = dbData[key];
              }
            } else {
              formDataFromDb[key] = dbData[key];
            }
          }

          // 应用恢复的数据
          this.formData = { ...this.defaultFormData, ...formDataFromDb };
          this.logger.success('从数据库恢复数据成功');
          this.showSyncStatus('success', '从数据库恢复数据', 'el-icon-download');
        }
      } catch (e) {
        this.logger.error('从数据库恢复数据失败: ' + e.message);
      }
    },

    /**
     * 表单数据变化处理
     */
    onFormChange() {
      this.lastModifyTime = Date.now();
      this.isSynced = false;

      // 清除之前的自动保存定时器
      if (this.autoSaveTimer) {
        clearTimeout(this.autoSaveTimer);
      }

      // 设置新的自动保存定时器（防抖）
      this.autoSaveTimer = setTimeout(() => {
        this.autoSyncToDatabase();
      }, this.AUTO_SAVE_DELAY);

      this.logger.info('表单已修改，将在 1 秒后自动同步');
    },

    /**
     * 自动同步到数据库（防抖）
     */
    autoSyncToDatabase() {
      if (!this.hasUnsavedChanges) {
        return;
      }

      this.logger.info('执行自动同步');
      this.saveFormDataToStorage();
      this.syncToDatabase();
    },

    /**
     * 手动同步到数据库
     */
    syncToDatabase() {
      try {
        this.logger.info('开始手动同步到数据库');

        // 1. 先保存到 LocalStorage
        if (!this.saveFormDataToStorage()) {
          return;
        }

        // 2. 同步到 SQLite
        if (typeof AndroidBridge !== 'undefined' && AndroidBridge.saveAllLocalStorageToDb) {
          // 收集所有 LocalStorage 数据
          const allData = {};
          for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            allData[key] = localStorage.getItem(key);
          }

          // 保存到 SQLite
          AndroidBridge.saveAllLocalStorageToDb(JSON.stringify(allData));
          this.logger.success('数据已同步到数据库');
          this.showSyncStatus('success', '数据已保存到数据库', 'el-icon-success');
          this.isSynced = true;
          this.updateLastSaveTime();
        } else {
          // 浏览器环境，只保存到 LocalStorage
          this.logger.warn('AndroidBridge 不可用，仅保存到 LocalStorage');
          this.showSyncStatus('info', '仅保存到 LocalStorage', 'el-icon-info');
          this.isSynced = true;
          this.updateLastSaveTime();
        }
      } catch (e) {
        this.logger.error('同步到数据库失败: ' + e.message);
        this.showSyncStatus('error', '同步失败: ' + e.message, 'el-icon-warning');
      }
    },

    /**
     * 提交表单
     */
    submitForm() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.logger.info('表单验证通过，开始保存');
          this.isSaving = true;

          // 模拟保存过程
          setTimeout(() => {
            this.syncToDatabase();
            this.isSaving = false;
          }, 500);
        } else {
          this.logger.error('表单验证失败');
          this.showSyncStatus('error', '表单验证失败', 'el-icon-warning');
          return false;
        }
      });
    },

    /**
     * 重置表单
     */
    resetForm() {
      this.$refs.form.resetFields();
      this.logger.info('表单已重置');
      this.showSyncStatus('info', '表单已重置', 'el-icon-refresh');
    },

    /**
     * 显示表单数据（调试用）
     */
    showFormData() {
      const message = `
当前表单数据:
${JSON.stringify(this.formData, null, 2)}

LocalStorage 数据:
${JSON.stringify(this.getFormDataFromStorage(), null, 2)}

上次保存时间: ${this.lastSaveTime}
同步状态: ${this.isSynced ? '已同步' : '未同步'}
      `;

      this.$alert(message, '表单数据查看', {
        confirmButtonText: '关闭',
        type: 'info',
        center: true,
        dangerouslyUseHTMLString: true,
        customClass: 'form-data-dialog'
      }).catch(() => {});

      this.logFormData('用户查看数据');
    },

    /**
     * 清空表单和数据
     */
    clearData() {
      this.$confirm('确定要清空所有数据吗？此操作无法撤销。', '清空数据', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 清空 LocalStorage
        localStorage.removeItem(this.STORAGE_KEY);
        localStorage.removeItem(this.LAST_SAVE_TIME_KEY);

        // 清空表单
        this.formData = { ...this.defaultFormData };
        this.$refs.form.clearValidate();

        this.logger.success('所有数据已清空');
        this.showSyncStatus('warning', '所有数据已清空', 'el-icon-delete');
        this.isSynced = false;
        this.lastSaveTime = '未保存';
      }).catch(() => {
        this.logger.info('用户取消清空操作');
      });
    },

    /**
     * 显示同步状态提示
     */
    showSyncStatus(type, message, icon) {
      this.syncStatus = {
        visible: true,
        type: type,
        message: message,
        icon: icon
      };

      // 3 秒后自动隐藏
      setTimeout(() => {
        this.syncStatus.visible = false;
      }, 3000);
    },

    /**
     * 更新最后保存时间
     */
    updateLastSaveTime() {
      const now = new Date();
      this.lastSaveTime = now.toLocaleTimeString('zh-CN');
      this.logger.info('最后保存时间已更新: ' + this.lastSaveTime);
    },

    /**
     * 检查数据库状态
     */
    checkDatabaseStatus() {
      try {
        if (typeof AndroidBridge !== 'undefined' && AndroidBridge.getDbRecordCount) {
          this.dbRecordCount = AndroidBridge.getDbRecordCount();
          this.logger.info('数据库状态: ' + this.dbRecordCount + ' 条记录');
        }
      } catch (e) {
        this.logger.warn('检查数据库状态失败: ' + e.message);
      }
    },

    /**
     * 获取 LocalStorage 大小（KB）
     */
    getLocalStorageSize() {
      let total = 0;
      for (let key in localStorage) {
        if (localStorage.hasOwnProperty(key)) {
          total += localStorage[key].length + key.length;
        }
      }
      return (total / 1024).toFixed(2);
    },

    /**
     * 设置页面卸载时保存数据
     */
    setupPageUnload() {
      window.addEventListener('beforeunload', () => {
        if (this.hasUnsavedChanges) {
          this.logger.info('页面卸载，保存未保存的数据');
          this.syncToDatabase();
        }
      });

      // 应用进入后台时保存
      document.addEventListener('visibilitychange', () => {
        if (document.hidden && this.hasUnsavedChanges) {
          this.logger.info('应用进入后台，保存数据');
          this.syncToDatabase();
        }
      });
    },

    /**
     * 设置自动保存
     */
    setupAutoSave() {
      // 定期检查数据库状态
      setInterval(() => {
        this.checkDatabaseStatus();
      }, 5000); // 每 5 秒检查一次
    },

    /**
     * 清理资源
     */
    cleanup() {
      if (this.autoSaveTimer) {
        clearTimeout(this.autoSaveTimer);
      }

      // 销毁时保存数据
      if (this.hasUnsavedChanges) {
        this.syncToDatabase();
      }
    },

    /**
     * 记录表单数据（调试用）
     */
    logFormData(label) {
      this.logger.debug(label + ' - 当前表单数据: ' + JSON.stringify(this.formData));
    }
  },

  // 日志工具
  logger: {
    info(message, data) {
      console.log(`[${new Date().toLocaleTimeString('zh-CN')}] [Info] ${message}`, data || '');
    },
    success(message, data) {
      console.log(`[${new Date().toLocaleTimeString('zh-CN')}] [Success] ✅ ${message}`, data || '');
    },
    error(message, data) {
      console.error(`[${new Date().toLocaleTimeString('zh-CN')}] [Error] ❌ ${message}`, data || '');
    },
    warn(message, data) {
      console.warn(`[${new Date().toLocaleTimeString('zh-CN')}] [Warn] ⚠️ ${message}`, data || '');
    },
    debug(message, data) {
      if (process.env.NODE_ENV === 'development') {
        console.debug(`[${new Date().toLocaleTimeString('zh-CN')}] [Debug] 🔍 ${message}`, data || '');
      }
    }
  }
};
</script>

<style scoped>
.form-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.box-card {
  max-width: 800px;
  margin: 0 auto;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

/* 同步状态提示 */
.sync-status {
  padding: 12px 16px;
  margin-bottom: 20px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  animation: slideIn 0.3s ease-out;
}

.sync-status.success {
  background: #f0f9ff;
  color: #0066cc;
  border-left: 4px solid #0066cc;
}

.sync-status.error {
  background: #fef0f0;
  color: #f56c6c;
  border-left: 4px solid #f56c6c;
}

.sync-status.warning {
  background: #fdf6ec;
  color: #e6a23c;
  border-left: 4px solid #e6a23c;
}

.sync-status.info {
  background: #f4f4f5;
  color: #606266;
  border-left: 4px solid #606266;
}

.sync-status i {
  font-size: 16px;
}

/* 数据统计 */
.data-stats {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #ebeef5;
}

.stat-card {
  padding: 15px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
}

.stat-label {
  font-size: 12px;
  opacity: 0.8;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
}

/* 表单样式 */
.el-form-item {
  margin-bottom: 20px;
}

/* 按钮组样式 */
.el-button {
  margin-right: 10px;
  margin-bottom: 10px;
}

/* 动画 */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .form-container {
    padding: 10px;
  }

  .stat-card {
    margin-bottom: 10px;
  }

  .el-button {
    width: 100%;
    margin-right: 0;
  }
}

/* 对话框样式 */
>>> .form-data-dialog {
  max-width: 90%;
}

>>> .form-data-dialog pre {
  background: #f5f7fa;
  padding: 12px;
  border-radius: 4px;
  overflow-x: auto;
  font-size: 12px;
}
</style>
