<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
	LinkedHashMap entrustBatch = new LinkedHashMap();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "EntrustBatch");
    entrustBatch.put("BatchNo", request.getParameter("BatchNo"));
    entrustBatch.put("BatchDate", request.getParameter("BatchDate"));
    entrustBatch.put("BatchTime", request.getParameter("BatchTime"));
    entrustBatch.put("TotalCount", request.getParameter("TotalCount"));
    entrustBatch.put("TotalAmount", request.getParameter("TotalAmount"));
    eBusMerchantCommonRequest.dicRequest.put("EntrustBatch", entrustBatch);
    eBusMerchantCommonRequest.dicRequest.put("Details", request.getParameter("Details"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>