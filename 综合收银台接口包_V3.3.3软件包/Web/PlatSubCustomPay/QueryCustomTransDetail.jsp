<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "QueryCustomTransDetail");
    eBusMerchantCommonRequest.dicRequest.put("SubCustomNo", request.getParameter("SubCustomNo"));  //二级客户编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("SelType", request.getParameter("SelType")); //交易类型（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("SDate", request.getParameter("SDate")); //开始日期（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("EDate", request.getParameter("EDate")); //结束日期（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("Status", request.getParameter("Status")); //交易状态
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo")); //订单号
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>