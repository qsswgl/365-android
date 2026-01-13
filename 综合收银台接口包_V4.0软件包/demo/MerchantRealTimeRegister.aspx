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
 *    abchina       2014/04/15  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    private bool ValidateRequestPara(out string orderno_arr, out string orderdate_arr, out string orderamount_arr, out string trnxcode_arr, out string trnxtype_arr,
             out string currencycode_arr, out string customid_arr, out string productname_arr, out string[] submerchantno_arr, out string[] submerchantname_arr,out string[] subAmt_arr, out string remark_arr)
    {
        //取得列表项
        string[] v_submerchantno_arr = null;
        string[] v_submerchantname_arr = null;
        string[] v_subAmt_arr = null;
        string v_remark_arr = null;

        //初始化
        orderno_arr = Request["txtOrderNo"].ToString();
        orderdate_arr = Request["txtOrderDate"].ToString(); 
        orderamount_arr = Request["txtOrderAmount"].ToString();
        trnxcode_arr = Request["txtTrnxCode"].ToString(); 
        trnxtype_arr = Request["txtTrnxType"].ToString(); 
        currencycode_arr = Request["txtCurrencyCode"].ToString(); 
        customid_arr = Request["txtCustomId"].ToString(); ;
        productname_arr = Request["txtProductName"].ToString();;
        submerchantno_arr = v_submerchantno_arr;
        submerchantname_arr = v_submerchantname_arr;
        subAmt_arr = v_subAmt_arr;
        remark_arr = v_remark_arr;

        try
        {
            decimal amt = decimal.Parse(orderamount_arr);
        }
        catch (Exception ex)
        {
            lblMessage.Text = "金额必输是数字，请重新输入!";
            return false;
        }

        string orderno = Request["txtOrderNo"];
        string orderdate = Request["txtOrderDate"];
        string orderamount = Request["txtOrderAmount"];
        string trnxcode = Request["txtTrnxCode"];
        string trnxtype = Request["txtTrnxType"];
        string currencycode = Request["txtCurrencyCode"];
        string customid = Request["txtCustomId"];
        string productname = Request["txtProductName"];
        string feeamount = Request["txtFeeAmount"];
        string submerchantno = Request["txtSubMerchantNo"];
        string submerchantname = Request["txtSubMerchantName"];
        string subAmt = Request["txtSubAmt"];
        string remark = Request["txtRemark"];

        if (submerchantno.Contains(","))
        {
            v_submerchantno_arr = submerchantno.Split(',');
        }
        else
        {
            v_submerchantno_arr = new string[] { submerchantno };
        }
        if (submerchantname.Contains(","))
        {
            v_submerchantname_arr = submerchantname.Split(',');
        }
        else
        {
            v_submerchantname_arr = new string[] { submerchantname };
        }
        if (subAmt.Contains(","))
        {
            v_subAmt_arr = subAmt.Split(',');
        }
        else
        {
            v_subAmt_arr = new string[] { subAmt };
        }

        //验证订单非空
        if (orderno == "")
        {
            lblMessage.Text = "交易编号不允许为空";
            return false;
        }
        if (currencycode != "156")
        {
            lblMessage.Text = "交易币种非人民币";
            return false;
        }
        try
        {
            Convert.ToDateTime(orderdate);        
        }
        catch (Exception e)
        {
            lblMessage.Text = "日期格式错误";
            return false;
        }

        orderno_arr = orderno;
        orderdate_arr = orderdate;
        orderamount_arr = orderamount;
        trnxcode_arr = trnxcode;
        trnxtype_arr = trnxtype;
        currencycode_arr = currencycode;
        customid_arr = customid;
        productname_arr = productname;
        submerchantno_arr = v_submerchantno_arr;
        submerchantname_arr = v_submerchantname_arr;
        subAmt_arr = v_subAmt_arr;
        remark_arr = v_remark_arr;
        return true;
    }

    protected void btnButton_Click(object sender, EventArgs e)
    {
        string orderno_arr = null;
        string orderdate_arr = null;
        string orderamount_arr = null;
        string trnxcode_arr = null;
        string trnxtype_arr = null;
        string currencycode_arr = null;
        string customid_arr = null;
        string productname_arr = null;
        string[] submerchantno_arr = null;
        string[] submerchantname_arr = null;
        string[] subAmt_arr = null;
        string remark_arr = null;

        StringBuilder strMessage = new StringBuilder("");
        //验证输入信息并取得退款所需要的信息
        if (!ValidateRequestPara(out orderno_arr, out orderdate_arr, out orderamount_arr, out trnxcode_arr, out trnxtype_arr,
             out currencycode_arr, out customid_arr, out productname_arr, out submerchantno_arr, out submerchantname_arr,out subAmt_arr, out remark_arr))
            return;
        //1、生成批量退款请求对象
        com.abc.trustpay.client.ebus.BatchRegisterRequest tBatchRefundRequest = new com.abc.trustpay.client.ebus.BatchRegisterRequest();
        //取得列表项 
        System.Collections.Generic.Dictionary<string, string> dic = new System.Collections.Generic.Dictionary<string, string>();
        for (int i = 0; i < submerchantno_arr.Length; i++)
        {
            dic["SeqNo"] = Convert.ToString(i + 1);
            dic["SubMerchantNo"] = submerchantno_arr[i];
            dic["SubMerchantName"] = submerchantname_arr[i];
            dic["SubAmt"] = subAmt_arr[i];
            tBatchRefundRequest.dic.Add(i, dic);
            dic = new System.Collections.Generic.Dictionary<string, string>();
        }
        tBatchRefundRequest.batchRegisterRequest["RequestNo"] = txtRequestNo.Text; //流水号
        tBatchRefundRequest.batchRegisterRequest["OrderNo"] = txtOrderNo.Text;  //
        tBatchRefundRequest.batchRegisterRequest["OrderDate"] = txtOrderDate.Text;  //
        tBatchRefundRequest.batchRegisterRequest["OrderAmount"] = txtOrderAmount.Text; //
        tBatchRefundRequest.batchRegisterRequest["TrnxCode"] = txtTrnxCode.Text;  //
        tBatchRefundRequest.batchRegisterRequest["TrnxType"] = txtTrnxType.Text;  //
        tBatchRefundRequest.batchRegisterRequest["CurrencyCode"] = txtCurrencyCode.Text;  //
        tBatchRefundRequest.batchRegisterRequest["CustomId"] = txtCustomId.Text;  //
        tBatchRefundRequest.batchRegisterRequest["ProductName"] = txtProductName.Text;  //
        tBatchRefundRequest.batchRegisterRequest["Remark"] = txtRemark.Text; 
        tBatchRefundRequest.batchRegisterRequest["OrderType"] = txtOrderType.Text; 

        //2、传送批量退款请求并取得结果
        tBatchRefundRequest.postJSONRequest();

        //3、判断批量退款结果状态，进行后续操作
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、批量退款成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ResultMessage   = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("SerialNumber  = [" + JSON.GetKeyValue("SerialNumber") + "]<br/>");
        }
        else
        {
            //5、批量退款失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

    

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口示例-批量退款</title>
</head>

<script language="javascript">
    var stroldcount = 0;
    var ioldcount = 0;
    function formatIndex(index) {
        if (index < 10)
            return "00" + index;
        else if (index >= 10 && index < 100)
            return "0" + index;
        else
            return index;
    }
    function ValidateRequestPara(count, amount) {
        //验证总笔数和总金额
        if (count == null || count == "") {
            alert("批次总笔数不能为空");
            return false;
        }
        if (isNaN(count)) {
            alert("批次总笔数请输入数字！");
            return false;
        }
        if (count < 1) {
            alert("批次总笔数必输是大于1的数字");
            return false;
        }
        if (amount == null || amount == "") {
            alert("总金额不能为空");
            return false;
        }
        if (isNaN(amount)) {
            alert("总金额请输入数字！");
            return false;
        }
        if (amount <= 0) {
            alert("总金额不能小于0");
            return false;
        }

        //验证批次详情

        return true;
    }
    function addLine() {
        var count = 1;
        //var amount = form1.TotalAmount.value;
        //if (!ValidateRequestPara(count, amount))
        //    return false;
        ioldcount = parseInt(stroldcount);
        count = parseInt(count);
        for (var i = 1 ; i <= count - ioldcount; i++) {
            var index = formatIndex(i);
            var row = bach.insertRow();
            for (var j = 0 ; j < 4; j++) {
                var col = row.insertCell();
                switch (j) {
                    case 0:
                        col.align = "left";
                        col.height = "30";
                        col.innerHTML = index;
                        break;
                    case 1:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtSubMerchantNo\" style=\"width:95%\" value=\"22222222\">";
                        break;
                    case 2:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtSubMerchantName\" style=\"width:95%\" value=\"二级商户名称\">";
                        break;
                    case 3:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtSubAmt\" style=\"width:95%\" value=\"\">";
                        break;
                    //case 4:
                    //    col.align = "center";
                    //    col.innerHTML = "<input type=\"text\" name=\"txtRemark\" style=\"width:95%\" value=\"备注\">";
                    //    break;
                }
            }
        }
        ioldcount = count;
        form1.btnButton.disabled = "";
    }
    function submitFun() {
        var count = form1.TotalCount.value;
        var amount = form1.TotalAmount.value;
        count = parseInt(count);
        if (count == 1)
            form1.TotalAmount.value = form1.orderamount.value;
        else {
            var c = 0;
            c = parseFloat(c);
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
        实时登记三方订单
    </center>
    <form id="form1" runat="server">
        <div style="color: Red; margin-bottom: 5px;">
            <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        </div>
        <br />
        <table>
            <tr>
                <td>流水号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtRequestNo' Text='202003300001' />*必输</td>
            </tr>
            <tr>
                <td>订单号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='' />*必输</td>
            </tr>
            <tr>
                <td>订单日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDate' Text='2020-03-20 11:11:11' />（yyyy-mm-dd HH:mm:ss）*必输</td>
            </tr>
            <tr>
                <td>订单金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderAmount' Text='1' />*必输</td>
            </tr>
            <tr>
                <td>交易类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtTrnxCode' Text='1' />*必输  包括1-POS支付、2-BMP支付、3-现金支付、4-商户自有支付方式、5-网银转账、6-其他、8-微信支付、9-支付宝支付。</td>
            </tr>
            <tr>
                <td>业务类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtTrnxType' Text='SUCCESS' />*必输 本字段对应微信对账单中的“交易状态”字段，如：“SUCCESS”、“REFUND”；对应支付宝对账单中的“业务类型”字段，如：“交易”、“退款”</td>
            </tr>
            <tr>
                <td>币种
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCurrencyCode' Text='156' />*必输</td>
            </tr>
            <tr>
                <td>用户标志
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomId' Text='' />*必输 本字段对应微信对账单中的“用户标识”字段，如：“otDNot6uuTOGLptNsyEB97uzRUQI”；对应支付宝对账单中的“对方账户”字段，如：“136****9066”、“146***@qq.com”</td>
            </tr>
            <tr>
                <td>商品名称
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtProductName' Text='' />*必输</td>
            </tr>
             <tr>
                <td>附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemark' Text='' />*必输</td>
            </tr>
            <tr>
                <td>订单类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderType' Text='' />*非必输</td>
            </tr>
            <tr>
                <td>
                    <input type='button' value=' 添加 ' name="AddOrder" onclick="addLine()"></td>
            </tr>
            <tr>
                <td colspan="2">
                    <table border="1" style="font-size: 12px;" width="100%" id="bach">
                        <tr>
                            <td width="15%" align="center">序号</td>
                            <td width="15%" align="center">二级商户号</td>
                            <td width="15%" align="center">二级商户名称</td>
                            <td width="15%" align="center">分账金额</td>
                            <tr>
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
