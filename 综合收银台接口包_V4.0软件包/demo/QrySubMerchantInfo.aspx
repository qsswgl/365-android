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
 *    abchina       2014/03/05  V3.0.0 Release
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成定单订单对象，并将订单明细加入订单中
        com.abc.trustpay.client.ebus.QrySubMerchantInfo tPaymentRequest = new com.abc.trustpay.client.ebus.QrySubMerchantInfo();

        tPaymentRequest.dicRequest["SubMerId"] = txtSubMerchantNo.Text;    //设定子商户号

 

        //5、传送支付请求并取得支付网址
        tPaymentRequest.postJSONRequest();

        //多商户
        //tPaymentRequest.extendPostJSONRequest(1);
        StringBuilder strMessage = new StringBuilder();
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        string MerchantName = JSON.GetKeyValue("MerchantName");
        string SubMerId = JSON.GetKeyValue("SubMerId");
        string SubMerName = JSON.GetKeyValue("SubMerName");
        string SubMerSort = JSON.GetKeyValue("SubMerSort");
        string SubMerchantType = JSON.GetKeyValue("SubMerchantType");
        string CertificateType = JSON.GetKeyValue("CertificateType");
        string CertificateNo = JSON.GetKeyValue("CertificateNo");
        string ContactName = JSON.GetKeyValue("ContactName");
        string MobileNo = JSON.GetKeyValue("MobileNo");
        string Status = JSON.GetKeyValue("Status");
        string StatusMessage = JSON.GetKeyValue("StatusMessage");
        string CompanyCertType = JSON.GetKeyValue("CompanyCertType");
        string CompanyCertNo = JSON.GetKeyValue("CompanyCertNo");
        string CompanyName = JSON.GetKeyValue("CompanyName");
        string NotifyUrl = JSON.GetKeyValue("NotifyUrl");
        string SubMerSignNo = JSON.GetKeyValue("SubMerSignNo");
        string isPassed = JSON.GetKeyValue("isPassed");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("MerchantName = [" + MerchantName + "]<br/>");
            strMessage.Append("SubMerId = [" + SubMerId + "]<br/>");
            strMessage.Append("SubMerName = [" + SubMerName + "]<br/>");
            strMessage.Append("SubMerSort = [" + SubMerSort + "]<br/>");
            strMessage.Append("SubMerchantType = [" + SubMerchantType + "]<br/>");
            strMessage.Append("CertificateType = [" + CertificateType + "]<br/>");
            strMessage.Append("CertificateNo = [" + CertificateNo + "]<br/>");
            strMessage.Append("ContactName = [" + ContactName + "]<br/>");
            strMessage.Append("MobileNo = [" + MobileNo + "]<br/>");
            strMessage.Append("Status = [" + Status + "]<br/>");
            strMessage.Append("StatusMessage = [" + StatusMessage + "]<br/>");
            strMessage.Append("CompanyCertType = [" + CompanyCertType + "]<br/>");
            strMessage.Append("CompanyCertNo = [" + CompanyCertNo + "]<br/>");
            strMessage.Append("CompanyName = [" + CompanyName + "]<br/>");
            strMessage.Append("NotifyUrl = [" + NotifyUrl + "]<br/>");
            strMessage.Append("SubMerSignNo = [" + SubMerSignNo + "]<br/>");
            strMessage.Append("isPassed = [" + isPassed + "]<br/>"); 
            
            //6、支付请求提交成功，将客户端导向支付页面
            //Response.Redirect(JSON.GetKeyValue("PaymentURL"));
        }
        else
        {
            //7、支付请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>"); 
        }

        lblMessage.Text = strMessage.ToString();
    }
</script>
<script language="javascript" type="text/javascript">





    function submitFun() {
        form1.submit();
    }


</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-二级商户信息查询接口</title>
</head>
<body style="font-size: 14px;">
    <center>
        二级商户信息查询接口</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>子商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' Text='123456789' />*必输</td>
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
