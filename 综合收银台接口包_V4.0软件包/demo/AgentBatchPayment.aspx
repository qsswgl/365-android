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
 *    abchina       2014/04/16  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        StringBuilder strMessage = new StringBuilder("");

        //1、取得批量授权扣款需要的信息
        string batchNo = Request["BatchNo"];
        string agentCount = Request["AgentCount"];
        string agentAmount = Request["AgentAmount"];

        string[] seqno_arr = null;
        string[] orderno_arr = null;
        string[] agentsignno_arr = null;
        string[] cardno_arr = null;
        string[] orderamount_arr = null;
        string[] receiveraddress_arr = null;
        string[] fee_arr = null;
        string[] certificateno_arr = null;
        string[] installmentmark_arr = null;
        string[] installmentcode_arr = null;
        string[] installmentnum_arr = null;
        string[] commoditytype_arr = null;
        string[] submername_arr = null;
        string[] submerid_arr = null;
        string[] submermcc_arr = null;
        string[] submerchantremarks_arr = null;
        string[] productid_arr = null;
        string[] productname_arr = null;
        string[] unitprice_arr = null;
        string[] qty_arr = null;
        string[] productremarks_arr = null;
        string[] producttype_arr = null;
        string[] productdiscount_arr = null;
        string[] productexpireddate_arr = null;
        string[] buyip_arr = null;
        string[] isBreakAccount_arr = null;
        string[] splitAccTemplate_arr = null;
        string[] remark_arr = null;

        string seqno = Request["SeqNo"];
        string orderno = Request["OrderNo"];
        string agentsignno = Request["AgentSignNo"];
        string cardno = Request["CardNo"];
        string orderamount = Request["OrderAmount"];
        string receiveraddress = Request["ReceiverAddress"];
        string fee = Request["Fee"];
        string certificateno = Request["CertificateNo"];
        string installmentmark = Request["InstallmentMark"];
        string installmentcode = Request["InstallmentCode"];
        string installmentnum = Request["InstallmentNum"];
        string commoditytype = Request["CommodityType"];
        string submername = Request["SubMerName"];
        string submerid = Request["SubMerId"];
        string submermcc = Request["SubMerMCC"];
        string submerchantremarks = Request["SubMerchantRemarks"];
        string productid = Request["ProductID"];
        string productname = Request["ProductName"];
        string unitprice = Request["UnitPrice"];
        string qty = Request["Qty"];
        string productremarks = Request["ProductRemarks"];
        string producttype = Request["ProductType"];
        string productdiscount = Request["ProductDiscount"];
        string productexpireddate = Request["ProductExpiredDate"];
        string buyip = Request["BuyIP"];
        string isBreakAccount = Request["IsBreakAccount"];
        string splitAccTemplate = Request["SplitAccTemplate"];
        string remark = Request["Remark"];
        int iBatchSize = int.Parse(agentCount);

        if (iBatchSize == 1)
        {
            seqno_arr = new string[] { seqno };
            orderno_arr = new string[] { orderno };
            agentsignno_arr = new string[] { agentsignno };
            cardno_arr = new string[] { cardno };
            orderamount_arr = new string[] { orderamount };
            receiveraddress_arr = new string[] { receiveraddress };
            fee_arr = new string[] { fee };
            certificateno_arr = new string[] { certificateno };
            installmentmark_arr = new string[] { installmentmark };
            installmentcode_arr = new string[] { installmentcode };
            installmentnum_arr = new string[] { installmentnum };
            commoditytype_arr = new string[] { commoditytype };
            submername_arr = new string[] { submername };
            submerid_arr = new string[] { submerid };
            submermcc_arr = new string[] { submermcc };
            submerchantremarks_arr = new string[] { submerchantremarks };
            productid_arr = new string[] { productid };
            productname_arr = new string[] { productname };
            unitprice_arr = new string[] { unitprice };
            qty_arr = new string[] { qty };
            productremarks_arr = new string[] { productremarks };
            producttype_arr = new string[] { producttype };
            productdiscount_arr = new string[] { productdiscount };
            productexpireddate_arr = new string[] { productexpireddate };
            buyip_arr = new string[] { buyip };
            isBreakAccount_arr = new string[] { isBreakAccount };
            splitAccTemplate_arr = new string[] { splitAccTemplate };
            remark_arr = new string[] { remark };
        }
        else
        {
            seqno_arr = seqno.Split(',');
            orderno_arr = orderno.Split(',');
            agentsignno_arr = agentsignno.Split(',');
            cardno_arr = cardno.Split(',');
            orderamount_arr = orderamount.Split(',');
            receiveraddress_arr = receiveraddress.Split(',');
            fee_arr = fee.Split(',');
            certificateno_arr = certificateno.Split(',');
            installmentmark_arr = installmentmark.Split(',');
            installmentcode_arr = installmentcode.Split(',');
            installmentnum_arr = installmentnum.Split(',');
            commoditytype_arr = commoditytype.Split(',');
            submername_arr = submername.Split(',');
            submerid_arr = submerid.Split(',');
            submermcc_arr = submermcc.Split(',');
            submerchantremarks_arr = submerchantremarks.Split(',');
            productid_arr = productid.Split(',');
            productname_arr = productname.Split(',');
            unitprice_arr = unitprice.Split(',');
            qty_arr = qty.Split(',');
            productremarks_arr = productremarks.Split(',');
            producttype_arr = producttype.Split(',');
            productdiscount_arr = productdiscount.Split(',');
            productexpireddate_arr = productexpireddate.Split(',');
            buyip_arr = buyip.Split(',');
            isBreakAccount_arr = isBreakAccount.Split(',');
            splitAccTemplate_arr = splitAccTemplate.Split(',');
            remark_arr = remark.Split(',');
        }
        //2、生成批量授权扣款请求对象
        com.abc.trustpay.client.ebus.AgentBatchPaymentRequest tRequest = new com.abc.trustpay.client.ebus.AgentBatchPaymentRequest();
        tRequest.agentBatch["BatchNo"] = batchNo;
        tRequest.agentBatch["BatchDate"] = txtBatchDate.Text;
        tRequest.agentBatch["BatchTime"] = txtBatchTime.Text;
        tRequest.agentBatch["AgentCount"] = agentCount;
        tRequest.agentBatch["AgentAmount"] = agentAmount;

        tRequest.dicRequest["ReceiveAccount"] = txtReceiveAccount.Text;
        tRequest.dicRequest["ReceiveAccName"] = txtReceiveAccName.Text;
        tRequest.dicRequest["CurrencyCode"] = txtCurrencyCode.Text;

        //3、生成每个批次包明细
        System.Collections.Generic.Dictionary<string, string> item = new System.Collections.Generic.Dictionary<string, string>();
        for (int i = 0; i < orderno_arr.Length; i++)
        {
            item["SeqNo"] = seqno_arr[i];
            item["OrderNo"] = orderno_arr[i];
            item["AgentSignNo"] = agentsignno_arr[i];
            item["CardNo"] = cardno_arr[i];
            item["OrderAmount"] = orderamount_arr[i];
            item["ReceiverAddress"] = receiveraddress_arr[i];
            item["Fee"] = fee_arr[i];
            item["CertificateNo"] = certificateno_arr[i];
            item["InstallmentMark"] = installmentmark_arr[i];
            if (installmentmark_arr[i].ToString().Equals("1"))
            {
                item["InstallmentCode"] = installmentcode_arr[i];
                item["InstallmentNum"] = installmentnum_arr[i];
            }
            item["CommodityType"] = commoditytype_arr[i];
            item["SubMerName"] = submername_arr[i];
            item["SubMerId"] = submerid_arr[i];
            item["SubMerMCC"] = submermcc_arr[i];
            item["SubMerchantRemarks"] = submerchantremarks_arr[i];
            item["ProductID"] = productid_arr[i];
            item["ProductName"] = productname_arr[i];
            item["UnitPrice"] = unitprice_arr[i];
            item["Qty"] = qty_arr[i];
            item["ProductRemarks"] = productremarks_arr[i];
            item["ProductType"] = producttype_arr[i];
            item["ProductDiscount"] = productdiscount_arr[i];
            item["ProductExpiredDate"] = productexpireddate_arr[i];
            item["BuyIP"] = buyip_arr[i];
            item["IsBreakAccount"] = isBreakAccount_arr[i];
            item["SplitAccTemplate"] = splitAccTemplate_arr[i];
            item["Remark"] = remark_arr[i];
            tRequest.dic.Add(i, item);

            tRequest.iSumAmount += decimal.Parse(orderamount_arr[i].ToString());
            item = new System.Collections.Generic.Dictionary<string, string>();
        }
        //传送交易请求
        tRequest.postJSONRequest();

        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("批量受理成功!");
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("MerchantNo = [" + JSON.GetKeyValue("MerchantNo") + "]<br/>");
            strMessage.Append("SendTime   = [" + JSON.GetKeyValue("SendTime") + "]<br/>");

        }
        else
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口示例-批量授权扣款</title>
</head>

