<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>农行线上支付平台(DCEP)-商户接口范例-导航页</title>
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
                        <b>子钱包支付、退款、查询</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-sub-ewallet-pay-request">子钱包支付</a>
                        <a class="item" href="#-sub-ewallet-refund-request">退款</a>
                        <a class="item" href="#-sub-ewallet-query-request">查询</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>主扫下单</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-ewallet-payreq-request">主扫下单</a>
                    </div>
                </div>
                <div class="item">
                    <a class="title">
                        <i class="dropdown icon"></i>
                        <b>被扫支付、退款、查询</b>
                    </a>
                    <div class="content menu">
                        <a class="item" href="#-udcapp-qrcode-payreq-request">被扫支付</a>
                        <a class="item" href="#-udcapp-qrcode-refund-request">退款</a>
                        <a class="item" href="#-udcapp-qrcode-query-request">查询</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="left text" style="width: 85%">
        <div id="-sub-ewallet-request-lib" style="padding-bottom: 40px">
            <h3 class="ui large header">
                子钱包支付、退款、查询
            </h3>
            <div class="ui section divider"></div>
            <div class="ui section">数币子钱包场景下的支付、退款、查询
            </div>
            <h3 class="ui header">
                <a target="_blank" href="DCEP/SubEWalletPayForOutterV2.html"><i class="play icon"></i></a>
                <div class="content" id="-sub-ewallet-pay-request">子钱包支付</div>
                <div style="display: inline-block; margin: 0 0 4px 20px"><a
                        class="ui label red tag">点击播放图标可跳转对应DEMO
                    页面</a></div>
            </h3>
            <div class="ui segment">商户对接此接口进行数币子钱包支付</div>
            <h3 class="ui header">
                <a target="_blank" href="Refund/MerchantRefund.html"><i class="play icon"></i></a>
                <div class="content" id="-sub-ewallet-refund-request">退款</div>
            </h3>
            <div class="ui segment">支付成功后，可用来发起退款</div>
            <h3 class="ui header">
                <a target="_blank" href="Query/MerchantQueryOrder.html"><i class="play icon"></i></a>
                <div class="content" id="-sub-ewallet-query-request">查询</div>
            </h3>
            <div class="ui segment">用于查询支付和退款的交易状态或者交易详情</div>
        </div>
        <div id="-ewallet-payreq-request-lib" style="padding-bottom: 40px">
            <h3 class="ui large header">主扫下单</h3>
            <div class="ui section divider"></div>
            <div class="ui section">数币主扫场景下的下单</div>
            <h3 class="ui header">
                <a target="_blank" href="DCEP/EWalletPayReq.html"><i class="play icon"></i></a>
                <div class="content" id="-ewallet-payreq-request">主扫下单</div>
            </h3>
            <div class="ui segment">商户对接此接口进行数币主扫下单</div>
        </div>
        <div id="-udcapp-qrcode-request-lib" style="padding-bottom: 40px">
            <h3 class="ui large header">被扫支付、退款、查询</h3>
            <div class="ui section divider"></div>
            <div class="ui section">数币被扫场景下的支付、退款、查询</div>
            <h3 class="ui header">
                <a target="_blank" href="DCEP/UDCAppQRCodePayReq.html"><i class="play icon"></i></a>
                <div class="content" id="-udcapp-qrcode-payreq-request">被扫支付</div>
            </h3>
            <div class="ui segment">商户对接此接口进行数币被扫支付</div>
            <h3 class="ui header">
                <a target="_blank" href="Refund/MerchantRefund.html"><i class="play icon"></i></a>
                <div class="content" id="-udcapp-qrcode-refund-request">退款</div>
            </h3>
            <div class="ui segment">支付成功后，可用来发起退款</div>
            <h3 class="ui header">
                <a target="_blank" href="Query/MerchantQueryOrder.html"><i class="play icon"></i></a>
                <div class="content" id="-udcapp-qrcode-query-request">查询</div>
            </h3>
            <div class="ui segment">用于查询支付和退款的交易状态或者交易详情</div>
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