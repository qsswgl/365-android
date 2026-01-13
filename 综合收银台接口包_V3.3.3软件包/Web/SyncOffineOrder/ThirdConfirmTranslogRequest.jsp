<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "ThirdConfirmTranslog");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("BatchNo", request.getParameter("BatchNo"));
    eBusMerchantCommonRequest.dicRequest.put("SplitAccInfoItems", request.getParameter("SplitAccInfoItems"));
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));

    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>