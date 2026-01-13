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
 *    abchina       2014/04/28  V3.0.0
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
            txtPaymentRequestNo.Text = "No" + DateTime.Now.Ticks.ToString();
            txtOrderDate.Text = System.DateTime.Now.ToString("yyyy/MM/dd");
            txtOrderTime.Text = System.DateTime.Now.ToString("HH:MM:ss");
        }
    }
    string _ResponseString = "";
    protected void btnButton_Click(object sender, EventArgs e)
    {
        com.abc.trustpay.client.ebus.PaymentRequest tPaymentRequest = new com.abc.trustpay.client.ebus.PaymentRequest();

        //1、生成定单订单对象，并将订单明细加入定单中
        tPaymentRequest.dicOrder["PayTypeID"] = txtPayTypeID.Text;    //设定交易类型
        tPaymentRequest.dicOrder["OrderNo"] = txtPaymentRequestNo.Text;                       //设定订单编号
        tPaymentRequest.dicOrder["ExpiredDate"] = txtExpiredDate.Text;//设定订单保存时间
        tPaymentRequest.dicOrder["OrderAmount"] = txtPaymentRequestAmount.Text;    //设定交易金额
        tPaymentRequest.dicOrder["Fee"] = txtFee.Text; //设定手续费金额
        tPaymentRequest.dicOrder["AccountNo"] = txtAccountNo.Text; //设定支付账户
        tPaymentRequest.dicOrder["CurrencyCode"] = txtCurrencyCode.Text;    //设定交易币种
        tPaymentRequest.dicOrder["ReceiverAddress"] = txtReceiverAddress.Text;     //收货地址
        tPaymentRequest.dicOrder["InstallmentMark"] = txtInstallmentMark.Text;  //分期标识
        if (txtInstallmentMark.Text.ToString().Equals("1") && txtPayTypeID.Text.ToString().Equals("DividedPay"))
        {
            tPaymentRequest.dicOrder["InstallmentCode"] = txtInstallmentCode.Text;    //设定分期代码
            tPaymentRequest.dicOrder["InstallmentNum"] = txtInstallmentNum.Text;    //设定分期期数
        }
        tPaymentRequest.dicOrder["BuyIP"] = txtBuyIP.Text;                           //IP
        tPaymentRequest.dicOrder["OrderDesc"] = txtOrderDesc.Text;                   //设定订单说明
        tPaymentRequest.dicOrder["OrderURL"] = txtOrderURL.Text;                   //设定订单地址
        tPaymentRequest.dicOrder["OrderDate"] = txtOrderDate.Text;                   //设定订单日期 （必要信息 - YYYY/MM/DD）
        tPaymentRequest.dicOrder["OrderTime"] = txtOrderTime.Text;                   //设定订单时间 （必要信息 - HH:MM:SS）
        tPaymentRequest.dicOrder["orderTimeoutDate"] = txtorderTimeoutDate.Text;                     //设定订单有效期
        tPaymentRequest.dicOrder["CommodityType"] = txtCommodityType.Text;   //设置商品种类

        System.Collections.Generic.Dictionary<string, string> orderitem = new System.Collections.Generic.Dictionary<string, string>();
        orderitem["SubMerName"] = "测试二级商户1";    //设定二级商户名称
        orderitem["SubMerId"] = "12345";    //设定二级商户代码
        orderitem["SubMerMCC"] = "0000";   //设定二级商户MCC码 
        orderitem["SubMerchantRemarks"] = "测试";   //二级商户备注项
        orderitem["ProductID"] = "IP000001";//商品代码，预留字段
        orderitem["ProductName"] = "中国移动IP卡";//商品名称
        orderitem["UnitPrice"] = "1.00";//商品总价
        orderitem["Qty"] = "1";//商品数量
        orderitem["ProductRemarks"] = "测试商品"; //商品备注项
        orderitem["ProductType"] = "充值类";//商品类型
        orderitem["ProductDiscount"] = "0.9";//商品折扣
        orderitem["ProductExpiredDate"] = "10";//商品有效期
        tPaymentRequest.dic.Add(1, orderitem);

        orderitem = new System.Collections.Generic.Dictionary<string, string>();
        orderitem["SubMerName"] = "测试二级商户1";    //设定二级商户名称
        orderitem["SubMerId"] = "12345";    //设定二级商户代码
        orderitem["SubMerMCC"] = "0000";   //设定二级商户MCC码 
        orderitem["SubMerchantRemarks"] = "测试";   //二级商户备注项
        orderitem["ProductID"] = "IP000001";//商品代码，预留字段
        orderitem["ProductName"] = "中国移动IP卡";//商品名称
        orderitem["UnitPrice"] = "1.00";//商品总价
        orderitem["Qty"] = "1";//商品数量
        orderitem["ProductRemarks"] = "测试商品"; //商品备注项
        orderitem["ProductType"] = "充值类";//商品类型
        orderitem["ProductDiscount"] = "0.9";//商品折扣
        orderitem["ProductExpiredDate"] = "10";//商品有效期
        tPaymentRequest.dic.Add(2, orderitem);
        //2、生成支付请求对象
        tPaymentRequest.dicRequest["PaymentType"] = txtPaymentType.Text;          //设定支付类型
        tPaymentRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;      //设定支付接入方式
        if (txtPaymentType.Text.ToString().Equals("6") && txtPaymentLinkType.Text.ToString().Equals("2"))
        {
            tPaymentRequest.dicRequest["UnionPayLinkType"] = txtUnionPayLinkType.Text;          //当支付类型为6，支付接入方式为2的条件满足时，需要设置银联跨行移动支付接入方式
        }
        tPaymentRequest.dicRequest["ReceiveAccount"] = txtReceiveAccount.Text;    //设定收款方账号
        tPaymentRequest.dicRequest["ReceiveAccName"] = txtReceiveAccName.Text;    //设定收款方户名
        tPaymentRequest.dicRequest["NotifyType"] = txtNotifyType.Text;    //设定通知方式
        tPaymentRequest.dicRequest["ResultNotifyURL"] = txtResultNotifyURL.Text;    //设定通知URL地址
        tPaymentRequest.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;    //设定附言
        tPaymentRequest.dicRequest["IsBreakAccount"] = txtIsBreakAccount.Text;    //设定交易是否分账
        tPaymentRequest.dicRequest["SplitAccTemplate"] = txtSplitAccTemplate.Text;      //分账模版编号

        _ResponseString = "";
        try
        {
            string tSignature = tPaymentRequest.genSignature(1);
            string sTrustPayIETrxURL = com.abc.trustpay.client.MerchantConfig.TrustPayIETrxURL;
            string sErrorUrl = com.abc.trustpay.client.MerchantConfig.MerchantErrorURL;

            form1.Visible = false;
            _ResponseString = "<form name=\"form2\" method=\"post\" action=\"" + sTrustPayIETrxURL + "\"> \r\n" +
                                "<input type=\"hidden\" name=\"MSG\" value=\"" + tSignature + "\"> \r\n" +
                                "<input type=\"hidden\" name=\"errorPage\" value=\"" + sErrorUrl + "\"> \r\n" +
                                "<input type=\"submit\" value=\"提交\"></form><br/> \r\n" +
                                "<a href='MerchantPaymentIE.aspx'>回商户首页</a> \r\n";
        }
        catch (com.abc.trustpay.client.TrxException ex)
        {
            form1.Visible = false;
            _ResponseString = "<center><br/> \r\n" +
                    "ReturnCode   = [" + ex.Code + "]<br/> \r\n" +
                    "ErrorMessage = [" + ex.Message + "]<br/><br/> \r\n" +
                    "<a href='MerchantPaymentIE.aspx'>回商户首页</a></center> \r\n";
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--%>
    <title>农行网上支付平台-商户接口范例-支付请求</title>
    <script language="javascript" type="text/javascript">

        function SelectedIndexChanged() {
            var paytypeid = form1.txtPayTypeID.value;
            if (paytypeid == "ImmediatePay") {
                installmentCode.style.display = "none";
                installmentNum.style.display = "none";
            }
            else if (paytypeid == "PreAuthPay") {
                installmentCode.style.display = "none";
                installmentNum.style.display = "none";
            }
            else if (paytypeid == "DividedPay") {
                installmentCode.style.display = "inline";
                installmentNum.style.display = "inline";

            }
        }
        function CheckValue() {
            var paymenttype = document.getElementById("txtPaymentType").value;
            var paymentlinktype = document.getElementById("txtPaymentLinkType").value;
            if (paymenttype == "6" && paymentlinktype == "2") {
                UnionPayLinkType.style.display = "inline";
            } else {
                UnionPayLinkType.style.display = "none";
            }
        }
    </script>
</head>
<body style="font-size: 14px;">
    <center>
        支付请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易类型</td>
                <td style="width: 158px">
                    <asp:DropDownList ID="txtPayTypeID" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="ImmediatePay" Selected="True">直接支付</asp:ListItem>
                        <asp:ListItem Value="PreAuthPay">预授权支付</asp:ListItem>
                        <asp:ListItem Value="DividedPay">分期支付</asp:ListItem>
                    </asp:DropDownList>*必输</td>
            </tr>
            <tr>
                <td>订单日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDate' Text='2004/12/23' />（YYYY/MM/DD）*必输</td>
            </tr>
            <tr>
                <td>订单时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderTime' Text='11:55:30' />（HH:MM:SS）*必输</td>
            </tr>
            <tr>
                <td>订单支付有效期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtorderTimeoutDate' Text='20240619104901' />精确到秒，选输</td>
            </tr>
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentRequestNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>交易币种
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCurrencyCode' Text='156' />156:人民币,*必输</td>
            </tr>
            <tr>
                <td>交易金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentRequestAmount' Text='2.00' />保留小数点后两位数字,*必输</td>
            </tr>
            <tr>
                <td>手续费金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtFee' Text='' />保留小数点后两位数字,选输</td>
            </tr>
            <tr>
                <td>指定付款账户
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccountNo' Text='' />选输</td>
            </tr>
            <tr>
                <td>订单说明
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDesc' Text='Game Card Order' />选输</td>
            </tr>
            <tr>
                <td>订单地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderURL' Text='http://127.0.0.1/Merchant/MerchantQueryOrder.aspx?ON=ON200412230001&DetailQuery=1' />选输</td>
            </tr>
            <tr>
                <td>收货地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiverAddress' Text='北京' />选输</td>
            </tr>
            <tr>
                <td>分期标识
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInstallmentMark' Text='0' />1：分期；0：否。*必输</td>
            </tr>

            <tr id="installmentCode" style="display: none;">
                <td>分期代码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInstallmentCode' Text='' />*必输</td>
            </tr>
            <tr id="installmentNum" style="display: none;">
                <td>分期期数
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInstallmentNum' Text='' />2-99,*必输</td>
            </tr>
            <tr>
                <td>商品种类
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCommodityType' Text='0101' /></td>
            </tr>
            <tr>
	            <td></td>
	            <td>
					<br/>0101:支付账户充值
					<br/>0201:虚拟类,0202:传统类,0203:实名类
					<br/>0301:本行转账,0302:他行转账
					<br/>0401:水费,0402:电费,0403:煤气费,0404:有线电视费,0405:通讯费,0406:物业费,0407:保险费,0408:行政费用,0409:税费,0410:学费,0499:其他
					<br/>0501:基金,0502:理财产品,0599:其他, *必输
				</td>
			</tr>
            <tr>
                <td>客户交易IP
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBuyIP' Text='' />选输</td>
            </tr>
            <tr>
                <td>订单保存时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtExpiredDate' Text='30' />单位:天，选输</td>
            </tr>
            <tr>
                <td>支付账户类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentType' Text='1' onkeyup="CheckValue()" />1：农行卡支付 2：国际卡支付 3：农行贷记卡支付 5:基于第三方的跨行支付 A:支付方式合并 6：银联跨行支付 7：对公户，*必输</td>
            </tr>
            <tr>
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' onkeyup="CheckValue()" />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
            </tr>
            <tr id="UnionPayLinkType" style="display: none;">
                <td>银联跨行移动支付接入方式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtUnionPayLinkType' Text='0' />0：页面接入 如果选择的支付帐户类型为6(银联跨行支付)交易渠道为2(手机网络接入)时，必输（此模式页面接入）</td>
            </tr>
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
                <td>通知方式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyType' Text='0' />0：URL页面通知 1：服务器通知，*必输</td>
            </tr>
            <tr>
                <td>通知URL地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtResultNotifyURL' Text='http://127.0.0.1/Merchant/MerchantResult.asp' />*必输</td>
            </tr>
            <tr>
                <td>附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />不超过100个字符，选输</td>
            </tr>
            <tr>
                <td>交易是否分账
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtIsBreakAccount' Text='0' />0:否；1:是，*必输</td>
            </tr>
            <tr>
                <td>分账模版编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSplitAccTemplate' Text='1' />选输</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交页面内容" OnClick="btnButton_Click" />
                    <a href='Merchant.html'>回商户首页</a>
                </td>
            </tr>
        </table>
    </form>
    <%=_ResponseString %>
</body>
</html>
