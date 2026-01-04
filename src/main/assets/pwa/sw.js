// 365酒水连锁 Service Worker
const CACHE_NAME = '365-liquor-v1.1.10';
const STATIC_CACHE = '365-liquor-static-v1.1.10';
const DYNAMIC_CACHE = '365-liquor-dynamic-v1.1.10';
const SW_VERSION = '1.1.10';

// 需要缓存的静态资源
const STATIC_ASSETS = [
    '/html/365/pwa/',
    '/html/365/pwa/index.html',
    '/html/365/pwa/manifest.json',
    '/html/365/pwa/icons/icon-72.png',
    '/html/365/pwa/icons/icon-72-maskable.png',
    '/html/365/pwa/icons/icon-96.png',
    '/html/365/pwa/icons/icon-96-maskable.png',
    '/html/365/pwa/icons/icon-128.png',
    '/html/365/pwa/icons/icon-128-maskable.png',
    '/html/365/pwa/icons/icon-144.png',
    '/html/365/pwa/icons/icon-144-maskable.png',
    '/html/365/pwa/icons/icon-152.png',
    '/html/365/pwa/icons/icon-152-maskable.png',
    '/html/365/pwa/icons/icon-180.png',
    '/html/365/pwa/icons/icon-180-maskable.png',
    '/html/365/pwa/icons/icon-192.png',
    '/html/365/pwa/icons/icon-192-maskable.png',
    '/html/365/pwa/icons/icon-384.png',
    '/html/365/pwa/icons/icon-384-maskable.png',
    '/html/365/pwa/icons/icon-512.png',
    '/html/365/pwa/icons/icon-512-maskable.png',
    '/html/365/pwa/offline.html'
];

// 安装事件 - 立即激活新版本
self.addEventListener('install', (event) => {
    console.log('[SW] 安装新版本:', SW_VERSION);
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then((cache) => {
                console.log('[SW] 缓存静态资源');
                return cache.addAll(STATIC_ASSETS);
            })
            .then(() => {
                console.log('[SW] 安装完成，跳过等待立即激活');
                // 强制跳过等待，立即激活新版本
                return self.skipWaiting();
            })
            .catch((error) => {
                console.error('[SW] 缓存失败:', error);
            })
    );
});

// 激活事件 - 清理旧缓存并接管所有客户端
self.addEventListener('activate', (event) => {
    console.log('[SW] 激活新版本:', SW_VERSION);
    event.waitUntil(
        caches.keys()
            .then((cacheNames) => {
                return Promise.all(
                    cacheNames.map((cacheName) => {
                        // 删除所有旧版本缓存
                        if (cacheName !== CACHE_NAME && cacheName !== STATIC_CACHE && cacheName !== DYNAMIC_CACHE) {
                            console.log('[SW] 清理旧缓存:', cacheName);
                            return caches.delete(cacheName);
                        }
                    })
                );
            })
            .then(() => {
                console.log('[SW] 激活完成，接管所有客户端');
                // 立即接管所有客户端
                return self.clients.claim();
            })
            .then(() => {
                // 通知所有客户端刷新页面
                return self.clients.matchAll({ type: 'window' });
            })
            .then((clients) => {
                clients.forEach((client) => {
                    // 发送更新消息给客户端
                    client.postMessage({
                        type: 'SW_UPDATED',
                        version: SW_VERSION
                    });
                });
            })
    );
});

// 监听来自客户端的消息
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        console.log('[SW] 收到跳过等待命令');
        self.skipWaiting();
    }

    if (event.data && event.data.type === 'GET_VERSION') {
        event.ports[0].postMessage({ version: SW_VERSION });
    }
});

// 网络请求拦截 - 混合策略
self.addEventListener('fetch', (event) => {
    // 只处理同源请求
    if (!event.request.url.startsWith(self.location.origin)) {
        return;
    }

    // 对于导航请求，使用网络优先策略
    if (event.request.mode === 'navigate') {
        event.respondWith(
            fetch(event.request)
                .then((response) => {
                    // 更新缓存
                    const responseClone = response.clone();
                    caches.open(DYNAMIC_CACHE).then((cache) => {
                        cache.put(event.request, responseClone);
                    });
                    return response;
                })
                .catch(() => {
                    // 网络不可用时，先尝试返回缓存的主页面，再返回离线页面
                    return caches.match('/html/365/pwa/index.html')
                        .then((cached) => cached || caches.match('/html/365/pwa/offline.html'));
                })
        );
        return;
    }

    // 对于静态资源（CSS、JS、图片等），使用缓存优先策略
    if (event.request.destination === 'script' || 
        event.request.destination === 'style' || 
        event.request.destination === 'image') {
        event.respondWith(
            caches.match(event.request)
                .then((cachedResponse) => {
                    // 缓存命中，直接返回
                    if (cachedResponse) {
                        // 在后台更新缓存
                        fetch(event.request)
                            .then((response) => {
                                if (response.status === 200) {
                                    caches.open(STATIC_CACHE).then((cache) => {
                                        cache.put(event.request, response.clone());
                                    });
                                }
                            })
                            .catch(() => {}); // 忽略更新失败
                        return cachedResponse;
                    }
                    
                    // 缓存未命中，从网络获取
                    return fetch(event.request)
                        .then((response) => {
                            // 网络请求成功，更新缓存
                            if (response.status === 200) {
                                const responseClone = response.clone();
                                caches.open(STATIC_CACHE)
                                    .then((cache) => {
                                        cache.put(event.request, responseClone);
                                    });
                            }
                            return response;
                        });
                })
        );
    } else {
        // 对于其他请求，使用网络优先策略
        event.respondWith(
            fetch(event.request)
                .then((response) => {
                    // 如果网络请求成功，更新缓存
                    if (response.status === 200) {
                        const responseClone = response.clone();
                        caches.open(DYNAMIC_CACHE)
                            .then((cache) => {
                                cache.put(event.request, responseClone);
                            });
                    }
                    return response;
                })
                .catch(() => {
                    // 网络失败时从缓存获取
                    return caches.match(event.request)
                        .then((cachedResponse) => {
                            if (cachedResponse) {
                                return cachedResponse;
                            }
                            // 如果动态缓存中也没有，返回离线页面
                            return caches.match('/html/365/pwa/offline.html');
                        });
                })
        );
    }
});

// 处理推送通知
self.addEventListener('push', (event) => {
    if (event.data) {
        const data = event.data.json();
        const options = {
            body: data.body || '您有新的消息',
            icon: '/html/365/pwa/icons/icon-192.png',
            badge: '/html/365/pwa/icons/icon-192.png',
            vibrate: [100, 50, 100],
            data: {
                url: data.url || '/html/365/pwa/'
            }
        };
        event.waitUntil(
            self.registration.showNotification(data.title || '365酒水连锁', options)
        );
    }
});

// 处理通知点击
self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    event.waitUntil(
        clients.openWindow(event.notification.data.url)
    );
});

// 后台同步事件
self.addEventListener('sync', (event) => {
    if (event.tag === 'background-sync') {
        console.log('[SW] 执行后台同步');
        event.waitUntil(
            // 这里可以添加需要同步的数据
            // 例如：发送离线时保存的数据到服务器
            Promise.resolve()
        );
    }
});

// 后台获取事件
self.addEventListener('backgroundfetchsuccess', (event) => {
    console.log('[SW] 后台获取成功');
    // 处理后台获取成功的资源
});
