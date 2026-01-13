<!--
/*
 * Project: BJP09001
 *
 * Description:
 *    数字人民币被扫交易
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
        com.abc.trustpay.client.ebus.UDCAppQRCodePayReqRequest tRequest = new com.abc.trustpay.client.ebus.UDCAppQRCodePayReqRequest();
        //2、生成定单订单对象
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;
        tRequest.dicRequest["OrderAbstract"] = txtOrderAbstract.Text;
        tRequest.dicRequest["OrderTime"] = txtOrderTime.Text;
        tRequest.dicRequest["OrderValidTime"] = txtOrderValidTime.Text;
        tRequest.dicRequest["OrderAmount"] = txtOrderAmount.Text;
        tRequest.dicRequest["OrderDesc"] = txtOrderDesc.Text;
        tRequest.dicRequest["PayQRCode"] = txtPayQRCode.Text;

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
    <title>农行网上支付平台-商户接口范例-数字人民币被扫交易</title>
</head>
<body style="font-size: 14px;">
    <center>
        数字人民币被扫交易
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='Test20220315001' />*必输</td>
            </tr>
            <tr>
                <td>交易名称
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAbstract' Text='数字人民币被扫交易测试' />*必输</td>
            </tr>
            <tr>
                <td>交易时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderTime' Text='20220315123000' />yyyyMMddHHmmss，*必输</td>
            </tr>
            <tr>
                <td>交易有效时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderValidTime' Text='20320315123000' />yyyyMMddHHmmss，*必输</td>
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
                    <asp:TextBox runat="server" ID='txtOrderDesc' Text='' />选输</td>
            </tr>
            <tr>
                <td>支付码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayQRCode' Text='0100320229316139647' />*必输</td>
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
