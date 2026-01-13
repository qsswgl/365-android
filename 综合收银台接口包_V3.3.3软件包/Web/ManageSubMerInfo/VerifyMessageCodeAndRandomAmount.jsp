<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "VerifyMessageCodeAndRandomAmount");
    eBusMerchantCommonRequest.dicRequest.put("VerificationCode", request.getParameter("VerificationCode"));
    eBusMerchantCommonRequest.dicRequest.put("RandomAmount", request.getParameter("RandomAmount"));
    eBusMerchantCommonRequest.dicRequest.put("Account", request.getParameter("Account"));
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantNo", request.getParameter("SubMerchantNo"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>

