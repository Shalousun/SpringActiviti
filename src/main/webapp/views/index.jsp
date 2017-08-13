<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>Activiti工作流</title>
    <link rel="icon" href="favicon.ico"/>
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/statics/css/font-awesome.min.css">
    <link rel="stylesheet" href="${ctx}/statics/css/skins/theme-blue-deep.css">
    <link rel="stylesheet" href="${ctx}/statics/css/index.css">
    <%--<link rel="stylesheet" href="${ctx}/statics/css/skins/base-skin.css">--%>
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="${ctx}/statics/js/html5.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
</head>
<body class="hold-transition skin-theme sidebar-mini" style="overflow-y:hidden;">
<div id="ajax-loader">
    <img src="${ctx}/statics/img/ajax-loader.gif"/>
</div>
<div class="wrapper">
    <!--头部信息-->
    <header class="main-header">

        <nav class="navbar navbar-static-top">
            <a href="" class="logo">
                <span class="logo-mini"><img src="${ctx}/statics/img/logo.png" alt="" style="width: 70%;"></span>
                <%--<span class="logo-lg"><img src="${ctx}/statics/img/logo.png" alt=""></span>--%>
                <span class="logo-lg"><img src="${ctx}/statics/img/logo-text.png" alt=""></span>
            </a>
            <a class="sidebar-toggle">
                <span class="sr-only"></span>
            </a>
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <img src="${ctx}/statics/img/user.png" class="user-image" alt="User Image">
                            <span class="hidden-xs">${sessionScope.username}</span>
                        </a>
                        <ul class="dropdown-menu pull-right">
                            <li><a class="menuItem" data-id="userInfo" href="${ctx}/views/personInfo.jsp"><i class="fa fa-user"></i>个人信息</a></li>
                            <li><a href="javascript:void(0);"><i class="fa fa-paint-brush"></i>皮肤设置</a></li>
                            <li class="divider"></li>
                            <li><a href="${ctx}/logout"><i class="ace-icon fa fa-power-off"></i>安全退出</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <!--左边导航-->
    <div class="main-sidebar">
        <div style="height:48px;padding-top: 20px;padding-left: 20px;">菜单</div>
        <div class="sidebar">

            <ul class="sidebar-menu" id="sidebar-menu">
                <!--<li class="header">导航菜单</li>-->
            </ul>
        </div>
    </div>
    <!--中间内容-->
    <div id="content-wrapper" class="content-wrapper">
        <div class="content-tabs">
            <button class="roll-nav roll-left tabLeft">
                <i class="fa fa-arrow-left"></i>
            </button>
            <nav class="page-tabs menuTabs">
                <div class="page-tabs-content" style="margin-left: 0px;">
                    <a href="javascript:;" class="menuTab active" data-id="default.html">欢迎首页</a>
                </div>
            </nav>
            <button class="roll-nav roll-right tabRight">
                <i class="fa fa-arrow-right" style="margin-left: 3px;"></i>
            </button>
            <div class="btn-group roll-nav roll-right">
                <button class="dropdown tabClose" data-toggle="dropdown">
                    页签操作<i class="fa fa-caret-down" style="padding-left: 3px;"></i>
                </button>
                <ul class="dropdown-menu dropdown-yellow dropdown-caret dropdown-menu-right" style="width:121px">
                    <li><a class="tabReload" href="javascript:void(0);">刷新当前</a></li>
                    <li><a class="tabCloseCurrent" href="javascript:void(0);">关闭当前</a></li>
                    <li><a class="tabCloseAll" href="javascript:void(0);">全部关闭</a></li>
                    <li><a class="tabCloseOther" href="javascript:void(0);">除此之外全部关闭</a></li>
                </ul>
            </div>
            <button class="roll-nav roll-right fullscreen"><i class="fa fa-arrows-alt"></i></button>
        </div>
        <div class="content-iframe" style="overflow: hidden;">
            <div class="mainContent" id="content-main">
                <iframe class="boco_iframe" width="100%" height="100%" src="${ctx}/views/default.html" frameborder="0" data-id="default.html"></iframe>
            </div>
        </div>
        <div class="copyRight">
            <p>Copyright@亿阳信通股份有限公司</p>
        </div>
    </div>

</div>
<script src="${ctx}/statics/js/jquery/jQuery-2.2.0.min.js"></script>
<script src="${ctx}/statics/js/bootstrap/js/bootstrap.min.js"></script>
<script src="${ctx}/statics/js/bootstrap/js/common.js?v=1.0"></script>
<script src="${ctx}/statics/js/simpleMenuData.js"></script>
<script src="${ctx}/statics/js/sidebarMenu.js?v=1.0"></script>
<script src="${ctx}/statics/js/index.js?v=1.0"></script>
<script>
    $(function () {
        $('#clrCache').on('click', function () {
            $.ajax({
                url:'${ctx}/index',
                dataType:'json',
                data:{},
                beforeSend :function(xmlHttp){
                    xmlHttp.setRequestHeader("If-Modified-Since","0");
                    xmlHttp.setRequestHeader("Cache-Control","no-cache");
                    console.log(xmlHttp)
                },
                success:function(response){

                    //操作
                },
                async:false
            });
        })
    });

    $(function () {
        $("#sidebar-menu").sidebarMenu({
            data:menuData //自定义的菜单数据变量
        });
        $.learuntab.init();
    });

    /**
     * 刷新当前激活的页面
     */
    function refreshActivePage(){
        $.learuntab.refreshTab();
    }
</script>
</body>
</html>

