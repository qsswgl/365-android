<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "UnifiedSignConfirm");
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));
    eBusMerchantCommonRequest.dicRequest.put("CardNo", request.getParameter("CardNo"));
    eBusMerchantCommonRequest.dicRequest.put("AccName", request.getParameter("AccName"));
    eBusMerchantCommonRequest.dicRequest.put("MobileNo", request.getParameter("MobileNo"));
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));
    eBusMerchantCommonRequest.dicRequest.put("ProductSignType", request.getParameter("ProductSignType"));
    eBusMerchantCommonRequest.dicRequest.put("SmsKey", request.getParameter("SmsKey"));
    eBusMerchantCommonRequest.dicRequest.put("VerificationCode", request.getParameter("VerificationCode"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
