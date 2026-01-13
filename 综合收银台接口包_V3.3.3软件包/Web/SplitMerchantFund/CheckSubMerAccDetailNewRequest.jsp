<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "CheckSubMerAccDetailNew");
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantNo", request.getParameter("SubMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("AccDate", request.getParameter("AccDate"));
    eBusMerchantCommonRequest.dicRequest.put("NumEntryRec", request.getParameter("NumEntryRec"));
    eBusMerchantCommonRequest.dicRequest.put("JrnNo", request.getParameter("JrnNo"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>