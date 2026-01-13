<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "DownloadStatement");
    eBusMerchantCommonRequest.dicRequest.put("StatementDate", request.getParameter("StatementDate"));
    eBusMerchantCommonRequest.dicRequest.put("StatementType", request.getParameter("StatementType"));
    eBusMerchantCommonRequest.dicRequest.put("Zip", request.getParameter("Zip"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
