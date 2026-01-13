<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "MigrateSubMerToOtherSubject");
    eBusMerchantCommonRequest.dicRequest.put("FromMerchantNo", request.getParameter("FromMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("FromSubMerchantNo", request.getParameter("FromSubMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("CustomToSubMerchantNo", request.getParameter("CustomToSubMerchantNo"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
