<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "CheckSubMerAccDetail");
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantNo", request.getParameter("SubMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("StartDate", request.getParameter("StartDate"));
    eBusMerchantCommonRequest.dicRequest.put("EndDate", request.getParameter("EndDate"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>