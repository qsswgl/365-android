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
        //1、生成授权支付签约请求对象
        com.abc.trustpay.client.ebus.EntrustSignForBankRequest tRequest = new com.abc.trustpay.client.ebus.EntrustSignForBankRequest();
        tRequest.entrustSignRequest["SignNo"] = txtSignNo.Text;             //证件号码       （必要信息）
        tRequest.entrustSignRequest["BusinessCode"] = txtBusinessCode.Text;//证件类型       （必要信息）农行卡类型
        tRequest.entrustSignRequest["SignChannel"] = "PERB";                 //通知类型 （必要信息）
        tRequest.entrustSignRequest["SubMerchantNo"] = txtSubMerchantNo.Text;         //通知地址（必要信息）
        tRequest.entrustSignRequest["SinglePaymentLimit"] = txtSinglePaymentLimit.Text;                         //订单编号（必要信息）
        tRequest.entrustSignRequest["InValidDate"] = txtInValidDate.Text;                 //接入渠道 （必要信息）
        tRequest.entrustSignRequest["CustomCertType"] = ddlCertificateType.SelectedValue;                 //客户编号
        tRequest.entrustSignRequest["CustomCertNo"] = txtCertificateNo.Text;                         //农行卡类型 （必要信息）
        tRequest.entrustSignRequest["PaymentType"] = txtPaymentType.Text;                 //验证请求日期 （必要信息 - YYYY/MM/DD）
        tRequest.entrustSignRequest["PayUnit"] = txtPayUnit.Text;                 //验证请求时间 （必要信息 - HH:MM:SS）
        tRequest.entrustSignRequest["PayStep"] = txtPayStep.Text;                 //签约有效期 （必要信息）
        tRequest.entrustSignRequest["PayFrequency"] = txtPayFrequency.Text;                 //签约标识 （必要信息）
        tRequest.entrustSignRequest["SignDesc"] = txtSignDesc.Text;                 //签约标识 （必要信息）
        tRequest.entrustSignRequest["NotifyType"] = txtNotifyType.Text;                 //签约标识 （必要信息）
        tRequest.entrustSignRequest["NotifyUrl"] = txtNotifyUrl.Text;                 //签约标识 （必要信息）
        //2、传送授权支付签约请求并取得签约网址
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode      = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + ErrorMessage + "]<br/>");
            strMessage.Append("SignNo      = [" + JSON.GetKeyValue("SignNo") + "]<br/>");
            //3、授权支付签约请求提交成功，将客户端导向签约页面
            Response.Redirect(JSON.GetKeyValue("EntrustSignRequestURL"));
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
    <title>农行网上支付平台-商户接口范例-代收支付签约</title>
</head>
<body style="font-size: 14px;">
    <center>
        代收支付签约
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>证件类型</td>
                <td>
                    <asp:DropDownList runat="server" ID="ddlCertificateType">
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
                <td>签约编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSignNo' Text='ON200905080001' />
                    *必输</td>
            </tr>
            <tr>
                <td>二级商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' Text='ON200905080001' />
                  *平台商户必输</td>
            </tr>
            <tr>
                <td>业务类别</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBusinessCode' Text='110014' />
                  *必输</td>
            </tr>
            
            <tr>
                <td>单笔限额</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSinglePaymentLimit' Text='100' />
                     *必输</td>
            </tr>
            <tr>
                <td>客户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerCustomNo' Text='1' />选输</td>
            </tr>

            <tr>
                <td>签约有效期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtInValidDate' Text='2024/04/14' />格式要求为YYYY/MM/DD，*必输</td>
            </tr>

            <tr>
                <td>签约卡类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPaymentType' Text='A' />1 借记卡 3 贷记卡 A借记卡及贷记卡均支持*必输</td>
            </tr>
            <tr>
                <td>扣款时间单位
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayUnit' Text='00' />00为年\04为月\07为日 *必输</td>
            </tr>
                        <tr>
                <td>扣款步长
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayStep' Text='3' />*必输</td>
            </tr>
                                    <tr>
                <td>扣款频次
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtPayFrequency' Text='1' />*必输</td>
            </tr>
                                                <tr>
                <td>签约附言
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSignDesc' Text='代收签约' />*必输</td>
            </tr>
            <tr>
                <td>NotifyType
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyType' Text='1' />0：URL页面通知 1：服务器通知</td>
            </tr>
            <tr>
                <td>结果接收URL</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyUrl' Text='http://127.0.0.1:1725/demo/AgentSignResult.aspx' />*必输</td>
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
