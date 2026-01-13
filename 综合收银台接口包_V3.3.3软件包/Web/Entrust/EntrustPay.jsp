<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "EntrustPay");
    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));
    eBusMerchantCommonRequest.dicRequest.put("OrderTime", request.getParameter("OrderTime"));
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("EntrustSignNo", request.getParameter("EntrustSignNo"));
    eBusMerchantCommonRequest.dicRequest.put("CardNo", request.getParameter("CardNo"));
    eBusMerchantCommonRequest.dicRequest.put("CurrencyCode", request.getParameter("CurrencyCode"));
    eBusMerchantCommonRequest.dicRequest.put("Amount", request.getParameter("Amount"));
    eBusMerchantCommonRequest.dicRequest.put("ReceiverAddress", request.getParameter("ReceiverAddress"));
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));
    eBusMerchantCommonRequest.dicRequest.put("BuyIP", request.getParameter("BuyIP"));
    eBusMerchantCommonRequest.dicRequest.put("ReceiveAccount", request.getParameter("ReceiveAccount"));
    eBusMerchantCommonRequest.dicRequest.put("ReceiveAccName", request.getParameter("ReceiveAccName"));
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));
    eBusMerchantCommonRequest.dicRequest.put("IsBreakAccount", request.getParameter("IsBreakAccount"));
    eBusMerchantCommonRequest.dicRequest.put("BusinessCode", request.getParameter("BusinessCode"));
    eBusMerchantCommonRequest.dicRequest.put("SplitAccInfoItems", request.getParameter("SplitAccInfoItems"));



    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());


%>