<script language="javascript">
    function formatIndex(index) {
        if (index < 10)
            return "00" + index;
        else if (index >= 10 && index < 10000)
            return "0" + index;
        else
            return index;
    }
    function addLine() {

        var count = form1.AgentCount.value;
        if (isNaN(count)) {
            alert("批次总笔数请输入数字！");
            return false;
        }
        count = parseInt(count);

        var currCount = batch.rows.length;
        for (var j = currCount ; j > 0; j--) {
            try {
                batch.deleteRow(j);
            }
            catch (e) { }
        }
        for (var i = 1 ; i <= count ; i++) {
            var index = formatIndex(i);
            var row = batch.insertRow();
            for (var j = 0 ; j < 28  ; j++) {
                var col = row.insertCell();
                switch (j) {
                    case 0:
                        col.align = "left";
                        col.height = "30";
                        col.innerHTML = "<input type=\"text\" name=\"SeqNo\" style=\"width:95%\" value=\"" + i + "\">";
                        break;
                    case 1:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"OrderNo\" style=\"width:95%\" value=\"" + form1.BatchNo.value + index + "\">";
                        break;
                    case 2:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"AgentSignNo\" style=\"width:95%\" value=\"" + i + "\">";
                        break;
                    case 3:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"CardNo\" style=\"width:95%\" value=\"5443333333333333\">";
                        break;
                    case 4:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"OrderAmount\" style=\"width:95%\" value=\"0.01\">";
                        break;
                    case 5:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ReceiverAddress\" style=\"width:95%\" value=\"北京\">";
                        break;
                    case 6:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"Fee\" style=\"width:95%\" value=\"0.01\">";
                        break;
                    case 7:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"CertificateNo\" style=\"width:95%\" value=\"370622222222222222\">";
                        break;
                    case 8:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"InstallmentMark\" style=\"width:95%;\" value=\"1\">";
                        break;
                    case 9:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"InstallmentCode\" style=\"width:95%;\" value=\"11111111\">";
                        break;
                    case 10:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"InstallmentNum\" style=\"width:95%;\" value=\"11\">";
                        break;
                    case 11:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"CommodityType\" style=\"width:95%\" value=\"0101\">";
                        break;
                    case 12:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"SubMerName\" style=\"width:95%\" value=\"测试商户\"" + index + "\">";
                        break;
                    case 13:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"SubMerId\" style=\"width:95%\" value=\"43424242\">";
                        break;
                    case 14:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"SubMerMCC\" style=\"width:95%\" value=\"1234\">";
                        break;
                    case 15:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"SubMerchantRemarks\" style=\"width:95%\" value=\"测试商户账单\">";
                        break;
                    case 16:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ProductID\" style=\"width:95%\" value=\"IP00" + i + "\">";
                        break;
                    case 17:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ProductName\" style=\"width:95%\" value=\"测试商品\">";
                        break;
                    case 18:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"UnitPrice\" style=\"width:95%\" value=\"1.00\">";
                        break;
                    case 19:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"Qty\" style=\"width:95%\" value=\"" + index + "\">";
                        break;
                    case 20:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ProductRemarks\" style=\"width:95%\" value=\"test\">";
                        break;
                    case 21:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ProductType\" style=\"width:95%\" value=\"1\">";
                        break;
                    case 22:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ProductDiscount\" style=\"width:95%\" value=\"1\">";
                        break;
                    case 23:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ProductExpiredDate\" style=\"width:95%\" value=\"1\">";
                        break;
                    case 24:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"BuyIP\" style=\"width:95%\" value=\"\">";
                        break;
                    case 25:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"IsBreakAccount\" style=\"width:95%\" value=\"0\">";
                        break;
                    case 26:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"SplitAccTemplate\" style=\"width:95%\" value=\"\">";
                        break;
                    case 27:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"Remark\" style=\"width:95%\" value=\"测试\">";
                        break;
                }

            }
        }
        form1.btnButton.disabled = "";
    }
    function submitFun() {
        var count = form1.AgentCount.value;
        if (isNaN(count))
            return false;
        count = parseInt(count);
        if (count == 1)
            form1.AgentAmount.value = form1.ordermount.value;
        else {
            var c = 0;
            for (var i = 0 ; i < count ; i++) {
                c = c + parseFloat(form1.orderamount[i].value);
            }
            form1.AgentAmount.value = c;
        }
        form1.submit();
    }
