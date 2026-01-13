<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    /*单商户模式下，默认使用第一个商户作为请求商户 */

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "EntrustSignConfirm");
    eBusMerchantCommonRequest.dicRequest.put("SignNo", request.getParameter("SignNo"));
    eBusMerchantCommonRequest.dicRequest.put("VerificationCode", request.getParameter("VerificationCode"));

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
