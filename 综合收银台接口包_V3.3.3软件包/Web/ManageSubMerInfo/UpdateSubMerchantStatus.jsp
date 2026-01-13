<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "UpdateSubMerchantStatus");
    eBusMerchantCommonRequest.dicRequest.put("SubMerId", request.getParameter("SubMerId"));
    eBusMerchantCommonRequest.dicRequest.put("UpdateFlag", request.getParameter("UpdateFlag"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>