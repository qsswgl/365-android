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
 *    abchina       2014/04/21  V3.0.0
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

        //1、生成保证金账簿明细查询请求对象
        com.abc.trustpay.client.ebus.GuaFundSubAccDetailQueryRequest tRequest = new com.abc.trustpay.client.ebus.GuaFundSubAccDetailQueryRequest();
        tRequest.dicRequest["AccDate"] = txtAccDate.Text;   //会计日期 （必要信息）
        tRequest.dicRequest["NumEntryRec"] = txtNumEntryRec.Text;   //
        tRequest.dicRequest["NumSeqDtal"] = txtNumSeqDtal.Text;   //
        tRequest.dicRequest["JrnNo"] = txtJrnNo.Text; 
        tRequest.dicRequest["NumSeqMacc"] = txtNumSeqMacc.Text; 

        //2、传送保证金账簿明细查询请求并取得二级商户明细
        tRequest.postJSONRequest();

        //3、判断保证金账簿明细查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        
        if (ReturnCode.Equals("0000"))
        {
            //4、保证金账簿明细查询成功，生成二级商户明细对象
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            strMessage.Append("DetailTable      = [" + JSON.GetKeyValue("DetailTable") + "]<br/>");
            strMessage.Append("NumEntryRec      = [" + JSON.GetKeyValue("NumEntryRec") + "]<br/>");
            strMessage.Append("NumSeqDtal      = [" + JSON.GetKeyValue("NumSeqDtal") + "]<br/>");
            strMessage.Append("JrnNo      = [" + JSON.GetKeyValue("JrnNo") + "]<br/>");
            strMessage.Append("NumSeqMacc      = [" + JSON.GetKeyValue("NumSeqMacc") + "]<br/>");
        }
        else
        {
            //6、保证金账簿明细查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-保证金账簿明细查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        保证金账簿明细查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>会计日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccDate' Text='' />（YYYYMMDD）*必输</td>
            </tr>
            <tr>
                <td>翻页查询分录序号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNumEntryRec' Text='' />续查时输入上次查询返回报文的NumEntryRec</td>
            </tr>
            <tr>
                <td>翻页查询明细顺序号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNumSeqDtal' Text='' />续查时输入上次查询返回报文的NumSeqDtal</td>
            </tr>
            <tr>
                <td>翻页查询日志号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtJrnNo' Text='' />续查时输入上次查询返回报文的JrnNo</td>
            </tr>
            <tr>
                <td>翻页查询多级账簿号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNumSeqMacc' Text='' />续查时输入上次查询返回报文的NumSeqMacc</td>
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
