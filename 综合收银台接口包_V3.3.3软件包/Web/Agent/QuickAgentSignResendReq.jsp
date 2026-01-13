<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "InterfaceAgentSignResend");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));                         //订单编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CardNo", request.getParameter("CardNo"));                           //签约账号       （必要信息）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>