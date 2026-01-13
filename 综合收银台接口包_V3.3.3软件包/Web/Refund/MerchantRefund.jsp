<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "Refund");
    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));  //订单日期（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("OrderTime", request.getParameter("OrderTime")); //订单时间（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo")); //支付原订单号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("NewOrderNo", request.getParameter("NewOrderNo")); //交易编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CurrencyCode", request.getParameter("CurrencyCode")); //交易币种（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("TrxAmount", request.getParameter("TrxAmount")); //退货金额 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));  //附言
    eBusMerchantCommonRequest.dicRequest.put("MerRefundAccountNo", request.getParameter("MerRefundAccountNo"));  //指定商户退款账号
    eBusMerchantCommonRequest.dicRequest.put("MerRefundAccountName", request.getParameter("MerRefundAccountName"));  //指定商户退款户名
    eBusMerchantCommonRequest.dicRequest.put("MerRefundAccountFlag", request.getParameter("MerRefundAccountFlag"));  //退款账簿上送标识 1：担保账户 2：商户二级账簿 3：退款账簿
    if (request.getParameter("SplitMerInfo") != null && !request.getParameter("SplitMerInfo").equals("")) {
        eBusMerchantCommonRequest.dicRequest.put("SplitMerInfo", request.getParameter("SplitMerInfo"));//平台分账退款情况
    }
    if (request.getParameter("TemplateSplitAccInfo") != null && !request.getParameter("TemplateSplitAccInfo").equals("")) {
        eBusMerchantCommonRequest.dicRequest.put("TemplateSplitAccInfo", request.getParameter("TemplateSplitAccInfo"));  //模板分账退款情况
    }
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>