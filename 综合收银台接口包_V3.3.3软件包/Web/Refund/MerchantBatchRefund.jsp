<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="com.abc.pay.client.ebus.BatchRefundRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "BatchRefund");
    eBusMerchantCommonRequest.dicRequest.put("BatchNo", request.getParameter("BatchNo")); //批量编号  （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("BatchDate", request.getParameter("BatchDate"));  //订单日期  （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("BatchTime", request.getParameter("BatchTime")); //订单时间  （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("MerRefundAccountNo", request.getParameter("MerRefundAccountNo"));  //商户退款账号
    eBusMerchantCommonRequest.dicRequest.put("MerRefundAccountName", request.getParameter("MerRefundAccountName")); //商户退款名
    eBusMerchantCommonRequest.dicRequest.put("TotalCount", request.getParameter("TotalCount"));  //总笔数  （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("TotalAmount", request.getParameter("TotalAmount"));  //总金额 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("OrderData", request.getParameter("OrderData"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>