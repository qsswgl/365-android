<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "EntrustBatchQuery");
    eBusMerchantCommonRequest.dicRequest.put("BatchNo", request.getParameter("BatchNo"));
    eBusMerchantCommonRequest.dicRequest.put("BatchDate", request.getParameter("BatchDate"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>