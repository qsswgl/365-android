<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
	LinkedHashMap agentBatch = new LinkedHashMap();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AgentBatch");
    agentBatch.put("BatchNo", request.getParameter("BatchNo"));
    agentBatch.put("BatchDate", request.getParameter("BatchDate"));
    agentBatch.put("BatchTime", request.getParameter("BatchTime"));
    agentBatch.put("AgentCount", request.getParameter("AgentCount"));
    agentBatch.put("AgentAmount", request.getParameter("AgentAmount"));
    eBusMerchantCommonRequest.dicRequest.put("AgentBatch", agentBatch);
    eBusMerchantCommonRequest.dicRequest.put("ReceiveAccount", request.getParameter("ReceiveAccount"));
    eBusMerchantCommonRequest.dicRequest.put("ReceiveAccName", request.getParameter("ReceiveAccName"));
    eBusMerchantCommonRequest.dicRequest.put("CurrencyCode", request.getParameter("CurrencyCode"));
    eBusMerchantCommonRequest.dicRequest.put("Details", request.getParameter("Details"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>