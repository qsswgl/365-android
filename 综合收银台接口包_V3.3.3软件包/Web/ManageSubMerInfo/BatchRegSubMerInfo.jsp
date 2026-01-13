<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "BatchRegSubMerInfo");
    eBusMerchantCommonRequest.dicRequest.put("SubMerInfoFile", request.getParameter("SubMerInfoFile"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>