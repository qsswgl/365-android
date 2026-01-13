<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "KPayReq");
    LinkedHashMap dicOrder = new LinkedHashMap();
    dicOrder.put("OrderNo", request.getParameter("OrderNo"));                       //设定订单编号 （必要信息）
    dicOrder.put("CurrencyCode", request.getParameter("CurrencyCode"));    //设定交易币种，
    dicOrder.put("OrderAmount", request.getParameter("OrderAmount")); //设定订单金额 （必要信息）
    dicOrder.put("Fee", request.getParameter("Fee")); //设定手续费金额
    dicOrder.put("OrderDate", request.getParameter("OrderDate"));                   //设定订单日期 （必要信息 - YYYY/MM/DD）
    dicOrder.put("OrderTime", request.getParameter("OrderTime"));                   //设定订单时间 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("Order", dicOrder);
    eBusMerchantCommonRequest.dicRequest.put("AccName", request.getParameter("AccName"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateType", request.getParameter("CertificateType"));
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));
    eBusMerchantCommonRequest.dicRequest.put("ExpDate", request.getParameter("ExpDate"));
    eBusMerchantCommonRequest.dicRequest.put("CVV2", request.getParameter("CVV2"));
    eBusMerchantCommonRequest.dicRequest.put("VerifyCode", request.getParameter("VerifyCode"));
    eBusMerchantCommonRequest.dicRequest.put("PaymentType", request.getParameter("PaymentType"));          //设定支付类型
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));      //设定支付接入方式
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));  //设定商户备注信息
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>