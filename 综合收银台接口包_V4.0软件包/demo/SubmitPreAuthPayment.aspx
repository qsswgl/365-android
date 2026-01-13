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
        //1、生成预授权取消/确认请求对象
        com.abc.trustpay.client.ebus.PreAuthPaymentRequest tRequest = new com.abc.trustpay.client.ebus.PreAuthPaymentRequest();
        tRequest.dicOrder["OperateType"] = txtOperateType.Text;                         //交易类型       （必要信息）
        tRequest.dicOrder["OrderDate"] = txtOrderDate.Text;                         //交易时间       （必要信息）
        tRequest.dicOrder["OrderTime"] = txtOrderTime.Text;                         //交易日期       （必要信息）
        tRequest.dicOrder["OrderNo"] = txtOrderNo.Text;                         //交易编号       （必要信息）
        tRequest.dicOrder["OriginalOrderNo"] = txtOriginalOrderNo.Text;                         //原交易编号       （必要信息）
        tRequest.dicOrder["CurrencyCode"] = txtCurrencyCode.Text;                         //币种       （必要信息）
        tRequest.dicOrder["OrderAmount"] = txtOrderAmount.Text;                         //金额       （必要信息）
        tRequest.dicOrder["Fee"] = txtFee.Text;                         //手续费金额      （必要信息）
        tRequest.dicOrder["MerchantRemarks"] = txtMerchantRemarks.Text;                         //备注

        //2、传送预授权取消/确认
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //成功结果
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
            strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
            strMessage.Append("OriginalOrderNo      = [" + JSON.GetKeyValue("OriginalOrderNo") + "]<br/>");
            strMessage.Append("BatchId      = [" + JSON.GetKeyValue("BatchNo") + "]<br/>");
            strMessage.Append("VouchNo      = [" + JSON.GetKeyValue("VouchNo") + "]<br/>");
            strMessage.Append("HostDate      = [" + JSON.GetKeyValue("HostDate") + "]<br/>");
            strMessage.Append("HostTime      = [" + JSON.GetKeyValue("HostTime") + "]<br/>");
            strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");

            //strMessage.Append("PaymentURL      = [" + JSON.GetKeyValue("PaymentURL") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-预授权取消/确认</title>
</head>
<body style="font-size: 14px;">
    <center>
        预授权取消/确认
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易类型</td>
                <td>
                    <asp:DropDownList ID="txtOperateType" runat="server">
                        <asp:ListItem Value="Cancel" Selected="True">预授权取消</asp:ListItem>
                        <asp:ListItem Value="Confirm">预授权确认</asp:ListItem>
                    </asp:DropDownList>*必输</td>
            </tr>
            <tr>
                <td>请求日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDate' Text='2009/05/08' />
                    格式要求为YYYY/MM/DD,*必输</td>
            </tr>
            <tr>
                <td>请求时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderTime' Text='09:10:10' />
                    格式为HH:MM:SS,*必输</td>
            </tr>
            <tr>
                <td>订单编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200905080001' />
                    *必输</td>
            </tr>

            <tr>
                <td>原交易编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOriginalOrderNo' Text='ON200905080001' />
                    *必输</td>
            </tr>
            <tr>
                <td>交易币种
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCurrencyCode' Text='156' />156:人民币,*必输</td>
            </tr>
            <tr>
                <td>交易金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAmount' Text='2.00' />保留小数点后两位数字,*必输</td>
            </tr>
            <tr>
                <td>手续费金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtFee' Text='' />保留小数点后两位数字,选输</td>
            </tr>
            <tr>
                <td>附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />不超过100个字符，选输</td>
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
