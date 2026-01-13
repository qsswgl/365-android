<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "RegisterSubmerchantInfo");
    eBusMerchantCommonRequest.dicRequest.put("SubMerId", request.getParameter("SubMerId"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerName", request.getParameter("SubMerName"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerType", request.getParameter("SubMerType"));
    eBusMerchantCommonRequest.dicRequest.put("ContactName", request.getParameter("ContactName"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));
    eBusMerchantCommonRequest.dicRequest.put("CompanyCertType", request.getParameter("CompanyCertType"));
    eBusMerchantCommonRequest.dicRequest.put("CompanyCertNo", request.getParameter("CompanyCertNo"));
    eBusMerchantCommonRequest.dicRequest.put("NotifyUrl", request.getParameter("NotifyUrl"));
    eBusMerchantCommonRequest.dicRequest.put("Announce", request.getParameter("Announce"));
    eBusMerchantCommonRequest.dicRequest.put("MerMobilePhone", request.getParameter("MerMobilePhone"));
    eBusMerchantCommonRequest.dicRequest.put("AccountName", request.getParameter("AccountName"));
    eBusMerchantCommonRequest.dicRequest.put("Account", request.getParameter("Account"));
    eBusMerchantCommonRequest.dicRequest.put("BankName", request.getParameter("BankName"));
    eBusMerchantCommonRequest.dicRequest.put("MobilePhone", request.getParameter("MobilePhone"));
    eBusMerchantCommonRequest.dicRequest.put("AccountType", request.getParameter("AccountType"));
    eBusMerchantCommonRequest.dicRequest.put("Address", request.getParameter("Address"));
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));
    eBusMerchantCommonRequest.dicRequest.put("ReplacedAccount", request.getParameter("ReplacedAccount"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactName", request.getParameter("SubMerContactName"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactCert", request.getParameter("SubMerContactCert"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactMail", request.getParameter("SubMerContactMail"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactType", request.getParameter("SubMerContactType"));
    eBusMerchantCommonRequest.dicRequest.put("ServicePhone", request.getParameter("ServicePhone"));
    eBusMerchantCommonRequest.dicRequest.put("Industry", request.getParameter("Industry"));
    eBusMerchantCommonRequest.dicRequest.put("BusinessRange", request.getParameter("BusinessRange"));
    eBusMerchantCommonRequest.dicRequest.put("FrCertEndDate", request.getParameter("FrCertEndDate"));
    eBusMerchantCommonRequest.dicRequest.put("FrIsController", request.getParameter("FrIsController"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerName", request.getParameter("ControllerName"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertType", request.getParameter("ControllerCertType"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertNo", request.getParameter("ControllerCertNo"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertEndDate", request.getParameter("ControllerCertEndDate"));
    eBusMerchantCommonRequest.dicRequest.put("FrIsAgent", request.getParameter("FrIsAgent"));
    eBusMerchantCommonRequest.dicRequest.put("AgentName", request.getParameter("AgentName"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertType", request.getParameter("AgentCertType"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertNo", request.getParameter("AgentCertNo"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertEndDate", request.getParameter("AgentCertEndDate"));
    eBusMerchantCommonRequest.dicRequest.put("ApplyService", request.getParameter("ApplyService"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerClass", request.getParameter("SubMerClass"));
    eBusMerchantCommonRequest.dicRequest.put("IsNewFlag", request.getParameter("NewSubMerFlag"));
    eBusMerchantCommonRequest.dicRequest.put("EndCertificateValidity", request.getParameter("EndCertificateValidity"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantShortName", request.getParameter("SubMerchantShortName"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateBegDate", request.getParameter("CertificateBegDate"));
    eBusMerchantCommonRequest.dicRequest.put("FrResidence", request.getParameter("FrResidence"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertBegDate", request.getParameter("ControllerCertBegDate"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerResidence", request.getParameter("ControllerResidence"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertBegDate", request.getParameter("AgentCertBegDate"));
    eBusMerchantCommonRequest.dicRequest.put("AgentResidence", request.getParameter("AgentResidence"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>