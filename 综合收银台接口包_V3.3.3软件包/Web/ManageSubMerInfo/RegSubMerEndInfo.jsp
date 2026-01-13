<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.*" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
    eBusMerchantCommonRequest.dicRequest.put("TrxType", "RegSubMerEndInfo");
    eBusMerchantCommonRequest.dicRequest.put("SubMerchantNo", request.getParameter("SubMerchantNo"));
    eBusMerchantCommonRequest.dicRequest.put("ShopName", request.getParameter("ShopName"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceSource", request.getParameter("DeviceSource"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceType",request.getParameter("DeviceType"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceSeqId", request.getParameter("DeviceSeqId"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceManufacturer", request.getParameter("DeviceManufacturer"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceModel", request.getParameter("DeviceModel"));
    eBusMerchantCommonRequest.dicRequest.put("EnablePosition", request.getParameter("EnablePosition"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceAddress", request.getParameter("DeviceAddress"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceLongitude", request.getParameter("DeviceLongitude"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceLatitude", request.getParameter("DeviceLatitude"));
    eBusMerchantCommonRequest.dicRequest.put("DeviceState", request.getParameter("DeviceState"));
    JSON responseJson = eBusMerchantCommonRequest.postRequest();
    out.print(responseJson.getIJsonString());
%>
