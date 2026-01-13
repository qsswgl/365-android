<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.ebus.*" %>
<%@ page import="java.net.URLDecoder" %>
<% response.setHeader("Cache-Control", "no-cache"); %>
<%
    //1、取得MSG参数，并利用此参数值生成验证结果对象
    String msg = URLDecoder.decode(request.getParameter("MSG"), "GBK");
    AgentSignResult tResult = new AgentSignResult(msg);
//2、判断验证结果状态，进行后续操作
    if (tResult.isSuccess()) {
        //3、签约解约成功
        if (tResult.getValue("TrxType").equals(TrxType.TRX_TYPE_EBUS_AGENT_SIGN.toUpperCase())) {
            out.println("签约成功<br>");
            out.println("签约协议号: [" + tResult.getValue("AgentSignNo") + "]<br>");
            out.println("签约卡号后4位: [" + tResult.getValue("Last4CardNo") + "]<br>");
        } else if (tResult.getValue("TrxType").equals(TrxType.TRX_TYPE_AGENT_UNSIGN.toUpperCase())) {
            out.println("解约成功<br>");
        }
        out.println("OrderNo         = [" + tResult.getValue("OrderNo") + "]<br>");

    } else {
        //4、签约解约失败
        out.println("ReturnCode   = [" + tResult.getReturnCode() + "]<br>");
        out.println("ErrorMessage = [" + tResult.getErrorMessage() + "]<br>");
    }
%>