<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "SendMobileMessageForSubMer");
    eBusMerchantCommonRequest.dicRequest.put("SubMerId", request.getParameter("SubMerId"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantAccNo", request.getParameter("SubMerchantAccNo"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>