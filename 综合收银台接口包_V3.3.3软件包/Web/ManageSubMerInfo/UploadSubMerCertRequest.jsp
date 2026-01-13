<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "UploadSubMerCert");
    eBusMerchantCommonRequest.dicRequest.put("SubMerNo", request.getParameter("SubMerNo"));
    eBusMerchantCommonRequest.dicRequest.put("Flag", request.getParameter("Flag"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerCertFile", request.getParameter("SubMerCertFile"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
