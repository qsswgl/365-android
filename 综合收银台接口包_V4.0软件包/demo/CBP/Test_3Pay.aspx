<%@ Page Language="C#" validateRequest="false" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script language="javascript">
    function btnNotifyForXingneng_Click(form)
    {	
	document.form3.MSG.value=document.form1.txtSignature.value;
	document.form3.NOTIFYURL.value=document.form1.txtNotifyUrl.value;
        form.submit();
	return true;
    }
</script>
<script runat="server">

    string _ResponseString = "";
    protected void btnNotify_Click(object sender, EventArgs e)
    {
        form1.Visible = false;
        _ResponseString = "<form name=\"form2\" method=\"post\" action=\"" + txtNotifyUrl.Text + "\"> \r\n" +
                            "<input type=\"hidden\" name=\"MSG\" value=\"" + txtSignature.Text + "\"> \r\n" +
                            "<input type=\"submit\" value=\"提交\"></form><br/> \r\n" +
                            "<a href='../Merchant.html'>回商户首页</a> \r\n";
       
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                //
                lblRequestMsg.Text = Request["MSG"];
                string strRequest = Encoding.GetEncoding("gb2312").GetString(Convert.FromBase64String(lblRequestMsg.Text));
                lblRequestSource.Text = HttpUtility.HtmlEncode(strRequest);//显示使用
                lblUnsignResult.Text = com.abc.util.SignTools.UnSign(strRequest).ToString();

                //init sign
                com.abc.trustpay.client.XMLDocument xmlDoc = new com.abc.trustpay.client.XMLDocument(strRequest);
                txtNotifyUrl.Text = xmlDoc.getValue("ResultURL").ToString();
                txtSource.Text = @"<TrxRequest>" +
                                        "<MerchantID>" + com.abc.trustpay.client.MerchantConfig.MerchantID(1) + "</MerchantID>" +
                                        "<CBPOrderNo>" + xmlDoc.getValue("CBPOrderNo") + "</CBPOrderNo>" +
                                        "<Status>1</Status>" +
                                        "<PayDate>" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "</PayDate>" +
                                        "<PayBankNo>0309</PayBankNo>" +
                                    "</TrxRequest>";
                //加工
                txtSignature.Text = com.abc.util.SignTools.Sign(txtSource.Text);
                txtSignature.Text = Convert.ToBase64String(Encoding.GetEncoding("gb2312").GetBytes(txtSignature.Text));
            }
        }
        catch
        {
        }
    }

    protected void btnBuild_Click(object sender, EventArgs e)
    {
        //手动加工
        txtSignature.Text = com.abc.util.SignTools.Sign(txtSource.Text);
        txtSignature.Text = Convert.ToBase64String(Encoding.GetEncoding("gb2312").GetBytes(txtSignature.Text));
    }

    protected void btnNotifyNoPage_Click(object sender, EventArgs e)
    {
        
        string strResult = SendHttpMsg(txtNotifyUrl.Text, "MSG=" + HttpUtility.UrlEncode(txtSignature.Text));
        if (strResult.IndexOf("<!--<NotifyStatus>TRUE</NotifyStatus>-->") > 0)
        {
            //good 
            lblMessage.Text = "通知成功";
        }
        else
        {
            lblMessage.Text = "通知失败";
        }
    }
    #region send msg no page
    /// <summary>
    /// 发送http请求，并得到返回结果
    /// </summary>
    /// <param name="url">地址</param>
    /// <param name="msg">发送报文</param>
    /// <returns>返回报文</returns>
    private string SendHttpMsg(string url, string msg)
    {
        byte[] source = System.Text.Encoding.UTF8.GetBytes(msg);

        HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(url);
        httpRequest.CookieContainer = new CookieContainer();
        httpRequest.Method = "POST";
        httpRequest.ProtocolVersion = HttpVersion.Version10;
        httpRequest.ContentType = "application/x-www-form-urlencoded";
        httpRequest.Timeout = -1;
        httpRequest.ContentLength = source.Length;
        //httpWebRequest.Proxy = System.Net.WebRequest.GetSystemWebProxy(); 
        BufferedStream requestStream = new BufferedStream(httpRequest.GetRequestStream());
        requestStream.Write(source, 0, source.Length);
        requestStream.Flush();
        requestStream.Close();

        HttpWebResponse webResponse = (HttpWebResponse)httpRequest.GetResponse();
        Stream receiveStream = webResponse.GetResponseStream();
        StreamReader reader = new StreamReader(receiveStream, System.Text.Encoding.GetEncoding("gb2312"));

        string message = reader.ReadToEnd();
        webResponse.Close();

        return message;
    }
    #endregion
 
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>第三方支付页面</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table width="90%" border="0" cellpadding="0" cellspacing="0" style="font-size: 14px;
                border: solid 1px #cccccc;">
                <tr>
                    <td>
                        <b>第一段：选择银行进行支付</b></td>
                </tr>
                <tr>
                    <td>
                        得到请求报文：<br />
                        <asp:Label ID="lblRequestMsg" runat="server" Text="Label"></asp:Label>
                        <br />
                        解开之后的报文：<br />
                        <asp:Label ID="lblRequestSource" runat="server" Text="Label"></asp:Label>
                        <br />
                        验签结果：
                        <asp:Label ID="lblUnsignResult" runat="server" Text="Label"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="radio" name="rdtest" checked="checked" />银行1<br />
                        <input type="radio" name="rdtest" />银行2<br />
                        <input type="radio" name="rdtest" />银行3<br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="支付" onclick="alert('经过你输入卡号、密码，最终支付成功！');" />
                    </td>
                </tr>
            </table>
            <br />
            <table width="90%" border="0" cellpadding="0" cellspacing="0" style="font-size: 14px;
                border: solid 1px #cccccc;">
                <tr>
                    <td>
                        <b>第二段：支付成功了，通知农行</b></td>
                </tr>
                <tr>
                    <td>
                        通知地址：<asp:TextBox ID="txtNotifyUrl" Width="800px" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        原始通知报文：<br />
                        <asp:TextBox ID="txtSource" runat="server" TextMode="MultiLine" Width="800px" Rows="8" />
                        <br />
                        <asp:Button ID="btnBuild" runat="server" Text="手动加工" OnClick="btnBuild_Click" />加工后报文：<br />
                        <asp:TextBox ID="txtSignature" runat="server" TextMode="MultiLine" Width="800px"
                            Rows="8" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnNotifyNoPage" runat="server" Text="无页面通知" OnClick="btnNotifyNoPage_Click" />
			<asp:Button ID="btnNotify" runat="server" Text=" 通 知 " OnClick="btnNotify_Click" />
                        <br />
                        <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="red"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </form>
    <%=_ResponseString %>
    <form name="form3" action="Test_3PayNotify.aspx" method="post">
		<input id= "MSG" type="hidden" name="MSG" value=""/>
		<input id= "NOTIFYURL" type="hidden" name="NOTIFYURL" value=""/>
		<button id="Button1" type="button" onclick="return btnNotifyForXingneng_Click(form3);">页面通知(性能测试点击此按钮)</button>
    </form>
</body>
</html>
