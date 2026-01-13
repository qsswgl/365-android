<%@ Page Language="C#" %>
<!DOCTYPE html>
<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成内转请求对象
        com.abc.trustpay.client.ebus.InnerPaymentRequest tRequest = new com.abc.trustpay.client.ebus.InnerPaymentRequest();
        //tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;  //交易编号（必要信息）
        tRequest.dicRequest["RemitterSubMerchantNo"] = txtRemitterSubMerchantNo.Text; //转出方二级商户编号（必要信息）
        tRequest.dicRequest["RemitteeSubMerchantNo"] = txtRemitteeSubMerchantNo.Text; //转入方二级商户编号（必要信息）
        tRequest.dicRequest["InternalTransferNo"] = txtInternalTransferNo.Text; //交易编号（必要信息）
        tRequest.dicRequest["Amount"] = txtTrxAmount.Text; //金额（必要信息）
        tRequest.dicRequest["Remark"] = txtRemark.Text; //附言（选输信息）
        //2、传送内转请求并取得退货结果
        tRequest.postJSONRequest();

        //3、判断外转结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、转账成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");

        }
        else
        {
            //5、转账失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>农行网上支付平台-商户接口范例-内转交易请求</title>
</head>
<body style="font-size: 14px;">
    
    <center>内转交易请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
           
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInternalTransferNo' Text='' />*必输</td>
            </tr>
            <tr>
                <td>转出方二级商户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemitterSubMerchantNo' Text='' /> *必输 </td>
            </tr>
            <tr>
                <td>转入方二级商户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemitteeSubMerchantNo' Text='' /> *必输</td>
            </tr>
            <tr>
                <td>金额</td>
                <td>
                    <asp:TextBox runat="server" ID='txtTrxAmount' Text='' />*必输</td>
            </tr>
            <tr>
                <td>附言</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemark' Text='' />选输</td>
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
