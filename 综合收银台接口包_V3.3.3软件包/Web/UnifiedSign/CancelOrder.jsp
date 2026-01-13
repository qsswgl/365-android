<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "CancelOrder");
    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));
    eBusMerchantCommonRequest.dicRequest.put("OrderTime", request.getParameter("OrderTime"));
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("TrxAmount", request.getParameter("TrxAmount"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
