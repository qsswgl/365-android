<!--
/*
 * Project: BJP09001
 *
 * Description:
 *    商户接口范例。
 *
 * Modify Information:
 *    Author        Date        Description
 *    ============  ==========  =======================================
 *    abchina       2014/04/18  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {

        //1、生成签约/解约结果查询请求对象
        com.abc.trustpay.client.ebus.QueryAgentSignRequest tRequest = new com.abc.trustpay.client.ebus.QueryAgentSignRequest();
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;  //交易编号          （必要信息）

        //2、传送签约/解约结果查询请求并取得订单查询结果
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder();
        //3、判断签约/解约结果查询结果状态，进行后续操作
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、获取结果信息
            strMessage.Append("ReturnCode      = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType      = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("MerchantNo      = [" + JSON.GetKeyValue("MerchantNo") + "]<br/>");
            strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
            strMessage.Append("AgentSignNo      = [" + JSON.GetKeyValue("AgentSignNo") + "]<br/>");
            strMessage.Append("CertificateNo      = [" + JSON.GetKeyValue("CertificateNo") + "]<br/>");
            strMessage.Append("CertificateType      = [" + JSON.GetKeyValue("CertificateType") + "]<br/>");
            strMessage.Append("Last4CardNo      = [" + JSON.GetKeyValue("Last4CardNo") + "]<br/>");
            strMessage.Append("SignDate      = [" + JSON.GetKeyValue("SignDate") + "]<br/>");
            strMessage.Append("UnSignDate      = [" + JSON.GetKeyValue("UnSignDate") + "]<br/>");
            strMessage.Append("AgentSignStatus      = [" + JSON.GetKeyValue("AgentSignStatus") + "]<br/>");
            strMessage.Append("AccountType      = [" + JSON.GetKeyValue("AccountType") + "]<br/>");
            strMessage.Append("PaymentLinkType      = [" + JSON.GetKeyValue("PaymentLinkType") + "]<br/>");


        }
        else
        {
            //5、签约/解约查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br>");
        }
        lblMessage.Text = strMessage.ToString();
    }
</script>


<html xmlns="http://www.w3.org/1999/xhtml">

<head><title>农行网上支付平台-商户接口范例-签约/解约结果查询</title></head>

<body style="font-size: 14px;">
    <center>签约/解约结果查询</center>
    <form name='form1' runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <table>
            <tr>
                <td>签约/解约申请编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200306300001' />*必输</td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="btnButton" runat="server" Text="提交页面内容" OnClick="btnButton_Click" />

                </td>
            </tr>
        </table>
    </form>
    <center><a href='Merchant.html'>回商户首页</a></center>
</body>
</html>
