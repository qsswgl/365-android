<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AppendSubmerchantInfo");
    eBusMerchantCommonRequest.dicRequest.put("OriSubMerNo", request.getParameter("OriSubMerNo"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactName", request.getParameter("SubMerContactName"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactCert", request.getParameter("SubMerContactCert"));
    eBusMerchantCommonRequest.dicRequest.put("MerMobilePhone", request.getParameter("MerMobilePhone"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactMail", request.getParameter("SubMerContactMail"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerContactType", request.getParameter("SubMerContactType"));
    eBusMerchantCommonRequest.dicRequest.put("ServicePhone", request.getParameter("ServicePhone"));
    eBusMerchantCommonRequest.dicRequest.put("Industry", request.getParameter("Industry"));
    eBusMerchantCommonRequest.dicRequest.put("BusinessRange", request.getParameter("BusinessRange"));
    eBusMerchantCommonRequest.dicRequest.put("Address", request.getParameter("Address"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateBegDate", request.getParameter("CertificateBegDate"));
    eBusMerchantCommonRequest.dicRequest.put("FrCertEndDate", request.getParameter("FrCertEndDate"));
    eBusMerchantCommonRequest.dicRequest.put("FrResidence", request.getParameter("FrResidence"));
    eBusMerchantCommonRequest.dicRequest.put("FrIsController", request.getParameter("FrIsController"));
    eBusMerchantCommonRequest.dicRequest.put("FrIsAgent", request.getParameter("FrIsAgent"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerName", request.getParameter("ControllerName"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertType", request.getParameter("ControllerCertType"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertNo", request.getParameter("ControllerCertNo"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertBegDate", request.getParameter("ControllerCertBegDate"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerCertEndDate", request.getParameter("ControllerCertEndDate"));
    eBusMerchantCommonRequest.dicRequest.put("ControllerResidence", request.getParameter("ControllerResidence"));
    eBusMerchantCommonRequest.dicRequest.put("AgentName", request.getParameter("AgentName"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertType", request.getParameter("AgentCertType"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertNo", request.getParameter("AgentCertNo"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertBegDate", request.getParameter("AgentCertBegDate"));
    eBusMerchantCommonRequest.dicRequest.put("AgentCertEndDate", request.getParameter("AgentCertEndDate"));
    eBusMerchantCommonRequest.dicRequest.put("AgentResidence", request.getParameter("AgentResidence"));
    eBusMerchantCommonRequest.dicRequest.put("ApplyService", request.getParameter("ApplyService"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerClass", request.getParameter("SubMerClass"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantShortName", request.getParameter("SubMerchantShortName"));
    eBusMerchantCommonRequest.dicRequest.put("EndCertificateValidity", request.getParameter("EndCertificateValidity"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>