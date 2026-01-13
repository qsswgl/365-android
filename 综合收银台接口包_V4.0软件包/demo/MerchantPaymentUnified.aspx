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
 *    abchina       2017/03/29  V3.0.0 Release
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
    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成定单订单对象，并将订单明细加入订单中
        com.abc.trustpay.client.ebus.UnifiedPaymentRequest tPaymentRequest = new com.abc.trustpay.client.ebus.UnifiedPaymentRequest();
        //2、设定订单属性
        tPaymentRequest.dicOrder["TerminalNo"] = txtTerminalNo.Text;    //设定终端编号
        tPaymentRequest.dicOrder["OrderNo"] = txtPaymentRequestNo.Text;                       //设定订单编号
        tPaymentRequest.dicOrder["ExpiredDate"] = txtExpiredDate.Text;//设定订单保存时间
        tPaymentRequest.dicOrder["OrderAmount"] = txtPaymentRequestAmount.Text;    //设定交易金额
        tPaymentRequest.dicOrder["SubsidyAmount"] = txtSubsidyAmount.Text;    //设定营销补贴金额
        tPaymentRequest.dicOrder["Fee"] = txtFee.Text; //设定手续费金额
        tPaymentRequest.dicOrder["AccountNo"] = txtAccountNo.Text; //设定支付账户
        tPaymentRequest.dicOrder["OpenID"] = txtOpenID.Text; //设定用户在子商户appid下的唯一标识
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
        //tPaymentRequest.dicOrder["OrderURL"] = txtOrderURL.Text;                   //设定订单地址
        tPaymentRequest.dicOrder["OrderDate"] = txtOrderDate.Text;                   //设定订单日期 （必要信息 - YYYY/MM/DD）
        tPaymentRequest.dicOrder["OrderTime"] = txtOrderTime.Text;                   //设定订单时间 （必要信息 - HH:MM:SS）
        tPaymentRequest.dicOrder["orderTimeoutDate"] = txtorderTimeoutDate.Text;                     //设定订单有效期
        tPaymentRequest.dicOrder["LimitPay"] = txtLimitPay.Text;    //是否限制贷记卡
        tPaymentRequest.dicOrder["PayTypeID"] = txtPayTypeID.Text;    //设定交易类型


        //3、添加订单明细
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
        orderitem["Qty"] = "2";//商品数量
        orderitem["ProductRemarks"] = "测试商品"; //商品备注项
        orderitem["ProductType"] = "充值类";//商品类型
        orderitem["ProductDiscount"] = "0.9";//商品折扣
        orderitem["ProductExpiredDate"] = "10";//商品有效期
        tPaymentRequest.dic.Add(2, orderitem);
        //4、设定支付请求对象
        tPaymentRequest.dicRequest["PaymentType"] = txtPaymentType.Text;          //设定支付类型
        tPaymentRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;  //设定支付接入方式
        //tPaymentRequest.dicRequest["ReceiveAccount"] = txtReceiveAccount.Text;    //设定收款方账号
        //tPaymentRequest.dicRequest["ReceiveAccName"] = txtReceiveAccName.Text;    //设定收款方户名
        tPaymentRequest.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;  //设定附言
        tPaymentRequest.dicRequest["IsBreakAccount"] = txtIsBreakAccount.Text;    //设定交易是否支持向二级商户入账
        tPaymentRequest.dicRequest["SplitAccTemplate"] = txtSplitAccTemplate.Text;      //分账模版编号
        tPaymentRequest.dicRequest["NotifyType"] = txtNotifyType.Text;    //设定通知方式
        tPaymentRequest.dicRequest["ResultNotifyURL"] = txtResultNotifyURL.Text;    //设定通知URL地址
        tPaymentRequest.dicRequest["MerModelFlag"] = MerModelFlag.Text;    //是否为大商户模式
        tPaymentRequest.dicRequest["SubMerchantID"] = SubMerchantID.Text;    //大商户模式的子商户号

        tPaymentRequest.dicH5SceneInfo["H5SceneType"] = txtH5SceneType.Text;    //场景类型
        tPaymentRequest.dicH5SceneInfo["H5SceneUrl"] = txtH5SceneUrl.Text;    //场景URL
        tPaymentRequest.dicH5SceneInfo["H5SceneName"] = txtH5SceneName.Text;    //场景名字

        tPaymentRequest.dicRequest["CommodityType"] = txtCommodityType.Text;   //设置商品种类
               
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
                tPaymentRequest.dicSplitAccInfo.Add(i, item);
                item = new Dictionary<string, string>();
            }
        }
        
        //5、传送支付请求并取得支付网址
        tPaymentRequest.postJSONRequest();

        //多商户
        //tPaymentRequest.extendPostJSONRequest(1);
        StringBuilder strMessage = new StringBuilder();
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {

            String QRURL = JSON.GetKeyValue("QRURL");
            String APP = JSON.GetKeyValue("APP");
            String JSAPI = JSON.GetKeyValue("JSAPI");

            strMessage.Append("ReturnCode   =   [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage =   [" + ErrorMessage + "]<br/>");
            strMessage.Append("MerchantID     = [" + JSON.GetKeyValue("MerchantID") + "]<br/>");
            strMessage.Append("TrxType        = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo        = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
            strMessage.Append("OrderAmount    = [" + JSON.GetKeyValue("OrderAmount") + "]<br/>");
            strMessage.Append("QRURL          = [" + JSON.GetKeyValue("QRURL") + "]<br/>");
            strMessage.Append("PaymentURL     = [" + JSON.GetKeyValue("PaymentURL") + "]<br/>");
            strMessage.Append("HostDate       = [" + JSON.GetKeyValue("HostDate") + "]<br/>");
            strMessage.Append("HostTime       = [" + JSON.GetKeyValue("HostTime") + "]<br/>");
            strMessage.Append("PrePayID       = [" + JSON.GetKeyValue("PrePayID") + "]<br/>");
            strMessage.Append("ThirdOrderNo   = [" + JSON.GetKeyValue("ThirdOrderNo") + "]<br/>");
            
            if (!QRURL.Equals("") || txtPaymentType.Text.Equals("8"))
            {
                strMessage.Append("QRURL   = [" + JSON.GetKeyValue("QRURL") + "]<br/>");  
            }
            else if (!APP.Equals(""))
            {
                strMessage.Append("appid        = [" + JSON.GetKeyValue("appid") + "]<br/>");
                strMessage.Append("partnerid    = [" + JSON.GetKeyValue("partnerid") + "]<br/>");
                strMessage.Append("prepayid     = [" + JSON.GetKeyValue("prepayid") + "]<br/>");
                strMessage.Append("timestamp    = [" + JSON.GetKeyValue("timestamp") + "]<br/>");
                strMessage.Append("noncestr     = [" + JSON.GetKeyValue("noncestr") + "]<br/>");
                strMessage.Append("package      = [" + JSON.GetKeyValue("package") + "]<br/>");
                strMessage.Append("sign         = [" + JSON.GetKeyValue("sign") + "]<br/>");
            }
            else if (!JSAPI.Equals(""))
            {
                strMessage.Append("appid        = [" + JSON.GetKeyValue("appid") + "]<br/>");
                strMessage.Append("timestamp    = [" + JSON.GetKeyValue("timestamp") + "]<br/>");
                strMessage.Append("noncestr     = [" + JSON.GetKeyValue("noncestr") + "]<br/>");
                strMessage.Append("package      = [" + JSON.GetKeyValue("package") + "]<br/>");
                strMessage.Append("signType     = [" + JSON.GetKeyValue("signType") + "]<br/>");
                strMessage.Append("paySign      = [" + JSON.GetKeyValue("paySign") + "]<br/>");
            }
            
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


    function SelectedIndexChanged() {
        var paytypeid = document.getElementById("txtPayTypeID").value;
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
    <title>农行网上支付平台-商户接口范例-微信支付请求</title>
</head>
<body style="font-size: 14px;">
    <center>
        微信支付请求</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>交易类型</td>
                <td style="width: 258px">
                    <asp:DropDownList ID="txtPayTypeID" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="NATIVE">扫码支付</asp:ListItem>
                        <asp:ListItem Value="JSAPI">公众号（小程序）支付</asp:ListItem>
                        <asp:ListItem Value="APP">app支付</asp:ListItem>
                        <asp:ListItem Value="MICROPAY">刷卡支付</asp:ListItem>
                        <asp:ListItem Value="MWEB">H5支付</asp:ListItem>
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
                    <asp:TextBox runat="server" ID='txtPaymentRequestAmount' Text='0.01' />保留小数点后两位数字,*必输</td>
            </tr>
            <tr>
                <td>营销补贴
                </td>
                <td>            
                    <asp:TextBox runat="server" ID='txtSubsidyAmount' Text='' />保留小数点后两位数字,非必输</td>
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
                    <asp:TextBox runat="server" ID='txtAccountNo' Text='' />选输,交易类型为“公众号（小程序）支付”时必输，上送子商户的公众号APPID，对应微信统一下单接口中的sub_appid；
              交易类型为"app支付"时必输，上送子商户的应用APPID，对应微信统一下单接口中的sub_appid；交易类型为“刷卡支付”时必输，上送授权码auth_code</td>
            </tr>
            <tr>
                <td>用户在子商户appid下的唯一标识</td>
                <td><asp:TextBox runat="server" ID='txtOpenID' Text='' />选输,交易类型为"公众号（小程序）支付"时必输，对应微信统一下单接口中的sub_openid</td>
            </tr>
            <tr>
                <td>订单说明
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDesc' Text='Game Card Order' />选输</td>
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
                    <asp:TextBox runat="server" ID='txtCommodityType' Text='0201' /></td>
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
                <td>支付方式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentType' Text='8' onkeyup="CheckValue()" />A:农行卡支付 8：微信支付，*必输</td>
            </tr>
            <tr>
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' onkeyup="CheckValue()" />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端 5：线下渠道，*必输</td>
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
                    <asp:TextBox runat="server" ID='txtResultNotifyURL' Text='http://127.0.0.1/Merchant/MerchantResult.aspx' />*必输</td>
            </tr>
                        <tr>
                <td>大商户模式
                </td>
                <td>
                    <asp:TextBox runat="server" ID='MerModelFlag' Text='0' />选输 0:普通模式 1:大商户模式</td>
            </tr>
                        <tr>
                <td>二级商户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='SubMerchantID' Text='' />选输</td>
            </tr>
            <tr>
                <td>终端编号</td>
                <td><asp:TextBox runat="server" ID='txtTerminalNo' Text='1' /></td>
            </tr>
            <tr>
                <td>附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />不超过100个字符，选输</td>
            </tr>
            <tr>
                <td>限制贷记卡
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtLimitPay' Text='no_credit' />选输</td>
          
            <tr>
                <td>场景类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtH5SceneType' Text='Wap' />选输</td>
            </tr>
            <tr>
                <td>场景URL
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtH5SceneUrl' Text='https://pay.qq.com' />选输</td>
            </tr>
            <tr>
                <td>场景名称
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtH5SceneName' Text='腾讯支付' />选输</td>
            </tr>
            <tr>
                <td>交易是否支持分账（(或分账模板分账)）
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtIsBreakAccount' Text='0' />0:否；1:是，*必输 （二次清分商户或者分账模板填1）</td>
            </tr>
                            <tr>
                <td>分账模板编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSplitAccTemplate' Text='0' />分账模板与二级商户一栏只能输入一个</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table border="1" style="font-size: 12px;" width="50%" id="account">
                        <tr>
                            <td width="12%" align="center">二级商户编号</td>
                            <td width="12%" align="center">入账金额</td>
                            <tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type='button' value='增加' name="add" onclick="addLine()"></td>

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
