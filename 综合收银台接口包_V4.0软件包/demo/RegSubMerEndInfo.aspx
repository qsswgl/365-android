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
        com.abc.trustpay.client.ebus.RegSubMerEndInfo tMerchantInfo = new com.abc.trustpay.client.ebus.RegSubMerEndInfo();

        //3、设置请求值
        //tMerchantInfo.merchantInfoRequest.put("MerchantID", request.getParameter("txtMerchantID")); 
        tMerchantInfo.merchantInfoRequest["SubMerchantNo"] = txtSubMerchantNo.Text;
        tMerchantInfo.merchantInfoRequest["DeviceSource"] = txtDeviceSource.Text;
        tMerchantInfo.merchantInfoRequest["DeviceType"] = txtDeviceType.Text;
        tMerchantInfo.merchantInfoRequest["DeviceSeqId"] = txtDeviceSeqId.Text;
        tMerchantInfo.merchantInfoRequest["DeviceManufacturer"] = txtDeviceManufacturer.Text;
        tMerchantInfo.merchantInfoRequest["DeviceModel"] = txtDeviceModel.Text;
        tMerchantInfo.merchantInfoRequest["EnablePosition"] = txtEnablePosition.Text;
        tMerchantInfo.merchantInfoRequest["DeviceAddress"] = txtDeviceAddress.Text;
        tMerchantInfo.merchantInfoRequest["DeviceLongitude"] = txtDeviceLongitude.Text;
        tMerchantInfo.merchantInfoRequest["DeviceLatitude"] = txtDeviceLatitude.Text;
        tMerchantInfo.merchantInfoRequest["DeviceState"] = txtDeviceState.Text;
        tMerchantInfo.merchantInfoRequest["ShopName"] = txtShopName.Text;

        //tMerchantInfo.merchantInfoRequest["Address"] = txtAddress.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("您的终端编号为：[" + JSON.GetKeyValue("DeviceId") + "]<br/>");
            strMessage.Append("MerchantID = [" + JSON.GetKeyValue("MerchantID") + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
            strMessage.Append("SubMerchantNo [" + JSON.GetKeyValue("SubMerchantNo") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-二级商户终端信息同步</title>
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
        二级商户终端信息同步
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级商户号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerchantNo' value='1038809076542i15' />*必输</td>
            </tr>
            <tr>
                <td>门店名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtShopName' value='' />*必输</td>
            </tr>
            <tr>
                <td>终端来源</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceSource' value='1' />*必输 0：行内采购、1：商户自采</td>
            </tr>
            <tr>
                <td>终端类型</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceType' value='10' />*必输 10：条码支付受理终端、11：辅助受理终端（不含静态条码展示介质）、21：静态条码展示介质</td>
            </tr>
            <tr>
                <td>终端序列号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceSeqId' value='' />终端设备类型为10时，该字段必填</td>
            </tr>

            <tr>
                <td>生产厂商</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceManufacturer' value='' />终端设备类型为10和11时，该字段必填</td>
            </tr>
            <tr>
                <td>终端型号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceModel' value='' />终端设备类型为10和11时，该字段必填</td>
            </tr>
            <tr>
                <td>终端是否具备定位功能</td>
                <td>
                    <asp:TextBox runat="server" ID='txtEnablePosition' value='0' />终端设备类型为10时，该字段必填。1:是，0:否。</td>
            </tr>
            <tr>
                <td>终端布放地址</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceAddress' value='' />*必输。省-市-区-详细地址。如：北京市北京市东城区邮通街50号</td>
            </tr>
            <tr>
                <td>终端位置经度</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceLongitude' value='121.483521' />*必输。经度格式：1-3位整数+1位小数点+6位小数，如121.483521</td>
            </tr>
            <tr>
                <td>终端位置纬度</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceLatitude' value='31.221345' />*必输。纬度格式：1-2位整数+1位小数点+6位小数，如31.221345</td>
            </tr>

            <tr>
                <td>终端状态</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceState' value='00' />*必输。00：启用，01：注销</td>
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
