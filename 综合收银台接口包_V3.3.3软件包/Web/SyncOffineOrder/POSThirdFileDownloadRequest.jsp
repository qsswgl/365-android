<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "SettlePOSThirdPartyStatement");
    eBusMerchantCommonRequest.dicRequest.put("SettleDate", request.getParameter("SettleDate"));               //对账单日期
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantNo", request.getParameter("SubMerchantNo"));     //二级商户号
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>