<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "PlatSubCustomPay");            //交易类型
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));    //交易流水号
    eBusMerchantCommonRequest.dicRequest.put("PlatSubCustomNo", request.getParameter("PlatSubCustomNo"));      //转出方二级客户编号
    eBusMerchantCommonRequest.dicRequest.put("PlatSubMerchantNo", request.getParameter("PlatSubMerchantNo"));      //转入方二级商户编号
    eBusMerchantCommonRequest.dicRequest.put("Amount", request.getParameter("Amount"));              //交易金额
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));    //附言
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>