<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.abc.pay.client.ebus.common.EBusMerchantCommonRequest" %>
<%@ page import="com.abc.pay.client.JSON" %>
<%
    EBusMerchantCommonRequest eBusMerchantCommonRequest = new EBusMerchantCommonRequest();
	eBusMerchantCommonRequest.dicRequest.put("TrxType", "InternalTransfer");
    eBusMerchantCommonRequest.dicRequest.put("InternalTransferNo", request.getParameter("InternalTransferNo"));  //交易流水号
    eBusMerchantCommonRequest.dicRequest.put("RemitterSubMerchantNo", request.getParameter("RemitterSubMerchantNo"));  //转出方子商户编号
    eBusMerchantCommonRequest.dicRequest.put("RemitteeSubMerchantNo", request.getParameter("RemitteeSubMerchantNo"));  //转入方子商户编号
    eBusMerchantCommonRequest.dicRequest.put("Amount", request.getParameter("Amount"));      //转账金额
    eBusMerchantCommonRequest.dicRequest.put("Remark", request.getParameter("Remark"));      //附言
	JSON responseJson = eBusMerchantCommonRequest.postRequest();
	out.print(responseJson.getIJsonString());
%>