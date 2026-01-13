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
 *    abchina       2017/04/11  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        StringBuilder strMessage = new StringBuilder("");

        //1、生成支付请求对象
        com.abc.trustpay.client.ebus.DownloadStatement tMerchantInfo = new com.abc.trustpay.client.ebus.DownloadStatement();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["StatementDate"] = txtStatementDate.Text;
        tMerchantInfo.merchantInfoRequest["StatementType"] = txtStatementType.Text;
        tMerchantInfo.merchantInfoRequest["Zip"] = txtZip.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("MD5HashedStatement = [" + JSON.GetKeyValue("MD5HashedStatement") + "]<br/>");
        }
        else
        {
            //6、请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }

        lblMessage.Text = strMessage.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-大文件对账单下载</title>
</head>

<script language="javascript">
    function formatIndex(index) {
        if (index < 10)
            return "00" + index;
        else if (index >= 10 && index < 100)
            return "0" + index;
        else
            return index;
    }
    function submitFun() {
        form1.submit();
    }
</script>

<body style="font-size: 14px;">
    <center>
        大文件对账单下载
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>对账单日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtStatementDate' value='2022/02/22' />*必输 对账单日期，YYYY/MM/DD</td>
            </tr>
            <tr>
                <td>对账单类型</td>
                <td>
                    <asp:DropDownList ID="txtStatementType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="ABCPAY" Selected="True">农行对账单</asp:ListItem>
                        <asp:ListItem Value="WXALIPAY">微信支付宝对账单</asp:ListItem>
                        <asp:ListItem Value="TRANSFERPAY">内转出金对账单</asp:ListItem>
                        <asp:ListItem Value="PLATFORMPAY">平台商户对账单</asp:ListItem>
                    </asp:DropDownList>
                    *必输
                </td>
            </tr>
            <tr>
                <td>压缩标识</td>
                <td>
                    <asp:DropDownList ID="txtZip" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="0" Selected="True">不压缩</asp:ListItem>
                        <asp:ListItem Value="1">压缩</asp:ListItem>
                    </asp:DropDownList>
                    *必输
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交" OnClick="btnButton_Click" /></td>
            </tr>
        </table>
    </form>
    <a href='Merchant.html'>回商户首页</a>
</body>
</html>
