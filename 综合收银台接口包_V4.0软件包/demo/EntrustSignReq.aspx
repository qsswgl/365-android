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
 *    abchina       2017/04/11  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        StringBuilder strMessage = new StringBuilder("");

        //1、生成支付请求对象
        com.abc.trustpay.client.ebus.EntrustSignReq tMerchantInfo = new com.abc.trustpay.client.ebus.EntrustSignReq();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["SignNo"] = txtSignNo.Text;
        tMerchantInfo.merchantInfoRequest["BusinessCode"] = txtBusinessCode.Text;
        tMerchantInfo.merchantInfoRequest["SignChannel"] = txtSignChannel.Text;
        tMerchantInfo.merchantInfoRequest["SubMerchantID"] = txtSubMerchantID.Text;
        tMerchantInfo.merchantInfoRequest["SinglePaymentLimit"] = txtSinglePaymentLimit.Text;
        tMerchantInfo.merchantInfoRequest["InValidDate"] = txtInValidDate.Text;
        tMerchantInfo.merchantInfoRequest["PayUnit"] = txtPayUnit.Text;
        tMerchantInfo.merchantInfoRequest["PayStep"] = txtPayStep.Text;
        tMerchantInfo.merchantInfoRequest["PayFrequency"] = txtPayFrequency.Text;
        tMerchantInfo.merchantInfoRequest["CustomAccType"] = txtCustomAccType.Text;
        tMerchantInfo.merchantInfoRequest["CustomAccNo"] = txtCustomAccNo.Text;
        tMerchantInfo.merchantInfoRequest["CustomPhone"] = txtCustomPhone.Text;
        tMerchantInfo.merchantInfoRequest["CustomName"] = txtCustomName.Text;
        tMerchantInfo.merchantInfoRequest["CustomCertType"] = txtCustomCertType.Text;
        tMerchantInfo.merchantInfoRequest["CustomCertNo"] = txtCustomCertNo.Text;
        tMerchantInfo.merchantInfoRequest["SignDesc"] = txtSignDesc.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }
        else
        {
            //6、请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }

        lblMessage.Text = strMessage.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-代收签约</title>
</head>

<script language="javascript">
    function formatIndex(index) {
        if (index < 10)
            return "00" + index;
        else if (index >= 10 && index < 100)
            return "0" + index;
        else
            return index;
    }
    function submitFun() {
        form1.submit();
    }
</script>

<body style="font-size: 14px;">
    <center>
        代收签约
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>签约编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSignNo' value='SignNo' />*必输</td>
            </tr>
            <tr>
                <td>代收业务种类</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBusinessCode' value='110014' />*必输</td>
            </tr>
            <tr>
                <td>签约渠道</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSignChannel' value='MERC' />*必输 签约渠道，1：MERC 2：PERB</td>
            </tr>
            <tr>
                <td>签约有效期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtInValidDate' value='2022/12/31' />*必输 YYYY/MM/DD</td>
            </tr>
            <tr>
                <td>代收扣款时间单位</td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayUnit' value='04' />*必输</td>
            </tr>
            <tr>
                <td>代收扣款时间步长</td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayStep' value='3' />*必输 时间单位为00、步长为1时，按年扣款；时间单位为04，步长为3时，按季扣款；时间单位为04，步长为1时，按月扣款；时间单位为07，步长为7时，按周扣款；时间单位为07，步长为1时，按日扣款。</td>
            </tr>
            <tr>
                <td>签约账户类型</td>
                <td>
                    <asp:DropDownList ID="txtCustomAccType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="1" Selected="True">农行借记卡</asp:ListItem>
                        <asp:ListItem Value="3">农行贷记卡</asp:ListItem>
                        <asp:ListItem Value="A">农行卡合并</asp:ListItem>
                    </asp:DropDownList>
                    *必输
                </td>
            </tr>
            <tr>
                <td>签约卡号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomAccNo' value='622XXXXXXXXXXXXXXX' />*必输</td>
            </tr>
            <tr>
                <td>签约手机号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomPhone' value='133XXXXXXXX' />*必输</td>
            </tr>
            <tr>
                <td>签约账户户名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomName' value='XXX' />*必输</td>
            </tr>
            <tr>
                <td>客户证件类型</td>
                <td>
                    <asp:DropDownList ID="txtCustomCertType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="I" Selected="True">公民身份证</asp:ListItem>
                    </asp:DropDownList>
                    *必输
                </td>
            </tr>
            <tr>
                <td>客户证件号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomCertNo' value='110105XXXXXXXXXXXX' />*必输</td>
            </tr>
            <tr>
                <td>代收扣款时间描述</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSignDesc' value='' /></td>
            </tr>
            <tr>
                <td>二级商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantID' value='' /></td>
            </tr>
            <tr>
                <td>代收交易限额</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSinglePaymentLimit' value='' /></td>
            </tr>
            <tr>
                <td>代收扣款频次</td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayFrequency' value='' /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交" OnClick="btnButton_Click" /></td>
            </tr>
        </table>
    </form>
    <a href='Merchant.html'>回商户首页</a>
</body>
</html>
