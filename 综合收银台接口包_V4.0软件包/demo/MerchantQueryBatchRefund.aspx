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
        //1、生成退款批量结果查询请求对象
        com.abc.trustpay.client.ebus.QueryBatchRequest tQueryBatchRequest = new com.abc.trustpay.client.ebus.QueryBatchRequest();
        tQueryBatchRequest.queryBatchRequest["BatchDate"] = txtBatchDate.Text;  //订单日期（必要信息）
        tQueryBatchRequest.queryBatchRequest["BatchTime"] = txtBatchTime.Text; //订单时间（必要信息）
        tQueryBatchRequest.queryBatchRequest["SerialNumber"] = txtSerialNumber.Text; //设定退款批量结果查询请求的流水号（必要信息）

        //2、传送退款批量结果查询请求并取得结果
        tQueryBatchRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        //3、判断退款批量结果查询状态，进行后续操作
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、生成批量对象
            strMessage.Append("ReturnCode      = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + ErrorMessage + "]<br/>");
            strMessage.Append("BatchDate      = [" + JSON.GetKeyValue("BatchDate").ToString() + "]<br/>");
            strMessage.Append("BatchTime  = [" + JSON.GetKeyValue("BatchTime").ToString() + "]<br/>");
            strMessage.Append("SerialNumber  = [" + JSON.GetKeyValue("SerialNumber").ToString() + "]<br/>");
            strMessage.Append("BatchStatus  = [" + JSON.GetKeyValue("BatchStatus").ToString() + "]<br/>");
            strMessage.Append("MerRefundAccountNo  = [" + JSON.GetKeyValue("MerRefundAccountNo").ToString() + "]<br/>");
            strMessage.Append("MerRefundAccountName  = [" + JSON.GetKeyValue("MerRefundAccountName").ToString() + "]<br/>");
            strMessage.Append("RefundAmount  = [" + JSON.GetKeyValue("RefundAmount").ToString() + "]<br/>");
            strMessage.Append("RefundCount    = [" + JSON.GetKeyValue("RefundCount").ToString() + "]<br/>");
            strMessage.Append("SuccessAmount      = [" + JSON.GetKeyValue("SuccessAmount").ToString() + "]<br/>");
            strMessage.Append("SuccessCount      = [" + JSON.GetKeyValue("SuccessCount").ToString() + "]<br/>");
            strMessage.Append("FailedAmount      = [" + JSON.GetKeyValue("FailedAmount").ToString() + "]<br/>");
            strMessage.Append("FailedCount      = [" + JSON.GetKeyValue("FailedCount").ToString() + "]<br/>");


            //5、取得订单明细
            System.Collections.Generic.Dictionary<int, Hashtable> tOrders = JSON.GetArrayValue("Order");
            if (tOrders.Count <= 0)
            {
                strMessage.Append("明细为空！<br/>");
            }
            else
            {
                foreach (int key in tOrders.Keys)
                {
                    strMessage.Append("OriginalOrderNo   = [" + tOrders[key]["OriginalOrderNo"] as string + "]<br/>");
                    strMessage.Append("RefundOrderNo = [" + tOrders[key]["RefundOrderNo"] as string + "]<br/>");
                    strMessage.Append("CurrencyCode  = [" + tOrders[key]["CurrencyCode"] as string + "]<br/>");
                    strMessage.Append("RefundAmountCell   = [" + tOrders[key]["RefundAmountCell"] as string + "]<br/>");
                    strMessage.Append("OrderStatus = [" + tOrders[key]["OrderStatus"] as string + "]<br/>");
                    strMessage.Append("Remark  = [" + tOrders[key]["Remark"] as string + "]<br/>");
                }
            }
        }
        else
        {
            //6、退款批量结果查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-查询批量处理结果</title>
</head>
<body style="font-size: 14px;">
    <center>
        查询批量处理结果
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchDate' Text='2004/12/23' />（YYYY/MM/DD）*必输</td>
            </tr>
            <tr>
                <td>订单时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchTime' Text='11:55:30' />（HH:MM:SS）*必输</td>
            </tr>
            <tr>
                <td>SerialNumber</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSerialNumber' Text='1234' />
                    *必输</td>
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
