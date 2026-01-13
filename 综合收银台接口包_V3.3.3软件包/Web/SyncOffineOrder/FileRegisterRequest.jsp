<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "FileRegister");
    eBusMerchantCommonRequest.dicRequest.put("BatchNo", request.getParameter("BatchNo"));
    eBusMerchantCommonRequest.dicRequest.put("BatchDate", request.getParameter("BatchDate"));
    eBusMerchantCommonRequest.dicRequest.put("FileContent", request.getParameter("FileContent"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>