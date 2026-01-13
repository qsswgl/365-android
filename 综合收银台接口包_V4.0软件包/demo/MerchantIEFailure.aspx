<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        lblReturnCode.Text = Request["ReturnCode"];
        lblErrorMessage.Text = Request["ErrorMessage"];
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>农行网上支付平台-商户接口范例-页面支付请求提交失败结果</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            返回信息<br />
            <asp:Label ID="lblReturnCode" runat="server" Text="Label"></asp:Label>
            :
            <asp:Label ID="lblErrorMessage" runat="server" Text="Label"></asp:Label>
        </div>
    </form>
</body>
</html>
