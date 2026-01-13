<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AgentUnSign");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));                         //订单编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("AgentSignNo", request.getParameter("AgentSignNo"));                 //签约编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("RequestDate", request.getParameter("RequestDate"));                 //请求日期 （必要信息 - YYYY/MM/DD）
    eBusMerchantCommonRequest.dicRequest.put("RequestTime", request.getParameter("RequestTime"));                 //请求时间 （必要信息 - HH:MM:SS）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>