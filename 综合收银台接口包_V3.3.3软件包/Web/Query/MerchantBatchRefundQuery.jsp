<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "QueryBatchRefund");
    eBusMerchantCommonRequest.dicRequest.put("BatchDate", request.getParameter("BatchDate"));  //订单日期（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("BatchTime", request.getParameter("BatchTime")); //订单时间（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("SerialNumber", request.getParameter("SerialNumber")); //设定退款批量结果查询请求的流水号（必要信息）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
