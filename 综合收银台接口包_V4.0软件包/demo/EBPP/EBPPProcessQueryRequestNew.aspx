<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RequestMsg();
        }
    }
    private void RequestMsg()
    {
        string orderNo = "No" + DateTime.Now.Ticks.ToString();
        String tMSG = Request["MSG"];


        tMSG = "<MSG><Message><EBPPMessage><MessageType>QRequest</MessageType><EBPPData>PEJpbGxlcj48QmlsbGVyTm8+MTAzODgxMTA0NDEwMDAxPC9CaWxsZXJObz48L0JpbGxlcj48Q29uZGl0aW9ucz48UGF5ZXJWYWx1ZTE+YzE8L1BheWVyVmFsdWUxPjxQYXllclZhbHVlMj5jMjwvUGF5ZXJWYWx1ZTI+PFZlcmlmeURvbWFpbj48VmVyaWZ5TmFtZTE+eTE8L1ZlcmlmeU5hbWUxPjxWZXJpZnlOYW1lMj55MjwvVmVyaWZ5TmFtZTI+PC9WZXJpZnlEb21haW4+PC9Db25kaXRpb25zPg==</EBPPData></EBPPMessage></Message><Signature-Algorithm>SHA1withRSA</Signature-Algorithm><Signature>kalVXpZ3xBbYi5KmUm8hpWMVT6I9J7RU7BsFt2LyFKKcldOxKWVjytqdBP8P/UkNM9XX7m+uXAV5JP7aLdp5jL8SG9HIx4YCEt/sMsJiRn34YNPvt4jPXDyYg4+jBKpxx+o1AgXcJQOuVx5djq6xdqfMgWylHAy2nYHAfB65GJc=</Signature></MSG>";

        LogWriter tLogWriter = new LogWriter();
        tLogWriter.logNewLine("tMSG" + tMSG);
        tLogWriter.closeWriter();
        if (!string.IsNullOrEmpty(tMSG))
        {
            XMLDocument tResult = new XMLDocument(tMSG);
            //XMLDocument tResult = tResult.init(tMSG);
            if (tResult.getValueNoNull("MessageType").Equals(com.abc.trustpay.client.ebus.ebpp.IPaymentMerchant.MESSAGETYPE_QREQ))
            {
                //查询接收成功
                com.abc.trustpay.client.ebus.ebpp.PaymentMerchant tPaymentMerchant = new com.abc.trustpay.client.ebus.ebpp.PaymentMerchant();
                //验签并取得查询请求信息对象,次对象用来生产查询帐单结果
                com.abc.trustpay.client.ebus.ebpp.QueryRequestBean tQueryRequestBean = tPaymentMerchant.getQueryReqeustBean(tMSG);

                ///*此处为出账单位对查询请求信息对象进行处理,略*/
                //生成账单查询结果(第一条账单)
                com.abc.trustpay.client.ebus.ebpp.PaymentMerchantBean tPaymentMerchantBean = new com.abc.trustpay.client.ebus.ebpp.PaymentMerchantBean();
                //以下为PaymentMerchantBean对象所赋的值，实际中要从tQueryRequestBean取出
                tPaymentMerchantBean.setTAmount(100.00);					    //设定账单金额
                tPaymentMerchantBean.setTBillName("小额账单");					//设定账单名称
                tPaymentMerchantBean.setTBillNo(orderNo);					    //设定业务账单号
                tPaymentMerchantBean.setTCreateDate("2015-09-11");				//设定账单建立日期(YYYY-MM-DD);
                tPaymentMerchantBean.setTEffectDate("2016-01-01");				//设定账单生效日期
                tPaymentMerchantBean.setTExpiredDate("2016-12-31");				//设定账单截止日期

                ArrayList tValueList = new ArrayList();
                tValueList.Add("c1");								            //根据定义的账单类型，设定账单查询条件信息1
                //根据帐单类型定义，掌握是否添加下面信息
                tValueList.Add("c2");								            //根据定义的账单类型，设定账单查询条件信息2	
                tPaymentMerchantBean.setTPayerValueList(tValueList);			//设定账单查询条件信息

                tPaymentMerchantBean.setTRemark("此账单为测试");				//设定账单备注
                tPaymentMerchantBean.setTStatus("1");						    //设定账单支付状态（1: 未支付  2: 支付成功  3:支付失败）

                ArrayList tVerifyDomainList = new ArrayList();
                //根据帐单类型定义，掌握是否添加下面信息
                tVerifyDomainList.Add("y1");							        //根据定义的账单类型，设定账单验证信息1
                //tVerifyDomainList.Add("y2");							    //根据定义的账单类型，设定账单验证信息2

                tPaymentMerchantBean.setTVerifyDomainList(tVerifyDomainList);	//设定账单验证信息

                ArrayList tBillDetailList = new ArrayList();
                //根据帐单类型定义，掌握是否添加下面信息
                tBillDetailList.Add("测试明细");							    //根据定义的账单类型，设定账单明细信息1
                //tBillDetailList.Add("95599");							        //根据定义的账单类型，设定账单明细信息2

                tPaymentMerchantBean.setTBillDetailList(tBillDetailList);		//设定账单明细信息
                string tStr = "true";
                tPaymentMerchant.setResultValue(tStr);
                tPaymentMerchant.setBillDataNew(1, tPaymentMerchantBean);		//将账单信息加入报文;1代表取第一个商户

                //生成账单查询结果(第二条账单)
                tPaymentMerchantBean = new com.abc.trustpay.client.ebus.ebpp.PaymentMerchantBean();
                //以下为PaymentMerchantBean对象所赋的值，实际中要从tQueryRequestBean取出
                tPaymentMerchantBean.setTAmount(100.00);					    //设定账单金额
                tPaymentMerchantBean.setTBillName("小额账单");					//设定账单名称
                tPaymentMerchantBean.setTBillNo(orderNo);					    //设定业务账单号
                tPaymentMerchantBean.setTCreateDate("2015-09-11");				//设定账单建立日期(YYYY-MM-DD);
                tPaymentMerchantBean.setTEffectDate("2016-01-01");				//设定账单生效日期
                tPaymentMerchantBean.setTExpiredDate("2016-12-31");				//设定账单截止日期

                tValueList = new ArrayList();
                tValueList.Add("c1");								            //根据定义的账单类型，设定账单查询条件信息1
                //根据帐单类型定义，掌握是否添加下面信息
                tValueList.Add("c2");								            //根据定义的账单类型，设定账单查询条件信息2	
                tPaymentMerchantBean.setTPayerValueList(tValueList);			//设定账单查询条件信息

                tPaymentMerchantBean.setTRemark("此账单为测试");				//设定账单备注
                tPaymentMerchantBean.setTStatus("1");						    //设定账单支付状态（1: 未支付  2: 支付成功  3:支付失败）

                tVerifyDomainList = new ArrayList();
                //根据帐单类型定义，掌握是否添加下面信息
                tVerifyDomainList.Add("y1");							        //根据定义的账单类型，设定账单验证信息1
                //tVerifyDomainList.Add("y2");							    //根据定义的账单类型，设定账单验证信息2

                tPaymentMerchantBean.setTVerifyDomainList(tVerifyDomainList);	//设定账单验证信息

                tBillDetailList = new ArrayList();
                //根据帐单类型定义，掌握是否添加下面信息
                tBillDetailList.Add("测试明细");							    //根据定义的账单类型，设定账单明细信息1
                //tBillDetailList.Add("95599");							        //根据定义的账单类型，设定账单明细信息2

                tPaymentMerchantBean.setTBillDetailList(tBillDetailList);		//设定账单明细信息
                tStr = "true";                                                  //true表示有符合条件的账单，false表示没有符合条件的账单
                tPaymentMerchant.setResultValue(tStr);
                tPaymentMerchant.setBillDataNew(1, tPaymentMerchantBean);		//将账单信息加入报文;1代表取第一个商户               
                
                //返回签名后内容		  
                string tBase64Message = tPaymentMerchant.getBase64MerchantNew(1);	//1代表取第一个商户
                Response.Charset = "gb2312";
                Response.Write(tBase64Message);
                Response.Flush();
                //Response.Close();
            }
        }
    }
    
    
</script>