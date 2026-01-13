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
 *    abchina       2014/04/15  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成授权支付签约请求对象
        com.abc.trustpay.client.ebus.FundTransferApplyQuery tRequest = new com.abc.trustpay.client.ebus.FundTransferApplyQuery();
        tRequest.fundTransferApplyQuery["SerialNumber"] = txtSerialNumber.Text;               //序号       （必要信息）
        
        //2、传送授权支付签约请求并取得签约网址
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode      = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + ErrorMessage + "]<br/>");
            strMessage.Append("ApprovalStatus      = [" + JSON.GetKeyValue("ApprovalStatus") + "]<br/>");
            //Response.Redirect(JSON.GetKeyValue("EntrustSignRequestURL"));
        }
        else
        {
            //4、授权支付签约请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>"); 
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-资金划拨申请结果查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        资金划拨申请结果查询
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>序号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSerialNumber' Text='111' />
                    *必输
                </td>
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
