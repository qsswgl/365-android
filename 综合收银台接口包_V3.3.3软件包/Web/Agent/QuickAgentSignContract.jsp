<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "InterfaceAgentSignReq");
    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));            //请求日期 （必要信息 - YYYY/MM/DD）
    eBusMerchantCommonRequest.dicRequest.put("OrderTime", request.getParameter("OrderTime"));            //请求时间 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));                  //订单编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));  //接入渠道 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("MerCustomNo", request.getParameter("MerCustomNo"));          //客户编号
    eBusMerchantCommonRequest.dicRequest.put("AgentSignNo", request.getParameter("AgentSignNo"));          //签约编号
    eBusMerchantCommonRequest.dicRequest.put("CardNo", request.getParameter("CardNo"));                    //签约账号  （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CardType", request.getParameter("CardType"));                //农行卡类型（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("MobileNo", request.getParameter("MobileNo"));                //签约手机号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("InvaidDate", request.getParameter("InvaidDate"));            //签约有效期（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("IsSign", request.getParameter("IsSign"));                    //签约/解约标识 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));  //证件类型（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));     //证件号码（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("AccName", request.getParameter("AccName"));                  //客户姓名（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CVV2", request.getParameter("CVV2"));                        //贷记卡CVV2码（农行卡类型为贷记卡时必输）
    eBusMerchantCommonRequest.dicRequest.put("CardDueDate", request.getParameter("CardDueDate"));          //贷记卡到期日（农行卡类型为贷记卡时必输）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>