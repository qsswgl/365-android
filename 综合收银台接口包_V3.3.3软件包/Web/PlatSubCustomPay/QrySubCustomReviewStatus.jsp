<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "QrySubCustomReviewStatus");
    eBusMerchantCommonRequest.dicRequest.put("SubCustomNo", request.getParameter("SubCustomNo"));  //二级客户编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("SerialNo", request.getParameter("SerialNo")); //申请单号（必要信息）
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>