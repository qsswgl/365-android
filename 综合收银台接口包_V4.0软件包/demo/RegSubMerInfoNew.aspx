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
        string totalCount = Request["txtTotalCount"];
        string Account = Request["txtAccount"];
        string AccountName = Request["txtAccountName"];
        string AccountType = Request["txtAccountType"];
        string AccountAbisNo = Request["txtAccountAbisNo"];
        string BankNo = Request["txtBankNo"];
        string MobilePhone = Request["txtMobilePhone"];
        string AccStatus = Request["txtAccStatus"];
        string IsABCAccount = Request["txtIsABCAccount"];


        //}
        //1、生成支付请求对象
        com.abc.trustpay.client.ebus.RegSubMerInfoNew tMerchantInfo = new com.abc.trustpay.client.ebus.RegSubMerInfoNew();

        //3、设置请求值
        //tMerchantInfo.merchantInfoRequest.put("MerchantID", request.getParameter("txtMerchantID")); 
        tMerchantInfo.merchantInfoRequest["SubMerId"] = txtSubMerId.Text;
        tMerchantInfo.merchantInfoRequest["IsNewFlag"] = txtNewSubMerFlag.Text;
        tMerchantInfo.merchantInfoRequest["SubMerContactName"] = txtSubMerContactName.Text;
        tMerchantInfo.merchantInfoRequest["SubMerContactCert"] = txtSubMerContactCert.Text;
        tMerchantInfo.merchantInfoRequest["MerMobilePhone"] = txtMerchantMobileNum.Text;
        tMerchantInfo.merchantInfoRequest["SubMerContactMail"] = txtSubMerContactMail.Text;
        tMerchantInfo.merchantInfoRequest["SubMerContactType"] = txtSubMerContactType.Text;
        //tMerchantInfo.merchantInfoRequest["CompanyName"] = txtSubMerName.Text;
        tMerchantInfo.merchantInfoRequest["SubMerName"] = txtSubMerName.Text;
        tMerchantInfo.merchantInfoRequest["ServicePhone"] = txtServicePhone.Text;
        tMerchantInfo.merchantInfoRequest["Industry"] = txtIndustry.Text;
        tMerchantInfo.merchantInfoRequest["BusinessRange"] = txtBusinessRange.Text;
        //tMerchantInfo.merchantInfoRequest["ProvinceCode"] = txtProvinceCode.Text;
        //tMerchantInfo.merchantInfoRequest["CityCode"] = txtCityCode.Text;
        //tMerchantInfo.merchantInfoRequest["DistrictCode"] = txtDistrictCode.Text;
        tMerchantInfo.merchantInfoRequest["Address"] = txtAddress.Text;
        tMerchantInfo.merchantInfoRequest["SubMerType"] = txtSubMerType.Text;
        tMerchantInfo.merchantInfoRequest["CompanyCertType"] = txtMerCertificateType.Text;
        tMerchantInfo.merchantInfoRequest["CompanyCertNo"] = txtMerCertificateNum.Text;
        tMerchantInfo.merchantInfoRequest["EndCertificateValidity"] = txtEndCertificateValidity.Text;
        tMerchantInfo.merchantInfoRequest["ContactName"] = txtContactName.Text;
        tMerchantInfo.merchantInfoRequest["CertificateType"] = txtCertificateType.Text;
        tMerchantInfo.merchantInfoRequest["CertificateNo"] = txtCertificateNo.Text;
        tMerchantInfo.merchantInfoRequest["FrCertEndDate"] = txtFrCertEndDate.Text;
        tMerchantInfo.merchantInfoRequest["FrIsController"] = txtFrIsController.Text;
        tMerchantInfo.merchantInfoRequest["ControllerName"] = txtControllerName.Text;
        tMerchantInfo.merchantInfoRequest["ControllerCertType"] = txtControllerCertType.Text;
        tMerchantInfo.merchantInfoRequest["ControllerCertNo"] = txtControllerCertNo.Text;
        tMerchantInfo.merchantInfoRequest["ControllerCertEndDate"] = txtControllerCertEndDate.Text;
        tMerchantInfo.merchantInfoRequest["FrIsAgent"] = txtFrIsAgent.Text;
        tMerchantInfo.merchantInfoRequest["AgentName"] = txtAgentName.Text;
        tMerchantInfo.merchantInfoRequest["AgentCertType"] = txtAgentCertType.Text;
        tMerchantInfo.merchantInfoRequest["AgentCertNo"] = txtAgentCertNo.Text;
        tMerchantInfo.merchantInfoRequest["AgentCertEndDate"] = txtAgentCertEndDate.Text;
        tMerchantInfo.merchantInfoRequest["Account"] = txtReceiveAccount.Text;
        tMerchantInfo.merchantInfoRequest["ReplacedAccount"] = txtReplacedAccount.Text;
        tMerchantInfo.merchantInfoRequest["AccountName"] = txtReceiveAccountName.Text;
        tMerchantInfo.merchantInfoRequest["AccountType"] = txtReceiveAccountType.Text;
        tMerchantInfo.merchantInfoRequest["BankName"] = txtReceiveBankName.Text;
        tMerchantInfo.merchantInfoRequest["MobilePhone"] = txtBankMobileNum.Text;
        tMerchantInfo.merchantInfoRequest["ApplyService"] = txtApplyService.Text;
        tMerchantInfo.merchantInfoRequest["Remark"] = txtRemark.Text;
        tMerchantInfo.merchantInfoRequest["Announce"] = txtAnnounce.Text;
        tMerchantInfo.merchantInfoRequest["NotifyUrl"] = txtNotifyUrl.Text;
        tMerchantInfo.merchantInfoRequest["SubMerClass"] = txtSubMerClass.Text;
        tMerchantInfo.merchantInfoRequest["SubMerchantShortName"] = txtSubMerchantShortName.Text;
        tMerchantInfo.merchantInfoRequest["CertificateBegDate"] = txtCertificateBegDate.Text;
        tMerchantInfo.merchantInfoRequest["FrResidence"] = txtFrResidence.Text;
        tMerchantInfo.merchantInfoRequest["ControllerCertBegDate"] = txtControllerCertBegDate.Text;
        tMerchantInfo.merchantInfoRequest["ControllerResidence"] = txtControllerResidence.Text;
        tMerchantInfo.merchantInfoRequest["AgentCertBegDate"] = txtAgentCertBegDate.Text;
        tMerchantInfo.merchantInfoRequest["AgentResidence"] = txtAgentResidence.Text;

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
            strMessage.Append("您的二级商户号为：[" + JSON.GetKeyValue("SubMerId") + "]<br/>");
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
        for (var i = 1; i <= count; i++) {
            var index = formatIndex(i);
            var row = account.insertRow();
            for (var j = 0; j < 9; j++) {
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
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerId' value='' />*新增二级商户时为空，修改二级商户时必输</td>
            </tr>
            <tr>
                <td>新增二级商户标识</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNewSubMerFlag' value='0' />*必输 新增为1，修改为0</td>
            </tr>
            <tr>
                <td>二级商户名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerName' value='测试' />*必输</td>
            </tr>
            <tr>
                <td>二级商户经营名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantShortName' value='' />*必输</td>
            </tr>
            <tr>
                <td>二级商户客服电话</td>
                <td>
                    <asp:TextBox runat="server" ID='txtServicePhone' value='12345678' />*必输 只能为数字或021-85104727类型的号码</td>
            </tr>
            <tr>
                <td>二级商户所属行业</td>
                <td>
                    <asp:TextBox runat="server" ID='txtIndustry' value='0000' />*必输 只能为4位数字</td>
            </tr>
            <tr>
                <td>二级商户经营范围</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBusinessRange' value='' />政府、金融机构及事业单位必输</td>
            </tr>
            <%--<tr>
                <td>二级商户所在省市代码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtProvinceCode' value='000000' />个人商户或政府、金融机构及事业单位必输</td>
            </tr>
            <tr>
                <td>二级商户所在城市代码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCityCode' value='000000' />个人商户或政府、金融机构及事业单位必输</td>
            </tr>
            <tr>
                <td>二级商户所在区县代码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDistrictCode' value='000000' />个人商户或政府、金融机构及事业单位必输</td>
            </tr>--%>
            <tr>
                <td>二级商户实际经营地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAddress' value='xx省xx市xx区县' />*必输</td>
            </tr>
            <tr>
                <td>二级商户类型</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerType' value='1' />*必输 1个人商户 2企业商户 3个体工商户 4政府、金融机构及事业单位</td>
            </tr>
            <tr>
                <td>二级商户证件类型</td>
                <td>
                    <asp:DropDownList ID="txtMerCertificateType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="610049">个体工商户营业执照</asp:ListItem>
                        <asp:ListItem Value="610047">企业营业执照</asp:ListItem>
                        <asp:ListItem Value="610001">组织机构代码</asp:ListItem>
                        <asp:ListItem Value="611009">统一社会信用代码</asp:ListItem>
                        <asp:ListItem Value="610170">事业单位法人证书</asp:ListItem>
                        <asp:ListItem Value="610023">社会团体登记证书</asp:ListItem>
                        <asp:ListItem Value="610025">民办非企业登记证书</asp:ListItem>
                        <asp:ListItem Value="610079">农民专业合作社营业执照</asp:ListItem>
                        <asp:ListItem Value="610033">主管部门颁居民委员会（村民委员会、社区委员会）批文（长度不超过40字符）</asp:ListItem>
                        <asp:ListItem Value="610037">政府主管部门批文（长度不超过40字符）</asp:ListItem>
                        <asp:ListItem Value="610039">财政部门证明（长度不超过40字符）</asp:ListItem>
                        <asp:ListItem Value="619999">其他机构证件标识</asp:ListItem>
                    </asp:DropDownList>
                    企业商户或政府、金融机构及事业单位必输
                </td>
            </tr>
            <tr>
                <td>二级商户证件编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerCertificateNum' value='' />企业商户或政府、金融机构及事业单位必输</td>
            </tr>
            <tr>
                <td>二级商户证件有效期结束时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtEndCertificateValidity' value='20221231' />政府、金融机构及事业单位必输 yyyyMMdd</td>
            </tr>
            <tr>
                <td>个人商户类别</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerClass' value='2' />个人商户必输 0有固定经营场所的实体商户 1无固定经营场所的实体商户 2网络商户</td>
            </tr>
            <tr>
                <td>法定代表人/经营者姓名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtContactName' value='张三' />*必输</td>
            </tr>
            <tr>
                <td>法定代表人/经营者证件类型</td>
                <td>
                    <asp:DropDownList ID="txtCertificateType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="110001" Selected="True">居民身份证</asp:ListItem>
                        <asp:ListItem Value="110003">临时居民身份证</asp:ListItem>
                        <asp:ListItem Value="110007">中国人民解放军军人身份证件</asp:ListItem>
                        <asp:ListItem Value="110009">中国人民武装警察身份证件</asp:ListItem>
                        <asp:ListItem Value="110019">港澳居民来往内地通行证</asp:ListItem>
                        <asp:ListItem Value="110021">台湾居民来往大陆通行证</asp:ListItem>
                        <asp:ListItem Value="110023">中华人民共和国护照</asp:ListItem>
                        <asp:ListItem Value="110025">外国护照</asp:ListItem>
                        <asp:ListItem Value="119999">其它个人证件识别标识</asp:ListItem>
                    </asp:DropDownList>
                    *必输
                </td>
            </tr>
            <tr>
                <td>法定代表人/经营者证件编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateNo' value='' />*必输</td>
            </tr>
            <tr>
                <td>法定代表人/经营者证件有效期开始时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtCertificateBegDate' value='' />*必输 yyyyMMdd</td>
            </tr>
            <tr>
                <td>法定代表人/经营者证件有效期结束时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtFrCertEndDate' value='20991231' />*必输 若证件有效期为长期，请填写：20991231</td>
            </tr>
            <tr>
                <td>法定代表人/经营者证件居住地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtFrResidence' value='' />*必输 省-市-区-详细地址。如：北京市北京市东城区邮通街50号</td>
            </tr>
            <tr>
                <td>法定代表人/经营者是否为受益所有人</td>
                <td>
                    <asp:TextBox runat="server" ID='txtFrIsController' value='1' />企业商户或个体工商户或政府、金融机构及事业单位必输，1：是，0：否</td>
            </tr>
            <tr>
                <td>受益所有人姓名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtControllerName' value='' />是否为受益所有人为0必输，为1必须为空</td>
            </tr>
            <tr>
                <td>受益所有人证件类型</td>
                <td>
                    <asp:DropDownList ID="txtControllerCertType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="110001">居民身份证</asp:ListItem>
                        <asp:ListItem Value="110003">临时居民身份证</asp:ListItem>
                        <asp:ListItem Value="110007">中国人民解放军军人身份证件</asp:ListItem>
                        <asp:ListItem Value="110009">中国人民武装警察身份证件</asp:ListItem>
                        <asp:ListItem Value="110019">港澳居民来往内地通行证</asp:ListItem>
                        <asp:ListItem Value="110021">台湾居民来往大陆通行证</asp:ListItem>
                        <asp:ListItem Value="110023">中华人民共和国护照</asp:ListItem>
                        <asp:ListItem Value="110025">外国护照</asp:ListItem>
                        <asp:ListItem Value="119999">其它个人证件识别标识</asp:ListItem>
                    </asp:DropDownList>
                    是否为受益所有人为0必输，为1必须为空
                </td>
            </tr>
            <tr>
                <td>受益所有人证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtControllerCertNo' value='' />是否为受益所有人为0必输，为1必须为空</td>
            </tr>
            <tr>
                <td>受益所有人证件有效期开始时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtControllerCertBegDate' value='' />是否为受益所有人为0必输，为1必须为空 yyyyMMdd</td>
            </tr>
            <tr>
                <td>受益所有人证件有效期结束时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtControllerCertEndDate' value='' />是否为受益所有人为0必输，为1必须为空 yyyyMMdd</td>
            </tr>
            <tr>
                <td>受益所有人证件居住地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtControllerResidence' value='' />是否为受益所有人为0必输，为1必须为空 省-市-区-详细地址。如：北京市北京市东城区邮通街50号</td>
            </tr>
            <tr>
                <td>法定代表人/经营者是否为实际办理业务人员</td>
                <td>
                    <asp:TextBox runat="server" ID='txtFrIsAgent' value='1' />企业商户或个体工商户或政府、金融机构及事业单位必输，1：是，0：否</td>
            </tr>
            <tr>
                <td>授权办理业务人员姓名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentName' value='' />是否为实际办理业务人员为0必输，为1必须为空</td>
            </tr>
            <tr>
                <td>授权办理业务人员证件类型</td>
                <td>
                    <asp:DropDownList ID="txtAgentCertType" runat="server" onclick="SelectedIndexChanged()">
                        <asp:ListItem Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="110001">居民身份证</asp:ListItem>
                        <asp:ListItem Value="110003">临时居民身份证</asp:ListItem>
                        <asp:ListItem Value="110007">中国人民解放军军人身份证件</asp:ListItem>
                        <asp:ListItem Value="110009">中国人民武装警察身份证件</asp:ListItem>
                        <asp:ListItem Value="110019">港澳居民来往内地通行证</asp:ListItem>
                        <asp:ListItem Value="110021">台湾居民来往大陆通行证</asp:ListItem>
                        <asp:ListItem Value="110023">中华人民共和国护照</asp:ListItem>
                        <asp:ListItem Value="110025">外国护照</asp:ListItem>
                        <asp:ListItem Value="119999">其它个人证件识别标识</asp:ListItem>
                    </asp:DropDownList>
                    是否为实际办理业务人员为0必输，为1必须为空
                </td>
            </tr>
            <tr>
                <td>授权办理业务人员证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentCertNo' value='' />是否为实际办理业务人员为0必输，为1必须为空</td>
            </tr>
            <tr>
                <td>授权办理业务人员证件有效期开始时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentCertBegDate' value='' />是否为实际办理业务人员为0必输，为1必须为空 yyyyMMdd</td>
            </tr>
            <tr>
                <td>授权办理业务人员证件有效期结束时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentCertEndDate' value='' />是否为实际办理业务人员为0必输，为1必须为空 yyyyMMdd</td>
            </tr>
            <tr>
                <td>授权办理业务人员证件居住地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAgentResidence' value='' />是否为实际办理业务人员为0必输，为1必须为空 省-市-区-详细地址。如：北京市北京市东城区邮通街50号</td>
            </tr>
            <tr>
                <td>商户联系人姓名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerContactName' value='张三' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人证件号码</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerContactCert' value='' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人联系电话</td>
                <td>
                    <asp:TextBox runat="server" ID='txtMerchantMobileNum' value='138888888888' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人邮箱</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerContactMail' value='abc@163.com' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人业务标识</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerContactType' value='01' />*必输 01：商户信息核实联系人，02：商户巡检联系人，03：客户投诉处理联系人</td>
            </tr>
            <tr>
                <td>银行账号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiveAccount' value='6228888888888888888' />*必输（若要更换已绑定的旧账号，该字段须填写新账号）</td>
            </tr>
            <tr>
                <td>要更换的旧账号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtReplacedAccount' value='' />若要更换已绑定的收款账号，则此项必输 </td>
            </tr>
            <tr>
                <td>银行账户户名</td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiveAccountName' value='张三' />*必输</td>
            </tr>
            <tr>
                <td>收款银行</td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiveBankName' value='中国农业银行股份有限公司' />*必输</td>
            </tr>
            <tr>
                <td>银行预留手机号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtBankMobileNum' value='138888888888' />*必输</td>
            </tr>
            <tr>
                <td>收款账户类型</td>
                <td>
                    <asp:TextBox runat="server" ID='txtReceiveAccountType' value='401' />*必输 401-借记卡 601-企业户 701-二类户 702-三类户</td>
            </tr>
            <tr>
                <td>申请服务</td>
                <td>
                    <asp:TextBox runat="server" ID='txtApplyService' value='000000' />（六位数0或1组成的代码，如010101，每一位代表是否开通下列服务：第1位-PC（PC网站） 第2位-WAP（手机网站） 第3位-APP（APP支付） 第4位-JSAPI(公众号支付) 第5位-APPLET(小程序支付) 第6位-MICROPAY/F2F（付款码支付/当面付）</td>
            </tr>
            <tr>
                <td>是否已签约</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAnnounce' value='' />*必输</td>
            </tr>
            <tr>
                <td>附言</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRemark' value='1' />选输</td>
            </tr>
            <tr>
                <td>审核通知地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNotifyUrl' value='' />*必输</td>
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
