<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
        EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
        eBusMerchantCommonRequest.dicRequest.put("TrxType", "KPayVerifyReq");
        eBusMerchantCommonRequest.dicRequest.put("CardNo", request.getParameter("CardNo")); //支付账户
        eBusMerchantCommonRequest.dicRequest.put("MobileNo", request.getParameter("MobileNo"));//手机号后四位
        eBusMerchantCommonRequest.dicRequest.put("CommodityType", request.getParameter("CommodityType"));   //设置商品种类
        eBusMerchantCommonRequest.dicRequest.put("PaymentType", request.getParameter("PaymentType"));          //设定支付类型
        eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));      //设定支付接入方式
        eBusMerchantCommonRequest.dicRequest.put("ReceiveAccount", request.getParameter("ReceiveAccount"));    //设定收款方账号
        eBusMerchantCommonRequest.dicRequest.put("ReceiveAccName", request.getParameter("ReceiveAccName"));    //设定收款方户名
        eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));    //设定附言
        eBusMerchantCommonRequest.dicRequest.put("IsBreakAccount", request.getParameter("IsBreakAccount"));    //设定交易是否分账
        eBusMerchantCommonRequest.dicRequest.put("SplitAccTemplate", request.getParameter("SplitAccTemplate"));      //分账模版编号
        eBusMerchantCommonRequest.dicRequest.put("Installment", request.getParameter("Installment"));  //分期标识
        if (request.getParameter("Installment").toString().equals("1"))
        {
                eBusMerchantCommonRequest.dicRequest.put("ProjectID", request.getParameter("ProjectID"));    //设定分期代码
                eBusMerchantCommonRequest.dicRequest.put("Period", request.getParameter("Period"));    //设定分期期数
        }
        LinkedHashMap dicOrder = new LinkedHashMap();
        dicOrder.put("PayTypeID", request.getParameter("PayTypeID"));    //设定交易类型
        dicOrder.put("OrderDate", request.getParameter("OrderDate"));                   //设定订单日期 （必要信息 - YYYY/MM/DD）
        dicOrder.put("OrderTime", request.getParameter("OrderTime"));                   //设定订单时间 （必要信息 - HH:MM:SS）
        dicOrder.put("orderTimeoutDate", request.getParameter("orderTimeoutDate"));                     //设定订单有效期
        dicOrder.put("OrderNo", request.getParameter("OrderNo"));                       //设定订单编号 （必要信息）
        dicOrder.put("CurrencyCode", request.getParameter("CurrencyCode"));    //设定交易币种
        dicOrder.put("OrderAmount", request.getParameter("OrderAmount"));    //设定交易金额
        dicOrder.put("Fee", request.getParameter("Fee")); //设定手续费金额
        dicOrder.put("OrderDesc", request.getParameter("OrderDesc"));                   //设定订单说明
        dicOrder.put("ReceiverAddress", request.getParameter("ReceiverAddress"));     //收货地址
        dicOrder.put("BuyIP", request.getParameter("BuyIP"));                           //IP
        dicOrder.put("ExpiredDate", request.getParameter("ExpiredDate"));//设定订单保存时间
        dicOrder.put("OrderItems",request.getParameter("OrderItems"));
        eBusMerchantCommonRequest.dicRequest.put("Order", dicOrder);
        JSON responseJson = eBusMerchantCommonRequest.postRequest();
        out.print(responseJson.getIJsonString());
%>