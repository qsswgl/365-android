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
 *    abc       2014/04/21      V3.0.0
 *
 */
-->


<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成身份验证请求对象
        com.abc.trustpay.client.ebus.QuickIdentityVerifyRequest tRequest = new com.abc.trustpay.client.ebus.QuickIdentityVerifyRequest();
        tRequest.dicRequest["CustomType"] = txtCustomType.Text; //客户类型 （必要信息）
        tRequest.dicRequest["ClientName"] = txtClientName.Text; //客户姓名 （必要信息）
        tRequest.dicRequest["AccNo"] = txtBankCardNo.Text;                    //银行帐号       （必要信息）
        tRequest.dicRequest["CertificateNo"] = txtCertificateNo.Text;              //证件号码       （必要信息）
        tRequest.dicRequest["CertificateType"] = ddlCertificateType.SelectedValue; //证件类型       （必要信息）
        tRequest.dicRequest["MobileNo"] = txtPhoneNo.Text;          //手机号
        tRequest.dicRequest["CustomNo "] = txtCustomNo.Text;              //网银客户号
        //3、传送身份验证请求并取得支付网址
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、身份验证请求提交成功，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
        }
        else
        {
            //5、身份验证请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();

    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-身份验证</title>
</head>
<body style="font-size: 14px;">
    <center>
        身份验证
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <table>
            <tr>
                <td>客户类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomType' Text='0' />个人0，对公1，*必输</td>
            </tr>
            <tr>
                <td>客户姓名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtClientName' Text='张三' />*必输</td>
            </tr>
            <tr>
                <td>证件类型</td>
                <td>
                    <asp:DropDownList ID="ddlCertificateType" runat="server">
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
                    *必输
                </td>
            </tr>
            <tr>
                <td>证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateNo' Text='350624560911051' />
                    *必输</td>
            </tr>
            <tr>
                <td>银行卡号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBankCardNo' Text='9559980120333681118' />
                    *必输</td>
            </tr>
            <tr>
                <td>手机号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtPhoneNo' Text='13888888888' />*必输</td>
            </tr>
            <tr>
                <td>网银客户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtCustomNo' Text='' />选输</td>
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
