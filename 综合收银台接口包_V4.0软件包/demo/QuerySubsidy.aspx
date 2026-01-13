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
 *    abchina       2014/03/05  V3.0.0 Release
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    protected void btnButton_Click(object sender, EventArgs e)
    {

        com.abc.trustpay.client.ebus.QuerySubsidy tQuerySubsidy = new com.abc.trustpay.client.ebus.QuerySubsidy();

        //1.设定请求支付对象
        tQuerySubsidy.dicRequest["InternalTransferNo"] = InternalTransferNo.Text;

        //2、传送支付请求并取得支付网址
        tQuerySubsidy.postJSONRequest();

        StringBuilder strMessage = new StringBuilder();
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("ResultCode = [" + JSON.GetKeyValue("ResultCode") + "]<br/>");
            strMessage.Append("ResultMessage = [" + JSON.GetKeyValue("ResultMessage") + "]<br/>");
            strMessage.Append("OriginalOrderNo = [" + JSON.GetKeyValue("OriginalOrderNo") + "]<br/>");
            strMessage.Append("TransType = [" + JSON.GetKeyValue("TransType") + "]<br/>");
            strMessage.Append("AccDate = [" + JSON.GetKeyValue("AccDate") + "]<br/>");
            strMessage.Append("JrnNo = [" + JSON.GetKeyValue("JrnNo") + "]<br/>");
            strMessage.Append("Amount = [" + JSON.GetKeyValue("Amount") + "]<br/>");
            //支付请求提交成功，将客户端导向支付页面
            //Response.Redirect(JSON.GetKeyValue("PaymentURL"));
        }
        else
        {
            //3、支付请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<script language="javascript" type="text/javascript">  
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-补贴查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        补贴查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>

            <tr>
                <td>内转号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='InternalTransferNo' Text='1009010' />*必输</td>
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
