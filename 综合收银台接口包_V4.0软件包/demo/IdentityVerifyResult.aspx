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
 *    abchina       2009/06/02  V2.0.1 Release
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RequestMsg();
        }
    }
    private void RequestMsg()
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;
        
        //1、取得MSG参数，并利用此参数值生成验证结果对象
        com.abc.trustpay.client.ebus.PaymentResult tResult = new com.abc.trustpay.client.ebus.PaymentResult();
        tResult.init(Request["MSG"]);
        //2、判断验证结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        if (tResult.isSuccess())
        {
            //3、验证成功
            strMessage.Append("户名         = [" + tResult.getValue("AccountName") + "]<br/>");

        }
        else
        {
            //4、验证失败
            strMessage.Append("ReturnCode   = [" + tResult.ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + tResult.ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        
        lblMessage.Text = strMessage.ToString();
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>农行网上支付平台-商户接口范例-身份验证结果接收</title>
</head>
<body style="font-size: 14px;">
    <center>
        身份验证结果接收
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
    </form>
</body>
</html>
