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
 *    abchina       2014/04/21  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成订单撤销请求对象
        com.abc.trustpay.client.ebus.PayCancelRequest tRequest = new com.abc.trustpay.client.ebus.PayCancelRequest();
        tRequest.dicRequest["OrderNo"] = OrderNo.Text;   //订单号
        tRequest.dicRequest["SubMchNO"] = SubMchNO.Text;//二级商户号
        tRequest.dicRequest["ModelFlag"] = ModelFlag.Text;//商户模式
        tRequest.dicRequest["MerchantFlag"] = MerchantFlag.Text;//支付渠道


        //2、传送订单撤销请求并取得对账单
        tRequest.postJSONRequest();

        //3、判断结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        string OrderInfo = JSON.GetKeyValue("OrderInfo");
        
        //4、输出返回
        strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
        strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
        strMessage.Append("OrderInfo    = [" + OrderInfo + "]<br/>");
        lblMessage.ForeColor = System.Drawing.Color.Red;

        
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-商户订单撤销</title>
</head>
<body style="font-size: 14px;">
    <center>商户订单撤销</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单编号</td>
                <td>
                    <asp:TextBox runat="server" ID='OrderNo' Text='' /> *必输</td>
            </tr>
            <tr>
                <td>二级商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='SubMchNO' Text='1' /> 选输</td>
            </tr>
            <tr>
                <td>商户模式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ModelFlag' Text='1' /> 1:大商户模式，0：非大商户模式 *必输</td>
            </tr>
            <tr>
                <td>支付渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='MerchantFlag' Text='W' /> W:微信，Z：支付宝 *必输</td>
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
