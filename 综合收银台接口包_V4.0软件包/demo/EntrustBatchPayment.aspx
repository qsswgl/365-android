<!--
/*
 * Project: 
 *
 * Description:
 *    代收业务批量扣款
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var ranNum = new Random().Next(9999999);
            txtBatchNo.Text = "DSYWPLKK" + ranNum;
        }
    }
    
    protected void btnButton_Click(object sender, EventArgs e)
    {
        StringBuilder strMessage = new StringBuilder("");

        //1、取得批量授权扣款需要的信息
        string totalCount = Request["TotalCount"];
        string totalAmount = Request["TotalAmount"];

        string[] seqno_arr = null;
        string[] orderno_arr = null;
        string[] entrustsignno_arr = null;
        string[] cardno_arr = null;
        string[] orderamount_arr = null;
        string[] businesscode_arr = null;
        string[] receiveraddress_arr = null;
        string[] buyip_arr = null;
        string[] remark_arr = null;
        string[] submerchantno_arr = null;

        string seqno = Request["SeqNo"];
        string orderno = Request["OrderNo"];
        string entrustsignno = Request["EntrustSignNo"];
        string cardno = Request["CardNo"];
        string orderamount = Request["OrderAmount"];
        string businesscode = Request["BusinessCode"];      
        string receiveraddress = Request["ReceiverAddress"];
        string buyip = Request["BuyIP"];
        string remark = Request["Remark"];
        string submerchantno = Request["SubMerchantNo"];
        
        int iBatchSize = int.Parse(totalCount);

        if (iBatchSize == 1)
        {
            seqno_arr = new string[] { seqno };
            orderno_arr = new string[] { orderno };
            entrustsignno_arr = new string[] { entrustsignno };
            cardno_arr = new string[] { cardno };
            orderamount_arr = new string[] { orderamount };
            businesscode_arr = new string[] { businesscode };
            receiveraddress_arr = new string[] { receiveraddress };
            buyip_arr = new string[] { buyip };
            remark_arr = new string[] { remark };
            submerchantno_arr = new string[] { submerchantno };
        }
        else
        {
            seqno_arr = seqno.Split(',');
            orderno_arr = orderno.Split(',');
            entrustsignno_arr = entrustsignno.Split(',');
            cardno_arr = cardno.Split(',');
            orderamount_arr = orderamount.Split(',');
            businesscode_arr = businesscode.Split(',');
            receiveraddress_arr = receiveraddress.Split(',');
            buyip_arr = buyip.Split(',');
            remark_arr = remark.Split(',');
            submerchantno_arr = submerchantno.Split(',');
        }
        //2、生成批量授权扣款请求对象
        com.abc.trustpay.client.ebus.EntrustBatchPaymentRequest tRequest = new com.abc.trustpay.client.ebus.EntrustBatchPaymentRequest();
        tRequest.agentBatch["BatchNo"] = txtBatchNo.Text;
        tRequest.agentBatch["BatchDate"] = txtBatchDate.Text;
        tRequest.agentBatch["BatchTime"] = txtBatchTime.Text;
        tRequest.agentBatch["TotalCount"] = totalCount;
        tRequest.agentBatch["TotalAmount"] = totalAmount;

        tRequest.dicRequest["ReceiveAccount"] = txtReceiveAccount.Text;
        tRequest.dicRequest["ReceiveAccName"] = txtReceiveAccName.Text;
        tRequest.dicRequest["CurrencyCode"] = txtCurrencyCode.Text;

        //3、生成每个批次包明细
        System.Collections.Generic.Dictionary<string, string> item = new System.Collections.Generic.Dictionary<string, string>();
        for (int i = 0; i < orderno_arr.Length; i++)
        {
            item["SeqNo"] = seqno_arr[i];
            item["OrderNo"] = orderno_arr[i];
            item["EntrustSignNo"] = entrustsignno_arr[i];
            item["CardNo"] = cardno_arr[i];
            item["OrderAmount"] = orderamount_arr[i];
            item["BusinessCode"] = businesscode_arr[i];
            item["ReceiverAddress"] = receiveraddress_arr[i];
            item["BuyIP"] = buyip_arr[i];
            item["Remark"] = remark_arr[i];
            item["SubMerchantNo"] = submerchantno_arr[i];
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
        var count = form1.TotalCount.value;
        if (isNaN(count)) {
            alert("批次总笔数请输入数字！");
            return false;
        }
        count = parseInt(count);
        form1.TotalAmount.value = 0.01 * count;

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
            for (var j = 0 ; j < 10  ; j++) {
                var col = row.insertCell();
                switch (j) {
                    case 0:
                        col.align = "left";
                        col.height = "30";
                        col.innerHTML = "<input type=\"text\" name=\"SeqNo\" style=\"width:95%\" value=\"" + i + "\">";
                        break;
                    case 1:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"OrderNo\" style=\"width:95%\" value=\"" + form1.txtBatchNo.value + index + "\">";
                        break;
                    case 2:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"EntrustSignNo\" style=\"width:95%\" value=\"lixuan20210331003\">";
                        break;
                    case 3:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"CardNo\" style=\"width:95%\" value=\"\">";
                        break;
                    case 4:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"OrderAmount\" style=\"width:95%\" value=\"0.01\">";
                        break;
                    case 5:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"BusinessCode\" style=\"width:95%\" value=\"110014\">";
                        break;
                    case 6:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"ReceiverAddress\" style=\"width:95%;\" value=\"北京\">";
                        break;
                    case 7:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"BuyIP\" style=\"width:95%;\" value=\"\">";
                        break;
                    case 8:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"Remark\" style=\"width:95%;\" value=\"测试\">";
                        break;
                    case 9:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"SubMerchantNo\" style=\"width:95%\" value=\"\">";
                        break;
                }
            }
        }
        form1.btnButton.disabled = "";
    }

    function submitFun() {
        var count = form1.TotalCount.value;
        if (isNaN(count))
            return false;
        count = parseInt(count);
        if (count == 1)
            form1.TotalAmount.value = form1.ordermount.value;
        else {
            var c = 0;
            for (var i = 0 ; i < count ; i++) {
                c = c + parseFloat(form1.orderamount[i].value);
            }
            form1.TotalAmount.value = c;
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
                    <asp:TextBox runat="server" ID='txtBatchNo' value='' />*必输</td>
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
                    <input name='TotalCount' value='10' />
                    *必输</td>
            </tr>
            <tr>
                <td>批次总金额</td>
                <td>
                    <input name='TotalAmount' value='0.00' />
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
                                    <td align="center">签约编号</td>
                                    <td align="center">卡号</td>
                                    <td align="center">交易金额</td>
                                    <td align="center">业务种类</td>
                                    <td align="center">收货地址</td>
                                    <td align="center">客户交易IP</td>
                                    <td align="center">附言</td>
                                    <td align="center">二级商户号</td>
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
