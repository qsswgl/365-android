<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AgentBatchQuery");
    eBusMerchantCommonRequest.dicRequest.put("BatchNo", request.getParameter("BatchNo")); //请求批次号       （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("BatchDate", request.getParameter("BatchDate")); //请求日期      YYYY/MM/DD       （必要信息）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>