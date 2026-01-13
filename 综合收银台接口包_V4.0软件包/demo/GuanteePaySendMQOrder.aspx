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
        com.abc.trustpay.client.ebus.GuanteePaySendMQOrder tPaymentRequest = new com.abc.trustpay.client.ebus.GuanteePaySendMQOrder();

        tPaymentRequest.dicRequest["OrderNo"] = txtOrderNo.Text;    //设定收款方账号
        tPaymentRequest.dicRequest["NewOrderNo"] = txtNewOrderNo.Text;    //设定收款方户名
        tPaymentRequest.dicRequest["OrderAmount"] = txtOrderAmount.Text;    //设定通知方式
        tPaymentRequest.dicRequest["AdvancedFund"] = txtAdvancedFund.Text;    //设定通知方式
         //添加分账信息
        string[] splitMerchantIdArr = null;
        string[] splitAmountArr = null;
        string splitMerchantId = Request["txtSplitMerchantID"];
        string splitAmount = Request["txtSplitAmount"];
        if (!string.IsNullOrEmpty(splitMerchantId) && !string.IsNullOrEmpty(splitAmount))
        {
            if (splitMerchantId.Contains(","))
            {
                splitMerchantIdArr = splitMerchantId.Split(',');
                splitAmountArr = splitAmount.Split(',');
            }
            else
            {
                splitMerchantIdArr = new string[] { splitMerchantId };
                splitAmountArr = new string[] { splitAmount };
            }
            Dictionary<string, string> item = new Dictionary<string, string>();
            for (int i = 0; i < splitMerchantIdArr.Length; i++)
            {
                item["SplitMerchantID"] = splitMerchantIdArr[i];
                item["SplitAmount"] = splitAmountArr[i];
                tPaymentRequest.dicSplitAccInfo.Add(i, item);
                item = new Dictionary<string, string>();
            }
        }

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
    <title>农行网上支付平台-商户接口范例-担保确认请求</title>
</head>
<body style="font-size: 14px;">
    <center>
        担保确认请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>担保支付交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>担保确认交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtNewOrderNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>交易金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAmount' Text='0.01' />保留小数点后两位数字,*必输</td>
            </tr>
            <tr>
                <td>是否垫资
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAdvancedFund' Text='0' /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <table border="1" style="font-size: 12px;" width="50%" id="account">
                        <tr>
                            <td width="12%" align="center">二级商户编号</td>
                            <td width="12%" align="center">入账金额</td>
                            <tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type='button' value='增加' name="add" onclick="addLine()"></td>

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
