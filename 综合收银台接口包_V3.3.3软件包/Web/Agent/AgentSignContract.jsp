<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AgentSign");
    eBusMerchantCommonRequest.dicRequest.put("RequestDate", request.getParameter("RequestDate"));                 //验证请求日期 （必要信息 - YYYY/MM/DD）
    eBusMerchantCommonRequest.dicRequest.put("RequestTime", request.getParameter("RequestTime"));                 //验证请求时间 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("NotifyType", request.getParameter("NotifyType"));                 //通知类型 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("ResultNotifyURL", request.getParameter("ResultNotifyURL"));         //通知地址（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));                         //订单编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));                 //接入渠道 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("MerCustomNo", request.getParameter("MerCustomNo"));                 //客户编号
    eBusMerchantCommonRequest.dicRequest.put("InvaidDate", request.getParameter("InvaidDate"));                 //签约有效期 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("IsSign", request.getParameter("IsSign"));                         //签约标识 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));           //证件号码       （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));       //证件类型       （必要信息）农行卡类型
    eBusMerchantCommonRequest.dicRequest.put("CardType", request.getParameter("CardType"));                         //农行卡类型 （必要信息）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>