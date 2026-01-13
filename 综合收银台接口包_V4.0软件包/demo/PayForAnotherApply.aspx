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
        com.abc.trustpay.client.ebus.PayForAnotherApply tRequest = new com.abc.trustpay.client.ebus.PayForAnotherApply();
        tRequest.payForAnotherApply["OrderNo"] = txtOrderNo.Text;               //订单号       （必要信息）
        tRequest.payForAnotherApply["SubMerId"] = txtSubMerchantNo.Text;     //子商户号       （必要信息）
        tRequest.payForAnotherApply["Account"] = txtAccount.Text;               //入账账户       （必要信息）
        tRequest.payForAnotherApply["AccountName"] = txtAccountName.Text;       //入账账户名       （必要信息）
        tRequest.payForAnotherApply["TrxAmount"] = txtTrxAmount.Text;         //交易金额     （必要信息）
        tRequest.payForAnotherApply["DrawingFlag"] = txtDrawingFlag.Text;       //提现标识 0:提现 1:外转       
        tRequest.payForAnotherApply["Remark"] = txtRemark.Text;            //附言       
        tRequest.payForAnotherApply["RecBankNo"] = txtRecBankNo.Text;         //他行行号
        //2、传送授权支付签约请求并取得签约网址
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode      = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + ErrorMessage + "]<br/>");
            strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("TrnxNo") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-二级商户出金申请</title>
</head>
<body style="font-size: 14px;">
    <center>
        二级商户出金申请
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='No637787197751798192' />
                    *必输
                </td>
            </tr>
            <tr>
                <td>子商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' Text='009' />
                    *必输
                </td>
            </tr>
            <tr>
                <td>入账账户</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccount' Text='6228270016020564175' />
                    *必输
                </td>
            </tr>
            <tr>
                <td>入账账户名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccountName' Text='徐东强' />
                    *必输
                </td>
            </tr>
            <tr>
                <td>交易金额</td>
                <td>
                    <asp:TextBox runat="server" ID='txtTrxAmount' Text='0.01' />
                    *必输
                </td>
            </tr>
            <tr>
                <td>提现标识</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDrawingFlag' Text='1' />
                    *非必输 0:提现 1:外转
                </td>
            </tr>
            <tr>
                <td>附言</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemark' Text='' />
                    *非必输
                </td>
            </tr>
            <tr>
                <td>他行行号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRecBankNo' Text='' />
                    *非必输
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
