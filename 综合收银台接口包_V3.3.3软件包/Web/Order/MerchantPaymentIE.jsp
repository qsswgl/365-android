<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.PaymentRequest" %>
<%
    request.setCharacterEncoding("gb2312");
    response.setHeader("Cache-Control", "no-cache");
%>
<%
    PaymentRequest tPaymentRequest = new PaymentRequest();
    tPaymentRequest.dicOrder.put("PayTypeID", request.getParameter("PayTypeID"));                   //设定交易类型
    tPaymentRequest.dicOrder.put("OrderDate", request.getParameter("OrderDate"));                  //设定订单日期 （必要信息 - YYYY/MM/DD）
    tPaymentRequest.dicOrder.put("OrderTime", request.getParameter("OrderTime"));                   //设定订单时间 （必要信息 - HH:MM:SS）
    tPaymentRequest.dicOrder.put("orderTimeoutDate", request.getParameter("orderTimeoutDate"));     //设定订单有效期
    tPaymentRequest.dicOrder.put("OrderNo", request.getParameter("OrderNo"));                       //设定订单编号 （必要信息）
    tPaymentRequest.dicOrder.put("CurrencyCode", request.getParameter("CurrencyCode"));             //设定交易币种
    tPaymentRequest.dicOrder.put("OrderAmount", request.getParameter("PaymentRequestAmount"));      //设定交易金额
    tPaymentRequest.dicOrder.put("Fee", request.getParameter("Fee"));                               //设定手续费金额
    tPaymentRequest.dicOrder.put("AccountNo", request.getParameter("AccountNo"));                   //设定支付账户
    tPaymentRequest.dicOrder.put("OrderDesc", request.getParameter("OrderDesc"));                   //设定订单说明
    tPaymentRequest.dicOrder.put("OrderURL", request.getParameter("OrderURL"));                     //设定订单地址
    tPaymentRequest.dicOrder.put("ReceiverAddress", request.getParameter("ReceiverAddress"));       //收货地址
    tPaymentRequest.dicOrder.put("InstallmentMark", request.getParameter("InstallmentMark"));       //分期标识
    if (request.getParameter("InstallmentMark") == "1" && request.getParameter("PayTypeID") == "DividedPay") {
        tPaymentRequest.dicOrder.put("InstallmentCode", request.getParameter("InstallmentCode"));   //设定分期代码
        tPaymentRequest.dicOrder.put("InstallmentNum", request.getParameter("InstallmentNum"));     //设定分期期数
    }
    tPaymentRequest.dicOrder.put("CommodityType", request.getParameter("CommodityType"));           //设置商品种类
    tPaymentRequest.dicOrder.put("BuyIP", request.getParameter("BuyIP"));                           //IP
    tPaymentRequest.dicOrder.put("ExpiredDate", request.getParameter("ExpiredDate"));               //设定订单保存时间
    tPaymentRequest.dicOrder.put("OrderItems", request.getParameter("OrderItems"));               //设定产品名称
    String paymentType = request.getParameter("PaymentType");
    tPaymentRequest.dicRequest.put("PaymentType", paymentType);            //设定支付类型
    String paymentLinkType = request.getParameter("PaymentLinkType");
    tPaymentRequest.dicRequest.put("PaymentLinkType", paymentLinkType);    //设定支付接入方式
    if (paymentType.equals(Constants.PAY_TYPE_UCBP) && paymentLinkType.equals(Constants.PAY_LINK_TYPE_MOBILE)) {
        tPaymentRequest.dicOrder.put("UnionPayLinkType", request.getParameter("UnionPayLinkType"));  //当支付类型为6，支付接入方式为2的条件满足时，需要设置银联跨行移动支付接入方式
    }
    tPaymentRequest.dicRequest.put("ReceiveAccount", request.getParameter("ReceiveAccount"));    //设定收款方账号
    tPaymentRequest.dicRequest.put("ReceiveAccName", request.getParameter("ReceiveAccName"));    //设定收款方户名
    tPaymentRequest.dicRequest.put("NotifyType", request.getParameter("NotifyType"));    //设定通知方式
    tPaymentRequest.dicRequest.put("ResultNotifyURL", request.getParameter("ResultNotifyURL"));    //设定通知URL地址
    tPaymentRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));    //设定附言
    tPaymentRequest.dicRequest.put("IsBreakAccount", request.getParameter("IsBreakAccount"));    //设定交易是否分账
    tPaymentRequest.dicRequest.put("SplitAccTemplate", request.getParameter("SplitAccTemplate"));      //分账模版编号
    MerchantPara para = MerchantConfig.getUniqueInstance().getPara();
    String sTrustPayIETrxURL = para.getTrustPayTrxIEURL();
    String sErrorUrl = para.getMerchantErrorURL();
    String tSignature = "";
    try {
        tSignature = tPaymentRequest.genSignature(1);
    } catch (TrxException e) {
        request.setAttribute("tReturnCode", e.getCode());
        request.setAttribute("tErrorMsg", e.getMessage());
        request.getRequestDispatcher("/ErrorPageInternal.jsp").forward(request, response);
        return;
    }
%>

<html>
<meta charset="gb2312">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
<link rel="stylesheet" type="text/css" href="../../css/semantic.css">
<script src="../../js/jquery.min.js"></script>
<script src="../../js/semantic.js"></script>
<script src="../../js/util.js"></script>
<body>
<div class="main ui container" style="padding-top: 100px; padding-bottom: 100px">
    <form name="form"  type="hidden" method="post" action="<%=sTrustPayIETrxURL%>">
        <input type="hidden" name="MSG" value="<%=tSignature%>">
        <input type="hidden" name="errorPage" value="<%=sErrorUrl%>">
    </form>
</div>
</body>
<script language="javascript" type="text/javascript">
    $(function () {
        $("form[name='form']").submit();
    })
</script>
</html>