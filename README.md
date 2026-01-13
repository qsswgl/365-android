1 APP里，JSBridge 方式帮webview的H5页面里，实现 "微信登录",流程如下：
   1 H5页面点击 微信登录 按钮，JSBridge调起APP里的 微信登录 方法
       1 APP收到调起指令后，通过调起 微信开放平台提供的 SDK（WeChat OpenSDK），拉起微信客户端，点击授权同意后，接收回调并获取code
       2  微信开放平台资料：移动应用：365酒水
         APPID:wx19d89333ff0d3efe
         AppSecret:f4566a825ef87dbb5add80e4a3c887d1
       3 将获取的code回传给H5页面