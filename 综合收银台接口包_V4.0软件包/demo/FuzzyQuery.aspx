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
 *    abchina       2014/04/21  V3.0.0
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Black;

        //1、生成订单模糊查询请求对象
        com.abc.trustpay.client.ebus.FuzzyQuery tRequest = new com.abc.trustpay.client.ebus.FuzzyQuery();
        tRequest.dicRequest["FuzzyOrderNo"] = FuzzyOrderNo.Text;   //外转（出金）交易编号 （必要信息）


        //2、传送订单模糊查询请求并取得结果信息
        tRequest.postJSONRequest();

        //3、判断订单模糊查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        
        if (ReturnCode.Equals("0000"))
        {
            //4、订单模糊查询成功，生成对账单对象
            strMessage.Append("ReturnCode      = [" + JSON.GetKeyValue("ReturnCode") + "]<br/>");
            strMessage.Append("ErrorMessage      = [" + JSON.GetKeyValue("ErrorMessage") + "]<br/>");
            strMessage.Append("OrderCount = [" + JSON.GetKeyValue("OrderCount") + "]<br/>");
            strMessage.Append("====================================<br/>");
            Dictionary<int, Hashtable> orderInfo = JSON.GetArrayValue("OrderInfo");
            for (int i = 0; i < Int16.Parse(JSON.GetKeyValue("OrderCount")); i++)
            {
                strMessage.Append("Order Index  =  [" + (i + 1) + "]<br/>");  
                foreach (string key in orderInfo[i].Keys)
                {
                    strMessage.Append(key + " = [" + orderInfo[i][key] + "]<br/>");  
                }
            }
            strMessage.Append("====================================<br/>");
        }
        else
        {
            //6、订单模糊查询失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-订单模糊查询接口</title>
    <style type="text/css">
        .auto-style1
        {
            height: 55px;
        }
    </style>
</head>
<body style="font-size: 14px;">
    <center style="width: 352px; height: 16px">
        订单模糊查询</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>订单模糊查询交易编号</td>
                <td>
                    <asp:TextBox runat="server" ID='FuzzyOrderNo' Text='' Width="228px" />*必输</td>
            </tr>
            <tr>
                <td colspan="2" class="auto-style1">
                    <asp:Button ID="btnButton" runat="server" Text="提交页面内容" OnClick="btnButton_Click" />
                    <a href='Merchant.html'>回商户首页</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

