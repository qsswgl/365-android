<%@ Page Language="C#" %>
<!DOCTYPE html>
<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成外转请求对象
        com.abc.trustpay.client.ebus.OutPaymentRequest tRequest = new com.abc.trustpay.client.ebus.OutPaymentRequest();

        tRequest.dicRequest["SubMerId"] = txtSubMerId.Text; //二级商户编号（必要信息）
        tRequest.dicRequest["AccountName"] = txtAccountName.Text; //收款户名（必要信息）
        tRequest.dicRequest["Account"] = txtAccount.Text;  //收款账号（必要信息）
        tRequest.dicRequest["TrxAmount"] = txtTrxAmount.Text; //出金金额
        tRequest.dicRequest["DrawingFlag"] = DrawingFlag.Text; //是否关联支付订单号
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;  //交易编号
        tRequest.dicRequest["Remark"] = Remark.Text; //附言
        tRequest.dicRequest["RecBankNo"] = RecBankNo.Text; //他行行号
      
        //2、传送外转请求并取得退货结果
        tRequest.postJSONRequest();

        //3、判断外转结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        string OrderNo = JSON.GetKeyValue("OrderNo");
        if (ReturnCode.Equals("0000"))
        {
            //4、退款成功/退款受理成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("OrderNo = [" + OrderNo + "]<br/>");
        }
        else
        {
            //5、外转失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>农行网上支付平台-商户接口范例-出金交易请求</title>
</head>
<body style="font-size: 14px;">
    
    <center>出金交易请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
           
            <tr>
                <td>二级商户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerId' Text='' /> *必输 </td>
            </tr>
                        <tr>
                <td>收款户名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccountName' Text='' />*必输</td>
            </tr>
            <tr>
                <td>收款账号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccount' Text='' /> *必输</td>
            </tr>

            <tr>
                <td>出金金额</td>
                <td>
                    <asp:TextBox runat="server" ID='txtTrxAmount' Text='100' />不关联支付订单时必输</td>
            </tr>
            <tr>
                <td>是否关联支付订单号</td>
                <td>
                    <asp:TextBox runat="server" ID='DrawingFlag' Text='' />选输 关联:1 不关联:0 </td>
            </tr>
            <tr>
                <td>他行行号</td>
                <td>
                    <asp:TextBox runat="server" ID='RecBankNo' Text='' />12位,他行出金金额大于50000时必输</td>
            </tr>
             <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='' /> 关联支付订单号时必输 </td>
            </tr>
                        <tr>
                <td>附言</td>
                <td>
                    <asp:TextBox runat="server" ID='Remark' Text='综合收银台出金' />选输</td>
            </tr>
            <tr>
                <td colspan="2">
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
