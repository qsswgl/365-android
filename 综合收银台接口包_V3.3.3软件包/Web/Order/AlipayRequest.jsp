<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.ebus.*" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    LinkedHashMap dicOrder = new LinkedHashMap();
    dicOrder.put("PayTypeID", request.getParameter("PayTypeID"));                   //设定交易类型
    dicOrder.put("ChildMerchantNo", request.getParameter("ChildMerchantNo"));      //子商户(大商户模式)
    dicOrder.put("OrderDate", request.getParameter("OrderDate"));                  //设定订单日期 （必要信息 - YYYY/MM/DD）
    dicOrder.put("OrderTime", request.getParameter("OrderTime"));                   //设定订单时间 （必要信息 - HH:MM:SS）
    dicOrder.put("OrderNo", request.getParameter("OrderNo"));                       //设定订单编号 （必要信息）
    dicOrder.put("CurrencyCode", request.getParameter("CurrencyCode"));             //设定交易币种
    dicOrder.put("OrderAmount", request.getParameter("OrderAmount"));      //设定交易金额
    dicOrder.put("SubsidyAmount", request.getParameter("SubsidyAmount"));            //设定交易金额
    dicOrder.put("ExpiredDate", request.getParameter("ExpiredDate"));               //设定订单保存时间
    dicOrder.put("AccountNo", request.getParameter("AccountNo"));                   //设定支付账户
    dicOrder.put("OrderDesc", request.getParameter("OrderDesc"));                   //设定订单说明
    dicOrder.put("ReceiverAddress", request.getParameter("ReceiverAddress"));       //收货地址
    dicOrder.put("BuyIP", request.getParameter("BuyIP"));                           //IP
    dicOrder.put("TerminalNo",request.getParameter("TerminalNo"));                  //设备终端号
    dicOrder.put("LimitPay", request.getParameter("LimitPay"));                      //限制贷记卡
    dicOrder.put("PC_QR_PAY_MODE", request.getParameter("PC_QR_PAY_MODE"));
    dicOrder.put("WAP_QUIT_URL", request.getParameter("WAP_QUIT_URL"));
    dicOrder.put("PC_QRCODE_WIDTH", request.getParameter("PC_QRCODE_WIDTH"));
    dicOrder.put("TIMEOUT_EXPRESS", request.getParameter("TIMEOUT_EXPRESS"));
    dicOrder.put("PAYED_RETURN_URL", request.getParameter("PAYED_RETURN_URL"));       //支付后回调地址
    dicOrder.put("SplitAccInfoItems", request.getParameter("SplitAccInfoItems"));    //平台商户当前分账情况
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AliPayOrderReq");
    eBusMerchantCommonRequest.dicRequest.put("PaymentType", request.getParameter("PaymentType"));            //设定支付类型
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));    //设定支付接入方式
    eBusMerchantCommonRequest.dicRequest.put("NotifyType", request.getParameter("NotifyType"));              //设定通知方式
    eBusMerchantCommonRequest.dicRequest.put("ResultNotifyURL", request.getParameter("ResultNotifyURL"));    //设定通知URL地址
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));    //设定附言
    eBusMerchantCommonRequest.dicRequest.put("IsBreakAccount", request.getParameter("IsBreakAccount"));      //设定交易是否支持向二级商户入账
    eBusMerchantCommonRequest.dicRequest.put("SplitAccTemplate", request.getParameter("SplitAccTemplate"));    //分账模版编号
    eBusMerchantCommonRequest.dicRequest.put("CommodityType", request.getParameter("CommodityType"));           //设置商品种类
    eBusMerchantCommonRequest.dicRequest.put("Order", dicOrder);
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>