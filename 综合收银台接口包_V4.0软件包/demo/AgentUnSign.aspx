<!--
/*
 * Project: 
 *
 * Description:
 *    商户接口范例。
 *
 * Modify Information:
 *    Author        Date        Description
 *    ============  ==========  =======================================
 *    abchina       2014/04/15  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成授权支付解约请求对象
        com.abc.trustpay.client.ebus.AgentUnSignRequest tRequest = new com.abc.trustpay.client.ebus.AgentUnSignRequest();
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;                         //订单编号（必要信息）
        tRequest.dicRequest["AgentSignNo"] = txtAgentSignNo.Text;                 //签约编号（必要信息）
        tRequest.dicRequest["RequestDate"] = txtRequestDate.Text;                 //验证请求日期 （必要信息 - YYYY/MM/DD）
        tRequest.dicRequest["RequestTime"] = txtRequestTime.Text;                 //验证请求时间 （必要信息 - HH:MM:SS）

        //2、传送授权支付解约请求
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //3、授权支付解约请求提交成功，获取返回信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
        }
        else
        {
            //4、授权支付解约请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-授权支付解约</title>
</head>
<body style="font-size: 14px;">
    <center>
        授权支付解约
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200905080001' />
                    *必输</td>
            </tr>
            <tr>
                <td>签约编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentSignNo' Text='1' /> *必输</td>
            </tr>
            <tr>
                <td>请求日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRequestDate' Text='2009/05/08' />
                    格式要求为YYYY/MM/DD *必输</td>
            </tr>
            <tr>
                <td>请求时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRequestTime' Text='09:10:10' />
                    格式为HH:MM:SS *必输</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交页面内容" OnClick="btnButton_Click" />
                    <a href='Merchant.html'>回商户首页</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
