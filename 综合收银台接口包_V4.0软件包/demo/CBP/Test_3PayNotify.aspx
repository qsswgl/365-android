<%@ Page Language="C#" ValidateRequest="false" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
   string url;
   string msg;
   protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
		url=Request["NOTIFYURL"];
		msg = Request["MSG"];
            }
        }
        catch
        {
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>第三方支付页面</title>
</head>
<body>

    <form name="form2" action=<%=url%> method="post">
                            <input type="hidden" name="MSG" value="<%=msg%>"/>
                            <input type="submit" value="提交"/>
    </form>
</body>
</html>
