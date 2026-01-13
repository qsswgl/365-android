<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "PayForAnother");
    eBusMerchantCommonRequest.dicRequest.put("SubMerId", request.getParameter("SubMerId"));        //二级商户编号
    eBusMerchantCommonRequest.dicRequest.put("Account", request.getParameter("Account"));          //收款账号
    eBusMerchantCommonRequest.dicRequest.put("AccountName", request.getParameter("AccountName"));  //收款账名
    eBusMerchantCommonRequest.dicRequest.put("TrxAmount", request.getParameter("TrxAmount"));      //出金金额
    eBusMerchantCommonRequest.dicRequest.put("DrawingFlag", request.getParameter("DrawingFlag"));          //交易编号
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));          //交易编号
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));          //交易编号
    eBusMerchantCommonRequest.dicRequest.put("RecBankNo", request.getParameter("RecBankNo"));          //他行行号
	JSON responseJson = eBusMerchantCommonRequest.postRequest();
	out.print(responseJson.getIJsonString());
%>