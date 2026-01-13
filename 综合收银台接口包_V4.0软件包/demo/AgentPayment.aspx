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

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成单笔授权扣款请求对象
        com.abc.trustpay.client.ebus.AgentPaymentRequest tRequest = new com.abc.trustpay.client.ebus.AgentPaymentRequest();
        //2、生成定单订单对象，并将订单明细加入定单中
        tRequest.dicRequest["OrderDate"] = txtOrderDate.Text;                   //设定订单日期 （必要信息 - YYYY/MM/DD）
        tRequest.dicRequest["OrderTime"] = txtOrderTime.Text;                   //设定订单时间 （必要信息 - HH:MM:SS）
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;                       //设定订单编号 （必要信息）
        tRequest.dicRequest["AgentSignNo"] = txtAgentSignNo.Text;                       //设定授权支付协议号 （必要信息）
        tRequest.dicRequest["CardNo"] = txtCardNo.Text;                       //设定账号
        tRequest.dicRequest["CurrencyCode"] = txtCurrencyCode.Text;    //设定交易币种 （必要信息）
        tRequest.dicRequest["Amount"] = txtAmount.Text;    //设定交易金额 （必要信息）
        tRequest.dicRequest["SubsidyAmount"] = txtSubsidyAmount.Text;    //设定营销补贴金额
        tRequest.dicRequest["ReceiverAddress"] = txtReceiverAddress.Text; //设定手续费金额
        tRequest.dicRequest["Fee"] = txtFee.Text; //设定手续费金额
        tRequest.dicRequest["CertificateNo"] = txtCertificateNo.Text;             //证件号码
        tRequest.dicRequest["InstallmentMark"] = txtInstallmentMark.Text;  //分期标识
        if (txtInstallmentMark.Text.ToString().Equals("1"))
        {
            tRequest.dicRequest["InstallmentCode"] = txtInstallmentCode.Text;    //设定分期代码
            tRequest.dicRequest["InstallmentNum"] = txtInstallmentNum.Text;    //设定分期期数
        }
        tRequest.dicRequest["CommodityType"] = txtCommodityType.Text;   //设置商品种类 （必要信息）
        tRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;      //设定支付接入方式 （必要信息）
        tRequest.dicRequest["BuyIP"] = txtBuyIP.Text; 
        tRequest.dicRequest["ExpiredDate"] = txtExpiredDate.Text;//设定订单保存时间
        tRequest.dicRequest["ReceiveAccount"] = txtReceiveAccount.Text;    //设定收款方账号
        tRequest.dicRequest["ReceiveAccName"] = txtReceiveAccName.Text;    //设定收款方户名
        tRequest.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;    //设定附言
        tRequest.dicRequest["IsBreakAccount"] = txtIsBreakAccount.Text;    //设定交易是否分账
        tRequest.dicRequest["SplitAccTemplate"] = txtSplitAccTemplate.Text;      //分账模版编号

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
        tRequest.dic.Add(1, orderitem);

        orderitem = new System.Collections.Generic.Dictionary<string, string>();
       orderitem["SubMerName"] = "测试二级商户1";    //设定二级商户名称
        orderitem["SubMerId"] = "12345";    //设定二级商户代码
        orderitem["SubMerMCC"] = "0000";   //设定二级商户MCC码 
        orderitem["SubMerchantRemarks"] = "测试";   //二级商户备注项
        orderitem["ProductID"] = "IP000001";//商品代码，预留字段
        orderitem["ProductName"] = "中国移动IP卡";//商品名称
        orderitem["UnitPrice"] = "2.00";//商品总价
        orderitem["Qty"] = "2";//商品数量
        orderitem["ProductRemarks"] = "测试商品"; //商品备注项
        orderitem["ProductType"] = "充值类";//商品类型
        orderitem["ProductDiscount"] = "0.9";//商品折扣
        orderitem["ProductExpiredDate"] = "10";//商品有效期
        tRequest.dic.Add(2, orderitem);

        //添加分账信息
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
                tRequest.dicSplitAccInfo.Add(i, item);
                item = new Dictionary<string, string>();
            }
        }
        
        //3、传送单笔授权扣款请求
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、单笔授权扣款请求提交成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
        }
        else
        {
            //5、单笔授权扣款请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<script language="javascript" type="text/javascript">
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
</script>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-单笔授权扣款</title>
</head>
<body style="font-size: 14px;">
    <center>
        单笔授权扣款
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>
                    订单日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderDate' Text='2004/12/23' />（YYYY/MM/DD）*必输</td>
            </tr>
            <tr>
                <td>
                    订单时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderTime' Text='11:55:30' />（HH:MM:SS）*必输</td>
            </tr>
            <tr>
                <td>交易编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200412230001' />*必输</td>
            </tr>
            <tr>
                <td>
                    授权支付签约号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentSignNo' Text='123' />*必输</td>
            </tr>            
            <tr>
                <td>
                    账号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCardNo' Text='' />选输</td>
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
                    <asp:TextBox runat="server" ID='txtAmount' Text='2.00' />保留小数点后两位数字,*必输</td>
            </tr>
            <tr>
                <td>营销补贴
                </td>
                <td>            
                    <asp:TextBox runat="server" ID='txtSubsidyAmount' Text='' />保留小数点后两位数字,非必输</td>
            </tr> 
            <tr>
                <td>收货人地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiverAddress' Text='北京' />选输</td>
            </tr> 
            <tr>
                <td>手续费金额
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtFee' Text='' />保留小数点后两位数字,选输</td>
            </tr> 
            <tr>
                <td>证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateNo' Text='340121198403084619' />
                    *必输</td>
            </tr>
            <tr>
                <td>分期标识
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInstallmentMark' Text='0' />1：分期；0：否。*必输</td>
            </tr>
            
            <tr>
                <td>分期代码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInstallmentCode' Text='' /> *分期时必输</td>
            </tr>
            <tr>
                <td>分期期数
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInstallmentNum' Text='' /> 2-99,*分期时必输</td>
            </tr>
            <tr>
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
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
                    <asp:TextBox runat="server" ID='txtExpiredDate' Text='30' />单位:天，*必输</td>
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
                <td>附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantRemarks' Text='' />不超过100个字符，选输</td>
            </tr>
            <tr>
                <td>交易是否分账
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtIsBreakAccount' Text='0' />0:否；1:是，必输 （二次清分商户填1）</td>
            </tr>            
			 <tr>
                <td>分账模版编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSplitAccTemplate' Text='' />选输</td>
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
