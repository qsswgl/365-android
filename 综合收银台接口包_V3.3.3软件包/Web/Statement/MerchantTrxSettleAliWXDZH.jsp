<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "SettleAliWxDZH");
    eBusMerchantCommonRequest.dicRequest.put("SettleDate",request.getParameter("SettleDate"));  //对账日期YYYY/MM/DD （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("ZIP",request.getParameter("ZIP"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>