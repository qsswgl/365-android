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
 *    abchina       2014/03/05  V3.0.0 Release
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成定单订单对象，并将订单明细加入订单中
        com.abc.trustpay.client.ebus.MigrateSubMerchantInfo tPaymentRequest = new com.abc.trustpay.client.ebus.MigrateSubMerchantInfo();

        tPaymentRequest.dicRequest["FromMerchantNo"] = txtFromMerchantNo.Text;    //设定子商户号
        tPaymentRequest.dicRequest["SubMerchantNo"] = txtSubMerchantNo.Text;    //设定短信验证码
 

        //5、传送支付请求并取得支付网址
        tPaymentRequest.postJSONRequest();

        //多商户
        //tPaymentRequest.extendPostJSONRequest(1);
        StringBuilder strMessage = new StringBuilder();
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>"); 
        }
        else
        {
            //7、支付请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>"); 
        }

        lblMessage.Text = strMessage.ToString();
    }
</script>
<script language="javascript" type="text/javascript">





    function submitFun() {
        form1.submit();
    }


</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-短信验证码&随机金额确认接口</title>
</head>
<body style="font-size: 14px;">
    <center>
        短信验证码&随机金额确认接口</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>源平台商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtFromMerchantNo' Text='103881920000325' />*必输</td>
            </tr>
                        <tr>
                <td>源平台二级商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' Text='103881920000325' />*选输（与随机金额二者必输其一）</td>
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
