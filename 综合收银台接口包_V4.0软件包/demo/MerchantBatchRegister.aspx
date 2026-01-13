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

    private bool ValidateRequestPara(out int iTotalCount, out decimal iTotalAmount, out int iBatchCount, out decimal iBatchAmount, out string[] merchantno_arr, out string[] orderno_arr, out string[] neworderno_arr, out string[] orderdate_arr, out string[] orderamount_arr, out string[] trnxcode_arr, out string[] trnxtype_arr,
             out string[] currencycode_arr, out string[] customid_arr, out string[] productname_arr, out string[] feeamount_arr, out string[] submerchantno_arr, out string[] submerchantname_arr, out string[] remark_arr)
    {
        string tTotalCount = Request["TotalCount"];
        string tTotalAmount = Request["TotalAmount"];
        string tBatchCount = Request["BatchCount"];
        string tBatchAmount = Request["BatchAmount"];

        //取得列表项
        string[] v_merchantno_arr = null;
        string[] v_orderno_arr = null;
        string[] v_neworderno_arr = null;
        string[] v_orderdate_arr = null;
        string[] v_orderamount_arr = null;
        string[] v_trnxcode_arr = null;
        string[] v_trnxtype_arr = null;
        string[] v_currencycode_arr = null;
        string[] v_customid_arr = null;
        string[] v_productname_arr = null;
        string[] v_feeamount_arr = null;
        string[] v_submerchantno_arr = null;
        string[] v_submerchantname_arr = null;
        string[] v_remark_arr = null;
        int v_tTotalCount = 0;
        int v_tBatchCount = 0;
        decimal v_tTotalAmount = 0;
        decimal v_tBatchAmount = 0;

        //初始化
        iTotalCount = v_tTotalCount;
        iTotalAmount = v_tTotalAmount;
        iBatchCount = v_tBatchCount;
        iBatchAmount = v_tBatchAmount;
        merchantno_arr = v_merchantno_arr;
        orderno_arr = v_orderno_arr;
        neworderno_arr = v_neworderno_arr;
        orderdate_arr = v_orderdate_arr;
        orderamount_arr = v_orderamount_arr;
        trnxcode_arr = v_trnxcode_arr;
        trnxtype_arr = v_trnxtype_arr;
        currencycode_arr = v_currencycode_arr;
        customid_arr = v_customid_arr;
        productname_arr = v_productname_arr;
        feeamount_arr = v_feeamount_arr;
        submerchantno_arr = v_submerchantno_arr;
        submerchantname_arr = v_submerchantname_arr;
        remark_arr = v_remark_arr;

        try
        {
            v_tTotalCount = int.Parse(Request["TotalCount"]);
            v_tTotalAmount = decimal.Parse(Request["TotalAmount"]);
            v_tBatchCount = int.Parse(Request["BatchCount"]);
            v_tBatchAmount = decimal.Parse(Request["BatchAmount"]);
        }
        catch (Exception ex)
        {
            lblMessage.Text = "总金额和总笔数必输是数字，请重新输入!";
            return false;
        }

        string merchantno = Request["txtMerchantNo"];
        string orderno = Request["txtOrderNo"];
        string neworderno = Request["txtUnionPayOrderNo"];
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
        string remark = Request["txtRemark"];

        if (merchantno.Contains(","))
        {
            v_merchantno_arr = merchantno.Split(',');
        }
        else
        {
            v_merchantno_arr = new string[] { merchantno };
        }
        if (orderno.Contains(","))
        {
            v_orderno_arr = orderno.Split(',');
        }
        else
        {
            v_orderno_arr = new string[] { orderno };
        }
        if (neworderno.Contains(","))
        {
            v_neworderno_arr = neworderno.Split(',');
        }
        else
        {
            v_neworderno_arr = new string[] { neworderno };
        }
        if (orderdate.Contains(","))
        {
            v_orderdate_arr = orderdate.Split(',');
        }
        else
        {
            v_orderdate_arr = new string[] { orderdate };
        }
        if (orderamount.Contains(","))
        {
            v_orderamount_arr = orderamount.Split(',');
        }
        else
        {
            v_orderamount_arr = new string[] { orderamount };
        }
        if (trnxcode.Contains(","))
        {
            v_trnxcode_arr = trnxcode.Split(',');
        }
        else
        {
            v_trnxcode_arr = new string[] { trnxcode };
        }
        if (trnxtype.Contains(","))
        {
            v_trnxtype_arr = trnxtype.Split(',');
        }
        else
        {
            v_trnxtype_arr = new string[] { trnxtype };
        }
        if (currencycode.Contains(","))
        {
            v_currencycode_arr = currencycode.Split(',');
        }
        else
        {
            v_currencycode_arr = new string[] { currencycode };
        }
        if (customid.Contains(","))
        {
            v_customid_arr = customid.Split(',');
        }
        else
        {
            v_customid_arr = new string[] { customid };
        }
        if (productname.Contains(","))
        {
            v_productname_arr = productname.Split(',');
        }
        else
        {
            v_productname_arr = new string[] { productname };
        }
        if (feeamount.Contains(","))
        {
            v_feeamount_arr = feeamount.Split(',');
        }
        else
        {
            v_feeamount_arr = new string[] { feeamount };
        }
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
        if (remark.Contains(","))
        {
            v_remark_arr = remark.Split(',');
        }
        else
        {
            v_remark_arr = new string[] { remark };
        }
        int orderno_length = v_orderno_arr.Length;
        int orderamount_length = v_orderamount_arr.Length;
        if (orderno_length != v_tTotalCount || orderamount_length != v_tTotalCount)
        {
            lblMessage.Text = "退款总笔数和退款订单总数不一致，正确的退款总笔数是：" + orderno_length;
            return false;
        }

        //验证订单非空
        foreach (string v_orderno in v_orderno_arr)
        {
            if (v_orderno == "")
            {
                lblMessage.Text = "交易编号不允许为空";
                return false;
            }
        }
        foreach (string v_neworderno in v_neworderno_arr)
        {
            if (v_neworderno == "")
            {
                lblMessage.Text = "银联订单编号不允许为空";
                return false;
            }
        }
        foreach (string v_currencycode in v_currencycode_arr)
        {
            if (v_currencycode != "156")
            {
                lblMessage.Text = "交易币种非人民币";
                return false;
            }
        }
        //验证单笔订单退款金额非空并且是数字
        decimal totalAmount = 0.0M;
        foreach (string v_orderamount in v_orderamount_arr)
        {
            if (v_orderamount != "")
            {
                try
                {
                    totalAmount = totalAmount + decimal.Parse(v_orderamount);
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "订单金额必输为数字";
                    return false;
                }
            }
            else
            {
                lblMessage.Text = "订单金额不允许为空";
                return false;
            }
        }

        //验证订单退款总金额与退款总金是否相等
        if (totalAmount != v_tTotalAmount)
        {
            lblMessage.Text = "总金额与退款订单总金额不一致";
            return false;
        }

        iTotalCount = v_tTotalCount;
        iBatchCount = v_tBatchCount;
        iTotalAmount = v_tTotalAmount;
        iBatchAmount = v_tBatchAmount;
        merchantno_arr = v_merchantno_arr;
        orderno_arr = v_orderno_arr;
        neworderno_arr = v_neworderno_arr;
        orderdate_arr = v_orderdate_arr;
        orderamount_arr = v_orderamount_arr;
        trnxcode_arr = v_trnxcode_arr;
        trnxtype_arr = v_trnxtype_arr;
        currencycode_arr = v_currencycode_arr;
        customid_arr = v_customid_arr;
        productname_arr = v_productname_arr;
        feeamount_arr = v_feeamount_arr;
        submerchantno_arr = v_submerchantno_arr;
        submerchantname_arr = v_submerchantno_arr;
        remark_arr = v_remark_arr;
        return true;
    }

    protected void btnButton_Click(object sender, EventArgs e)
    {
        string[] merchantno_arr = null;
        string[] orderno_arr = null;
        string[] neworderNo_arr = null;
        string[] orderdate_arr = null;
        string[] orderamount_arr = null;
        string[] trnxcode_arr = null;
        string[] trnxtype_arr = null;
        string[] currencycode_arr = null;
        string[] customid_arr = null;
        string[] productname_arr = null;
        string[] feeamount_arr = null;
        string[] submerchantno_arr = null;
        string[] submerchantname_arr = null;
        string[] remark_arr = null;
        int iTotalCount, iBatchCount = 0;
        decimal iTotalAmount, iBatchAmount = 0;

        StringBuilder strMessage = new StringBuilder("");
        //验证输入信息并取得退款所需要的信息
        if (!ValidateRequestPara(out iTotalCount, out iTotalAmount, out iBatchCount, out iBatchAmount, out merchantno_arr, out orderno_arr, out neworderNo_arr, out orderdate_arr, out orderamount_arr, out trnxcode_arr, out trnxtype_arr,
             out currencycode_arr, out customid_arr, out productname_arr, out feeamount_arr, out submerchantno_arr, out submerchantname_arr, out remark_arr))
            return;
        //1、生成批量退款请求对象
        com.abc.trustpay.client.ebus.BatchRegisterRequest tBatchRefundRequest = new com.abc.trustpay.client.ebus.BatchRegisterRequest();
        //取得列表项 
        System.Collections.Generic.Dictionary<string, string> dic = new System.Collections.Generic.Dictionary<string, string>();
        for (int i = 0; i < orderno_arr.Length; i++)
        {
            //string[] torder = new String[6];
            dic["SeqNo"] = Convert.ToString(i + 1);
            dic["MerchantNo"] = merchantno_arr[i];
            dic["OrderNo"] = orderno_arr[i];
            dic["UnionPayOrderNo"] = neworderNo_arr[i];
            dic["OrderDate"] = orderdate_arr[i];
            dic["OrderAmount"] = orderamount_arr[i];
            dic["TrnxCode"] = trnxcode_arr[i];
            dic["TrnxType"] = trnxtype_arr[i];
            dic["CurrencyCode"] = currencycode_arr[i];
            dic["CustomId"] = customid_arr[i];
            dic["ProductName"] = productname_arr[i];
            dic["FeeAmount"] = feeamount_arr[i];
            dic["SubMerchantNo"] = submerchantno_arr[i];
            dic["SubMerchantName"] = submerchantname_arr[i];
            dic["Remark"] = remark_arr[i];
            tBatchRefundRequest.dic.Add(i, dic);
            dic = new System.Collections.Generic.Dictionary<string, string>();
        }
        tBatchRefundRequest.batchRegisterRequest["BatchNo"] = txtBatchNo.Text; //批量编号  （必要信息）
        tBatchRefundRequest.batchRegisterRequest["BatchDate"] = txtBatchDate.Text;  //订单日期  （必要信息）
        tBatchRefundRequest.batchRegisterRequest["BatchTime"] = txtBatchTime.Text; //订单时间  （必要信息）
        tBatchRefundRequest.batchRegisterRequest["BatchCount"] = iBatchCount.ToString();  //商户退款账号
        tBatchRefundRequest.batchRegisterRequest["BatchAmount"] = iBatchAmount.ToString(); //商户退款名
        tBatchRefundRequest.batchRegisterRequest["TotalCount"] = iTotalCount.ToString();  //总笔数  （必要信息）
        tBatchRefundRequest.batchRegisterRequest["TotalAmount"] = iTotalAmount.ToString();  //总金额 （必要信息）

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
            strMessage.Append("TotalCount  = [" + JSON.GetKeyValue("TotalCount") + "]<br/>");
            strMessage.Append("TotalAmount = [" + JSON.GetKeyValue("TotalAmount") + "]<br/>");
            strMessage.Append("SerialNumber  = [" + JSON.GetKeyValue("SerialNumber") + "]<br/>");
            strMessage.Append("HostDate  = [" + JSON.GetKeyValue("HostDate") + "]<br/>");
            strMessage.Append("HostTime  = [" + JSON.GetKeyValue("HostTime") + "]<br/>");
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
        var count = form1.TotalCount.value;
        var amount = form1.TotalAmount.value;
        if (!ValidateRequestPara(count, amount))
            return false;
        ioldcount = parseInt(stroldcount);
        count = parseInt(count);
        var currCount = bach.rows.length;
        for (var j = currCount ; j > 0; j--) {
            try {
                bach.deleteRow(j);
            }
            catch (e) { }
        }

        for (var i = 1 ; i <= count - ioldcount; i++) {
            var index = formatIndex(i);
            var row = bach.insertRow();
            for (var j = 0 ; j < 15; j++) {
                var col = row.insertCell();
                switch (j) {
                    case 0:
                        col.align = "left";
                        col.height = "30";
                        col.innerHTML = index;
                        break;
                    case 1:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtMerchantNo\" style=\"width:95%\" value=\"103882200000958\">";
                        break;
                    case 2:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtOrderNo\" style=\"width:95%\" value=\"ON200905010001\">";
                        break;
                    case 3:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtUnionPayOrderNo\" style=\"width:95%\" value=\"ON200905010002\">";
                        break;
                    case 4:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtOrderDate\" style=\"width:95%\" value=\"2019-11-08\">";
                        break;
                    case 5:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtOrderAmount\" style=\"width:95%\" value=\"0.01\">";
                        break;
                    case 6:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtTrnxCode\" style=\"width:95%\" value=\"1\">";
                        break;
                    case 7:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtTrnxType\" style=\"width:95%\" value=\"Sale\">";
                        break;
                    case 8:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtCurrencyCode\" style=\"width:95%\" value=\"156\">";
                        break;
                    case 9:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtCustomId\" style=\"width:95%\" value=\"123456\">";
                        break;
                    case 10:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtFeeAmount\" style=\"width:95%\" value=\"0.01\">";
                        break;
                    case 11:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtSubMerchantNo\" style=\"width:95%\" value=\"22222222\">";
                        break;
                    case 12:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtSubMerchantName\" style=\"width:95%\" value=\"二级商户名称\">";
                        break;
                    case 13:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtProductName\" style=\"width:95%\" value=\"商品名称\">";
                        break;
                    case 14:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtRemark\" style=\"width:95%\" value=\"备注\">";
                        break;
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
        批量登记三方订单
    </center>
    <form id="form1" runat="server">
        <div style="color: Red; margin-bottom: 5px;">
            <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        </div>
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
                <td>批量编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchNo' Text='0001' />*必输</td>
            </tr>
            <tr width="">
                <td>本批次笔数</td>
                <td>
                    <input name='BatchCount' value='10'>*必输</td>
            </tr>
            <tr>
                <td>本批次金额</td>
                <td>
                    <input name='BatchAmount' value='0.10'>*必输</td>
            </tr>
            <tr width="">
                <td>交易总笔数</td>
                <td>
                    <input name='TotalCount' value='10'>*必输</td>
            </tr>
            <tr>
                <td>交易总金额</td>
                <td>
                    <input name='TotalAmount' value='0.10'>*必输</td>
                <td>
                    <input type='button' value=' 添加 ' name="AddOrder" onclick="addLine()"></td>
            </tr>
            <tr>
                <td colspan="2">
                    <table border="1" style="font-size: 12px;" width="100%" id="bach">
                        <tr>
                            <td width="15%" align="center">序号</td>
                            <td width="15%" align="center">商户号</td>
                            <td width="15%" align="center">订单号</td>
                            <td width="15%" align="center">银联订单号</td>
                            <td width="15%" align="center">订单日期</td>
                            <td width="15%" align="center">订单金额</td>
                            <td width="15%" align="center">业务类型</td>
                            <td width="15%" align="center">交易类型</td>
                            <td width="15%" align="center">交易币种</td>
                            <td width="15%" align="center">客户标识</td>
                            <td width="15%" align="center">手续费</td>
                            <td width="15%" align="center">二级商户号</td>
                            <td width="15%" align="center">二级商户名称</td>
                            <td width="15%" align="center">商品名称</td>
                            <td width="15%" align="center">备注</td>
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
