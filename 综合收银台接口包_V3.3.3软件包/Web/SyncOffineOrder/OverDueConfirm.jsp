<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "OverDueConfirm");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("NewOrderNo", request.getParameter("NewOrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerId", request.getParameter("SubMerId"));
    eBusMerchantCommonRequest.dicRequest.put("OrderAmount", request.getParameter("OrderAmount"));
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>