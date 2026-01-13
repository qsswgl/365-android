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
 *    abchina       2014/04/04  Create V3.0.0 
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成交易流水查询请求对象
        com.abc.trustpay.client.ebus.QueryTrnxRecords tRequest = new com.abc.trustpay.client.ebus.QueryTrnxRecords();
        tRequest.queryRequest["SettleDate"] = txtQueryDate.Text;//查询日期 （必要信息）
        tRequest.queryRequest["SettleStartHour"] = txtQueryStartHour.Text;//起始时间 （必要信息）
        tRequest.queryRequest["SettleEndHour"] = txtQueryEndHour.Text;//截止时间 （必要信息）
        tRequest.queryRequest["ZIP"] = txtZIP.Text;//压缩标识 （必要信息）

        //2、传送商户交易流水查询请求并取得查询结果
        tRequest.postJSONRequest();

        //3、判断商户交易流水查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        
        if (ReturnCode.Equals("0000"))
        {
            //4、生成订单对象
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            strMessage.Append("TrxType      = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            if (txtZIP.Text.Equals("1"))
            {
                byte[] zipDetailRecords = com.abc.util.Zip.DeCompression.DeCompression.DecompressFromBase64String(JSON.GetKeyValue("ZIPDetailRecords"));
                strMessage.Append("ZIPDetailRecords      = [" + System.Text.Encoding.GetEncoding("gb2312").GetString(zipDetailRecords) + "]<br/>");
            }
            else
            {
                strMessage.Append("DetailRecords      = [" + JSON.GetKeyValue("DetailRecords") + "]<br/>");
            }


        }
        else
        {
            //5、商户订单查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-交易流水查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        交易流水查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>查询日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtQueryDate' Text='2004/12/23' />（YYYY/MM/DD）*必输</td>
            </tr>
            <tr>
                <td>起始时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtQueryStartHour' Text='1' />（0—23）*必输</td>
            </tr>
            <tr>
                <td>截止时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtQueryEndHour' Text='11' />（0—23）大于起始时间 *必输</td>
            </tr>
            <tr>
                <td>压缩标识
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtZIP' Text='1' />1：压缩，0：否 *必输</td>
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
