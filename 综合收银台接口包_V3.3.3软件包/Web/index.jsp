<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>农行线上支付平台-商户接口范例-导航页</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <link rel="stylesheet" type="text/css" href="../css/semantic.css">
    <script src="../js/jquery.min.js"></script>
    <script src="../js/semantic.js"></script>
</head>
<body>
<div class="main ui container" id="context" style="position:relative; padding:100px 0px 100px 0px">
    <div class="ui right rail">
        <div class="ui sticky" style="padding-top: 100px">
            <h4 class="ui header">导航栏</h4>
            <div class="ui vertical following fluid accordion text menu">
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>微信、支付宝、农行/一码多扫支付</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-weixin-order-request">微信下单</a>
                        <a class="item" href="#-ali-pay-request">支付宝下单</a>
                        <a class="item" href="#-one-qr-for-merchantpayment-request">下单</a>
                        <a class="item" href="#-merchant-payment-ie-request">支付请求</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>退款、查询</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-merchant-refund-request">退款</a>
                        <a class="item" href="#-merchant-query-request">查询</a>
                        <a class="item" href="#-merchant-paycancel-request">订单撤销</a>
                        <a class="item" href="#-get-weixin-auth-info-request">获取调用凭证</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>农行掌银付款码支付</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-abcqr-pay-request">掌银被扫刷卡支付下单</a>
                    </div>
                </div>
                <%--<div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>统一协议支付</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#unified-sign-apply-request">统一协议支付签约申请</a>
                        <a class="item" href="#unified-sign-confirm-request">统一协议支付签约确认</a>
                        <a class="item" href="#unified-sign-terminate-request">统一协议支付签约解约</a>
                        <a class="item" href="#unified-sign-pay-request">统一协议支付</a>
                        <a class="item" href="#unified-sign-cancel-request">统一协议支付订单撤销</a>
                    </div>
                </div>--%>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>农行授权支付</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-authorized-agentsigncontract-request">银行侧签约-申请</a>
                        <a class="item" href="#-authorized-quickagentsigncontract-request">商户侧签约-申请</a>
                        <a class="item" href="#-authorized-quickagentsignconfirm-request">商户侧签约-确认</a>
                        <a class="item" href="#-authorized-quickagentsignresendreq-request">商户侧签约-验证码重发</a>
                        <a class="item" href="#-authorized-agentunsigncontract-request">解约</a>
                        <a class="item" href="#-authorized-agentsigncontractquery-request">签约/解约查询</a>
                        <a class="item" href="#-authorized-agentpayment-request">单笔扣款</a>
                        <a class="item" href="#-authorized-agentbatchpayment-request">批量扣款</a>
                        <a class="item" href="#-authorized-agentbatchpaymentquery-request">批量扣款结果查询</a>
                        <a class="item" href="#-authorized-merchantbatchrefund-request">批量退款</a>
                        <a class="item" href="#-authorized-merchantbatchrefundquery-request">批量退款结果查询</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>代收</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-entrust-sign-request">签约申请</a>
                        <a class="item" href="#-entrust-sign-resendSMS-request">验证码重发</a>
                        <a class="item" href="#-entrust-sign-confirm-request">签约确认</a>
                        <a class="item" href="#-entrust-sign-query-request">签约查询</a>
                        <a class="item" href="#-entrust-unsign-request">解约</a>
                        <a class="item" href="#-entrust-payment-request">代收支付单笔扣款</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>农行K码支付</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-k-code-merchantquickpaymentreq-request">账单发送</a>
                        <a class="item" href="#-k-code-merchantquickpaymentsend-request">支付请求</a>
                        <a class="item" href="#-k-code-merchantquickpaymentresend-request">验证码重发</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>对账单下载</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-settlement-merchanttrxsettlequery-download">农行支付交易对账单下载</a>
                        <a class="item" href="#-settlement-posthirdfiledownloadrequest-download">农行POS交易对账单下载</a>
                        <a class="item" href="#-settlement-merchanttrxsettlealiwx-download">微信支付宝对账单下载</a>
                        <a class="item" href="#-settlement-merchanttrxsettletransfer-download">内转出金对账单下载</a>
                        <a class="item" href="#-settlement-merchanttrxsettleplatform-download">平台商户交易对账单下载</a>
                        <a class="item" href="#-settlement-merchanttrxsettlealiwxdzh-download">垫资户模式微信支付宝对账单下载</a>
                        <a class="item" href="#-settlement-merchanttrxsettle-download">大文件对账单下载</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>二级商户资金分账</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-split-merchant-fund-deposit-request">支出类二级账簿充值</a>
                        <a class="item" href="#-split-merchant-fund-merchantinnerpayment-request">二级商户内转交易</a>
                        <a class="item" href="#-split-merchant-fund-merchantoutpayment-request">二级商户出金交易</a>
                        <a class="item" href="#-split-merchant-fund-transferoutquery-request">出金交易查询</a>
                        <a class="item" href="#-split-merchant-fund-guanteepaysendmqorder-request">平台商户担保确认</a>
                        <a class="item" href="#-split-merchant-fund-queryplatformconfirm-request">平台商户担保确认查询</a>
                        <a class="item" href="#-split-merchant-fund-checksubmeraccdetail-request">二级商户账簿明细查询[不再使用]</a>
                        <a class="item" href="#-split-merchant-fund-checksubmeraccdetailnew-request">二级商户账簿明细分页查询</a>
                        <a class="item" href="#-split-merchant-fund-subaccquery-request"> 二级商户账簿余额查询</a>
                        <a class="item" href="#-split-merchant-fund-merchantgetreceipt-request">出金交易电子回单下载</a>
                        <a class="item" href="#-split-merchant-fund-query-request">内转交易查询</a>
                        <a class="item" href="#-split-merchant-fund-checkguarantedfundaccdetail-request">保证金账户明细查询</a>
                        <a class="item" href="#-split-merchant-fund-schooltransferout-request">校培监管资金划拨申请交易</a>
                        <a class="item" href="#-split-merchant-fund-schooltransferoutquery-request">校培监管资金划拨结果查询交易</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>二级商户营销补贴</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-subsidy-subsidytransfer-request">营销补贴资金发放</a>
                        <a class="item" href="#-subsidy-subsidyrefund-request">营销补贴资金回退</a>
                        <a class="item" href="#-subsidy-querysubsidy-request">营销补贴资金查询</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>二级商户管理</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-merchant-config-regsubmerinfo">二级商户信息同步申请</a>
                        <a class="item" href="#-merchant-config-regsubmerinfoNew">二级商户信息同步申请（新）</a>
                        <a class="item" href="#-merchant-config-sendmobilemessageforsubmer">二级商户信息同步申请短信验证码重发</a>
                        <a class="item" href="#-merchant-config-verifymessagecodeandrandomamount">二级商户信息同步确认</a>
                        <a class="item" href="#-merchant-config-updatesubmerchantstatus">二级商户状态变更</a>
                        <a class="item" href="#-merchant-config-qrysubmerchantinfo">二级商户信息查询</a>
                        <%--                        <a class="item" href="#-merchant-config-regsubmerchantinfo">二级商户信息同步</a>--%>
                        <a class="item" href="#-merchant-config-uploadsubmercertrequest">二级商户证照资料上传</a>
                        <a class="item" href="#-merchant-config-uploadsubmercertrequestNew">二级商户证照资料上传（新）</a>
                        <a class="item" href="#-merchant-config-qrysubmerreviewstatusrequest">二级商户申请单申请状态查询</a>
                        <a class="item" href="#-merchant-config-batchregsubmerinfo">批量二级商户同步</a>
                        <a class="item" href="#-merchant-config-migratesubmerchantinfo">二级商户迁移接口</a>
                        <a class="item" href="#-merchant-config-migratesubmertoothersubject">不同主体二级商户迁移</a>
                        <a class="item" href="#-merchant-config-regsubmerendinfo">二级商户终端同步</a>
                        <a class="item" href="#-merchant-config-appendsubmerchantinfo">二级商户迁移补录</a>
                        <a class="item" href="#-merchant-config-cancelregsubmerapply">二级商户同步申请撤销</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>订单信息同步</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-syncoffineorder-batchregister-request">第三方订单信息同步</a>
                        <a class="item" href="#-syncoffineorder-thirdconfirmtranslog-request">第三方订单信息确认（含附言）</a>
                        <%--                        <a class="item" href="#-syncoffineorder-thirdconfirmsendmq-request">第三方订单信息确认[不再使用]</a>--%>
                        <a class="item" href="#-syncoffineorder-queryrealtimeregister-request">第三方订单信息确认结果查询</a>
                        <a class="item" href="#-syncoffineorder-fileregister-request">第三方订单信息批量上传</a>
                        <a class="item" href="#-syncoffineorder-queryfileregister-request">第三方订单信息批量上传结果查询</a>
                        <a class="item" href="#-syncoffineorder-registerposorder-request">农行POS订单信息同步</a>
                        <a class="item" href="#-syncoffineorder-querysubmertdaysettle-request">农行POS渠道可清算金额查询</a>
                        <a class="item" href="#-syncoffineorder-overdueconfirm-request">超期担保确认</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>查询</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-query-merchantqueryorder-request">单笔统一查询</a>
                        <a class="item" href="#-query-merchantquerytrnxrecords-request">银行交易流水明细查询</a>
                        <a class="item" href="#-query-submertransdetail-request">二级商户交易明细查询</a>
                        <a class="item" href="#-query-queryclearanceresult-request">清算结果查询</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>身份认证</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-identity-verify-request">身份认证-页面认证</a>
                        <a class="item" href="#-identity-verify-static-request">身份认证-接口认证</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>客户账簿支付</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-transfer-platsubcustompay-request">客户账簿支付</a>
                        <a class="item" href="#-transfer-platsubcustomrefund-request">退款</a>
                        <a class="item" href="#-transfer-qrysubcustomreviewstatus-request">客户申请状态查询</a>
                        <a class="item" href="#-transfer-proxyregsubcustomerinfo-request">客户信息同步</a>
                        <a class="item" href="#-transfer-querycustomaccdetail-request">二级客户账簿明细查询</a>
                        <a class="item" href="#-transfer-querycustominfo-request">客户信息查询接口</a>
                        <a class="item" href="#-transfer-querycustomtransdetail-request">二级客户交易明细查询</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="left text" style="width: 85%">
        <div id="-weixin-ali-request" style="padding-bottom: 40px">
            <h3 class="ui large header">
                微信、支付宝、农行/一码多扫支付
            </h3>
            <div class="ui section divider"></div>
            <div class="ui section">商户通过对接下述接口可以在支付场景中调起微信支付宝农行/一码多扫支付模块完成收款。微信支付支持JSAPI支付、小程序支付、付款码支付、APP支付，APP
                支付当前仅支持政府、事业单位、公立医院和学校四类特殊商户，如非该四类商户无法使用微信APP支付。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Order/WeiXinOrderRequest.html"><i class="play icon"></i></a>
                <div class="content" id="-weixin-order-request">微信下单</div>
                <div style="display: inline-block; margin: 0 0 4px 20px"><a
                        class="ui label red tag">点击播放图标可跳转对应DEMO
                    页面</a></div>
            </h3>
            <div class="ui segment">支持JSAPI支付、小程序支付、付款码支付、APP支付</div>
            <h3 class="ui header">
                <a target="_blank" href="Order/AlipayRequest.html"><i class="play icon"></i></a>
                <div class="content" id="-ali-pay-request">支付宝下单</div>
            </h3>
            <div class="ui segment">支持支付宝订单创建、订单预生成、付款码支付、移动页面wap支付、电脑页面PC支付、APP支付</div>
            <h3 class="ui header">
                <a target="_blank" href="Order/MerchantPayment.html"><i class="play icon"></i></a>
                <div class="content" id="-one-qr-for-merchantpayment-request">下单</div>
            </h3>
            <div class="ui segment">
                1、农行支付下单交易，下单后返回PaymentURL，跳转该URL可完成支付。在使用农行支付时，且未上送指定商户收款账户账号ReceiveAccount，默认收款账户为综管商户配置的主账户，如商户未将主账户配置为商户收款账户会导致支付失败“取商户账户信息失败，无记录”
                2、农行一码多扫URL生成交易，下单后返回OneQRForAll，将该链接生成二维码，即可支持微信、支付宝、掌银APP扫码支付。如需使用农行一码多扫，请先前往微信商户管理平台配置对应的APPID和授权支付目录，否则使用微信支付时将会失败“sub_mch_id与sub_appid不匹配”，具体APPID和授权支付目录参数可咨询业务工作人员，参考微信文档https://kf.qq.com/faq/190715yaYnYv1907153mmIbA.html?pass_ticket=mx%2Fz5fll0KxtnS8GJ%2BKMz1mnDQW5H%2Fr8955UA30fiwIxhpdcWOa8g1is2eWgMTLe
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Order/ScanPayOrderReq.html"><i class="play icon"></i></a>
                <div class="content" id="-scan-pay-order-request">线下扫码下单</div>
            </h3>
            <div class="ui segment">
                线下扫码支付下单
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Order/OLScanPayOrderReq.html"><i class="play icon"></i></a>
                <div class="content" id="-Online-Scan-pay-order-request">线上扫码下单</div>
            </h3>
            <div class="ui segment">
                线上扫码支付下单
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Order/MerchantPaymentIE.html"><i class="play icon"></i></a>
                <div class="content" id="-merchant-payment-ie-request">支付请求</div>
            </h3>
            <div class="ui segment">页面接入的方式进行跨行支付。</div>
        </div>
        <div id="-one-qr-for-all-request" style="padding-bottom: 40px">
            <h3 class="ui large header">退款、查询</h3>
            <div class="ui section divider"></div>
            <div class="ui section">商户通过对接下述接口可以在支付场景中调起退款、查询。</div>
            <h3 class="ui header">
                <a target="_blank" href="Refund/MerchantRefund.html"><i class="play icon"></i></a>
                <div class="content" id="-merchant-refund-request">退款</div>
            </h3>
            <div class="ui segment">支付成功后，可用来发起退款</div>
            <h3 class="ui header">
                <a target="_blank" href="Query/MerchantQueryOrder.html"><i class="play icon"></i></a>
                <div class="content" id="-merchant-query-request">查询</div>
            </h3>
            <div class="ui segment">用于查询支付和退款的交易状态或者交易详情</div>
            <h3 class="ui header">
                <a target="_blank" href="Order/MerchantPayCancel.html"><i class="play icon"></i></a>
                <div class="content" id="-merchant-paycancel-request">订单撤销</div>
            </h3>
            <div class="ui segment">对于七天以内的刷卡支付交易，如支付交易返回失败、支付系统交易超时，可调用该接口撤销交易。已支付成功订单，不允许撤销，若客户已支付成功，请调用退款接口。</div>
            <h3 class="ui header">
                <a target="_blank" href="Order/GetWeiXinAuthInfo.html"><i class="play icon"></i></a>
                <div class="content" id="-get-weixin-auth-info-request">获取调用凭证</div>
            </h3>
            <div class="ui segment">用于刷脸付根据微信接口获取auth_info信息。</div>
        </div>
        <div id="-abcqr-pay" style="padding-bottom: 40px">
            <h3 class="ui large header">农行掌银付款码支付</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起农行掌银付款码支付模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="Order/ABCQRPayRequest.html"><i class="play icon"></i></a>
                <div class="content" id="-abcqr-pay-request">掌银被扫刷卡支付下单</div>
            </h3>
            <div class="ui segment">
                当消费者给商户展示其农行掌银的付款二维码后，商户获取消费者付款码信息并将该付款码及其他订单信息提交请求给网上支付平台，接着将消费者的浏览器导到农行网上支付平台的支付页面。消费者在网上支付平台上进行在线支付的操作，支付成功后，网上支付平台会将支付结果通知给商户。
            </div>
        </div>
        <%-- <div id="-unified-sign-pay" style="padding-bottom: 40px">
             <h3 class="ui large header">统一协议支付</h3>
             <div class="ui section divider"></div>
             <div class="ui segment">商户通过对接下述接口可以调起统一协议支付模块。</div>
             <h3 class="ui header">
                 <a target="_blank" href="UnifiedSign/UnifiedSign.html"><i class="play icon"></i></a>
                 <div class="content" id="unified-sign-apply-request">统一协议支付签约申请</div>
             </h3>
             <div class="ui segment">
                 统一协议支付签约申请。
             </div>
             <h3 class="ui header">
                 <a target="_blank" href="UnifiedSign/UnifiedSign.html"><i class="play icon"></i></a>
                 <div class="content" id="unified-sign-confirm-request">统一协议支付签约确认</div>
             </h3>
             <div class="ui segment">
                 统一协议支付签约确认。
             </div>
             <h3 class="ui header">
                 <a target="_blank" href="UnifiedSign/UnifiedSign.html"><i class="play icon"></i></a>
                 <div class="content" id="unified-sign-terminate-request">统一协议支付签约解约</div>
             </h3>
             <div class="ui segment">
                 统一协议支付签约解约。
             </div>
             <h3 class="ui header">
                 <a target="_blank" href="UnifiedSign/UnifiedSign.html"><i class="play icon"></i></a>
                 <div class="content" id="unified-sign-pay-request">统一协议支付</div>
             </h3>
             <div class="ui segment">
                 统一协议支付。
             </div>
             <h3 class="ui header">
                 <a target="_blank" href="UnifiedSign/UnifiedSign.html"><i class="play icon"></i></a>
                 <div class="content" id="unified-sign-cancel-request">统一协议支付订单撤销</div>
             </h3>
             <div class="ui segment">
                 统一协议支付订单撤销。
             </div>
         </div>--%>
        <div id="-authorized-pay" style="padding-bottom: 40px">
            <h3 class="ui large header">农行授权支付</h3>
            <div class="ui section divider"></div>
            <div class="ui section">商户通过对接下述接口可以在支付场景中调起农行授权支付模块完成收款。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/AgentSignContract.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-agentsigncontract-request">银行侧签约-申请</div>
            </h3>
            <div class="ui segment">授权支付银行侧签约，返回签约页面。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/QuickAgentSignContract.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-quickagentsigncontract-request">商户侧签约-申请</div>
            </h3>
            <div class="ui segment">商户端授权支付签约交易。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/QuickAgentSignConfirm.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-quickagentsignconfirm-request">商户侧签约-确认</div>
            </h3>
            <div class="ui segment">商户端授权支付签约申请后确认。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/QuickAgentSignResendReq.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-quickagentsignresendreq-request">商户侧签约-验证码重发</div>
            </h3>
            <div class="ui segment">商户端授权支付签约验证码重发。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/AgentUnsignContract.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-agentunsigncontract-request">解约</div>
            </h3>
            <div class="ui segment">授权支付解约。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/AgentSignContractQuery.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-agentsigncontractquery-request">签约/解约查询</div>
            </h3>
            <div class="ui segment">查询授权支付签约编号签约情况。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/AgentPayment.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-agentpayment-request">单笔扣款</div>
            </h3>
            <div class="ui segment">农行授权支付单笔扣款。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/AgentBatchPayment.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-agentbatchpayment-request">批量扣款</div>
            </h3>
            <div class="ui segment">农行授权支付批量扣款。</div>
            <h3 class="ui header">
                <a target="_blank" href="Agent/AgentBatchPaymentQuery.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-agentbatchpaymentquery-request">批量扣款结果查询</div>
            </h3>
            <div class="ui segment">批量授权扣款结果查询。</div>
            <h3 class="ui header">
                <a target="_blank" href="Refund/MerchantBatchRefund.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-merchantbatchrefund-request">批量退款</div>
            </h3>
            <div class="ui segment">批量退款。</div>
            <h3 class="ui header">
                <a target="_blank" href="Query/MerchantBatchRefundQuery.html"><i class="play icon"></i></a>
                <div class="content" id="-authorized-merchantbatchrefundquery-request">批量退款结果查询</div>
            </h3>
            <div class="ui segment">批量退款结果查询。</div>
        </div>
        <div id="-entrust-pay" style="padding-bottom: 40px">
            <h3 class="ui large header">代收</h3>
            <div class="ui section divider"></div>
            <div class="ui section">商户通过对接下述接口可以在支付场景中调起代收模块完成收款。</div>
            <h3 class="ui header">
                <a target="_blank" href="Entrust/Entrust.html"><i class="play icon"></i></a>
                <div class="content" id="-entrust-sign-request">签约申请</div>
            </h3>
            <div class="ui segment">商户端代收签约交易。</div>
            <h3 class="ui header">
                <a target="_blank" href="Entrust/Entrust.html"><i class="play icon"></i></a>
                <div class="content" id="-entrust-sign-resendSMS-request">验证码重发</div>
            </h3>
            <div class="ui segment">商户端代收签约验证码重发。</div>
            <h3 class="ui header">
                <a target="_blank" href="Entrust/Entrust.html"><i class="play icon"></i></a>
                <div class="content" id="-entrust-sign-confirm-request">签约确认</div>
            </h3>
            <div class="ui segment">商户端代收签约申请后确认。</div>
            <h3 class="ui header">
                <a target="_blank" href="Entrust/Entrust.html"><i class="play icon"></i></a>
                <div class="content" id="-entrust-sign-query-request">签约/解约查询</div>
            </h3>
            <div class="ui segment">查询代收签约编号签约情况。</div>
            <h3 class="ui header">
                <a target="_blank" href="Entrust/Entrust.html"><i class="play icon"></i></a>
                <div class="content" id="-entrust-unsign-request">解约</div>
            </h3>
            <div class="ui segment">代收解约。</div>
            <h3 class="ui header">
                <a target="_blank" href="Entrust/Entrust.html"><i class="play icon"></i></a>
                <div class="content" id="-entrust-payment-request">代收支付单笔扣款</div>
            </h3>
            <div class="ui segment">农行代收单笔扣款。</div>
        </div>
        <div id="-k-code-pay" style="padding-bottom: 40px">
            <h3 class="ui large header">农行K码支付</h3>
            <div class="ui section">商户通过对接下述接口可以在支付场景中调起农行K码支付模块完成收款。</div>
            <div class="ui section divider"></div>
            <h3 class="ui header">
                <a target="_blank" href="QuickPayment/MerchantQuickPaymentReq.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-k-code-merchantquickpaymentreq-request">账单发送</div>
            </h3>
            <div class="ui segment">网上K码支付-账单发送。</div>
            <h3 class="ui header">
                <a target="_blank" href="QuickPayment/MerchantQuickPaymentSend.html"><i class="play icon"></i></a>
                <div class="content" id="-k-code-merchantquickpaymentsend-request">支付请求</div>
            </h3>
            <div class="ui segment">网上K码支付-支付请求。</div>
            <h3 class="ui header">
                <a target="_blank" href="QuickPayment/MerchantQuickPaymentResend.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-k-code-merchantquickpaymentresend-request">验证码重发</div>
            </h3>
            <div class="ui segment">网上K码支付-验证码重发。</div>
        </div>
        <div id="-settlement-download" style="padding-bottom: 40px">
            <h3 class="ui large header">对账单下载</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起对账单下载模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="Statement/MerchantTrxSettleQuery.html"><i class="play icon"></i></a>
                <div class="content" id="-settlement-merchanttrxsettlequery-download">农行支付交易对账单下载</div>
            </h3>
            <div class="ui segment">1、可用来下载农行支付指定日期的对账单。2、T日对账单在T+1日06:00之后生成，因此请求对账单下载不应早于次日06:00。</div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/POSThirdFileDownloadRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-settlement-posthirdfiledownloadrequest-download">农行POS交易对账单下载</div>
            </h3>
            <div class="ui segment">可用来下载在POS渠道支付的指定日期的对账单。</div>
            <h3 class="ui header">
                <a target="_blank" href="Statement/MerchantTrxSettleAliWX.html"><i class="play icon"></i></a>
                <div class="content" id="-settlement-merchanttrxsettlealiwx-download">微信支付宝对账单下载</div>
            </h3>
            <div class="ui segment">1、可用来下载微信支付宝支付指定日期的对账单。2、T日对账单在T+1日17:00之后生成，因此请求对账单下载不应早于次日17:00。</div>
            <h3 class="ui header">
                <a target="_blank" href="Statement/MerchantTrxSettleTransfer.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-settlement-merchanttrxsettletransfer-download">内转出金对账单下载</div>
            </h3>
            <div class="ui segment">可用来下载内转出金对账单。</div>
            <h3 class="ui header">
                <a target="_blank" href="Statement/MerchantTrxSettlePlatForm.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-settlement-merchanttrxsettleplatform-download">平台商户交易对账单下载</div>
            </h3>
            <div class="ui segment">可用来下载平台商户交易对账单。</div>
            <h3 class="ui header">
                <a target="_blank" href="Statement/MerchantTrxSettleAliWXDZH.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-settlement-merchanttrxsettlealiwxdzh-download">垫资户模式微信支付宝对账单下载</div>
            </h3>
            <div class="ui segment">可用来下载垫资户模式微信支付宝对账单。</div>
            <h3 class="ui header">
                <a target="_blank" href="Statement/Statement.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-settlement-merchanttrxsettle-download">大文件对账单下载</div>
            </h3>
            <div class="ui segment">可用来下载大文件对账单。</div>
        </div>
        <div id="-split-merchant-fund" style="padding-bottom: 40px">
            <h3 class="ui large header">二级商户资金分账</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起二级商户资金分账模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/Deposit.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-deposit-request">支出类二级账簿充值</div>
            </h3>
            <div class="ui segment">支出类二级账簿充值是指平台类商户通过农行B2B支付从自有资金账户向支出类账簿充值。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/MerchantInnerPaymentRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-merchantinnerpayment-request">二级商户内转交易</div>
            </h3>
            <div class="ui segment">可以用来实现平台商户下二级商户账簿资金的互转。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/MerchantOutPaymentRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-merchantoutpayment-request">二级商户出金交易</div>
            </h3>
            <div class="ui segment">二级账簿提现交易，可以用来实现平台商户下二级商户账簿资金转出至一类户。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/TransferOutQuery.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-transferoutquery-request">出金交易查询</div>
            </h3>
            <div class="ui segment">出金交易查询。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/GuanteePaySendMQOrder.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-guanteepaysendmqorder-request">平台商户担保确认</div>
            </h3>
            <div class="ui segment">平台商户担保确认。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/QueryPlatformConfirm.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-queryplatformconfirm-request">平台商户担保确认查询</div>
            </h3>
            <div class="ui segment">平台商户担保确认查询。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/CheckSubMerAccDetailRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-checksubmeraccdetail-request">二级商户账簿明细查询[不在使用]</div>
            </h3>
            <div class="ui segment">可以用来查询平台商户下二级商户账簿明细。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/CheckSubMerAccDetailNewRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-checksubmeraccdetailnew-request">二级商户账簿明细分页查询</div>
            </h3>
            <div class="ui segment">可以用来查询平台商户下二级商户账簿明细。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/SubAccQuery.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-subaccquery-request">二级商户账簿余额查询</div>
            </h3>
            <div class="ui segment">二级商户账簿余额查询。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/MerchantGetReceipt.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-merchantgetreceipt-request">出金交易电子回单下载</div>
            </h3>
            <div class="ui segment">可用来下载出金交易电子回单凭证。</div>
            <h3 class="ui header">
                <a target="_blank" href="Query/Query.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-query-request">内转交易查询</div>
            </h3>
            <div class="ui segment">内转交易查询的功能用于查询历史内转记录。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/CheckGuarantedFundAccDetail.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-checkguarantedfundaccdetail-request">保证金账户明细查询</div>
            </h3>
            <div class="ui segment">保证金账户明细查询。</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/PayForAnotherApply.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-schooltransferout-request">校培监管资金划拨申请交易</div>
            </h3>
            <div class="ui segment">校培监管资金划拨申请交易</div>
            <h3 class="ui header">
                <a target="_blank" href="SplitMerchantFund/FundTransferApplyQuery.html"><i class="play icon"></i></a>
                <div class="content" id="-split-merchant-fund-schooltransferoutquery-request">校培监管资金划拨结果查询交易</div>
            </h3>
            <div class="ui segment">校培监管资金划拨结果查询交易</div>
        </div>
        <div id="-subsidy-request" style="padding-bottom: 40px">
            <h3 class="ui large header">二级商户营销补贴</h3>
            <div class="ui section">商户通过对接下述接口可以在支付场景中调起二级商户营销补贴模块。</div>
            <div class="ui section divider"></div>
            <h3 class="ui header">
                <a target="_blank" href="Pay/PaySubsidy.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-subsidy-subsidytransfer-request">营销补贴资金发放</div>
            </h3>
            <div class="ui segment">营销补贴资金发放接口用于平台出资开展的各类营销活动，如满减、随机、立减等。平台可通过该接口将营销资金补贴到二级商户账簿中。</div>
            <h3 class="ui header">
                <a target="_blank" href="Pay/PaySubsidy.html"><i class="play icon"></i></a>
                <div class="content" id="-subsidy-subsidyrefund-request">营销补贴资金回退</div>
            </h3>
            <div class="ui segment">营销补贴资金回退接口用于对已发放的营销补贴资金进行回退。平台可通过该接口将营销补贴资金从二级商户账簿回退到平台营销补贴资金账簿中。</div>
            <h3 class="ui header">
                <a target="_blank" href="Pay/PaySubsidy.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-subsidy-querysubsidy-request">营销补贴资金查询</div>
            </h3>
            <div class="ui segment">营销补贴查询的功能用于查询历史补贴记录，其中包括了营销补贴支付和营销补贴退款的记录。</div>
        </div>
        <div id="-merchant-config" style="padding-bottom: 40px">
            <h3 class="ui large header">二级商户管理</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起二级商户管理模块。</div>
            <%--<h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/RegSubMerInfo.html"><i class="play icon"></i></a>
                <div class="content" id="-merchant-config-regsubmerinfo">二级商户信息同步申请</div>
            </h3>--%>
            <div class="ui segment">
                平台类商户可通过接口向我行发起二级商户信息同步申请。我行收到平台类商户传输过来的二级商户注册信息后会实时对二级商户进行注册，但是同步申请通过后还需要调用二级商户签约确认交易进行确认二级商户后方才生效。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/RegSubMerInfoNew.html"><i class="play icon"></i></a>
                <div class="content" id="-merchant-config-regsubmerinfoNew">二级商户信息同步申请（新）</div>
            </h3>
            <div class="ui segment">
                平台类商户可通过接口向我行发起二级商户信息同步申请。我行收到平台类商户传输过来的二级商户注册信息后会实时对二级商户进行注册，但是同步申请通过后还需要调用二级商户签约确认交易进行确认二级商户后方才生效。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/SendMobileMessageForSubMer.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-sendmobilemessageforsubmer">二级商户信息同步申请短信验证码重发</div>
            </h3>
            <div class="ui segment">二级商户信息同步申请短信验证码重发。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/VerifyMessageCodeAndRandomAmount.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-verifymessagecodeandrandomamount">二级商户信息同步确认</div>
            </h3>
            <div class="ui segment">
                1、平台商户在二级商户信息同步申请后可通过此交易发起二级商户信息同步确认请求，对于对公账户，以及中行银行、招行银行、北京银行等个人卡，无法通过短信验证码进行身份鉴权的情况，请选择校验随机金额进行确认。
                2、二级商户信息同步确认后，还需银行工作人员进行复核，复核通过后会根据二级商户信息同步申请接口上送的审核结果通知地址通知审核结果。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/UpdateSubMerchantStatus.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-updatesubmerchantstatus">二级商户状态变更</div>
            </h3>
            <div class="ui segment">平台商户根据需要变更二级商户状态，解约，关闭或者开启。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/QrySubMerchantInfo.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-qrysubmerchantinfo">二级商户信息查询</div>
            </h3>
            <div class="ui segment">二级商户信息查询。</div>
            <%--            <h3 class="ui header">--%>
            <%--                <a target="_blank" href="ManageSubMerInfo/RegSubMerchantInfo.html"><i--%>
            <%--                        class="play icon"></i></a>--%>
            <%--                <div class="content" id="-merchant-config-regsubmerchantinfo">二级商户信息同步</div>--%>
            <%--            </h3>--%>
            <%--            <div class="ui segment">平台类商户可通过接口向我行发起二级商户信息同步。我行收到平台类商户传输过来的二级商户注册信息后对二级商户进行注册。</div>--%>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/UploadSubMerCertRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-uploadsubmercertrequest">二级商户证照资料上传</div>
            </h3>
            <div class="ui segment">二级商户证照资料上传。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/QrySubMerReviewStatus.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-qrysubmerreviewstatusrequest">二级商户申请单申请状态查询</div>
            </h3>
            <div class="ui segment">二级商户申请单申请状态查询。</div>
            <!--<h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/BatchRegSubMerInfo.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-batchregsubmerinfo">批量二级商户同步</div>
            </h3>
            <div class="ui segment">批量二级商户同步。</div>-->
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/MigrateSubMerchantInfo.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-migratesubmerchantinfo">二级商户迁移接口</div>
            </h3>
            <div class="ui segment">二级商户迁移接口。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/MigrateSubMerToOtherSubject.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-migratesubmertoothersubject">不同主体二级商户迁移</div>
            </h3>
            <div class="ui segment">不同主体二级商户迁移。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/RegSubMerEndInfo.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-regsubmerendinfo">二级商户终端同步</div>
            </h3>
            <div class="ui segment">二级商户终端同步。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/AppendSubmerchantInfo.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-appendsubmerchantinfo">二级商户迁移补录</div>
            </h3>
            <div class="ui segment">二级商户迁移补录。</div>
            <h3 class="ui header">
                <a target="_blank" href="ManageSubMerInfo/CancelRegSubmerApply.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-merchant-config-cancelregsubmerapply">二级商户同步申请撤销</div>
            </h3>
            <div class="ui segment">二级商户同步申请撤销。</div>
        </div>
        <div id="-syncoffineorder-request" style="padding-bottom: 40px">
            <h3 class="ui large header">订单信息同步</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起订单信息同步模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/BatchRegisterRequest.html"><i class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-batchregister-request">第三方订单信息同步</div>
            </h3>
            <div class="ui segment">
                用于商户联机向农行同步第三方订单信息-如微信APP和H5支付、支付宝线上支付、现金等非综合收银台提供支付方式支付的订单。订单信息同步成功后，商户须单独调用“第三方订单信息确认接口”将资金实时划转到指定的二级商户账簿。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/ThirdConfirmTranslogRequest.html"><i class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-thirdconfirmtranslog-request">第三方订单信息确认(含附言)</div>
            </h3>
            <div class="ui segment">
                对于通过“第三方订单信息同步”接口同步成功的订单，商户可通过该接口将资金实时划转到指定的二级商户账簿。
            </div>
            <%--            <h3 class="ui header">--%>
            <%--                <a target="_blank" href="SyncOffineOrder/ThirdConfirmSendMQOrderRequest.html"><i--%>
            <%--                        class="play icon"></i></a>--%>
            <%--                <div class="content" id="-syncoffineorder-thirdconfirmsendmq-request">第三方订单信息确认不再使用</div>--%>
            <%--            </h3>--%>
            <%--            <div class="ui segment">--%>
            <%--                对于通过“第三方订单信息同步”接口同步成功的订单，商户可通过该接口将资金实时划转到指定的二级商户账簿。--%>
            <%--            </div>--%>
            <h3 class="ui header">
                <a target="_blank" href="Query/Query.html"><i class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-queryrealtimeregister-request">第三方订单信息确认结果查询</div>
            </h3>
            <div class="ui segment">
                可以用来查询第三方订单信息确认结果。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/FileRegisterRequest.html"><i class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-fileregister-request">第三方订单信息批量上传</div>
            </h3>
            <div class="ui segment">
                用于商户通过文件上传方式批量向农行同步第三方订单信息-如微信APP和H5支付、支付宝线上支付、现金等非综合收银台提供支付方式支付的订单。批量同步成功后，农行会定时于当天10点、16点和22点分三个批次将资金实时划转到指定的二级商户账簿。商户可通过“第三方订单信息批量上传结果查询”接口查询处理结果。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/QueryFileRegister.html"><i class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-queryfileregister-request">第三方订单信息批量上传结果查询</div>
            </h3>
            <div class="ui segment">
                可以用来查询第三方订单信息批量上传的最终处理结果。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/RegisterPOSOrderRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-registerposorder-request">农行POS订单信息同步</div>
            </h3>
            <div class="ui segment">
                可用来同步线下农行POS订单信息，并完成二级账簿出金至一类户。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/QuerySubMerTdaySettleRequest.html"><i
                        class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-querysubmertdaysettle-request">农行POS渠道可清算金额查询</div>
            </h3>
            <div class="ui segment">
                可用来查询T日商户POS渠道清算金额、可确认金额以及订单登记序列号。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="SyncOffineOrder/OverDueConfirm.html"><i class="play icon"></i></a>
                <div class="content" id="-syncoffineorder-overdueconfirm-request">超期担保确认</div>
            </h3>
            <div class="ui segment">超期担保确认</div>
        </div>
        <div id="-query-request" style="padding-bottom: 40px">
            <h3 class="ui large header">查询</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起查询模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="Query/MerchantQueryOrder.html"><i class="play icon"></i></a>
                <div class="content" id="-query-merchantqueryorder-request">单笔统一查询</div>
            </h3>
            <div class="ui segment">
                1、可以用来查询农行、微信、支付宝支付订单支付状态。 2、可以用来查询农行、微信、支付宝退款订单退款状态。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Query/MerchantQueryTrnxRecords.html"><i class="play icon"></i></a>
                <div class="content" id="-query-merchantquerytrnxrecords-request">银行交易流水明细查询</div>
            </h3>
            <div class="ui segment">
                可用来查询特定时间范围内的银行交易流水明细查询。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Query/Query.html"><i class="play icon"></i></a>
                <div class="content" id="-query-submertransdetail-request">二级商户交易明细查询</div>
            </h3>
            <div class="ui segment">
                可以用来查询二级商户交易明细。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="Query/QueryClearanceResult.html"><i class="play icon"></i></a>
                <div class="content" id="-query-queryclearanceresult-request">清算结果查询</div>
            </h3>
            <div class="ui segment">
                清算结果查询
            </div>
        </div>
        <div id="-identity-verify" style="padding-bottom: 40px">
            <h3 class="ui large header">身份认证</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起身份认证模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="IdentityVerify/IdentityVerify.html"><i class="play icon"></i></a>
                <div class="content" id="-identity-verify-request">身份认证-页面认证</div>
            </h3>
            <div class="ui segment">
                商户通过接口向我行电子商务系统发送客户身份验证请求，系统验证交易信息的正确性，引导客户跳转到我行相应页面完成身份验证，将验证结果通知商户。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="IdentityVerify/StaticIdentityVerify.html"><i class="play icon"></i></a>
                <div class="content" id="-identity-verify-static-request">身份认证-接口认证</div>
            </h3>
            <div class="ui segment">
                商户通过接口向我行电子商务系统发送客户身份验证请求，系统验证交易信息的正确性，并告知结果。
            </div>
        </div>
        <div id="-transfer" style="padding-bottom: 40px">
            <h3 class="ui large header">客户账薄支付</h3>
            <div class="ui section divider"></div>
            <div class="ui segment">商户通过对接下述接口可以调起客户账薄支付模块。</div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/PlatSubCustomPay.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-platsubcustompay-request">客户账薄支付</div>
            </h3>
            <div class="ui segment">
                客户账薄支付申请。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/PlatSubCustomRefund.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-platsubcustomrefund-request">退款</div>
            </h3>
            <div class="ui segment">
                客户账薄支付对应的退款。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/QrySubCustomReviewStatus.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-qrysubcustomreviewstatus-request">客户申请状态查询</div>
            </h3>
            <div class="ui segment">
                客户申请状态查询。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/RegSubCustomerInfo.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-proxyregsubcustomerinfo-request">客户信息同步</div>
            </h3>
            <div class="ui segment">
                客户信息同步。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/QueryCustomAccDetail.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-querycustomaccdetail-request">二级客户账簿明细查询</div>
            </h3>
            <div class="ui segment">
                可以用来分页查询二级客户账簿明细。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/QueryCustomInfo.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-querycustominfo-request">客户信息查询接口</div>
            </h3>
            <div class="ui segment">
                客户信息查询接口。
            </div>
            <h3 class="ui header">
                <a target="_blank" href="PlatSubCustomPay/QueryCustomTransDetail.html"><i class="play icon"></i></a>
                <div class="content" id="-transfer-querycustomtransdetail-request">二级客户交易明细查询</div>
            </h3>
            <div class="ui segment">
                可以用来查询二级客户交易明细。
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script language="javascript" type="text/javascript">
    $(function () {
        $('.ui.accordion').accordion();
        $('.ui.sticky')
            .sticky({
                context: '#context',
                pushing: true
            })
    });
</script>