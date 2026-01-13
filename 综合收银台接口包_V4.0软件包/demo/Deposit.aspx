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
        if (!IsPostBack)
        {
        }
    }
    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成定单订单对象，并将订单明细加入订单中
        com.abc.trustpay.client.ebus.Deposit tPaymentRequest = new com.abc.trustpay.client.ebus.Deposit();
        //2、设定订单属性
        tPaymentRequest.dicOrder["orderTimeoutDate"] = txtorderTimeoutDate.Text;    //设定交易类型
        tPaymentRequest.dicOrder["OrderNo"] = txtOrderNo.Text;                       //设定订单编号
        tPaymentRequest.dicOrder["OrderAmount"] = txtOrderAmount.Text;//设定订单保存时间
        tPaymentRequest.dicOrder["OrderDesc"] = txtOrderDesc.Text;    //设定交易金额

        //4、设定支付请求对象
        tPaymentRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;      //设定支付接入方式
        tPaymentRequest.dicRequest["NotifyType"] = txtNotifyType.Text;    //设定通知方式
        tPaymentRequest.dicRequest["ResultNotifyURL"] = txtResultNotifyURL.Text;    //设定通知URL地址
        tPaymentRequest.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;    //设定附言
        tPaymentRequest.dicRequest["ReceiveSubMerchantNo"] = txtReceiveSubMerchantNo.Text;    //设定附言
                      
        //5、传送支付请求并取得支付网址
        tPaymentRequest.postJSONRequest();

        //多商户
        //tPaymentRequest.extendPostJSONRequest(1);
        StringBuilder strMessage = new StringBuilder();
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>"); 
            //6、支付请求提交成功，将客户端导向支付页面
            Response.Redirect(JSON.GetKeyValue("PaymentURL"));
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


    function SelectedIndexChanged() {
        var paytypeid = document.getElementById("txtPayTypeID").value;
        if (paytypeid == "ImmediatePay") {
            installmentCode.style.display = "none";
            installmentNum.style.display = "none";
        }
        else if (paytypeid == "PreAuthPay") {
            installmentCode.style.display = "none";
            installmentNum.style.display = "none";
        }
        else if (paytypeid == "DividedPay") {
            installmentCode.style.display = "inline";
            installmentNum.style.display = "inline";

        }
    }

    function CheckValue() {        
        var paymenttype = document.getElementById("txtPaymentType").value;
        var paymentlinktype = document.getElementById("txtPaymentLinkType").value;
        if (paymenttype == "6" && paymentlinktype == "2") {
            UnionPayLinkType.style.display = "inline";
        } else {
            UnionPayLinkType.style.display = "none";
        }
    }
    function addLine() {
        var row = account.insertRow();
        for (var j = 0; j < 2; j++) {
            var col = row.insertCell();
            switch (j) {
                case 0:
                    col.align = "center";
                    col.innerHTML = "<input type=\"text\" name=\"txtSplitMerchantID\" style=\"width:95%\" value=\"\">";
                    break;
                case 1:
                    col.align = "center";
                    col.innerHTML = "<input type=\"text\" name=\"txtSplitAmount\" style=\"width:95%\" value=\"\">";
                    break;
            }

        }

        form1.btnButton.disabled = "";
    }
    function submitFun() {
        form1.submit();
    }


</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-支付请求</title>
</head>
<body style="font-size: 14px;">
    <center>
        支付请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单支付有效期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtorderTimeoutDate' Text='20240619104901' />精确到秒，选输</td>
            </tr>
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>交易金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAmount' Text='0.01' />保留小数点后两位数字,*必输</td>
            </tr>
            <tr>
                <td>订单说明
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDesc' Text='Game Card Order' />选输</td>
            </tr>
            <tr>
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' onkeyup="CheckValue()" />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
            </tr>
            <tr>
                <td>通知方式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyType' Text='0' />0：URL页面通知 1：服务器通知，*必输</td>
            </tr>
            <tr>
                <td>通知URL地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtResultNotifyURL' Text='http://127.0.0.1/Merchant/MerchantResult.aspx' />*必输</td>
            </tr>
            <tr>
                <td>二级商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiveSubMerchantNo' Text='1234567890' />*必输</td>
            </tr>
                        <tr>
                <td>附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />不超过100个字符，选输</td>
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
