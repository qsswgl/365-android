<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "BatchRegister");
    eBusMerchantCommonRequest.dicRequest.put("RequestNo", request.getParameter("RequestNo"));
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));
    eBusMerchantCommonRequest.dicRequest.put("OrderAmount", request.getParameter("OrderAmount"));
    eBusMerchantCommonRequest.dicRequest.put("TrnxCode", request.getParameter("TrnxCode"));
    eBusMerchantCommonRequest.dicRequest.put("TrnxType", request.getParameter("TrnxType"));
    eBusMerchantCommonRequest.dicRequest.put("CurrencyCode", request.getParameter("CurrencyCode"));
    eBusMerchantCommonRequest.dicRequest.put("CustomId", request.getParameter("CustomId"));
    eBusMerchantCommonRequest.dicRequest.put("ProductName", request.getParameter("ProductName"));
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));
    eBusMerchantCommonRequest.dicRequest.put("OrderType", request.getParameter("OrderType"));
    eBusMerchantCommonRequest.dicRequest.put("OrderData", request.getParameter("OrderData"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>