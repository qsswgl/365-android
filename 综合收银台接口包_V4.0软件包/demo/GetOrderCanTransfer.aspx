<%@ Page Language="C#" %>
<!DOCTYPE html>
<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成外转请求对象
        com.abc.trustpay.client.ebus.OrderCanTransferRequest tRequest = new com.abc.trustpay.client.ebus.OrderCanTransferRequest();
        tRequest.dicRequest["SubMerchantNo"] = txtSubMerchantNo.Text;  //交易编号（必要信息）
        tRequest.dicRequest["StartDate"] = txtStartDate.Text; //子商户编号（必要信息）
        tRequest.dicRequest["EndDate"] = txtEndDate.Text;  //子商户收款账户（必要信息）
      
        //2、传送外转请求并取得退货结果
        tRequest.postJSONRequest();

        //3、判断外转结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        string DetailTable = JSON.GetKeyValue("DetailTable");
        if (ReturnCode.Equals("0000"))
        {
            //4、退款成功/退款受理成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("DetailTable = [" + DetailTable + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-出金交易查询请求</title>
</head>
<body style="font-size: 14px;">
    
    <center>
        出金交易查询请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
           
            <tr>
                <td>二级商户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' Text='' /> *必输 </td>
            </tr>
                        <tr>
                <td>起始日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtStartDate' Text='' />*必输</td>
            </tr>
            <tr>
                <td>截止日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtEndDate' Text='' /> *必输</td>
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
</body>
</html>
