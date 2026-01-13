<!--
/*
 * Project: BJP09001
 *
 * Description:
 *    二级商户迁移补录
 *
 * Modify Information:
 *    Author        Date        Description
 *    ============  ==========  =======================================
 *    wt        2023/01/10    AppendSubmerchantInfo
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成请求对象
        com.abc.trustpay.client.ebus.AppendSubmerchantInfoRequest tRequest = new com.abc.trustpay.client.ebus.AppendSubmerchantInfoRequest();
        //2、生成定单订单对象
        tRequest.dicRequest["OriSubMerNo"] = OriSubMerNo.Text;
        tRequest.dicRequest["SubMerContactName"] = SubMerContactName.Text;
        tRequest.dicRequest["SubMerContactCert"] = SubMerContactCert.Text;
        tRequest.dicRequest["MerMobilePhone"] = MerMobilePhone.Text;
        tRequest.dicRequest["SubMerContactMail"] = SubMerContactMail.Text;
        tRequest.dicRequest["SubMerContactType"] = SubMerContactType.Text;
        tRequest.dicRequest["ServicePhone"] = ServicePhone.Text;
        tRequest.dicRequest["Industry"] = Industry.Text;
        tRequest.dicRequest["BusinessRange"] = BusinessRange.Text;
        tRequest.dicRequest["Address"] = Address.Text;
        tRequest.dicRequest["CertificateBegDate"] = CertificateBegDate.Text;
        tRequest.dicRequest["FrCertEndDate"] = FrCertEndDate.Text;
        tRequest.dicRequest["FrResidence"] = FrResidence.Text;
        tRequest.dicRequest["FrIsController"] = FrIsController.Text;
        tRequest.dicRequest["FrIsAgent"] = FrIsAgent.Text;
        tRequest.dicRequest["ControllerName"] = ControllerName.Text;
        tRequest.dicRequest["ControllerCertType"] = ControllerCertType.Text;
        tRequest.dicRequest["ControllerCertNo"] = ControllerCertNo.Text;
        tRequest.dicRequest["ControllerCertBegDate"] = ControllerCertBegDate.Text;
        tRequest.dicRequest["ControllerCertEndDate"] = ControllerCertEndDate.Text;
        tRequest.dicRequest["ControllerResidence"] = ControllerResidence.Text;
        tRequest.dicRequest["AgentName"] = AgentName.Text;
        tRequest.dicRequest["AgentCertType"] = AgentCertType.Text;
        tRequest.dicRequest["AgentCertNo"] = AgentCertNo.Text;
        tRequest.dicRequest["AgentCertBegDate"] = AgentCertBegDate.Text;
        tRequest.dicRequest["AgentCertEndDate"] = AgentCertEndDate.Text;
        tRequest.dicRequest["AgentResidence"] = AgentResidence.Text;
        tRequest.dicRequest["ApplyService"] = ApplyService.Text;
        tRequest.dicRequest["SubMerClass"] = SubMerClass.Text;
        tRequest.dicRequest["SubMerchantShortName"] = SubMerchantShortName.Text;
        tRequest.dicRequest["EndCertificateValidity"] = EndCertificateValidity.Text;

        
        //3、传送请求
        tRequest.postJSONRequest();
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //4、请求提交成功
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("TrxType   = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("OrderNo = [" + JSON.GetKeyValue("OrderNo") + "]<br/>");
        }
        else
        {
            //5、请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }

        lblMessage.Text = strMessage.ToString();
    }

</script>

<script language="javascript" type="text/javascript">
</script>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-二级商户迁移补录</title>
</head>
<body style="font-size: 14px;">
    <center>
        二级商户迁移补录
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>原二级商户号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='OriSubMerNo' Text='123456789' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人姓名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='SubMerContactName' Text='张海华' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人证件号码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='SubMerContactCert' Text='370112199408017435' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人联系电话
                </td>
                <td>
                    <asp:TextBox runat="server" ID='MerMobilePhone' Text='13811246202' />*必输</td>
            </tr>
            <tr>
                <td>商户联系人邮箱
                </td>
                <td>
                     <asp:TextBox runat="server" ID='SubMerContactMail' Text='' /></td>
            </tr>
            <tr>
                <td>商户联系人业务标识
                </td>
                <td>
                     <asp:TextBox runat="server" ID='SubMerContactType' Text='01' />*必输</td>
            </tr>
            <tr>
                <td>二级商户客服电话
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ServicePhone' Text='13811246202' />*必输</td>
            </tr>
            <tr>
                <td>二级商户所属行业
                </td>
                <td>
                    <asp:TextBox runat="server" ID='Industry' Text='0002' />*必输</td>
            </tr>
            <tr>
                <td>二级商户经营范围
                </td>
                <td>
                    <asp:TextBox runat="server" ID='BusinessRange' Text='' /></td>
            </tr>
            <tr>
                <td>地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='Address' Text='北京市海淀区' /></td>
            </tr>
            <tr>
                <td>法人/经营者证件有效期开始时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='CertificateBegDate' Text='20201225' />*必输</td>
            </tr>
            <tr>
                <td>法人/经营者证件有效期结束时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='FrCertEndDate' Text='20231231' />*必输</td>
            </tr>
            <tr>
                <td>法人/经营者证件居住地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='FrResidence' Text='北京市海淀区' />*必输</td>
            </tr>
            <tr>
                <td>法人/经营者是否为控股股东名称或者实际控制人
                </td>
                <td>
                    <asp:TextBox runat="server" ID='FrIsController' Text='1' />*必输</td>
            </tr>
            <tr>
                <td>法人/经营者是否为实际办理业务人员
                </td>
                <td>
                    <asp:TextBox runat="server" ID='FrIsAgent' Text='1' />*必输</td>
            </tr>
            <tr>
                <td>控股股东名称或者实际控制人姓名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ControllerName' Text='' /></td>
            </tr>
            <tr>
                <td>控股股东名称或者实际控制人证件类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ControllerCertType' Text='' /></td>
            </tr>
            <tr>
                <td>控股股东名称或者实际控制人证件号码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ControllerCertNo' Text='' /></td>
            </tr>
            <tr>
                <td>控股股东名称或者实际控制人证件有效期开始时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ControllerCertBegDate' Text='' /></td>
            </tr>
            <tr>
                <td>控股股东名称或者实际控制人证件有效期结束时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ControllerCertEndDate' Text='' /></td>
            </tr>
            <tr>
                <td>控股股东证件居住地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ControllerResidence' Text='' /></td>
            </tr>
            <tr>
                <td>授权办理业务人员姓名
                </td>
                <td>
                    <asp:TextBox runat="server" ID='AgentName' Text='' /></td>
            </tr>
            <tr>
                <td>授权办理业务人员证件类型
                </td>
                <td>
                    <asp:TextBox runat="server" ID='AgentCertType' Text='' /></td>
            </tr>
            <tr>
                <td>授权办理业务人员证件号码
                </td>
                <td>
                    <asp:TextBox runat="server" ID='AgentCertNo' Text='' /></td>
            </tr>
            <tr>
                <td>授权办理业务人员证件有效期开始时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='AgentCertBegDate' Text='' /></td>
            </tr>
            <tr>
                <td>授权办理业务人员证件有效期结束时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='AgentCertEndDate' Text='' /></td>
            </tr>
            <tr>
                <td>授权办理业务人员证件居住地址
                </td>
                <td>
                    <asp:TextBox runat="server" ID='AgentResidence' Text='' /></td>
            </tr>
            <tr>
                <td>申请服务
                </td>
                <td>
                    <asp:TextBox runat="server" ID='ApplyService' Text='111111' />*必输</td>
            </tr>
            <tr>
                <td>个人商户类别
                </td>
                <td>
                    <asp:TextBox runat="server" ID='SubMerClass' Text='1' />*必输</td>
            </tr>
            <tr>
                <td>二级商户经营名称
                </td>
                <td>
                    <asp:TextBox runat="server" ID='SubMerchantShortName' Text='成都瑞峰商业管理' />*必输</td>
            </tr>
            <tr>
                <td>二级商户证件有效期结束时间
                </td>
                <td>
                    <asp:TextBox runat="server" ID='EndCertificateValidity' Text='' /></td>
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
