<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "QueryTrnxRecords");
    eBusMerchantCommonRequest.dicRequest.put("SettleDate", request.getParameter("SettleDate"));  //查询日期YYYY/MM/DD （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("SettleStartHour", request.getParameter("SettleStartHour"));  //查询开始时间段（0-23）
    eBusMerchantCommonRequest.dicRequest.put("SettleEndHour", request.getParameter("SettleEndHour"));  //查询截止时间段（0-23）
    eBusMerchantCommonRequest.dicRequest.put("ZIP", request.getParameter("ZIP"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());

%>