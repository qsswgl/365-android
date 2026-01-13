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

        //1、生成鉴权交易查询请求对象
        com.abc.trustpay.client.ebus.QueryAuthenMerchant tRequest = new com.abc.trustpay.client.ebus.QueryAuthenMerchant();
        tRequest.dicRequest["TransferNo"] = TransferNo.Text;   //鉴权订单编号 （必要信息）


        //2、传送鉴权交易查询请求并取得结果信息
        tRequest.postJSONRequest();

        //3、判断鉴权交易查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        
        if (ReturnCode.Equals("0000"))
        {
            //4、鉴权交易查询成功，生成对账单对象
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            //strMessage.Append("TrxType      = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            //strMessage.Append("SettleDate      = [" + JSON.GetKeyValue("SettleDate") + "]<br/>");

            strMessage.Append("Status = [" + JSON.GetKeyValue("Status") + "]  (0000成功 99失败 ZY状态未知)<br/>");


        }
        else
        {
            //6、鉴权交易查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-鉴权交易查询接口</title>
    <style type="text/css">
        .auto-style1
        {
            height: 55px;
        }
    </style>
</head>
<body style="font-size: 14px;">
    <center style="width: 352px; height: 16px">
        鉴权交易查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>鉴权订单编号</td>
                <td>
                    <asp:TextBox runat="server" ID='TransferNo' Text='' Width="228px" />*必输</td>
            </tr>
            <tr>
                <td colspan="2" class="auto-style1">
                    <asp:Button ID="btnButton" runat="server" Text="提交页面内容" OnClick="btnButton_Click" />
                    <a href='Merchant.html'>回商户首页</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

