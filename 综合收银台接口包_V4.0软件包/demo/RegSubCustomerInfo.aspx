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
        com.abc.trustpay.client.ebus.RegSubCustomerInfo tMerchantInfo = new com.abc.trustpay.client.ebus.RegSubCustomerInfo();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["BankName"] = txtBankName.Text;
        tMerchantInfo.merchantInfoRequest["Account"] = txtAccount.Text;
        tMerchantInfo.merchantInfoRequest["CompanyCertType"] = txtCompanyCertType.Text;
        tMerchantInfo.merchantInfoRequest["Address"] = txtAddress.Text;
        tMerchantInfo.merchantInfoRequest["SubMerType"] = txtSubMerType.Text;
        tMerchantInfo.merchantInfoRequest["SubMerSort"] = txtSubMerSort.Text;
        tMerchantInfo.merchantInfoRequest["Announce"] = txtAnnounce.Text;
        tMerchantInfo.merchantInfoRequest["SubMerName"] = txtSubMerName.Text;
        tMerchantInfo.merchantInfoRequest["CertificateNo"] = txtCertificateNo.Text;
        tMerchantInfo.merchantInfoRequest["AccountType"] = txtAccountType.Text;
        tMerchantInfo.merchantInfoRequest["MobilePhone"] = txtMobilePhone.Text;
        tMerchantInfo.merchantInfoRequest["CompanyCertNo"] = txtCompanyCertNo.Text;
        tMerchantInfo.merchantInfoRequest["Remark"] = txtRemark.Text;
        tMerchantInfo.merchantInfoRequest["CertificateType"] = txtCertificateType.Text;
        tMerchantInfo.merchantInfoRequest["CompanyName"] = txtCompanyName.Text;
        tMerchantInfo.merchantInfoRequest["SubMerId"] = txtSubMerId.Text;
        tMerchantInfo.merchantInfoRequest["NotifyUrl"] = txtNotifyUrl.Text;
        tMerchantInfo.merchantInfoRequest["MerMobilePhone"] = txtMerMobilePhone.Text;
        tMerchantInfo.merchantInfoRequest["ContactName"] = txtContactName.Text;
        tMerchantInfo.merchantInfoRequest["AccountName"] = txtAccountName.Text;
        tMerchantInfo.merchantInfoRequest["SerialNo"] = txtSerialNo.Text;
        tMerchantInfo.merchantInfoRequest["ReplacedAccount"] = txtReplacedAccount.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("SubMerSignNo = [" + JSON.GetKeyValue("SubMerSignNo") + "]<br/>");
            strMessage.Append("SerialNo = [" + JSON.GetKeyValue("SerialNo") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-客户信息同步</title>
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
        客户信息同步
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级客户请求号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSerialNo' value='123448' />*二级客户编号和二级客户请求号必须输入且只能输入一个</td>
            </tr>
            <tr>
                <td>二级客户编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerId' value='' />*二级客户编号和二级客户请求号必须输入且只能输入一个</td>
            </tr>
            <tr>
                <td>二级客户名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerName' value='新陆零测试' />*必输</td>
            </tr>
            <tr>
                <td>二级客户类型</td>
                <td>
                    <asp:DropDownList ID="txtSubMerType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="P" Selected="True">个人客户</asp:ListItem>
                    </asp:DropDownList>
                    *必输 二级客户类型，P：个人客户(固定)
                </td>
            </tr>
            <tr>
                <td>二级客户种类</td>
                <td>
                    <asp:DropDownList ID="txtSubMerSort" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="5" Selected="True">普通类</asp:ListItem>
                    </asp:DropDownList>
                    *必输 二级客户种类，5：普通类
                </td>
            </tr>
            <tr>
                <td>法人/经营者姓名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtContactName' value='张三' />*必输 二级客户类型为“个人客户”时，请填写个人身份证件上的姓名</td>
            </tr>
            <tr>
                <td>法人/经营者证件类型</td>
                <td>
                    <asp:DropDownList ID="txtCertificateType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="I" Selected="True">身份证</asp:ListItem>
                        <asp:ListItem Value="P">护照</asp:ListItem>
                        <asp:ListItem Value="G">军官证</asp:ListItem>
                        <asp:ListItem Value="U">其他证件</asp:ListItem>
                    </asp:DropDownList>
                    *必输 二级客户类型，P：个人客户(固定)
                </td>
            </tr>
            <tr>
                <td>法人/经营者证件编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateNo' value='35010219920907625X' />*必输 二级客户类型为“个人客户”时，请填写个人身份证号码</td>
            </tr>
            <tr>
                <td>银行账号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccount' value='6228270016020564175' />*必输</td>
            </tr>
            <tr>
                <td>银行账户户名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAccountName' value='张三' />*必输 账户类型为个人银行卡（401：借记卡、701：二类户，702：三类户）户名必须与法人/经营者姓名一致</td>
            </tr>
            <tr>
                <td>开户银行名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBankName' value='中国农业银行股份有限公司' />*必输</td>
            </tr>
            <tr>
                <td>银行预留手机号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtMobilePhone' value='13819951105' />*必输</td>
            </tr>
            <tr>
                <td>账户类型</td>
                <td>
                    <asp:DropDownList ID="txtAccountType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="401" Selected="True">借记卡</asp:ListItem>
                        <asp:ListItem Value="701">二类户</asp:ListItem>
                        <asp:ListItem Value="702">三类户</asp:ListItem>
                    </asp:DropDownList>
                    *必输 401：借记卡，701：二类户，702：三类户
                </td>
            </tr>
            <tr>
                <td>地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAddress' value='广州市白云区黄边北路时代玫瑰园' />*必输</td>
            </tr>
            <tr>
                <td>声明已签署三方协议</td>
                <td>
                    <asp:DropDownList ID="txtAnnounce" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="1" Selected="True">已声明</asp:ListItem>
                    </asp:DropDownList>
                    *必输 声明已签署三方协议，1：已声明
                </td>
            </tr>
            <tr>
                <td>企业商户名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCompanyName' value='' />暂不支持企业商户</td>
            </tr>
            <tr>
                <td>企业商户证件类型</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCompanyCertType' value='' />暂不支持企业商户</td>
            </tr>
            <tr>
                <td>企业商户证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCompanyCertNo' value='' />暂不支持企业商户</td>
            </tr>
            <tr>
                <td>附言</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemark' value='' /></td>
            </tr>
            <tr>
                <td>审核结果通知地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyUrl' value='http://10.72.213.117:8080' /></td>
            </tr>
            <tr>
                <td>客户负责人联系电话</td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerMobilePhone' value='13819951105' /></td>
            </tr>
            <tr>
                <td>要更改的二级客户账户账号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtReplacedAccount' value='' /></td>
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
