<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "GetWeiXinAuthInfo");
    eBusMerchantCommonRequest.dicRequest.put("StoreId", request.getParameter("StoreId"));
    eBusMerchantCommonRequest.dicRequest.put("StoreName", request.getParameter("StoreName"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceId", request.getParameter("DeviceId"));
    eBusMerchantCommonRequest.dicRequest.put("Attach", request.getParameter("Attach"));
    eBusMerchantCommonRequest.dicRequest.put("RawData", request.getParameter("RawData"));
    eBusMerchantCommonRequest.dicRequest.put("SubAppId", request.getParameter("SubAppId"));
    eBusMerchantCommonRequest.dicRequest.put("Now", request.getParameter("Now"));
    eBusMerchantCommonRequest.dicRequest.put("VersionNo", request.getParameter("VersionNo"));
    eBusMerchantCommonRequest.dicRequest.put("SignType", request.getParameter("SignType"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
