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
 *    abchina       2014/03/05  V3.0.0 Release
 *
 */
-->

<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void btnButton_Click(object sender, EventArgs e)
    {
        //1、生成定单订单对象，并将订单明细加入订单中
        com.abc.trustpay.client.ebus.SettleQuery settleQuery = new com.abc.trustpay.client.ebus.SettleQuery();

        settleQuery.dicRequest["DateOfClearance"] = txtDateOfClearance.Text;



        //5、传送支付请求并取得支付网址
        settleQuery.postJSONRequest();

        //多商户
        //tPaymentRequest.extendPostJSONRequest(1);
        StringBuilder strMessage = new StringBuilder();
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        string ResultCount = JSON.GetKeyValue("ResultCount");
        Dictionary<int, Hashtable> dic = JSON.GetArrayValue("ResultList");
        

        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");

            if (dic.Count == 0)
            {
                strMessage.Append("清算结果查询为空<br/>");
            }
            else
            {
                for (int key= 0; key < dic.Count; key++)
                {
                    strMessage.Append("MerchantNo   = [" + dic[key]["MerchantNo"].ToString() + "], ");
                    strMessage.Append("TimeOfClearance = [" + dic[key]["TimeOfClearance"].ToString() + "], ");
                    strMessage.Append("ClearanceBatchId = [" + dic[key]["ClearanceBatchId"].ToString() + "], ");
                    strMessage.Append("SumAmount  = [" + dic[key]["SumAmount"].ToString() + "], ");
                    strMessage.Append("ItemCount  = [" + dic[key]["ItemCount"].ToString() + "], ");
                    strMessage.Append("Status  = [" + dic[key]["Status"].ToString() + "]<br/>");
                }
            }
        }
        else
        {
            //7、支付请求提交失败，商户自定后续动作
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
        }

        lblMessage.Text = strMessage.ToString();
    }
</script>
<script language="javascript" type="text/javascript">





    function submitFun() {
        form1.submit();
    }


</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-清算结果查询接口</title>
</head>
<body style="font-size: 14px;">
    <center>
        清算结果查询接口</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
        <br />
        <table>
            <tr>
                <td>清算日期
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtDateOfClearance' Text='2022-08-19' />*必输(yyyy-mm-dd)</td>
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
