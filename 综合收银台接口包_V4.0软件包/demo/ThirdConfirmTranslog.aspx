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
        com.abc.trustpay.client.ebus.ThirdConfirmTranslog tMerchantInfo = new com.abc.trustpay.client.ebus.ThirdConfirmTranslog();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["OrderNo"] = txtOrderNo.Text;
        tMerchantInfo.merchantInfoRequest["BatchNo"] = txtBatchNo.Text;
        tMerchantInfo.merchantInfoRequest["SplitAccInfoItems"] = txtSplitAccInfoItems.Text;
        tMerchantInfo.merchantInfoRequest["SplitMerchantID"] = txtSplitMerchantID.Text;
        tMerchantInfo.merchantInfoRequest["SplitAmount"] = txtSplitAmount.Text;
        tMerchantInfo.merchantInfoRequest["Remark"] = txtRemark.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-第三方订单信息确认(含附言)</title>
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
        第三方订单信息确认(含附言)
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>原订单编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' value='001123123' />*必输</td>
            </tr>
            <tr>
                <td>流水号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchNo' value='002' />*必输</td>
            </tr>
            <tr>
                <td>附言</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemark' value='Remark' /></td>
            </tr>
            <tr>
                <td>分账子商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSplitMerchantID' value='23123' /></td>
            </tr>
            <tr>
                <td>子商户分账金额</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSplitAmount' value='1' />所有子商户分账金额的总和需要等于该笔的订单金额</td>
            </tr>
            <tr>
                <td>平台商户当前分账情况</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSplitAccInfoItems' value='' /></td>
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
