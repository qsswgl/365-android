/**
 * 365酒水连锁 PWA 安装管理器
 * 遵循 Chrome PWA 最佳实践：https://developer.chrome.com/docs/capabilities/pwa/promote-install
 */

(function () {
    'use strict';

    // ==================== 配置项 ====================
    const APK_DOWNLOAD_URL = 'https://www.qsgl.net/html/365/365.apk';
    const APP_NAME = '365酒水连锁';
    const APP_ICON = '/html/365/pwa/icons/icon-192.png';

    // ==================== 状态管理 ====================
    const state = {
        deferredPrompt: null,
        isStandalone: false,
        isWeChat: false,
        isIOS: false,
        hasCheckedAPI: false
    };

    // ==================== 浏览器检测 ====================
    const BrowserDetector = {
        init: function () {
            const ua = navigator.userAgent.toLowerCase();
            state.isWeChat = /micromessenger/i.test(ua);
            state.isIOS = /iphone|ipad|ipod/i.test(ua);
            state.isStandalone = this.checkStandalone();
        },

        checkStandalone:function () {
            if(
                window.matchMedia('(display-mode: standalone)').matches ||
                window.matchMedia('(display-mode: fullscreen)').matches ||
                window.matchMedia('(display-mode: minimal-ui)').matches ||
                (window.navigator.standalone === true) ||
                document.referrer.includes('android-app://') ||
                sessionStorage.getItem('pwa-standalone') === 'true'
            ){
                console.log('JS检测[PWA] 检测到已安装');
                return true;
            }

            if((new URLSearchParams(window.location.search)).get('source') == 'pwa'){
                return true;
            }

            return false;
        }
    };

    // ==================== UI 组件 ====================
    const InstallUI = {
        modalId: 'pwa-install-modal',
        blockerId: 'pwa-app-blocker',

        createStyles: function () {
            if (document.getElementById('pwa-install-styles')) return;
            const styles = document.createElement('style');
            styles.id = 'pwa-install-styles';
            styles.textContent = `
                #pwa-app-blocker {
                    position: fixed; top: 0; left: 0; right: 0; bottom: 0;
                    z-index: 999998;
                    background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
                    display: flex; flex-direction: column;
                    align-items: center; justify-content: flex-start;
                    padding-top: 80px;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                }
                .blocker-header { text-align: center; color: #fff; margin-bottom: 40px; }
                .blocker-header .app-icon { 
                    width: 90px; height: 90px; border-radius: 22px; 
                    box-shadow: 0 10px 30px rgba(0,0,0,0.5); margin-bottom: 20px; 
                }
                .blocker-header h1 { font-size: 26px; margin: 0 0 10px 0; font-weight: 700; letter-spacing: 1px; }
                .blocker-header p { font-size: 15px; opacity: 0.8; margin: 0; }

                #pwa-install-modal {
                    position: fixed; top: 0; left: 0; right: 0; bottom: 0;
                    z-index: 999999;
                    display: flex; align-items: flex-end; justify-content: center;
                    background: rgba(0,0,0,0.2);
                    backdrop-filter: blur(5px);
                    -webkit-backdrop-filter: blur(5px);
                }
                .modal-content {
                    background: #fff;
                    border-radius: 24px 24px 0 0;
                    width: 100%; max-width: 500px;
                    box-shadow: 0 -10px 40px rgba(0,0,0,0.2);
                    padding: 25px;
                    animation: slideUp 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                }
                @keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }
                
                .modal-header { display: flex; align-items: center; margin-bottom: 25px; }
                .modal-header .app-icon { width: 64px; height: 64px; border-radius: 16px; margin-right: 18px; }
                .app-info h3 { margin: 0 0 4px 0; font-size: 20px; color: #1a1a1a; font-weight: 700; }
                .app-info p { margin: 0; font-size: 14px; color: #666; }
                
                .action-btn {
                    width: 90%; padding: 16px; border: none; border-radius: 14px;
                    background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
                    color: #fff; font-size: 17px; font-weight: 700;
                    cursor: pointer; transition: all 0.2s;
                    box-shadow: 0 6px 20px rgba(255, 107, 53, 0.3);
                    text-decoration: none; display: flex; align-items: center; justify-content: center;
                }
                .action-btn:active { transform: scale(0.98); }
                .action-btn.loading { opacity: 0.7; pointer-events: none; }
                
                .manual-guide { margin-top: 20px; padding: 18px; background: #fcfcfc; border: 1px solid #eee; border-radius: 16px; }
                .guide-item { display: flex; align-items: flex-start; margin-bottom: 12px; }
                .guide-num { 
                    width: 24px; height: 24px; background: #ff6b35; color: #fff; 
                    border-radius: 50%; display: flex; align-items: center; justify-content: center;
                    font-size: 12px; font-weight: 700; margin-right: 12px; flex-shrink: 0; margin-top: 2px;
                }
                .guide-text { font-size: 15px; color: #444; line-height: 1.5; }

                #pwa-toast {
                    position: fixed; bottom: 40px; left: 50%; transform: translateX(-50%);
                    background: rgba(0,0,0,0.85); color: #fff; padding: 12px 24px; border-radius: 30px;
                    font-size: 14px; z-index: 1000001; transition: opacity 0.3s;
                }
            `;
            document.head.appendChild(styles);
        },

        show: function (mode) {
            this.createStyles();
            this.remove();

            const blocker = document.createElement('div');
            blocker.id = this.blockerId;
            blocker.innerHTML = `
                <div class="blocker-header">
                    <img class="app-icon" src="${APP_ICON}" alt="${APP_NAME}">
                    <h1>${APP_NAME}</h1>
                    <p>正在拉取最佳体验配置...</p>
                </div>
            `;
            document.body.appendChild(blocker);

            const modal = document.createElement('div');
            modal.id = this.modalId;

            let content = '';
            if (mode === 'API') {
                content = `
                    <div class="modal-header">
                        <img class="app-icon" src="${APP_ICON}">
                        <div class="app-info"><h3>${APP_NAME}</h3><p>点击下方按钮秒速安装</p></div>
                    </div>
                    <button class="action-btn" id="pwa-install-btn" onclick="PWAInstaller.triggerInstall()">
                        🚀 立即安装到桌面
                    </button>
                    <div style="display:flex; justify-content:space-between; margin-top:20px; color:#999; font-size:12px;">
                        <span>✓ 无需下载</span><span>✓ 极速启动</span><span>✓ 安全稳定</span>
                    </div>
                `;
            } else if (mode === 'IOS') {
                content = `
                    <div class="modal-header">
                        <img class="app-icon" src="${APP_ICON}">
                        <div class="app-info"><h3>${APP_NAME}</h3><p>iOS 用户请按照提示操作</p></div>
                    </div>
                    <div class="manual-guide">
                        <div class="guide-item"><span class="guide-num">1</span><span class="guide-text">点击下方导航栏的<strong>分享</strong>按钮 📤</span></div>
                        <div class="guide-item"><span class="guide-num">2</span><span class="guide-text">向上滑动找到并点击<strong>“添加到主屏幕”</strong></span></div>
                        <div class="guide-item"><span class="guide-num">3</span><span class="guide-text">最后点击右上角的<strong>“添加”</strong>即可</span></div>
                    </div>
                `;
            } else {
                content = `
                    <div class="modal-header">
                        <img class="app-icon" src="${APP_ICON}">
                        <div class="app-info"><h3>${APP_NAME}</h3><p>当前浏览器不支持自动安装</p></div>
                    </div>
                    <a href="${APK_DOWNLOAD_URL}" class="action-btn">📥 下载安卓客户端</a>
                    <p style="text-align:center; color:#999; font-size:12px; margin-top:15px;">若已安装，请从桌面图标启动</p>
                `;
            }

            modal.innerHTML = `<div class="modal-content">${content}</div>`;
            document.body.appendChild(modal);
        },

        remove: function () {
            const b = document.getElementById(this.blockerId);
            const m = document.getElementById(this.modalId);
            if (b) b.remove();
            if (m) m.remove();
        },

        toast: function (msg) {
            const t = document.createElement('div');
            t.id = 'pwa-toast';
            t.textContent = msg;
            document.body.appendChild(t);
            setTimeout(() => t.remove(), 3000);
        }
    };

    // ==================== 核心逻辑 ====================
    const PWAInstaller = {
        init: function () {
            BrowserDetector.init();

            // 早期监听 prompt 事件
            window.addEventListener('beforeinstallprompt', (e) => {
                console.log('[PWA] beforeinstallprompt 事件触发');
                e.preventDefault();
                state.deferredPrompt = e;
                state.hasCheckedAPI = true;
                console.log('PWA install prompt deferred');

                if (!state.isStandalone && !state.isWeChat) {
                    InstallUI.show('API');
                }
            });

            window.addEventListener('appinstalled', (e) => {
                console.log('[PWA] 应用已安装');
                InstallUI.toast('✅ 安装成功，正在进入...');
                setTimeout(() => {
                    InstallUI.remove();
                    window.location.reload();
                }, 1500);
            });

            // 如果已经在 standalone 模式，直接注册 SW 退出
            if (state.isStandalone) {
                console.log('[PWA] 已在独立模式运行');
                this.registerSW();
                try { sessionStorage.setItem('pwa-standalone', 'true'); } catch (e) { }
                return;
            }

            // 如果在微信，正常展示（不做安装提示，除非你想引导跳出）
            if (state.isWeChat) {
                console.log('[PWA] 微信环境');
                return;
            }

            // 流程启动
            this.registerSW();
            this.startCheckProcess();
        },

        startCheckProcess: function () {
            // 给浏览器一些时间来触发 beforeinstallprompt (尤其是 SW 注册后)
            setTimeout(() => {
                if (state.hasCheckedAPI) return; // 已经处理过了

                if (state.isIOS) {
                    InstallUI.show('IOS');
                } else {
                    // 再次检查，如果还是没触发 API，则认为是普通浏览器
                    setTimeout(() => {
                        if (!state.deferredPrompt) {
                            console.log('[PWA] 最终确认：不支持 API 安装');
                            InstallUI.show('APK');
                        }
                    }, 1000); // 增加等待时间到共 3 秒
                }
            }, 1000);
        },

        triggerInstall: function () {
            if (!state.deferredPrompt) {
                InstallUI.show('APK');
                return;
            }

            const btn = document.getElementById('pwa-install-btn');
            if (btn) {
                btn.classList.add('loading');
                btn.textContent = '请在浏览器弹窗确认...';
            }

            state.deferredPrompt.prompt();
            state.deferredPrompt.userChoice.then((choiceResult) => {
                console.log('[PWA] 用户选择:', choiceResult.outcome);
                if (choiceResult.outcome === 'accepted') {
                    console.log('PWA install accepted');
                    InstallUI.toast('✅ 安装成功，正在进入...');
                    setTimeout(() => {
                        InstallUI.remove();
                        window.location.reload();
                    }, 1500);
                } else {
                    console.log('PWA install dismissed');
                    if (btn) {
                        btn.classList.remove('loading');
                        btn.textContent = '🚀 立即安装到桌面';
                    }
                }
                state.deferredPrompt = null;
            });
        },

        registerSW: function () {
            if (!('serviceWorker' in navigator)) return;

            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/html/365/pwa/sw.js', { scope: '/html/365/pwa/' })
                    .then(reg => {
                        console.log('[PWA] Service Worker 注册成功');
                        // 定期检查更新
                        setInterval(() => reg.update(), 1000 * 60 * 60);
                    })
                    .catch(err => console.error('[PWA] SW 注册失败:', err));
            });

            navigator.serviceWorker.addEventListener('message', event => {
                if (event.data?.type === 'SW_UPDATED') {
                    InstallUI.toast('应用有更新，正在刷新...');
                    setTimeout(() => window.location.reload(), 2000);
                }
            });
        }
    };

    // 暴露给全局
    window.PWAInstaller = PWAInstaller;

    // 尝试尽快运行
    if (document.readyState === 'complete') {
        PWAInstaller.init();
    } else {
        window.addEventListener('load', () => PWAInstaller.init());
    }
})();