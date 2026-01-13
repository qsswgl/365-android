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
            txtOrderNo.Text = "No" + DateTime.Now.Ticks.ToString();
        }
    }
    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成定单订单对象，并将订单明细加入订单中
        com.abc.trustpay.client.ebus.ThirdOrderConfirm thirdOrder = new com.abc.trustpay.client.ebus.ThirdOrderConfirm();
        //2、设定订单属性
        thirdOrder.dicRequest["OrderNo"] = txtOrderNo.Text;    //设定订单编号
        thirdOrder.dicRequest["BatchNo"] = txtBatchNo.Text; //设定流水号
        
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
                thirdOrder.dicSplitAccInfo.Add(i, item);
                item = new Dictionary<string, string>();
            }
        }

        //5、传送支付请求并取得支付网址
        thirdOrder.postJSONRequest();

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
    <title>农行网上支付平台-商户接口范例-第三方确认请求</title>
</head>
<body style="font-size: 14px;">
    <center>
        第三方确认请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo'/>*必输</td>
            </tr>
            <tr>
                <td>流水号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchNo' />*必输</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table border="1" style="font-size: 12px;" width="100%" id="account">
                        <tr>
                            <td width="24%" align="center">二级商户编号</td>
                            <td width="12%" align="center">确认金额</td>
                            </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type='button' value='增加' name="add" onclick="addLine()" /></td>

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
