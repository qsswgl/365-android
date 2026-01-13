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
        
        string[] Account_arr = null;       
		string[] AccountName_arr = null;            
		string[] AccountType_arr = null;          
		string[] AccountAbisNo_arr = null;         
		string[] BankNo_arr = null;                
		string[] MobilePhone_arr = null;         
		string[] AccStatus_arr = null;                 
		string[] IsABCAccount_arr = null;       	        
        string totalCount =  Request["txtTotalCount"]; 
        string Account           = Request["txtAccount"];
		string AccountName       = Request["txtAccountName"];
		string AccountType       = Request["txtAccountType"];
		string AccountAbisNo     = Request["txtAccountAbisNo"];
		string BankNo            = Request["txtBankNo"];
		string MobilePhone       = Request["txtMobilePhone"];
		string AccStatus         = Request["txtAccStatus"];
		string IsABCAccount      = Request["txtIsABCAccount"];
        

        //}
         //1、生成支付请求对象
        com.abc.trustpay.client.ebus.RegSubMerInfo tMerchantInfo = new com.abc.trustpay.client.ebus.RegSubMerInfo();

        //3、设置请求值
        //tMerchantInfo.merchantInfoRequest.put("MerchantID", request.getParameter("txtMerchantID")); 
        tMerchantInfo.merchantInfoRequest["SubMerId"] = txtSubMerId.Text; 
        tMerchantInfo.merchantInfoRequest["SubMerName"] = txtSubMerName.Text;
        tMerchantInfo.merchantInfoRequest["SubMerType"] = txtSubMerType.Text;     
        tMerchantInfo.merchantInfoRequest["CertificateType"] = txtCertificateType.Text;
        tMerchantInfo.merchantInfoRequest["CertificateNo"] = txtCertificateNo.Text;
        tMerchantInfo.merchantInfoRequest["ContactName"] = txtContactName.Text;
        tMerchantInfo.merchantInfoRequest["Address"] = txtAddress.Text;
        tMerchantInfo.merchantInfoRequest["Remark"] = txtRemark.Text;
        tMerchantInfo.merchantInfoRequest["CompanyName"] = txtMerchantName.Text;
        tMerchantInfo.merchantInfoRequest["CompanyCertType"] = txtMerCertificateType.Text;
        tMerchantInfo.merchantInfoRequest["CompanyCertNo"] = txtMerCertificateNum.Text;
        tMerchantInfo.merchantInfoRequest["AccountName"] = txtReceiveAccountName.Text;
        tMerchantInfo.merchantInfoRequest["Account"] = txtReceiveAccount.Text;
        tMerchantInfo.merchantInfoRequest["BankName"] = txtReceiveBankName.Text;
        tMerchantInfo.merchantInfoRequest["MobilePhone"] = txtBankMobileNum.Text;
        tMerchantInfo.merchantInfoRequest["MerMobilePhone"] = txtMerchantMobileNum.Text;
        tMerchantInfo.merchantInfoRequest["AccountType"] = txtReceiveAccountType.Text;
        tMerchantInfo.merchantInfoRequest["Announce"] = txtAnnounce.Text;
        tMerchantInfo.merchantInfoRequest["NotifyUrl"] = txtNotifyUrl.Text;
        tMerchantInfo.merchantInfoRequest["ReplacedAccount"] = txtReplacedAccount.Text;
        
        //tMerchantInfo.merchantInfoRequest["Address"] = txtAddress.Text;
                
        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        String SerialNo = JSON.GetKeyValue("SerialNo");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("您的申请单号为：[" + SerialNo + "]<br/>");
            //strMessage.append("ECMerchantType   = [" + json.GetKeyValue("ECMerchantType") + "]<br/>");
            strMessage.Append("MerchantID = [" + JSON.GetKeyValue("MerchantID") + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("TransferNo [" + JSON.GetKeyValue("TransferNo") + "]<br/>");
            //strMessage.Append("ResRemark [" + JSON.GetKeyValue("ResRemark") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-二级商户信息同步</title>
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
    function ValidateRequestPara(count) {
        //验证总笔数和总金额
        if (count == null || count == "") {
            alert("账户个数不能为空");
            return false;
        }
        if (isNaN(count)) {
            alert("账户个数请输入数字！");
            return false;
        }
        if (count < 1) {
            alert("账户个数必输是大于1的数字");
            return false;
        }
        return true;
    }

    function addLine() {
        var count = form1.txtTotalCount.value;
        if (!ValidateRequestPara(count))
            return false;
        count = parseInt(count);
        for (var i = 1 ; i <= count; i++) {
            var index = formatIndex(i);
            var row = account.insertRow();
            for (var j = 0 ; j < 9  ; j++) {
                var col = row.insertCell();
                switch (j) {
                    case 0:
                        col.align = "left";
                        col.height = "30";
                        col.innerHTML = index;
                        break;
                    case 1:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtAccount\" style=\"width:95%\" value=\"\">";
                        break;
                    case 2:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtAccountName\" style=\"width:95%\" value=\"\">";
                        break;
                    case 3:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtAccountType\" style=\"width:95%\" value=\"\">";
                        break;
                    case 4:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtAccountAbisNo\" style=\"width:95%\" value=\"\">";
                        break;
                    case 5:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtBankNo\" style=\"width:95%\" value=\"\">";
                        break;
                    case 6:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtMobilePhone\" style=\"width:95%\" value=\"\">";
                        break;
                    case 7:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtAccStatus\" style=\"width:95%\" value=\"\">";
                        break;
                    case 8:
                        col.align = "center";
                        col.innerHTML = "<input type=\"text\" name=\"txtIsABCAccount\" style=\"width:95%\" value=\"\">";
                        break;
                }

            }
        }
        form1.btnButton.disabled = "";
    }
    function submitFun() {
        form1.submit();
    }
</script>

<body style="font-size: 14px;">
    <center>
        二级商户信息同步
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级商户编号</td>
                <td><asp:TextBox runat="server" ID='txtSubMerId' value='103881920000002' />*必输</td>
            </tr>
            <tr>
                <td>二级商户名称</td>
                <td><asp:TextBox runat="server" ID='txtSubMerName' value='测试' />*必输</td>
            </tr>
            <tr>
                <td>二级商户类型</td>
                <td><asp:TextBox runat="server" ID='txtSubMerType' value='1' />*必输 1个人商户 2企业商户 3个体户</td>
            </tr>          
                        <tr>
                <td>法定代表人或负责人名称</td>
                <td><asp:TextBox runat="server" ID='txtContactName' value='张三' />*必输</td>
            </tr>  
            <tr>
                <td>法定代表人或负责人证件类型</td>                 
                 <td>
                    <asp:DropDownList ID="txtCertificateType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="I" Selected="True">公民身份证</asp:ListItem>
                        <asp:ListItem Value="P">护照</asp:ListItem>
                        <asp:ListItem Value="G">军官证</asp:ListItem>
                        <asp:ListItem Value="U">其他证件</asp:ListItem>
                    </asp:DropDownList>*必输</td>
                  
            </tr>
            <tr>
                <td>法定代表人或负责人证件编号</td>
                <td><asp:TextBox runat="server" ID='txtCertificateNo' value='' />*必输</td>
            </tr>

                        <tr>
                <td>企业名称</td>
                <td><asp:TextBox runat="server" ID='txtMerchantName' value='张三商店' />企业商户必输</td>
            </tr>
                   <tr>
                <td>企业证件类型</td>                 
                 <td>
                    <asp:DropDownList ID="txtMerCertificateType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="U">营业执照</asp:ListItem>
                        <asp:ListItem Value="Y">组织机构代码证</asp:ListItem>
                        <asp:ListItem Value="V">统一社会信用代码</asp:ListItem>
                    </asp:DropDownList>企业商户必输</td>
                  
            </tr>
            <tr>
                <td>企业证件编号</td>
                <td><asp:TextBox runat="server" ID='txtMerCertificateNum' value='' />企业商户必输</td>
            </tr>
                                 

            <tr>
                <td>收款户名</td>
                <td><asp:TextBox runat="server" ID='txtReceiveAccountName' value='张三' />*必输</td>
            </tr> 
            <tr>
                <td>要更换的旧账号</td>
                <td><asp:TextBox runat="server" ID='txtReplacedAccount' value='' />若要更换已绑定的收款账号，则此项必输 </td>
            </tr>
            <tr>
                <td>收款账号</td>
                <td><asp:TextBox runat="server" ID='txtReceiveAccount' value='6228888888888888888' />*必输（若要更换已绑定的旧账号，该字段须填写新账号）</td>
            </tr> 
            <tr>
                <td>收款银行</td>
                <td><asp:TextBox runat="server" ID='txtReceiveBankName' value='中国农业银行股份有限公司' />*必输</td>      
            </tr>
  
                 <tr>
                <td>银行预留手机号</td>
                <td><asp:TextBox runat="server" ID='txtBankMobileNum' value='138888888888' />*必输</td>
            </tr> 
                <tr>
                <td>收款账户类型</td>
                <td><asp:TextBox runat="server" ID='txtReceiveAccountType' value='401' />*必输 401-借记卡 601-支票户</td>
            </tr> 
                 <tr>
                <td>商户负责人联系电话</td>
                <td><asp:TextBox runat="server" ID='txtMerchantMobileNum' value='138888888888' />选输</td>
            </tr>
            <tr>
                <td>地址</td>
                <td><asp:TextBox runat="server" ID='txtAddress' value='' />选输</td>
            </tr>
            <tr>
                <td>是否已签约</td>
                <td><asp:TextBox runat="server" ID='txtAnnounce' value='' />*必输</td>
            </tr>
            <tr>
                <td>审核通知地址</td>
                <td><asp:TextBox runat="server" ID='txtNotifyUrl' value='' />*必输</td>
            </tr>
            <tr>
                <td>备注</td>
                <td><asp:TextBox runat="server" ID='txtRemark' value='1' />选输</td>
            </tr> 
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnButton" runat="server" Text="提交" OnClick="btnButton_Click"/></td>
            </tr>
        </table>
    </form>
    <a href='Merchant.html'>回商户首页</a>
</body>
</html>
