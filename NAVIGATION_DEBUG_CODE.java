// 这个代码应该添加到 MainActivity.java 的 shouldOverrideUrlLoading 方法中
// 用于详细日志记录 URL 内容

// 修改后的 shouldOverrideUrlLoading 方法片段

if (url.startsWith("amap://") || url.startsWith("androidamap://")) {
    Log.d("WebView", "=== 检测到高德地图链接 ===");
    Log.d("WebView", "完整URL: " + url);
    
    // 解析URL的各个部分
    Uri uri = Uri.parse(url);
    Log.d("WebView", "Scheme: " + uri.getScheme());
    Log.d("WebView", "Host: " + uri.getHost());
    Log.d("WebView", "Path: " + uri.getPath());
    Log.d("WebView", "Query: " + uri.getQuery());
    
    // 查看所有参数
    Set<String> paramNames = uri.getQueryParameterNames();
    Log.d("WebView", "参数个数: " + paramNames.size());
    for (String paramName : paramNames) {
        String paramValue = uri.getQueryParameter(paramName);
        Log.d("WebView", "参数: " + paramName + " = " + paramValue);
    }
    
    handleAmapNavigation(url);
    return true;
}

