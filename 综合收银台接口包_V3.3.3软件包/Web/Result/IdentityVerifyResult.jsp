<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="com.abc.pay.client.ebus.*" %>
<%@ page import="java.net.URLDecoder" %>
<% response.setHeader("Cache-Control", "no-cache"); %>
<%
    //1、取得MSG参数，并利用此参数值生成验证结果对象

    String msg = URLDecoder.decode(request.getParameter("MSG"), "GBK");
    PaymentResult tResult = new PaymentResult(msg);
//2、判断验证结果状态，进行后续操作
    if (tResult.isSuccess()) {
        //3、验证成功
        out.println("户名         = [" + tResult.getValue("AccountName") + "]<br>");

    } else {
        //4、验证失败
        out.println("ReturnCode   = [" + tResult.getReturnCode() + "]<br>");
        out.println("ErrorMessage = [" + tResult.getErrorMessage() + "]<br>");
    }
%>