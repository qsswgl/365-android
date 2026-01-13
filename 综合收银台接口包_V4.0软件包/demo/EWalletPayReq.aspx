<!--
/*
 * Project: BJP09001
 *
 * Description:
 *    数字人民币主扫交易
 *
 * Modify Information:
 *    Author        Date        Description
 *    ============  ==========  =======================================
 *    abchina       2022/03/15  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成请求对象
        com.abc.trustpay.client.ebus.EWalletPayReqRequest tRequest = new com.abc.trustpay.client.ebus.EWalletPayReqRequest();
        //2、生成定单订单对象
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;                       
        tRequest.dicRequest["OrderAmount"] = txtOrderAmount.Text;                   
        tRequest.dicRequest["OrderDesc"] = txtOrderDesc.Text;
        tRequest.dicRequest["OrderValidTime"] = txtOrderValidTime.Text;
        tRequest.dicRequest["Token"] = txtToken.Text;
        tRequest.dicRequest["ProductName"] = txtProductName.Text;
        tRequest.dicRequest["PaymentType"] = txtPaymentType.Text;
        tRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;
        tRequest.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;
        tRequest.dicRequest["NotifyType"] = txtNotifyType.Text;
        tRequest.dicRequest["ResultNotifyURL"] = txtResultNotifyURL.Text;   

        //3、传送请求
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、请求提交成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
        }
        else
        {
            //5、请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<script language="javascript" type="text/javascript">
</script>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-数字人民币主扫交易</title>
</head>
<body style="font-size: 14px;">
    <center>
        数字人民币主扫交易
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='Test20220310001' />*必输</td>
            </tr>
            <tr>
                <td>交易金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAmount' Text='2.15' />保留小数点后两位数字，*必输</td>
            </tr>
            <tr>
                <td>交易详情
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDesc' Text='数字人民币主扫交易测试' />*必输</td>
            </tr>
            <tr>
                <td>交易有效时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderValidTime' Text='170000' />*必输</td>
            </tr>
            <tr>
                <td>Token
                </td>
                <td>
                     <asp:TextBox runat="server" ID='txtToken' Text='' />选输</td>
            </tr>
            <tr>
                <td>商品名称
                </td>
                <td>
                     <asp:TextBox runat="server" ID='txtProductName' Text='测试商品' />*必输</td>
            </tr>
            <tr>
                <td>支付类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentType' Text='D' />*必输</td>
            </tr>
            <tr>
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='2' />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
            </tr>
            <tr>
                <td>商户备注
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />选输</td>
            </tr>
            <tr>
                <td>通知方式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyType' Text='1' />0：URL页面通知 1：服务器通知，*必输</td>
            </tr>
            <tr>
                <td>通知URL地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtResultNotifyURL' Text='http://127.0.0.1/Merchant/MerchantResult.aspx' />*必输</td>
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
