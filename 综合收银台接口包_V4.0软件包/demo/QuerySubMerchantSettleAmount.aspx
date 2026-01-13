<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SettleDate.Text = System.DateTime.Now.ToString("yyyy/MM/dd");

        }
    }

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成查询请求对象
        com.abc.trustpay.client.ebus.QrySubMerSettleAmountRequest tRequest = new com.abc.trustpay.client.ebus.QrySubMerSettleAmountRequest();
        tRequest.queryRequest["SubMerchantNo"] = SubMerchantNo.Text;   //二级商户号 （必要信息）
        tRequest.queryRequest["SettleDate"] = SettleDate.Text;   //日期 （必要信息）

        //2、传送查询请求并取得结果信息
        tRequest.postJSONRequest();

        //3、判断查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        
        if (ReturnCode.Equals("0000"))
        {
            //4、查询成功，生成对账单对象
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            //strMessage.Append("TrxType      = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("SettleAmount      = [" + JSON.GetKeyValue("SettleAmount") + "]<br/>");
            strMessage.Append("SettleStatus      = [" + JSON.GetKeyValue("SettleStatus") + "]<br/>");
            strMessage.Append("SupSettleAmount      = [" + JSON.GetKeyValue("SupSettleAmount") + "]<br/>");
            strMessage.Append("SupSettleStatus      = [" + JSON.GetKeyValue("SupSettleStatus") + "]<br/>");            

            //strMessage.Append("Status = [" + JSON.GetKeyValue("Status") + "](0000成功 99失败 ZY状态未知)<br/>");


        }
        else
        {
            //6、查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-查询接口</title>
    <style type="text/css">
        .auto-style1
        {
            height: 55px;
        }
    </style>
</head>
<body style="font-size: 14px;">
    <center style="width: 352px; height: 16px">
        农行POS渠道清算金额查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='SubMerchantNo' Text='' Width="228px" /></td>
            </tr>
              <tr>
                <td>清算日期</td>
                <td>
                    <asp:TextBox runat="server" ID='SettleDate' Text='' Width="228px" />*必输</td>
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