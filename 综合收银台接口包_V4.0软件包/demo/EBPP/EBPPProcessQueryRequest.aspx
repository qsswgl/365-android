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

        LogWriter iLogWriter = new LogWriter();
        iLogWriter.logNewLine("tMSG" + tMSG);
               
        
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
                //生成账单查询结果
                com.abc.trustpay.client.ebus.ebpp.PaymentMerchantBean tPaymentMerchantBean = new com.abc.trustpay.client.ebus.ebpp.PaymentMerchantBean();
                //以下为PaymentMerchantBean对象所赋的值，实际中要从tQueryRequestBean取出
                tPaymentMerchantBean.setTAmount(100.00);					//设定账单金额
                tPaymentMerchantBean.setTBillName("小额账单");					//设定账单名称
                tPaymentMerchantBean.setTBillNo(orderNo);					//设定业务账单号
                tPaymentMerchantBean.setTCreateDate("2006-09-11");				//设定账单建立日期(YYY-MM-DD);
                tPaymentMerchantBean.setTEffectDate("2006-01-01");				//设定账单生效日期
                tPaymentMerchantBean.setTExpiredDate("2006-12-31");				//设定账单截止日期

                ArrayList tValueList = new ArrayList();
                tValueList.Add("c1");								//根据定义的账单类型，设定账单查询条件信息1
                //根据帐单类型定义，掌握是否添加下面信息
                tValueList.Add("c2");								//根据定义的账单类型，设定账单查询条件信息2	
                tPaymentMerchantBean.setTPayerValueList(tValueList);				//设定账单查询条件信息

                tPaymentMerchantBean.setTRemark("此账单为测试");				//设定账单备注
                tPaymentMerchantBean.setTStatus("1");						//设定账单支付状态（1: 未支付  2: 支付成功  3:支付失败）

                ArrayList tVerifyDomainList = new ArrayList();
                //根据帐单类型定义，掌握是否添加下面信息
                tVerifyDomainList.Add("y1");							//根据定义的账单类型，设定账单验证信息1
                //tVerifyDomainList.Add("888888");							//根据定义的账单类型，设定账单验证信息2
                //tVerifyDomainList.Add("657566");
                //tVerifyDomainList.Add("45656");
                //tVerifyDomainList.Add("57768");
                tPaymentMerchantBean.setTVerifyDomainList(tVerifyDomainList);				//设定账单验证信息

                ArrayList tBillDetailList = new ArrayList();
                //根据帐单类型定义，掌握是否添加下面信息
                tBillDetailList.Add("张大毛");							//根据定义的账单类型，设定账单明细信息1
                //tBillDetailList.Add("95599");							//根据定义的账单类型，设定账单明细信息2
                //tBillDetailList.Add("测试明细");							//根据定义的账单类型，设定账单明细信息3
                //tBillDetailList.Add("234");
                //tBillDetailList.Add("5656");
                tPaymentMerchantBean.setTBillDetailList(tBillDetailList);				//设定账单明细信息

                tPaymentMerchant.setBillData(tPaymentMerchantBean);				//将账单信息加入报文

                string tStr = "true";
                tPaymentMerchant.setResultValue(tStr);
                //返回签名后内容		  
                string tBase64Message = tPaymentMerchant.getBase64Merchant(1);			//true表示有符合条件的账单，false表示没有符合条件的账单

                iLogWriter.logNewLine("tMSG" + tMSG);
                Response.Charset = "gb2312";
                Response.Write(tBase64Message);
                Response.Flush();
                //Response.Close();
            }
        }
    }
    
    
</script>