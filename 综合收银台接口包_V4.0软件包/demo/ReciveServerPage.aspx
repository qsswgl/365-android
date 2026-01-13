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
 *    abc       2014/05/13      V3.0.0
 *
 */
-->

<%@ Page Language="C#" Debug="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    private string tMerchantPage = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //1、取得MSG参数，并利用此参数值生成支付结果对象
        com.abc.trustpay.client.ebus.PaymentResult tResult = new com.abc.trustpay.client.ebus.PaymentResult();
        tResult.init(Request["MSG"]);

        //2、判断支付结果状态，进行后续操作
        if (tResult.isSuccess())
        {
            //3、支付成功
            //tMerchantPage = "http://172.30.7.117/demo/CustomerPage.aspx?请传入必要的参数"  如下：
            tMerchantPage = "http://172.30.7.117/demo/CustomerPage.aspx?OrderNo=" + tResult.getValue("OrderNo");
        }
        else
        {
            //4、支付失败
            //tMerchantPage = "http://172.30.7.117/demo/MerchantFailure.aspx?请传入必要的参数" 如下：
            tMerchantPage = "http://172.30.7.117/demo/MerchantFailure.aspx?OrderNo=" + tResult.getValue("OrderNo");
        }
    }
</script>

<!--
<URL><%= tMerchantPage %></URL>
-->
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <meta http-equiv="refresh" content="0; url='<%= tMerchantPage %>'">
</head>
</html>