</script>

<body style="font-size: 14px;">
    <center>
        批量授权扣款
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>批次编号</td>
                <td>
                    <input name='BatchNo' value='1' />*必输</td>
            </tr>
            <tr>
                <td>批次日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchDate' value='2004/12/23' />（YYYY/MM/DD）*必输</td>
            </tr>
            <tr>
                <td>批次时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchTime' Text='11:55:30' />（HH:MM:SS）*必输，</td>
            </tr>
            <tr>
                <td>批次总笔数</td>
                <td>
                    <input name='AgentCount' value='10' />
                    *必输</td>
            </tr>
            <tr>
                <td>批次总金额</td>
                <td>
                    <input name='AgentAmount' value='10.00' />
                    *必输</td>
                <td>

                    <tr>
                        <td>收款方账号
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID='txtReceiveAccount' Text='' />选输</td>
                    </tr>
                    <tr>
                        <td>收款方户名
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID='txtReceiveAccName' Text='' />选输</td>
                    </tr>
                    <tr>
                        <td>交易币种
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID='txtCurrencyCode' Text='156' />156:人民币,*必输</td>


                        <td>
                            <input type='button' value=' 添加 ' name="AddOrder" onclick="addLine()" /></td>
                    </tr>
            <tr>
                <td colspan="2">
                    <table border="1" style="font-size: 17px;" width="100%" id="batch">
                        <tr>
                            <td align="center">序号</td>
                            <td align="center">交易编号</td>
                            <td align="center">签约协议号</td>
                            <td align="center">账号</td>
                            <td align="center">金额</td>
                            <td align="center">收货人地址</td>
                            <td align="center">手续费金额</td>
                            <td align="center">证件号码</td>
                            <td align="center">分期标识</td>
                            <td align="center">分期代码</td>
                            <td align="center">分期期数</td>
                            <td align="center">商品种类</td>
                            <td align="center">二级商户名称</td>
                            <td align="center">二级商户代码</td>
                            <td align="center">二级商户MCC码</td>
                            <td align="center">二级商户备注项</td>
                            <td align="center">商品代码</td>
                            <td align="center">商品名称</td>
                            <td align="center">商品总价</td>
                            <td align="center">商品数量</td>
                            <td align="center">商品备注项</td>
                            <td align="center">商品类型</td>
                            <td align="center">商品折扣</td>
                            <td align="center">商品有效期</td>
                            <td align="center">客户IP</td>
                            <td align="center">交易是否分账,0:否；1:是</td>
                            <td align="center">分账模版编号</td>                            
                            <td align="center">备注</td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交页面内容" OnClick="btnButton_Click"
                        disabled="disabled" />
                    <a href='Merchant.html'>回商户首页</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
