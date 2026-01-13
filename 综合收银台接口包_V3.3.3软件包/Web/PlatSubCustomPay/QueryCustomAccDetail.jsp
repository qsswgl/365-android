<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "QueryCustomAccDetail");
    eBusMerchantCommonRequest.dicRequest.put("SubCustomNo", request.getParameter("SubCustomNo"));  //二级客户编号（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("AccDate", request.getParameter("AccDate")); //会计日期（必要信息）
    eBusMerchantCommonRequest.dicRequest.put("JrnNo", request.getParameter("JrnNo")); //续查日志号
    eBusMerchantCommonRequest.dicRequest.put("NumEntryRec", request.getParameter("NumEntryRec")); //翻页查询页码
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>