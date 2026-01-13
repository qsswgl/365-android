<%@ Page Language="C#" ValidateRequest="false" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                /*第一节：接收*/
                //接收
                string strRequestMsg = Request["MSG"];
                //base64解码
                string strRequest = Encoding.GetEncoding("gb2312").GetString(Convert.FromBase64String(strRequestMsg));
                //验签
                string strUnsignResult = com.abc.util.SignTools.UnSign(strRequest).ToString();


                /*第二节：返回*/
                if (strUnsignResult.ToLower() == "true")
                {
                    //取内容
                    string strTrxRequest = "<TrxResponse>" + GetValue(strRequest, "TrxRequest") + "</TrxResponse>";
                    //处理.....此处省略xxx字
                    //处理完毕，假设都成功了
                    string strReturnTrxRequest = strTrxRequest.Replace("</CBPOrderNo>", "</CBPOrderNo><Status>1</Status><PayBankNo>0309</PayBankNo>");
                    //签名
                    string strReturnSignature = com.abc.util.SignTools.Sign(strReturnTrxRequest);
                    //base64编码
                    string strReturnBase64 = Convert.ToBase64String(Encoding.GetEncoding("gb2312").GetBytes(strReturnSignature));
                    //返回
                    Response.Write(strReturnBase64);
                }
            }
        }
        catch
        {
        }
    }
    /// <summary>
    /// 从XML文档的字符串中取出某一节点的数据
    /// </summary>
    /// <param name="iXMLString">XML文档的字符串</param>
    /// <param name="aTag">节点名称</param>
    /// <returns>返回节点内容</returns>
    private string GetValue(string iXMLString, string aTag)
    {
        string tXMLDocument = null;
        int tStartIndex = iXMLString.IndexOf("<" + aTag.Trim() + ">");
        int tEndIndex = iXMLString.IndexOf("</" + aTag.Trim() + ">");
        if ((tStartIndex >= 0) && (tEndIndex >= 0) && (tStartIndex < tEndIndex))
        {
            tXMLDocument = iXMLString.Substring(tStartIndex + aTag.Length + 2, tEndIndex - (tStartIndex + aTag.Length + 2));
        }
        return tXMLDocument;
    }
 
</script>

