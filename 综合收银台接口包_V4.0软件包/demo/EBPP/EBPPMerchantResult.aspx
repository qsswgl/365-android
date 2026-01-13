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
 *    abc       2014/05/13      V3.0.2
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

        //1、取得MSG参数，并利用此参数值生成支付结果对象
        com.abc.trustpay.client.ebus.PaymentResult tResult = new com.abc.trustpay.client.ebus.PaymentResult();
        tResult.init(Request["MSG"]);

        //2、判断支付结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        if (tResult.isSuccess())
        {
            //3、成功            
            strMessage.Append("MerchantID			= [" + tResult.getValue("MerchantID") + "]<br>");//出账单位编号
            strMessage.Append("TrxType				= [" + tResult.getValue("TrxType") + "]<br>");//报文交易类型（支付结果）
            strMessage.Append("OrderNo				= [" + tResult.getValue("OrderNo") + "]<br>");//交易号(银行系统账单ID号)
            strMessage.Append("ProductID 			= [" + tResult.getValue("ProductID") + "]<br>");//出账单位账单号
            strMessage.Append("Amount				= [" + tResult.getValue("Amount") + "]<br>");//账单金额
            strMessage.Append("BatchNo				= [" + tResult.getValue("BatchNo") + "]<br>");//账单交易批次号
            strMessage.Append("HostDate			= [" + tResult.getValue("HostDate") + "]<br>");//主机日期
            strMessage.Append("HostTime			= [" + tResult.getValue("HostTime") + "]<br>");//主机时间
            strMessage.Append("MerchantRemarks		= [" + tResult.getValue("MerchantRemarks") + "]<br>");//备注
            strMessage.Append("PayType				= [" + tResult.getValue("PayType") + "]<br>");//支付方式（PAY01注册客户，PAY02公共客户）
        }
        else
        {
            //4、失败
            strMessage.Append("ReturnCode   = [" + tResult.ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + tResult.ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>农行网上支付平台-商户接口范例-接收交易结果</title>
</head>
<body style="font-size: 14px;">
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
    </form>
</body>
</html>

