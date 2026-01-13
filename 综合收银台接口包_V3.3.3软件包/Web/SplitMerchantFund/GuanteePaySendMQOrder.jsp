<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "GuanteePaySendMQOrder");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo")); //支付订单号
    eBusMerchantCommonRequest.dicRequest.put("NewOrderNo", request.getParameter("NewOrderNo")); //担保确认交易编号
    eBusMerchantCommonRequest.dicRequest.put("AdvancedFund", request.getParameter("AdvancedFund")); //是否垫资
    eBusMerchantCommonRequest.dicRequest.put("SplitAccInfoItems", request.getParameter("SplitAccInfoItems"));    //平台商户当前分账情况
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>