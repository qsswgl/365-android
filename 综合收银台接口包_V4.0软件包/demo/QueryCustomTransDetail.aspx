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
 *    abchina       2017/04/11  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        StringBuilder strMessage = new StringBuilder("");

        //1、生成支付请求对象
        com.abc.trustpay.client.ebus.QueryCustomTransDetail tMerchantInfo = new com.abc.trustpay.client.ebus.QueryCustomTransDetail();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["SubCustomNo"] = txtSubCustomNo.Text;
        tMerchantInfo.merchantInfoRequest["SelType"] = txtSelType.Text;
        tMerchantInfo.merchantInfoRequest["SDate"] = txtSDate.Text;
        tMerchantInfo.merchantInfoRequest["EDate"] = txtEDate.Text;
        tMerchantInfo.merchantInfoRequest["Status"] = txtStatus.Text;
        tMerchantInfo.merchantInfoRequest["OrderNo"] = txtOrderNo.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("TrxList = [" + JSON.GetKeyValue("TrxList") + "]<br/>");
        }
        else
        {
            //6、请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }

        lblMessage.Text = strMessage.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-二级客户交易明细查询</title>
</head>

<script language="javascript">
    function formatIndex(index) {
        if (index < 10)
            return "00" + index;
        else if (index >= 10 && index < 100)
            return "0" + index;
        else
            return index;
    }
    function submitFun() {
        form1.submit();
    }
</script>

<body style="font-size: 14px;">
    <center>
        二级客户交易明细查询
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级客户编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubCustomNo' value='zhanghh1234' />*必输</td>
            </tr>
            <tr>
                <td>交易类型</td>
                <td>
                    <asp:DropDownList ID="txtSelType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="1" Selected="True">订单支付退款</asp:ListItem>
                        <asp:ListItem Value="2">客户支付退款和内外转</asp:ListItem>
                    </asp:DropDownList>
                    *必输 1：订单支付退款; 2：客户支付退款和内外转
                </td>
            </tr>
            <tr>
                <td>开始日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSDate' value='2020-11-26' />*必输 YYYY-MM-DD</td>
            </tr>
            <tr>
                <td>结束日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtEDate' value='2020-11-26' />*必输 YYYY-MM-DD</td>
            </tr>
            <tr>
                <td>交易状态</td>
                <td>
                    <asp:TextBox runat="server" ID='txtStatus' value='' />空：全部交易; 0000：成功; Other：失败; ZY：状态不明确</td>
            </tr>
            <tr>
                <td>订单号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' value='' /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交" OnClick="btnButton_Click" /></td>
            </tr>
        </table>
    </form>
    <a href='Merchant.html'>回商户首页</a>
</body>
</html>
