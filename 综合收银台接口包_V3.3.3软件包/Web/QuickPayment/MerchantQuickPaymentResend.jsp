<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "KPayResendReq");
    LinkedHashMap dicOrder = new LinkedHashMap();
    dicOrder.put("OrderNo", request.getParameter("OrderNo"));                       //设定订单编号 （必要信息）
    dicOrder.put("CurrencyCode", request.getParameter("CurrencyCode"));    //设定交易币种
    dicOrder.put("OrderAmount", request.getParameter("OrderAmount")); //设定订单金额 （必要信息）
    dicOrder.put("OrderDate", request.getParameter("OrderDate"));    //设定订单日期 （必要信息 - YYYY/MM/DD）
    dicOrder.put("OrderTime", request.getParameter("OrderTime"));                   //设定订单时间 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("Order", dicOrder);
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>