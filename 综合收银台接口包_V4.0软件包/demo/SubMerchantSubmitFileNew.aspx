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

<!DOCTYPE html>
<script runat="server">

    protected void btnButton_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        lblMessage.ForeColor = System.Drawing.Color.Red;

        //1、生成商户交易查询请求对象
        com.abc.trustpay.client.ebus.SubMerchantSubFileNew tRequest = new com.abc.trustpay.client.ebus.SubMerchantSubFileNew();
        tRequest.dicRequest["SubMerNo"] = txtSubMerId.Text;    //设定交易类型（必要信息）
        
        //string name = fileName.Text;    //设定交易类型（必要信息）
        //string filestring = tRequest.ZipFileToBase64String(name);
        tRequest.dicRequest["SubMerCertFile"] = SubMerCertFile.Text;
        tRequest.dicRequest["Flag"] = flag.Text;
        tRequest.dicRequest["DeviceId"] = deviceId.Text;

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
            strMessage.Append("仍需上传 = [" + JSON.GetKeyValue("FlagLeft") + "]<br/>");
 
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
<meta http-equiv ="X-UA-Compatible" content ="IE=edge;charset=utf-8"/>
    <title>农行网上支付平台-商户接口范例-二级商户上传资料</title>
</head>
    <script>
        // 上传csv格式的文件
        function uploadfile() {
            var reads = new FileReader();
            file = document.getElementById('file').files[0];
            reads.readAsDataURL(file);
            console.log(reads);
            reads.onload = function (e) {
                console.log(e)
                // document.getElementById('result').innerText = this.result
                document.getElementsByName('SubMerCertFile')[0].value = e.target.result.substring(e.target.result.indexOf(',') + 1)
            };
            reads.onloadstart = function (e) {
                console.log('onloadstart ---> ', e)
            }
            reads.onloadend = function (e) {
                console.log('onloadend ---> ', e)
            }
            reads.onprogress = function (e) {
                console.log('onprogress ---> ', e)
            }
        }
    </script>
<body style="font-size: 14px;">
    <center>
        二级商户上传资料</center>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        <br />
        <table>
            <tr>
                <td>二级商户名称
                </td>
                <td>
                    <asp:TextBox runat="server" ID='txtSubMerId' Text='tj0816' /> *必输 </td>
            </tr>
            <tr>
                <td>文件路径+文件名
                </td>
                <td>
                      <input type="file" id="file" accept=".zip" onchange="uploadfile();" />
                   <%-- <asp:TextBox runat="server" ID='fileName' Text='D:\bigzip.zip' /> --%>*必输(zip包大小必须低于1.5M) </td>
            </tr>
            <tr>
                <td>标志位
                </td>
                <td>
                    <asp:TextBox runat="server" ID='flag' Text='1' /> *必输 </td>
                <td><asp:TextBox runat="server" ID='SubMerCertFile' value='' style="display:none"/></td>
                   
                  
            </tr>
            <tr>
                <td>终端编号
                </td>
                <td>
                    <asp:TextBox runat="server" ID='deviceId' Text='' /> 上传终端信息相关材料时必输 </td>
            </tr>
            <tr>
                <td colspan="2">
                    1：个体工商户/企业营业执照照片 2：政府机关/事业单位/社会组织登记证书照片 3：辅助证明材料 </td>
            </tr>
            <tr>
                <td colspan="2"> 4：法定代表人/经营者身份证人像面照片 5：法定代表人/经营者身份证国徽面照片 6：法定代表人/经营者护照、通行证照片</td>
            </tr>
            <tr>
                <td colspan="2">  7：法定代表人授权函 8：特殊资质证照影印件  9：非同名银行结算账户证明材料 10：其他证明材料</td>
            </tr>
            <tr>
                <td colspan="2">  11：定位功能证明材料 12：固定经营场所证明材料 13：合法合规用途证明材料</td>
            </tr>
            <tr>
                <td colspan="2">  业务规则：</td>
            </tr>
            <tr>
                <td colspan="2">  （1）、二级商户类型为1个人商户时，如果法人/经营者证件类型为居民身份证的，标志位上送3、4和5；如果法人/经营者证件类型为非居民身份证的，标志位上送3和6。</td>
            </tr>
            <tr>
                <td colspan="2">  （2）、二级商户类型为2企业商户和3个体工商户时，如果法人/经营者证件类型为居民身份证的，标志位上送1、4和5；如果法人/经营者证件类型为非居民身份证的，标志位上送1和6。</td>
            </tr>
            <tr>
                <td colspan="2">  （3）、二级商户类型为4：政府机关/事业单位/社会组织时，如果法人/经营者证件类型为居民身份证的，标志位上送2、4和5；如果法人/经营者证件类型为非居民身份证的，标志位上送2和6。</td>
            </tr>
            <tr>
                <td colspan="2">  （4）、法人/经营者是否为实际办理业务人员为0时，标志位上送7。</td>
            </tr>
            <tr>
                <td colspan="2">  （5）、二级商户终端定位功能为是时，标志位上送11；二级商户终端定位功能为否时，标志位上送12和13</td>
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
