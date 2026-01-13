<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "UnifiedSignPay");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("OrderAmount", request.getParameter("OrderAmount"));
    eBusMerchantCommonRequest.dicRequest.put("CommodityType", request.getParameter("CommodityType"));
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));
    eBusMerchantCommonRequest.dicRequest.put("SignNo", request.getParameter("SignNo"));
    eBusMerchantCommonRequest.dicRequest.put("ProductSignType", request.getParameter("ProductSignType"));
    eBusMerchantCommonRequest.dicRequest.put("IsBreakAccount", request.getParameter("IsBreakAccount"));
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));
    eBusMerchantCommonRequest.dicRequest.put("BuyIP", request.getParameter("BuyIP"));
    eBusMerchantCommonRequest.dicRequest.put("SplitAccInfoItems", request.getParameter("SplitAccInfoItems"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
