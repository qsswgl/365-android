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
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Red;

        //1、生成商户交易查询请求对象
        com.abc.trustpay.client.ebus.QueryOrderRequest tRequest = new com.abc.trustpay.client.ebus.QueryOrderRequest();
        tRequest.queryRequest["PayTypeID"] = txtPayTypeID.Text;    //设定交易类型（必要信息）
        tRequest.queryRequest["OrderNo"] = txtOrderNo.Text;  //交易编号           （必要信息）
        if (txtDetailQuery.Text == "0") //是否查询详细信息 （必要信息）
        {
            tRequest.queryRequest["QueryDetail"] = "false";
        }
        else if (txtDetailQuery.Text == "1")
        {
            tRequest.queryRequest["QueryDetail"] = "true";
        }
        else
        {
            lblMessage.Text = "DetailQuery（0：状态查询； 1：详细查询）设置不正确";
            lblMessage.ForeColor = System.Drawing.Color.Red;
            return;
        }

        //2、传送商户交易查询请求并取得交易查询结果
        tRequest.postJSONRequest();

        //3、判断商户交易查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            //4、获取结果信息
            string orderInfo = JSON.GetKeyValue("Order");
            if (string.IsNullOrEmpty(orderInfo))
            {
                strMessage.Append("查询结果为空<br/>");
            }
            else
            {
                byte[] order = Convert.FromBase64String(orderInfo);
                //1、还原经过base64编码的信息            
                string orderDetail = System.Text.Encoding.GetEncoding("gb2312").GetString(order);
                //com.abc.trustpay.client.JSON json = new com.abc.trustpay.client.JSON();
                //json.setJsonString(orderDetail);
                JSON.setJsonString(orderDetail);
                string queryDetail = txtDetailQuery.Text.ToString();
                if (queryDetail.Equals("0"))
                {
                    strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                    strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                    strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                    strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                    strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
                    strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                }
                else
                {
                    string payTypeID = JSON.GetKeyValue("PayTypeID");

                    System.Collections.Generic.Dictionary<int, Hashtable> dic = new System.Collections.Generic.Dictionary<int, Hashtable>();
                    if (payTypeID.Equals("ImmediatePay") || payTypeID.Equals("PreAuthPay"))
                    {
                        strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                        strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                        strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                        strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                        strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
                        strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                        strMessage.Append("OrderDesc      = [" + JSON.GetKeyValue("OrderDesc") + "]<br/>");
                        strMessage.Append("OrderURL      = [" + JSON.GetKeyValue("OrderURL") + "]<br/>");
                        strMessage.Append("PaymentLinkType      = [" + JSON.GetKeyValue("PaymentLinkType") + "]<br/>");
                        strMessage.Append("AcctNo      = [" + JSON.GetKeyValue("AcctNo") + "]<br/>");
                        strMessage.Append("CommodityType      = [" + JSON.GetKeyValue("CommodityType") + "]<br/>");
                        strMessage.Append("ReceiverAddress      = [" + JSON.GetKeyValue("ReceiverAddress") + "]<br/>");
                        strMessage.Append("BuyIP      = [" + JSON.GetKeyValue("BuyIP") + "]<br/>");
                        strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");
                        strMessage.Append("ReceiveAccount      = [" + JSON.GetKeyValue("ReceiveAccount") + "]<br/>");
                        strMessage.Append("ReceiveAccName      = [" + JSON.GetKeyValue("ReceiveAccName") + "]<br/>");
                        strMessage.Append("MerchantRemarks      = [" + JSON.GetKeyValue("MerchantRemarks") + "]<br/>");
                        //5、商品明细

                        dic = JSON.GetArrayValue("OrderItems");
                        if (dic.Count == 0)
                            strMessage.Append("商品明细为空");
                        else
                        {
                            strMessage.Append("商品明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SubMerName      = [" + dic[key]["SubMerName"].ToString() + "],");
                                strMessage.Append("SubMerId      = [" + dic[key]["SubMerId"].ToString() + "],");
                                strMessage.Append("SubMerMCC      = [" + dic[key]["SubMerMCC"].ToString() + "],");
                                strMessage.Append("SubMerchantRemarks      = [" + dic[key]["SubMerchantRemarks"].ToString() + "],");
                                strMessage.Append("ProductID      = [" + dic[key]["ProductID"].ToString() + "],");
                                strMessage.Append("ProductName      = [" + dic[key]["ProductName"].ToString() + "],");
                                strMessage.Append("UnitPrice      = [" + dic[key]["UnitPrice"].ToString() + "],");
                                strMessage.Append("Qty      = [" + dic[key]["Qty"].ToString() + "],");
                                strMessage.Append("ProductRemarks      = [" + dic[key]["ProductRemarks"].ToString() + "],");
                            }
                        }
                        dic = JSON.GetArrayValue("SplitAccInfoItems");
                        if (dic.Count == 0)
                            strMessage.Append("分账账户信息为空");
                        else
                        {
                            strMessage.Append("分账账户信息明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SplitAcc      = [" + dic[key]["SplitAcc"].ToString() + "],");
                                strMessage.Append("SplitAmount      = [" + dic[key]["SplitAmount"].ToString() + "],");
                            }
                        }

                    }
                    else if (payTypeID.Equals("DividedPay") || payTypeID.Equals("PostponePay"))
                    {
                        strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                        strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                        strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                        strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                        strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
                        strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                        strMessage.Append("InstallmentCode      = [" + JSON.GetKeyValue("InstallmentCode") + "]<br/>");
                        strMessage.Append("InstallmentNum      = [" + JSON.GetKeyValue("InstallmentNum") + "]<br/>");
                        strMessage.Append("PaymentLinkType      = [" + JSON.GetKeyValue("PaymentLinkType") + "]<br/>");
                        strMessage.Append("AcctNo      = [" + JSON.GetKeyValue("AcctNo") + "]<br/>");
                        strMessage.Append("CommodityType      = [" + JSON.GetKeyValue("CommodityType") + "]<br/>");
                        strMessage.Append("ReceiverAddress      = [" + JSON.GetKeyValue("ReceiverAddress") + "]<br/>");
                        strMessage.Append("BuyIP      = [" + JSON.GetKeyValue("BuyIP") + "]<br/>");
                        strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");
                        strMessage.Append("ReceiveAccount      = [" + JSON.GetKeyValue("ReceiveAccount") + "]<br/>");
                        strMessage.Append("ReceiveAccName      = [" + JSON.GetKeyValue("ReceiveAccName") + "]<br/>");
                        strMessage.Append("MerchantRemarks      = [" + JSON.GetKeyValue("MerchantRemarks") + "]<br/>");

                        dic = JSON.GetArrayValue("OrderItems");
                        if (dic.Count == 0)
                            strMessage.Append("商品明细为空");
                        else
                        {
                            strMessage.Append("商品明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SubMerName      = [" + dic[key]["SubMerName"].ToString() + "],");
                                strMessage.Append("SubMerId      = [" + dic[key]["SubMerId"].ToString() + "],");
                                strMessage.Append("SubMerMCC      = [" + dic[key]["SubMerMCC"].ToString() + "],");
                                strMessage.Append("SubMerchantRemarks      = [" + dic[key]["SubMerchantRemarks"].ToString() + "],");
                                strMessage.Append("ProductID      = [" + dic[key]["ProductID"].ToString() + "],");
                                strMessage.Append("ProductName      = [" + dic[key]["ProductName"].ToString() + "],");
                                strMessage.Append("UnitPrice      = [" + dic[key]["UnitPrice"].ToString() + "],");
                                strMessage.Append("Qty      = [" + dic[key]["Qty"].ToString() + "],");
                                strMessage.Append("ProductRemarks      = [" + dic[key]["ProductRemarks"].ToString() + "],");
                            }
                        }

                        dic = JSON.GetArrayValue("Distribution");
                        if (dic.Count == 0)
                            strMessage.Append("分账账户信息为空");
                        else
                        {
                            strMessage.Append("分账账户信息明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("DisAccountNo      = [" + dic[key]["DisAccountNo"].ToString() + "],");
                                strMessage.Append("DisAccountName      = [" + dic[key]["DisAccountName"].ToString() + "],");
                                strMessage.Append("DisAmount      = [" + dic[key]["DisAmount"].ToString() + "],");
                            }
                        }
                        dic = JSON.GetArrayValue("SplitAccInfoItems");
                        if (dic.Count == 0)
                            strMessage.Append("分账账户信息为空");
                        else
                        {
                            strMessage.Append("分账账户信息明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SplitAcc      = [" + dic[key]["SplitAcc"].ToString() + "],");
                                strMessage.Append("SplitAmount      = [" + dic[key]["SplitAmount"].ToString() + "],");
                            }
                        }

                    }
                    else if (payTypeID.Equals("Refund"))
                    {
                        strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                        strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                        strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                        strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                        strMessage.Append("RefundAmount      = [" + JSON.GetKeyValue("RefundAmount") + "]<br/>");
                        strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                        strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");                        
                        strMessage.Append("MerRefundAccountNo      = [" + JSON.GetKeyValue(" MerRefundAccountNo") + "]<br/>");
                        strMessage.Append("MerRefundAccountName      = [" + JSON.GetKeyValue(" MerRefundAccountName") + "]<br/>");
                        dic = JSON.GetArrayValue("SplitAccInfoItems");
                        if (dic.Count == 0)
                            strMessage.Append("分账账户信息为空");
                        else
                        {
                            strMessage.Append("分账账户信息明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SplitAcc      = [" + dic[key]["SplitAcc"].ToString() + "],");
                                strMessage.Append("SplitAmount      = [" + dic[key]["SplitAmount"].ToString() + "],");
                            }
                        }
                    }
                    else if (payTypeID.Equals("AgentPay"))
                    {
                        strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                        strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                        strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                        strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                        strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
                        strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                        strMessage.Append("InstallmentCode      = [" + JSON.GetKeyValue("InstallmentCode") + "]<br/>");
                        strMessage.Append("InstallmentNum      = [" + JSON.GetKeyValue("InstallmentNum") + "]<br/>");
                        strMessage.Append("PaymentLinkType      = [" + JSON.GetKeyValue("PaymentLinkType") + "]<br/>");
                        strMessage.Append("AcctNo      = [" + JSON.GetKeyValue("AcctNo") + "]<br/>");
                        strMessage.Append("CommodityType      = [" + JSON.GetKeyValue("CommodityType") + "]<br/>");
                        strMessage.Append("ReceiverAddress      = [" + JSON.GetKeyValue("ReceiverAddress") + "]<br/>");
                        strMessage.Append("BuyIP      = [" + JSON.GetKeyValue("BuyIP") + "]<br/>");
                        strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");
                        strMessage.Append("ReceiveAccount      = [" + JSON.GetKeyValue("ReceiveAccount") + "]<br/>");
                        strMessage.Append("ReceiveAccName      = [" + JSON.GetKeyValue("ReceiveAccName") + "]<br/>");
                        strMessage.Append("MerchantRemarks      = [" + JSON.GetKeyValue("MerchantRemarks") + "]<br/>");
                        dic = JSON.GetArrayValue("OrderItems");
                        if (dic.Count == 0)
                            strMessage.Append("商品明细为空");
                        else
                        {
                            strMessage.Append("商品明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SubMerName      = [" + dic[key]["SubMerName"].ToString() + "],");
                                strMessage.Append("SubMerId      = [" + dic[key]["SubMerId"].ToString() + "],");
                                strMessage.Append("SubMerMCC      = [" + dic[key]["SubMerMCC"].ToString() + "],");
                                strMessage.Append("SubMerchantRemarks      = [" + dic[key]["SubMerchantRemarks"].ToString() + "],");
                                strMessage.Append("ProductID      = [" + dic[key]["ProductID"].ToString() + "],");
                                strMessage.Append("ProductName      = [" + dic[key]["ProductName"].ToString() + "],");
                                strMessage.Append("UnitPrice      = [" + dic[key]["UnitPrice"].ToString() + "],");
                                strMessage.Append("Qty      = [" + dic[key]["Qty"].ToString() + "],");
                                strMessage.Append("ProductRemarks      = [" + dic[key]["ProductRemarks"].ToString() + "],");
                            }
                        }
                        dic = new System.Collections.Generic.Dictionary<int, Hashtable>();
                        //4、获取分账账户信息
                        dic = JSON.GetArrayValue("Distribution");
                        if (dic.Count == 0)
                            strMessage.Append("分账账户信息明细为空<br/>");
                        else
                        {
                            strMessage.Append("分账账户信息明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("DisAccountNo      = [" + dic[key]["DisAccountNo"] + "],");//分账账号
                                strMessage.Append("DisAccountName      = [" + dic[key]["DisAccountName"] + "],");//分账账户
                                strMessage.Append("DisAmount      = [" + dic[key]["DisAmount"] + "]<br/>");//分账金额
                            }
                        }
                    }
                    else if (payTypeID.Equals("PreAuthed") || payTypeID.Equals("PreAuthCancel"))
                    {
                        strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                        strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                        strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                        strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                        strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
                        strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                        strMessage.Append("AcctNo      = [" + JSON.GetKeyValue("AcctNo") + "]<br/>");
                        strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");
                        strMessage.Append("ReceiveAccount      = [" + JSON.GetKeyValue("ReceiveAccount") + "]<br/>");
                        strMessage.Append("ReceiveAccName      = [" + JSON.GetKeyValue("ReceiveAccName") + "]<br/>");

                    }
                    else
                    {
                        strMessage.Append("PayTypeID      = [" + JSON.GetKeyValue("PayTypeID") + "]<br/>");
                        strMessage.Append("OrderNo      = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
                        strMessage.Append("OrderDate      = [" + JSON.GetKeyValue("OrderDate") + "]<br/>");
                        strMessage.Append("OrderTime      = [" + JSON.GetKeyValue("OrderTime") + "]<br/>");
                        strMessage.Append("OrderAmount      = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
                        strMessage.Append("Status      = [" + JSON.GetKeyValue("Status") + "]<br/>");
                        strMessage.Append("AcctNo      = [" + JSON.GetKeyValue("AcctNo") + "]<br/>");
                        strMessage.Append("iRspRef      = [" + JSON.GetKeyValue("iRspRef") + "]<br/>");
                        strMessage.Append("ReceiveAccount      = [" + JSON.GetKeyValue("ReceiveAccount") + "]<br/>");
                        strMessage.Append("ReceiveAccName      = [" + JSON.GetKeyValue("ReceiveAccName") + "]<br/>");
                        dic = JSON.GetArrayValue("SplitAccInfoItems");
                        if (dic.Count == 0)
                            strMessage.Append("分账账户信息为空");
                        else
                        {
                            strMessage.Append("分账账户信息明细为:<br/>");
                            foreach (int key in dic.Keys)
                            {
                                strMessage.Append("SplitAcc      = [" + dic[key]["SplitAcc"].ToString() + "],");
                                strMessage.Append("SplitAmount      = [" + dic[key]["SplitAmount"].ToString() + "],");
                            }
                        }
                    }
                }
            }
        }
        else
        {
            //6、商户订单查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-交易查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        交易查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易类型</td>
                <td style="width: 158px">
                    <asp:DropDownList ID="txtPayTypeID" runat="server">
                        <asp:ListItem Value="ImmediatePay" Selected="True">直接支付</asp:ListItem>
                        <asp:ListItem Value="PreAuthPay">预授权支付</asp:ListItem>
                        <asp:ListItem Value="DividedPay">分期支付</asp:ListItem>
                        <asp:ListItem Value="PostponePay">分期延期支付</asp:ListItem>
                        <asp:ListItem Value="AgentPay">授权支付</asp:ListItem>
                        <asp:ListItem Value="Refund">退款</asp:ListItem>
                        <asp:ListItem Value="DefrayPay">付款</asp:ListItem>
                        <asp:ListItem Value="PreAuthed">预授权确认</asp:ListItem>
                        <asp:ListItem Value="PreAuthCancel">预授权取消</asp:ListItem>
                        <asp:ListItem Value="TransferPay">内转外转交易</asp:ListItem>
                    </asp:DropDownList>*必输</td>
            </tr>
            <tr>
                <td>OrderNo</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>DetailQuery（0：状态查询； 1：详细查询）*必输</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDetailQuery' Text='0' /></td>
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
