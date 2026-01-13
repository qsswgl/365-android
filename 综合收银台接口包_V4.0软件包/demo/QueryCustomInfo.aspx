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
        com.abc.trustpay.client.ebus.QueryCustomInfo tMerchantInfo = new com.abc.trustpay.client.ebus.QueryCustomInfo();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["SubCustomId"] = txtSubCustomId.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("MerchantNo = [" + JSON.GetKeyValue("MerchantID") + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("MerchantName = [" + JSON.GetKeyValue("MerchantName") + "]<br/>");
            strMessage.Append("SubMerchantNo = [" + JSON.GetKeyValue("SubCustomId") + "]<br/>");
            strMessage.Append("SubMerchantName = [" + JSON.GetKeyValue("SubCustomName") + "]<br/>");
            strMessage.Append("SubMerchantSort = [" + JSON.GetKeyValue("SubCustomSort") + "]<br/>");
            strMessage.Append("SubMerchantType = [" + JSON.GetKeyValue("SubCustomType") + "]<br/>");
            strMessage.Append("CertificateType = [" + JSON.GetKeyValue("CertificateType") + "]<br/>");
            strMessage.Append("CertificateNo = [" + JSON.GetKeyValue("CertificateNo") + "]<br/>");
            strMessage.Append("ContactName = [" + JSON.GetKeyValue("ContactName") + "]<br/>");
            strMessage.Append("MerMobileNo = [" + JSON.GetKeyValue("CustomMobileNo") + "]<br/>");
            strMessage.Append("Status = [" + JSON.GetKeyValue("Status") + "]<br/>");
            strMessage.Append("StatusMessage = [" + JSON.GetKeyValue("StatusMessage") + "]<br/>");
            strMessage.Append("NotifyUrl = [" + JSON.GetKeyValue("NotifyUrl") + "]<br/>");
            strMessage.Append("SubMerSignNo = [" + JSON.GetKeyValue("SubCustomSignNo") + "]<br/>");
            strMessage.Append("IsPassed = [" + JSON.GetKeyValue("IsPassed") + "]<br/>");
            strMessage.Append("Account = [" + JSON.GetKeyValue("Account") + "]<br/>");
            strMessage.Append("AccountName = [" + JSON.GetKeyValue("AccountName") + "]<br/>");
            strMessage.Append("BankNo = [" + JSON.GetKeyValue("BankNo") + "]<br/>");
            strMessage.Append("AccountType = [" + JSON.GetKeyValue("AccountType") + "]<br/>");
            strMessage.Append("AccountAbisNo = [" + JSON.GetKeyValue("AccountAbisNo") + "]<br/>");
            strMessage.Append("MobilePhone = [" + JSON.GetKeyValue("MobilePhone") + "]<br/>");
            strMessage.Append("AccStatus = [" + JSON.GetKeyValue("AccStatus") + "]<br/>");
            strMessage.Append("IsABCAccount = [" + JSON.GetKeyValue("IsABCAccount") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-客户信息查询接口</title>
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
        客户信息查询接口
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级客户编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubCustomId' value='zhanghh1234' />*必输</td>
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
