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
 *    abc       2014/04/17      V3.0.0
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

        //1、生成批量授权扣款查询请求对象
        com.abc.trustpay.client.ebus.AgentBatchPaymentQueryRequest tRequest = new com.abc.trustpay.client.ebus.AgentBatchPaymentQueryRequest();
        tRequest.agentBatchQueryRequest["BatchNo"] = txtBatchNo.Text; //请求批次号       （必要信息）
        tRequest.agentBatchQueryRequest["BatchDate"] = txtBatchDate.Text; //请求日期      YYYY/MM/DD       （必要信息）

        //传送交易请求
        tRequest.postJSONRequest();
        
        //3、判断结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、查询成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("BatchNo  = [" + JSON.GetKeyValue("BatchNo") + "]<br/>");
            strMessage.Append("BatchDate    = [" + JSON.GetKeyValue("BatchDate") + "]<br/>");
            strMessage.Append("BatchTime    = [" + JSON.GetKeyValue("BatchTime") + "]<br/>");
            strMessage.Append("AgentAmount  = [" + JSON.GetKeyValue("AgentAmount") + "]<br/>");
            strMessage.Append("AgentCount    = [" + JSON.GetKeyValue("AgentCount") + "]<br/>");
            strMessage.Append("BatchStatus    = [" + JSON.GetKeyValue("BatchStatus") + "]<br/>");
            strMessage.Append("BatchStatusZH    = [" + tRequest.getBatchSatusChinese(JSON.GetKeyValue("BatchStatus")) + "]<br/>");
            strMessage.Append("CurrencyCode    = [" + JSON.GetKeyValue("CurrencyCode") + "]<br/>");
            strMessage.Append("SuccessAmount    = [" + JSON.GetKeyValue("SuccessAmount") + "]<br/>");
            strMessage.Append("SuccessCount    = [" + JSON.GetKeyValue("SuccessCount") + "]<br/>");
            strMessage.Append("FailedAmount    = [" + JSON.GetKeyValue("FailedAmount") + "]<br/>");
            strMessage.Append("FailedCount    = [" + JSON.GetKeyValue("FailedCount") + "]<br/>");
            //5、取得批量授权扣款明细
            System.Collections.Generic.Dictionary<int, Hashtable> dic = JSON.GetArrayValue("AgentBatchDetail");
            if (dic.Count == 0)
            {
                strMessage.Append("批量授权扣款明细为空<br/>");
            }
            else
            {
                foreach (int key in dic.Keys)
                {
                    strMessage.Append("SeqNo   = [" + key + "],");
                    strMessage.Append("OrderNo   = [" + dic[key]["OrderNo"].ToString() + "],");
                    strMessage.Append("OrderAmount = [" + dic[key]["OrderAmount"].ToString() + "],");
                    strMessage.Append("AgentSignNo = [" + dic[key]["AgentSignNo"].ToString() + "],");
                    strMessage.Append("OrderStatus  = [" + dic[key]["OrderStatus"].ToString() + "],");
                    strMessage.Append("OrderStatusZH  = [" + tRequest.getBatchDetailStatusChinese(dic[key]["OrderStatus"].ToString()) + "]<br/>");
                }               
            }

        }
        else
        {
            //6、批量结果查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-授权扣款批量处理结果结果查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        授权扣款批量处理结果查询
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>批次编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchNo' Text='30' />）*必输</td>
            </tr>
            <tr>
                <td>批次日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchDate' Text='2004/12/23' />（YYYY/MM/DD）*必输</td>
            </tr>
            <tr>
                <td colspan="2">
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
