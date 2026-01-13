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
 *    abc       2014/04/21      V3.0.0
 *
 */
-->


<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成身份验证请求对象
        com.abc.trustpay.client.ebus.TransferRequestSMS tRequest = new com.abc.trustpay.client.ebus.TransferRequestSMS();
        tRequest.dicRequest["RemitterSubMerchantNo"] = RemitterSubMerchantNo.Text; //子商户号
        tRequest.dicRequest["TransferNo"] = TransferNo.Text; //内外传流水号
        tRequest.dicRequest["MobileNo"] = MobileNo.Text;                    //手机号
        //3、传送身份验证请求并取得支付网址
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、身份验证请求提交成功，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
        }
        else
        {
            //5、身份验证请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();

    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-内外转短信验证</title>
</head>
<body style="font-size: 14px;">
    <center>
        内外转短信验证
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>转出子商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='RemitterSubMerchantNo' Text='' />转出子商户号，*必输</td>
            </tr>
            <tr>
                <td>内外传流水号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='TransferNo' Text='No123456789' />*必输</td>
            </tr>
            <tr>
                <td>手机号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='MobileNo' Text='13800000000' />*必输</td>
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
