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
 *    abchina       2009/06/02  V2.0.1 Release
 *
 */
-->

<%@ Page Language="C#" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    
    protected void btnSign_Click(object sender, EventArgs e)
    {
        txtMessage.Text = com.abc.util.SignTools.Sign(txtSource.Text);
    }

    protected void btnUnSign_Click(object sender, EventArgs e)
    {
        txtMessage.Text = com.abc.util.SignTools.UnSign(txtSource.Text).ToString();
    }

    protected void btnToBase64_Click(object sender, EventArgs e)
    {
        txtMessage.Text = Convert.ToBase64String(Encoding.GetEncoding("gb2312").GetBytes(txtSource.Text));
    }

    protected void btnFromBase64_Click(object sender, EventArgs e)
    {
        txtMessage.Text = Encoding.GetEncoding("gb2312").GetString(Convert.FromBase64String(txtSource.Text));
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口示例-签名验签</title>
</head>
<body style="font-size: 14px;">
    <center>
       <b>签名验签</b>
    </center>
    <form id="form1" runat="server">
        <table>
            <tr>
                <td>
                    原始数据：<br />
                    <asp:TextBox ID="txtSource" runat="server" TextMode="MultiLine" Width="500px" Rows="5" />
                    <br />
                    结果：<br />
                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Width="500px" Rows="5" />
                    <br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnSign" runat="server" Text="签名" OnClick="btnSign_Click" />
                    <asp:Button ID="btnUnSign" runat="server" Text="验签" OnClick="btnUnSign_Click" />
                    <asp:Button ID="btnToBase64" runat="server" Text="Base64编码" OnClick="btnToBase64_Click" />
                    <asp:Button ID="btnFromBase64" runat="server" Text="Base64解码" OnClick="btnFromBase64_Click" />
                    <a href='../Merchant.html'>回商户首页</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
