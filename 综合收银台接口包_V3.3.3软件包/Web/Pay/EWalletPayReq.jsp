<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>

<%
    /*单商户模式下，默认使用第一个商户作为请求商户 */

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "EWalletPayReq");
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    eBusMerchantCommonRequest.dicRequest.put("OrderAmount", request.getParameter("OrderAmount"));
    eBusMerchantCommonRequest.dicRequest.put("OrderDesc", request.getParameter("OrderDesc"));
    eBusMerchantCommonRequest.dicRequest.put("OrderValidTime", request.getParameter("OrderValidTime"));
    eBusMerchantCommonRequest.dicRequest.put("Token", request.getParameter("Token"));
    eBusMerchantCommonRequest.dicRequest.put("ProductName", request.getParameter("ProductName"));
    eBusMerchantCommonRequest.dicRequest.put("PaymentType", request.getParameter("PaymentType"));
    eBusMerchantCommonRequest.dicRequest.put("PaymentLinkType", request.getParameter("PaymentLinkType"));
    eBusMerchantCommonRequest.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));
    eBusMerchantCommonRequest.dicRequest.put("NotifyType", request.getParameter("NotifyType"));
    eBusMerchantCommonRequest.dicRequest.put("ResultNotifyURL", request.getParameter("ResultNotifyURL"));

    /*单商户模式下，默认使用第一个商户作为请求商户*/
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    /**
     * 多商户模式下，需要使用如下方法，选择哪个商户作为请求商户
     *
     * JSON json = tPaymentRequest.extendPostRequest(1);
     *
     * */
    out.print(responseJson.getIJsonString());

%>
