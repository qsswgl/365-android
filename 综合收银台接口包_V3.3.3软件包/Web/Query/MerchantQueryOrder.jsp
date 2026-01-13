<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    String queryDetail = request.getParameter("QueryDetail");
    if (queryDetail.equals("0")) {
		queryDetail = "false";
    } else if (queryDetail.equals("1")) {
		queryDetail = "true";
    }
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "Query");
    eBusMerchantCommonRequest.dicRequest.put("PayTypeID", request.getParameter("PayTypeID"));    //设定交易类型
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));    //设定订单编号 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("QueryDetail", queryDetail);//设定查询方式
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>