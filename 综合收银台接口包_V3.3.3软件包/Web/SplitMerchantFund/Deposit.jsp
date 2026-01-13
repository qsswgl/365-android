<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="java.util.LinkedHashMap" %>
<%

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    LinkedHashMap dicOrder = new LinkedHashMap();
    dicOrder.put("orderTimeoutDate", request.getParameter("orderTimeoutDate"));     //设定订单有效期
    dicOrder.put("OrderAmount", request.getParameter("OrderAmount"));      //设定交易金额
    dicOrder.put("OrderDesc", request.getParameter("OrderDesc"));                   //设定订单说明
    dicOrder.put("OrderNo", request.getParameter("OrderNo"));                   //设定订单说明
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "Deposit");
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));    //设定支付接入方式
    eBusMerchantCommonRequest.dicRequest.put("NotifyType", request.getParameter("NotifyType"));              //设定通知方式
    eBusMerchantCommonRequest.dicRequest.put("ResultNotifyURL", request.getParameter("ResultNotifyURL"));    //设定通知URL地址
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));    //设定附言
    eBusMerchantCommonRequest.dicRequest.put("ReceiveSubMerchantNo", request.getParameter("ReceiveSubMerchantNo")); //设定收款子商户号
	eBusMerchantCommonRequest.dicRequest.put("Order", dicOrder);
	JSON responseJson = eBusMerchantCommonRequest.postRequest();
	out.print(responseJson.getIJsonString());
%>