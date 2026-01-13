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
 *    abchina       2018/01/30  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Red;

        //1、生成商户交易查询请求对象
        com.abc.trustpay.client.ebus.SubMerchantSubPic tRequest = new com.abc.trustpay.client.ebus.SubMerchantSubPic();
        //tRequest.queryRequest["SubMerId"] = txtSubMerId.Text;    //设定交易类型（必要信息）


        //2、传送商户交易查询请求并取得交易查询结果
        tRequest.postJSONRequest();

        //3、判断商户交易查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        string MerchantName = JSON.GetKeyValue("MerchantName");
        string SubMerId = JSON.GetKeyValue("SubMerId");
        string SubMerchantAccNo = JSON.GetKeyValue("SubMerchantAccNo");
        string Balance = JSON.GetKeyValue("Balance");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            //4、获取结果信息
           
            strMessage.Append("MerchantName   = [" + MerchantName + "]<br/>");         //主商户名称
            strMessage.Append("SubMerId   = [" + SubMerId + "]<br/>");                 //二级商户号
            strMessage.Append("SubMerchantAccNo   = [" + SubMerchantAccNo + "]<br/>"); //二级商户账号
            strMessage.Append("Balance   = [" + Balance + "]<br/>");                   //二级商户余额
 
        }
        else
        {
            //6、商户订单查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }


    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>农行网上支付平台-商户接口范例-二级商户余额查询</title>
</head>
<body style="font-size: 14px;">
    <center>
        二级商户余额查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>子商户编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerId' Text='' /> *必输 </td>
            </tr>
            <tr>
                <td colspan="2">
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
