<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.SubEWalletPay" %>
<%
    /*单商户模式下，默认使用第一个商户作为请求商户 */

    SubEWalletPay subEWalletPay = new SubEWalletPay();

    subEWalletPay.dicRequest.put("TrxType", "SubEWalletPayForOutter");
    subEWalletPay.dicRequest.put("OrderNo", request.getParameter("OrderNo"));
    subEWalletPay.dicRequest.put("Token", request.getParameter("Token"));
    subEWalletPay.dicRequest.put("OrderAmount", request.getParameter("OrderAmount"));
    subEWalletPay.dicRequest.put("OrderDesc", request.getParameter("OrderDesc"));
    subEWalletPay.dicRequest.put("MerchantRemarks", request.getParameter("MerchantRemarks"));



    /*单商户模式下，默认使用第一个商户作为请求商户*/
    JSON responseJson = subEWalletPay.postRequest();
    /**
     * 多商户模式下，需要使用如下方法，选择哪个商户作为请求商户
     *
     * JSON json = tPaymentRequest.extendPostRequest(1);
     *
     * */

    out.print(responseJson.getIJsonString());

%>
