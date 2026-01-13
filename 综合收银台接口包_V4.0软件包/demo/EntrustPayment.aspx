<!--
/*
 * Project: BJP09001
 *
 * Description:
 *    代收业务单笔扣款
 *
 * Modify Information:
 *    Author        Date        Description
 *    ============  ==========  =======================================
 *    wt       2021/04/13     V3.1.7
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成代收业务单笔扣款请求对象
        com.abc.trustpay.client.ebus.EntrustPaymentRequest tRequest = new com.abc.trustpay.client.ebus.EntrustPaymentRequest();
        //2、生成定单订单对象，并将订单明细加入定单中
        tRequest.dicRequest["OrderDate"] = txtOrderDate.Text;                   //设定订单日期 （必要信息 - YYYY/MM/DD）
        tRequest.dicRequest["OrderTime"] = txtOrderTime.Text;                   //设定订单时间 （必要信息 - HH:MM:SS）
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;                       //设定订单编号 （必要信息）
        tRequest.dicRequest["EntrustSignNo"] = txtEntrustSignNo.Text;                       //设定签约编号 （必要信息）
        tRequest.dicRequest["CardNo"] = txtCardNo.Text;                       //设定账号
        tRequest.dicRequest["CurrencyCode"] = txtCurrencyCode.Text;    //设定交易币种 （必要信息）
        tRequest.dicRequest["Amount"] = txtAmount.Text;    //设定交易金额 （必要信息）
        tRequest.dicRequest["Fee"] = txtFee.Text; //设定手续费金额
        tRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;      //设定交易渠道 （必要信息）
        tRequest.dicRequest["BusinessCode"] = txtBusinessCode.Text;   //代收业务种类
        tRequest.dicRequest["BuyIP"] = txtBuyIP.Text; 
        tRequest.dicRequest["ReceiveAccount"] = txtReceiveAccount.Text;    //设定收款方账号
        tRequest.dicRequest["ReceiveAccName"] = txtReceiveAccName.Text;    //设定收款方户名
        tRequest.dicRequest["ReceiverAddress"] = txtReceiverAddress.Text;  //设定收货地址
        tRequest.dicRequest["MerchantRemarks"] = txtMerchantRemarks.Text;    //设定附言
        tRequest.dicRequest["IsBreakAccount"] = txtIsBreakAccount.Text;    //设定交易是否分账
        tRequest.dicRequest["Scene"] = txtScene.Text;    //设定缴费场景

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
        
        //3、传送扣款请求
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、扣款请求提交成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
        }
        else
        {
            //5、扣款请求提交失败，商户自定后续动作
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
        代收业务单笔扣款
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
                    签约编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtEntrustSignNo' Text='lixuan20210331003' />*必输</td>
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
                <td>交易渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
            </tr>
            <tr>
                <td>代收业务种类
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBusinessCode' Text='110014' /></td>
            </tr>
            <tr>
	            <td></td>
	            <td>
					<br/>110001:水电煤气缴费,110002	:税费缴纳,110003:非营利性教育缴费,110006:路桥通行缴费,110008,电视账单缴费,110009:话费账单缴费,110010:宽带账单缴费,110011:公益慈善,110012:政府服务
					<br/>110013:财政非税收入,110014:营利性教育培训,110015:公共交通,110017:物业缴费,110019:供暖费缴纳,110020:废弃物处理费用缴纳,110021:租金缴纳,110022:会员费用缴纳
					<br/>120001:基金理财产品申购,120002:基金理财产品认购,120003:非投资型保险费用缴纳,120004:贷款还款,120015:信用卡还款,120019:投资型保险费用缴纳,120020:小贷公司贷款还款
					<br/>130007:银行账户充值
					<br/>150001:集团资金归集,150002:供应链资金归集, *必输
				</td>
			</tr>
            <tr>
                <td>客户交易IP
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtBuyIP' Text='' />选输</td>
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
                <td>缴费场景
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtScene' Text='0' />缴费场景，选输</td>
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
