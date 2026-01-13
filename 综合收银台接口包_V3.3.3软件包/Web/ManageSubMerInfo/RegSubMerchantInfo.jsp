<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "RegSubMerchantInfo");
    eBusMerchantCommonRequest.dicRequest.put("SubMerId", request.getParameter("SubMerId"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerName", request.getParameter("SubMerName"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerType", request.getParameter("SubMerType"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerSort", request.getParameter("SubMerSort"));
    eBusMerchantCommonRequest.dicRequest.put("Status", request.getParameter("Status"));
    eBusMerchantCommonRequest.dicRequest.put("ContactName", request.getParameter("ContactName"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));
    eBusMerchantCommonRequest.dicRequest.put("CompanyName", request.getParameter("CompanyName"));
    eBusMerchantCommonRequest.dicRequest.put("CompanyCertType", request.getParameter("CompanyCertType"));
    eBusMerchantCommonRequest.dicRequest.put("CompanyCertNo", request.getParameter("CompanyCertNo"));
    eBusMerchantCommonRequest.dicRequest.put("AccountName", request.getParameter("AccountName"));
    eBusMerchantCommonRequest.dicRequest.put("Account", request.getParameter("Account"));
    eBusMerchantCommonRequest.dicRequest.put("BankName", request.getParameter("BankName"));
    eBusMerchantCommonRequest.dicRequest.put("MobilePhone", request.getParameter("MobilePhone"));
    eBusMerchantCommonRequest.dicRequest.put("AccountType", request.getParameter("AccountType"));
    eBusMerchantCommonRequest.dicRequest.put("Address", request.getParameter("Address"));
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>