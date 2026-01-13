<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "MicroPayCancel");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("SubMchNO", request.getParameter("SubMchNO"));
    eBusMerchantCommonRequest.dicRequest.put("QueryDetail", request.getParameter("QueryDetail"));
    eBusMerchantCommonRequest.dicRequest.put("ModelFlag", request.getParameter("ModelFlag"));
    eBusMerchantCommonRequest.dicRequest.put("MerchantFlag", request.getParameter("MerchantFlag"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>