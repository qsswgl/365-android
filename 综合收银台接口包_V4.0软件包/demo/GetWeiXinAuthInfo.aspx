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
        com.abc.trustpay.client.ebus.GetWeiXinAuthInfo tMerchantInfo = new com.abc.trustpay.client.ebus.GetWeiXinAuthInfo();

        //3、设置请求值
        tMerchantInfo.merchantInfoRequest["StoreId"] = txtStoreId.Text;
        tMerchantInfo.merchantInfoRequest["StoreName"] = txtStoreName.Text;
        tMerchantInfo.merchantInfoRequest["DeviceId"] = txtDeviceId.Text;
        tMerchantInfo.merchantInfoRequest["Attach"] = txtAttach.Text;
        tMerchantInfo.merchantInfoRequest["RawData"] = txtRawData.Text;
        tMerchantInfo.merchantInfoRequest["SubAppId"] = txtSubAppId.Text;
        tMerchantInfo.merchantInfoRequest["Now"] = txtNow.Text;
        tMerchantInfo.merchantInfoRequest["VersionNo"] = txtVersionNo.Text;
        tMerchantInfo.merchantInfoRequest["SignType"] = txtSignType.Text;

        //4、传送请求并返回结果
        tMerchantInfo.postJSONRequest();

        String ReturnCode = JSON.GetKeyValue("ReturnCode");
        String ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        String AuthInfo = JSON.GetKeyValue("AuthInfo");
        String ExpiresIn = JSON.GetKeyValue("ExpiresIn");
        if (ReturnCode.Equals("0000"))
        {
            //5、请求提交成功，返回结果信息
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            strMessage.Append("AuthInfo：[" + AuthInfo + "]<br/>");
            strMessage.Append("ExpiresIn：[" + ExpiresIn + "]<br/>");
            strMessage.Append("MerchantID = [" + JSON.GetKeyValue("MerchantID") + "]<br/>");
            strMessage.Append("TrxType = [" + JSON.GetKeyValue("TrxType") + "]<br/>");
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
    <title>农行网上支付平台-商户接口范例-获取调用凭证</title>
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
        获取调用凭证
    </center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>门店编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtStoreId' value='NFZF2000001' />*必输</td>
            </tr>
            <tr>
                <td>门店名称</td>
                <td>
                    <asp:TextBox runat="server" ID='txtStoreName' value='NFZF2000001' />*必输</td>
            </tr>
            <tr>
                <td>终端设备编号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtDeviceId' value='BD7102033005139' />*必输</td>
            </tr>
            <tr>
                <td>附加字段</td>
                <td>
                    <asp:TextBox runat="server" ID='txtAttach' value='' />字段格式使用Json</td>
            </tr>
            <tr>
                <td>初始化数据</td>
                <td>
                    <asp:TextBox runat="server" ID='txtRawData' value='KstAuVx0YpEWKL2zEJMZsfR+DvFEbbS/T7smTK2T0TIHBIK6tf/2ct80RgHHTczGJWZujBHVKmz7qPdy18GF2DT/ScueXLOwD5IWYXmnvLelW88axFQh3gNiydsdwTc7d4M2b4YL165sExnXXEmRarRxdmcuxP5sGyBgx3op2MaKyn+edWA4aSmxwQyX2AG/242qtuOvjO7CrtHXMS9hRTKu6XmAhjZgsox3QfXLa2c1WHXUFb6uQ3ZE2SYkfHPtroHwwgxA/qBixp6h0TY40KurTIfXBIXuvwDRJhAV9JUnHJCyiuQGc0IG9wMO1cxZ6lKnzR9t5w6t4BdQY9sHyXVWMRVDVJoq1peRzZj/2cjdR2o/UMhiV5aVq1ytTt3uxXc84wbUW4rWGz6QyS/nLjGapv3jy09stbPOLcYa36CDoFWqdnjDP55IcVHb2qQioeN4jTsvPS5ncJ/QIRAvvtW9FDc1lFRexi0FMp4Rbx3CO+cAXR1yZmtr8qaoafsOA2vGiUBUQ5uxHfRSI/PoPKbkEZlhDK19GQ9kTPggC631uLTplX/6a3PksMMrlTjGSZj8mnDA4PtxRA8F5XS6XjKzGzxxV95eTXI=' />*必输 由微信人脸SDK的接口返回</td>
            </tr>
            <tr>
                <td>子商户绑定的公众号/小程序appid</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubAppId' value='' /></td>
            </tr>
            <tr>
                <td>当前时间</td>
                <td>
                    <asp:TextBox runat="server" ID='txtNow' value='1636356407' />*必输 取当前时间，10位unix时间戳</td>
            </tr>
            <tr>
                <td>版本号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtVersionNo' value='1' />*必输 固定为1</td>
            </tr>
            <tr>
                <td>签名类型</td>
                <td>
                    <asp:TextBox runat="server" ID='txtSignType' value='MD5' />*必输 目前支持HMAC-SHA256和MD5,默认为MD5</td>
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
