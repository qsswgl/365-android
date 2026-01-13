<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "IdentityVerifyReq");
    eBusMerchantCommonRequest.dicRequest.put("CustomType", request.getParameter("CustomType")); //客户类型 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));              //证件号码       （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType")); //证件类型       （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));              //验证请求日期 （必要信息 - YYYY/MM/DD）
    eBusMerchantCommonRequest.dicRequest.put("OrderTime", request.getParameter("OrderTime"));              //验证请求时间 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("BankCardNo", request.getParameter("BankCardNo"));                    //银行帐号       （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("ResultNotifyURL", request.getParameter("ResultNotifyURL"));          //身份验证回传网址（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType")); //交易渠道 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("CustomNo", request.getParameter("CustomNo")); //网银客户号
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>