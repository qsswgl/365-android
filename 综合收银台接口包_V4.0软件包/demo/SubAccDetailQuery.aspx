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

        //1、生成二级商户明细查询请求对象
        com.abc.trustpay.client.ebus.SubMerAccDetailQryRequest tRequest = new com.abc.trustpay.client.ebus.SubMerAccDetailQryRequest();
        tRequest.dicRequest["SubMerchantNo"] = txtSubMerchantNo.Text;   //二级商户号 （必要信息）
        tRequest.dicRequest["StartDate"] = txtStartDate.Text;   //开始日期YYYY/MM/DD （必要信息）
        tRequest.dicRequest["EndDate"] = txtEndDate.Text;   //结束日期YYYY/MM/DD （必要信息）

        //2、传送二级商户明细查询请求并取得二级商户明细
        tRequest.postJSONRequest();

        //3、判断二级商户明细查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        
        if (ReturnCode.Equals("0000"))
        {
            //4、二级商户明细查询成功，生成二级商户明细对象
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            strMessage.Append("DetailTable      = [" + JSON.GetKeyValue("DetailTable") + "]<br/>");
        }
        else
        {
            //6、二级商户明细查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-二级商户明细查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        二级商户明细查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' Text='' />*必输</td>
            </tr>
            <tr>
                <td>开始日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtStartDate' Text='' />（YYYYMMDD）*必输</td>
            </tr>
            <tr>
                <td>结束日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtEndDate' Text='' />（YYYYMMDD）*必输</td>
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
