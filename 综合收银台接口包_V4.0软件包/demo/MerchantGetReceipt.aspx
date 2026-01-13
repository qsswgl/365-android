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
 *    abchina       2018/08/20  Create V3.0.0 
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

        //1、生成商户回单请求对象
        com.abc.trustpay.client.ebus.GetReceiptRequest tRequest = new com.abc.trustpay.client.ebus.GetReceiptRequest();
        tRequest.receiptRequest["SubMerchantNo"] = subMerchantNo.Text.Trim();    //设定交易类型（必要信息）
        string order = txtOrderNo.Text.Trim();
        tRequest.receiptRequest["OrderNo"] = order;  //交易编号           （必要信息）
        

        //2、传送商户交易查询请求并取得交易查询结果
        tRequest.postJSONRequest();

        //3、判断商户交易查询结果状态，进行后续操作
        StringBuilder strMessage = new StringBuilder("");
        string ReturnCode = JSON.GetKeyValue("ReturnCode");
        string ErrorMessage = JSON.GetKeyValue("ErrorMessage");
        if (ReturnCode.Equals("0000"))
        {
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            //4、获取结果信息
            string rawStr = JSON.GetKeyValue("ImageCode");
            Byte[] imageBytes = tRequest.DecompressFromBase64String(rawStr);
       
            HttpResponse response = null;
            try
            {
                response = HttpContext.Current.Response;
                response.Clear();
                response.ContentType = "application/x-bmp";
                response.AppendHeader("content-disposition", "attachment;filename=" + order + ".bmp");

                response.BinaryWrite(imageBytes);
                response.Flush();
                
            }
            catch (System.Exception exc)
            {
                ErrorMessage = exc.Message;
                strMessage.Append("Download receipt err, ErrorMessage = [" + ErrorMessage + "]<br/>");
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = strMessage.ToString();
            }
            finally
            {

                if (null != response)
                {
                    response.Close();
                }
            }
            
               
               
             
        }
        else
        {
            //6、请求回单失败
            strMessage.Append("ReturnCode   = [" + ReturnCode + "]<br/>");
            strMessage.Append("ErrorMessage = [" + ErrorMessage + "]<br/>");
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = strMessage.ToString();
        }
       // lblMessage.Text = strMessage.ToString();
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>农行网上支付平台-商户接口范例-电子回单下载</title>
</head>
<body style="font-size: 14px;">
    <center>电子回单下载</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级商户号</td>
                <td><asp:TextBox runat="server" ID='subMerchantNo' Text='' />*必输</td>
            </tr>
            <tr>
                <td>订单号</td>
                <td>
                    <asp:TextBox runat="server" ID='txtOrderNo' Text='' />*必输</td>
            </tr>
            
            <tr>
                <td colspan="2">
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="btnButton" runat="server" Text="下载电子回单" OnClick="btnButton_Click" />
                            <a href='Merchant.html'>回商户首页</a>
                        </td>
                    </tr>
        </table>
    </form>
</body>
</html>
