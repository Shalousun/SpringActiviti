<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
    <title>权限列表</title>
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap-table/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/statics/css/font-awesome.min.css">
    <link rel="stylesheet" href="${ctx}/statics/css/pageCommon.css">
    <link rel="stylesheet" href="${ctx}/statics/js/easyui/themes/bootstrap/easyui.css">
    <style>
        #roleGrantLayout {
            height: 300px !important;
        }
    </style>
</head>
<body>
<div id="toolbar-container">
    <form class="form-inline" role="form">

        <div class="form-group">
            <label for="name"  class="control-label">权限名称</label>
            <input type="text" class="form-control" id="name" placeholder="权限名称" style="width: 150px">
        </div>
        <div class="form-group">
            &nbsp;&nbsp;
            <button type="button" class="btn btn-primary" id="searchBtn">查询</button>
            &nbsp;&nbsp;
            <button type="button" class="btn btn-success" id="insertBtn">新增</button>
        </div>
    </form>
</div>
<div id="table-container">
    <table id="table">
    </table>
</div>

<!--include js-->
<script src="${ctx}/statics/js/jquery/jQuery-2.2.0.min.js"></script>
<script src="${ctx}/statics/js/bootstrap/js/bootstrap-draggable.min.js"></script>
<script src="${ctx}/statics/js/bootstrap/js/common.js"></script>
<script src="${ctx}/statics/js/bootstrap-table/bootstrap-table.js"></script>
<script src="${ctx}/statics/js/bootstrap-table/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/statics/js/jquery.baseCommon.js"></script>
<script src="${ctx}/statics/js/easyui/jquery.easyui.min.js"></script>
<script src="${ctx}/statics/js/easyui/extJs.js"></script>
<script>
    var $table = $("#table");
    $(function () {
        initTable();
    });
    var $grid;
    function initTable() {
        $grid = $table.bootstrapTable({
            url: '${ctx}/permission/page',
            method: 'get',
            height: 550,
            search: false,
            toolbar: '#toolbar-container',
            pagination: true,
            pageNumber: 1,//初始化加载第一页，默认第一页
            pageSize: 10,//每页的记录行数（*）
            sidePagination: 'server',
            pageList: [5, 25, 50, 100],
            clickToSelect: true,
            singleSelect: true,
            dataField: 'list',//后台返回的数据字段
            queryParams: function (params) {
                var queryParams = {
                    limit: params.limit,
                    offset: params.offset
                }
                return queryParams;
            },
            rowStyle: function (row, index) {
                var strClass = "";
                if (index & 1) {
                    strClass = "table-odd";
                } else {
                    strClass = "table-even";
                }
                return {classes: strClass}
            },
            columns: [{
                title: '编号',
                field: 'pid',
                align: 'center',
                width: 100
            },{
                title: '角色名称',
                field: 'permissionName',
                align: 'center',
                width: 100
            },  {
                title: '操作',
                field: 'operate',
                align: 'center',
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="grant(\'{0}\')"><i class="fa fa-user-o"></i>授权</a>',row.pid);
                    return link;
                },
                width: 150
            }]
        });
    }
    //query
    $("#searchBtn").on('click', function () {
        $grid.bootstrapTable("refresh");
    });
</script>

</body>
</html>

