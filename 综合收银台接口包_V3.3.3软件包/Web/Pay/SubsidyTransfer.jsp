<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "SubsidyTransfer");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("RemitterSubMerchantNo", request.getParameter("RemitterSubMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("RemitteeSubMerchantNo", request.getParameter("RemitteeSubMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("Amount", request.getParameter("Amount"));
    eBusMerchantCommonRequest.dicRequest.put("InternalTransferNo", request.getParameter("InternalTransferNo"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
