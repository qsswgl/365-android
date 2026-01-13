<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    /*单商户模式下，默认使用第一个商户作为请求商户 */

    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();

    eBusMerchantCommonRequest.dicRequest.put("TrxType", "EntrustUnSign");
    eBusMerchantCommonRequest.dicRequest.put("SignNo", request.getParameter("SignNo"));
    eBusMerchantCommonRequest.dicRequest.put("OrderNo", request.getParameter("OrderNo"));

    /*单商户模式下，默认使用第一个商户作为请求商户*/

    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());

%>
