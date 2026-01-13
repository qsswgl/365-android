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

    private bool ValidateRequestPara(out int iTotalCount, out decimal iTotalAmount, out string[] orderno_arr, out string[] neworderno_arr, out string[] currencycode_arr, out string[] orderamount_arr, out string[] remark_arr)
    {
        string tTotalCount = Request["TotalCount"];
        string tTotalAmount = Request["TotalAmount"];

        //取得列表项
        string[] v_orderno_arr = null;
        string[] v_neworderno_arr = null;
        string[] v_currencycode_arr = null;
        string[] v_orderamount_arr = null;
        string[] v_remark_arr = null;
        int v_tTotalCount = 0;
        decimal v_tTotalAmount = 0;

        //初始化
        iTotalCount = v_tTotalCount;
        iTotalAmount = v_tTotalAmount;
        orderno_arr = v_orderno_arr;
        neworderno_arr = v_neworderno_arr;
        currencycode_arr = v_currencycode_arr;
        orderamount_arr = v_orderamount_arr;
        remark_arr = v_remark_arr;

        try
        {
            v_tTotalCount = int.Parse(Request["TotalCount"]);
            v_tTotalAmount = decimal.Parse(Request["TotalAmount"]);
        }
        catch (Exception ex)
        {
            lblMessage.Text = "总金额和总笔数必输是数字，请重新输入!";
            return false;
        }

        string orderno = Request["txtOrderNo"];
        string neworderno = Request["txtNewOrderNo"];
        string currencycode = Request["txtCurrencyCode"];
        string orderamount = Request["txtRefundAmount"];
        string remark = Request["txtRemark"];
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
        if (currencycode.Contains(","))
        {
            v_currencycode_arr = currencycode.Split(',');
        }
        else
        {
            v_currencycode_arr = new string[] { currencycode };
        }
        if (orderamount.Contains(","))
        {
            v_orderamount_arr = orderamount.Split(',');
        }
        else
        {
            v_orderamount_arr = new string[] { orderamount };
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
                lblMessage.Text = "退款订单原交易编号不允许为空";
                return false;
            }
        }
        foreach (string v_neworderno in v_neworderno_arr)
        {
            if (v_neworderno == "")
            {
                lblMessage.Text = "退款订单编号不允许为空";
                return false;
            }
        }
        foreach (string v_currencycode in v_currencycode_arr)
        {
            if (v_currencycode != "156")
            {
                lblMessage.Text = "退款订单交易币种非人民币";
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
                    lblMessage.Text = "退款订单金额必输为数字";
                    return false;
                }
            }
            else
            {
                lblMessage.Text = "退款订单金额不允许为空";
                return false;
            }
        }

        //验证订单退款总金额与退款总金是否相等
        if (totalAmount != v_tTotalAmount)
        {
            lblMessage.Text = "退款总金额与退款订单总金额不一致";
            return false;
        }

        iTotalCount = v_tTotalCount;
        iTotalAmount = v_tTotalAmount;
        orderno_arr = v_orderno_arr;
        neworderno_arr = v_neworderno_arr;
        currencycode_arr = v_currencycode_arr;
        orderamount_arr = v_orderamount_arr;
        remark_arr = v_remark_arr;
        return true;
    }

    protected void btnButton_Click(object sender, EventArgs e)
    {

        string[] orderno_arr = null;
        string[] neworderNo_arr = null;
        string[] currencycode_arr = null;
        string[] orderamount_arr = null;
        string[] remark_arr = null;
        int iTotalCount = 0;
        decimal iTotalAmount = 0;

        StringBuilder strMessage = new StringBuilder("");
        //验证输入信息并取得退款所需要的信息
        if (!ValidateRequestPara(out iTotalCount, out iTotalAmount, out orderno_arr, out neworderNo_arr, out currencycode_arr, out orderamount_arr, out remark_arr))
            return;
        //1、生成批量退款请求对象
        com.abc.trustpay.client.ebus.BatchRefundRequest tBatchRefundRequest = new com.abc.trustpay.client.ebus.BatchRefundRequest();
        //取得列表项 
        System.Collections.Generic.Dictionary<string, string> dic = new System.Collections.Generic.Dictionary<string, string>();
        for (int i = 0; i < orderno_arr.Length; i++)
        {
            //string[] torder = new String[6];
            dic["SeqNo"] = Convert.ToString(i + 1);
            dic["OrderNo"] = orderno_arr[i];
            dic["NewOrderNo"] = neworderNo_arr[i];
            dic["CurrencyCode"] = currencycode_arr[i];
            dic["RefundAmount"] = orderamount_arr[i];
            dic["Remark"] = remark_arr[i];
            tBatchRefundRequest.dic.Add(i, dic);
            dic = new System.Collections.Generic.Dictionary<string, string>();
        }
        tBatchRefundRequest.batchRefundRequest["BatchNo"] = txtBatchNo.Text; //批量编号  （必要信息）
        tBatchRefundRequest.batchRefundRequest["BatchDate"] = txtBatchDate.Text;  //订单日期  （必要信息）
        tBatchRefundRequest.batchRefundRequest["BatchTime"] = txtBatchTime.Text; //订单时间  （必要信息）
        tBatchRefundRequest.batchRefundRequest["MerRefundAccountNo"] = txtMerRefundAccountNo.Text;  //商户退款账号
        tBatchRefundRequest.batchRefundRequest["MerRefundAccountName"] = txtMerRefundAccountName.Text; //商户退款名
        tBatchRefundRequest.batchRefundRequest["TotalCount"] = iTotalCount.ToString();  //总笔数  （必要信息）
        tBatchRefundRequest.batchRefundRequest["TotalAmount"] = iTotalAmount.ToString();  //总金额 （必要信息）

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
            alert("退款总金额不能为空");
            return false;
        }
        if (isNaN(amount)) {
            alert("退款总金额请输入数字！");
            return false;
        }
        if (amount <= 0) {
            alert("退款总金额不能小于0");
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
            for (var j = 0 ; j < 6; j++) {
                var col = row.insertCell();
                switch (j) {
                    case 0:
                        col.align = "left";
                        col.height = "30";
                        col.innerHTML = index;
                        break;
                    case 1:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtOrderNo\" style=\"width:95%\" value=\"ON200905010001\">";
                        break;
                    case 2:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtNewOrderNo\" style=\"width:95%\" value=\"ON200905010002\">";
                        break;
                    case 3:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtCurrencyCode\" style=\"width:95%\" value=\"156\">";
                        break;
                    case 4:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtRefundAmount\" style=\"width:95%\" value=\"0.01\">";
                        break;
                    case 5:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtRemark\" style=\"width:95%\" value=\"测试批量退款客户端\">";
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
        批量退款
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
                <td>商户退款账号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerRefundAccountNo' Text='' />选输</td>
            </tr>
            <tr>
                <td>商户退款名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerRefundAccountName' Text='' />选输</td>
            </tr>
            <tr>
                <td>批量编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBatchNo' Text='0001' />*必输</td>
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
                            <td width="15%" align="center">原交易编号</td>
                            <td width="15%" align="center">交易编号</td>
                            <td width="15%" align="center">交易币种</td>
                            <td width="15%" align="center">交易金额</td>
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
