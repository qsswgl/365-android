<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "AgentPay");

    eBusMerchantCommonRequest.dicRequest.put("OrderDate", request.getParameter("OrderDate"));                   //设定订单日期 （必要信息 - YYYY/MM/DD）
    eBusMerchantCommonRequest.dicRequest.put("OrderTime", request.getParameter("OrderTime"));                   //设定订单时间 （必要信息 - HH:MM:SS）
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));                       //设定订单编号 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("AgentSignNo", request.getParameter("AgentSignNo"));                       //设定授权支付协议号 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("CardNo", request.getParameter("CardNo"));                       //设定账号
    eBusMerchantCommonRequest.dicRequest.put("CurrencyCode", request.getParameter("CurrencyCode"));    //设定交易币种 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("Amount", request.getParameter("Amount"));    //设定交易金额 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("SubsidyAmount", request.getParameter("SubsidyAmount"));    //设定交易金额 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("ReceiverAddress", request.getParameter("ReceiverAddress")); //设定手续费金额
    eBusMerchantCommonRequest.dicRequest.put("Fee", request.getParameter("Fee")); //设定手续费金额
    eBusMerchantCommonRequest.dicRequest.put("SubsidyAmount", request.getParameter("SubsidyAmount")); //设定补贴金额
    eBusMerchantCommonRequest.dicRequest.put("CertificateNo", request.getParameter("CertificateNo"));             //证件号码
    eBusMerchantCommonRequest.dicRequest.put("InstallmentMark", request.getParameter("InstallmentMark"));  //分期标识（必要信息）
    if ("1".equals(request.getParameter("InstallmentMark"))) {
        eBusMerchantCommonRequest.dicRequest.put("InstallmentCode", request.getParameter("InstallmentCode"));    //设定分期代码
        eBusMerchantCommonRequest.dicRequest.put("InstallmentNum", request.getParameter("InstallmentNum"));    //设定分期期数
    }
    eBusMerchantCommonRequest.dicRequest.put("CommodityType", request.getParameter("CommodityType"));   //设置商品种类 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));      //设定支付接入方式 （必要信息）
    eBusMerchantCommonRequest.dicRequest.put("BuyIP", request.getParameter("BuyIP"));
    eBusMerchantCommonRequest.dicRequest.put("ExpiredDate", request.getParameter("ExpiredDate"));//设定订单保存时间
    eBusMerchantCommonRequest.dicRequest.put("ReceiveAccount", request.getParameter("ReceiveAccount"));    //设定收款方账号
    eBusMerchantCommonRequest.dicRequest.put("ReceiveAccName", request.getParameter("ReceiveAccName"));    //设定收款方户名
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));    //设定附言
    eBusMerchantCommonRequest.dicRequest.put("IsBreakAccount", request.getParameter("IsBreakAccount"));    //设定交易是否分账
    eBusMerchantCommonRequest.dicRequest.put("SplitAccTemplate", request.getParameter("SplitAccTemplate"));      //分账模版编号
    eBusMerchantCommonRequest.dicRequest.put("SplitAccInfoItems", request.getParameter("SplitAccInfoItems"));

    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());


%>