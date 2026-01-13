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
 *    abchina       2014/04/15  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成授权支付签约请求对象
        com.abc.trustpay.client.ebus.QuickAgentSignContractRequest tRequest = new com.abc.trustpay.client.ebus.QuickAgentSignContractRequest();
        tRequest.dicRequest["OrderDate"] = txtRequestDate.Text;                 //验证请求日期 （必要信息 - YYYY/MM/DD）
        tRequest.dicRequest["OrderTime"] = txtRequestTime.Text;                 //验证请求时间 （必要信息 - HH:MM:SS）
        tRequest.dicRequest["OrderNo"] = txtOrderNo.Text;                         //订单编号（必要信息）
        tRequest.dicRequest["PaymentLinkType"] = txtPaymentLinkType.Text;                 //接入渠道 （必要信息）
        tRequest.dicRequest["MerCustomNo"] = txtMerCustomNo.Text;                 //客户编号
        tRequest.dicRequest["AgentSignNo"] = txtAgentSignNo.Text;                 //签约编号
        tRequest.dicRequest["CardNo"] = txtCardNo.Text;//签约账号       （必要信息）
        tRequest.dicRequest["CardType"] = txtCardType.Text;                         //农行卡类型
        tRequest.dicRequest["MobileNo"] = txtMobileNo.Text;         //签约手机号（必要信息）
        tRequest.dicRequest["InvaidDate"] = txtInvaidDate.Text;                 //签约有效期
        tRequest.dicRequest["IsSign"] = txtIsSign.Text;                 //签约/解约标识 （必要信息）
        tRequest.dicRequest["AccName"] = txtAccName.Text;                 //客户姓名 （必要信息）       
        tRequest.dicRequest["CertificateNo"] = txtCertificateNo.Text;             //证件号码       （必要信息）
        tRequest.dicRequest["CertificateType"] = txtCertificateType.Text;//证件类型       （必要信息）
        tRequest.dicRequest["CardDueDate"] = txtCardDueDate.Text;                         //贷记卡有效期（卡类型为贷记卡时必要信息）
        tRequest.dicRequest["CVV2"] = txtCV2.Text;                         //贷记卡CVV2（卡类型为贷记卡时必要信息）     

        //2、传送授权支付签约请求
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //3、授权支付签约请求提交成功，获取返回信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
        }
        else
        {
            //4、授权支付签约请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-授权支付签约（商户端）</title>
</head>
<body style="font-size: 14px;">
    <center>
        授权支付签约（商户端）
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>请求日期</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRequestDate' Text='2009/05/08' />
                    格式要求为YYYY/MM/DD *必输</td>
            </tr>
            <tr>
                <td>请求时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRequestTime' Text='09:10:10' />
                    格式为HH:MM:SS *必输</td>
            </tr>
            <tr>
                <td>订单编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='ON200905080001' />
                    *必输</td>
            </tr>
            <tr>
                <td>签约渠道
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentLinkType' Text='1' />1：internet网络接入 2：手机网络接入 3:数字电视网络接入 4:智能客户端，*必输</td>
            </tr>
            <tr>
                <td>客户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerCustomNo' Text='1' />选输</td>
            </tr>
            <tr>
                <td>签约编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentSignNo' Text='1' />选输</td>
            </tr>
            <tr>
                <td>签约账号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCardNo' Text='5359111111111111' /> *必输
                    </td>
            </tr>
            <tr>
                <td>签约卡类型</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCardType' Text='1' />
                    1:农行借记卡准贷记卡 3:农行贷记卡  A:农行卡合并 *必输</td>
            </tr>
             <tr>
                <td>签约手机号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtMobileNo' Text='13888888888' /> *必输
                    </td>
            </tr>
            <tr>
                <td>签约有效期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInvaidDate' Text='2014/04/14' />格式要求为YYYY/MM/DD *必输</td>
            </tr>
            <tr>
                <td>签约标识
                </td>
                <td>
                <asp:TextBox runat="server" ID='txtIsSign' Text='Sign' />签约，*必输</td>
            </tr>
            <tr>
                <td>证件类型</td>
                <td>
                    <asp:DropDownList runat="server" ID="txtCertificateType">
                        <asp:ListItem Value="I">公民身份证</asp:ListItem>
                        <asp:ListItem Value="P">中国护照</asp:ListItem>
                        <asp:ListItem Value="S">军人身份证</asp:ListItem>
                        <asp:ListItem Value="J">警官证</asp:ListItem>
                        <asp:ListItem Value="K">户口簿</asp:ListItem>
                        <asp:ListItem Value="T">临时身份证</asp:ListItem>
                        <asp:ListItem Value="F">外国护照</asp:ListItem>
                        <asp:ListItem Value="D">港澳通行证</asp:ListItem>
                        <asp:ListItem Value="W">台胞通行证</asp:ListItem>
                        <asp:ListItem Value="R">离休干部荣誉证</asp:ListItem>
                        <asp:ListItem Value="B">军官退休证</asp:ListItem>
                        <asp:ListItem Value="A">文职干部退休证</asp:ListItem>
                        <asp:ListItem Value="C">军事院校学员证</asp:ListItem>
                        <asp:ListItem Value="E">武装警察身份证</asp:ListItem>
                        <asp:ListItem Value="G">军官证</asp:ListItem>
                        <asp:ListItem Value="H">文职干部证</asp:ListItem>
                        <asp:ListItem Value="L">军人士兵证</asp:ListItem>
                        <asp:ListItem Value="M">武警士兵证</asp:ListItem>
                        <asp:ListItem Value="U">其他证件</asp:ListItem>
                    </asp:DropDownList>
                    目前只支持公民身份证 *必输
                </td>
            </tr>
            <tr>
                <td>证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateNo' Text='340121198403084619' />
                    *必输</td>
            </tr>
            <tr>
                <td>客户姓名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccName' Text='测试' />*必输</td>
            </tr>
            <tr>
                <td>贷记卡CVV2
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCV2' Text='123' />卡类型为贷记卡时必输</td>
            </tr>
             <tr>
                <td>贷记卡有效期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCardDueDate' Text='0715' />卡类型为贷记卡时必输</td>
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
