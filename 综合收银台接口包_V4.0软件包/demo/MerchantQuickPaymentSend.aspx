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
 *    abchina       2014/04/04  Create V3.0.0 
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成支付请求对象
        com.abc.trustpay.client.ebus.QuickPaymentSend tQuickPaymentSend = new com.abc.trustpay.client.ebus.QuickPaymentSend();

        tQuickPaymentSend.dicOrder["OrderNo"] = txtOrderNo.Text;                       //设定订单编号 （必要信息）
        tQuickPaymentSend.dicOrder["CurrencyCode"] = txtCurrencyCode.Text;    //设定交易币种，
        tQuickPaymentSend.dicOrder["OrderAmount"] = txtOrderAmount.Text; //设定订单金额 （必要信息）
        tQuickPaymentSend.dicOrder["Fee"] = txtFee.Text; //设定手续费金额
        tQuickPaymentSend.dicOrder["OrderDate"] = txtOrderDate.Text;                   //设定订单日期 （必要信息 - YYYY/MM/DD）
        tQuickPaymentSend.dicOrder["OrderTime"] = txtOrderTime.Text;                   //设定订单时间 （必要信息 - HH:MM:SS）

        tQuickPaymentSend.dicRequest["AccName"] = txtAccName.Text;
        tQuickPaymentSend.dicRequest["CertificateType"] = txtCertificateType.Text;
        tQuickPaymentSend.dicRequest["CertificateID"] = txtCertificateID.Text;
        tQuickPaymentSend.dicRequest["ExpDate"] = txtExpDate.Text;
        tQuickPaymentSend.dicRequest["CVV2"] = txtCVV2.Text;
        tQuickPaymentSend.dicRequest["VerifyCode"] = txtVerifyCode.Text;
        tQuickPaymentSend.dicRequest["PaymentType"] = txtPaymentType.Text;          //设定支付类型
        tQuickPaymentSend.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;      //设定支付接入方式
        tQuickPaymentSend.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;  //设定商户备注信息

        //2、传送支付请求并返回结果
        tQuickPaymentSend.postJSONRequest();

        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //3、支付请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("ECMerchantType   = [" + JSON.GetKeyValue("ECMerchantType") + "]<br/>");
            strMessage.Append("MerchantID = [" + JSON.GetKeyValue("MerchantID") + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
            strMessage.Append("Amount = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
            strMessage.Append("HostDate = [" + JSON.GetKeyValue("HostDate") + "]<br/>");
            strMessage.Append("HostTime = [" + JSON.GetKeyValue("HostTime") + "]<br/>");
        }
        else
        {
            //6、支付请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-快捷支付请求</title>
</head>
<body style="font-size: 14px;">
    <center>
        快捷支付请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>交易币种
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCurrencyCode' Text='156' />*必输</td>
            </tr>
            <tr>
                <td>交易金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAmount' Text='2.00' />保留小数点后两位数字，*必输</td>
            </tr>
            <tr>
                <td>手续费金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtFee' Text='' />保留小数点后两位数字,选输</td>
            </tr>
            <tr>
                <td>订单日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDate' Text='2004/12/23' />（YYYY/MM/DD），*必输</td>
            </tr>
            <tr>
                <td>订单时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderTime' Text='11:55:30' />（HH:MM:SS），*必输</td>
            </tr>
            <tr>
                <td>姓名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccName' Text='' />选输</td>
            </tr>
            <tr>
                <td>证件类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateType' Text='I' />选输</td>
            </tr>
            <tr>
                <td>证件号码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateID' Text='' />选输</td>
            </tr>
            <tr>
                <td>卡有效期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtExpDate' Text='0715' />选输</td>
            </tr>
            <tr>
                <td>贷记卡CVV2
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCVV2' Text='123' />选输</td>
            </tr>
            <tr>
                <td>短信验证码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtVerifyCode' Text='123456' />选输</td>
            </tr>
            <tr>
                <td>支付账户类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentType' Text='1' />1：农行卡支付 3：农行贷记卡支付 A:支付方式合并 *必输</td>
            </tr>
            <tr>
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
            </tr>
            <tr>
                <td>MerchantRemarks</td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />选输</td>
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
