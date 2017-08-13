<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>模型列表</title>
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap-table/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/statics/css/font-awesome.min.css">
    <link rel="stylesheet" href="${ctx}/statics/css/pageCommon.css">
</head>
<body>
<div id="toolbar-container">
    <form class="form-inline" role="form">
        <div class="form-group">
            <label for="name" class="control-label">模型名称</label>
            <input type="text" class="form-control" id="name" placeholder="模型名称" style="width: 150px">
        </div>
        <div class="form-group">
            &nbsp;&nbsp;
            <button type="button" class="btn btn-primary" id="searchBtn">查询</button>
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
<script>
    $(function(){
        initTable();
    });
    var $grid;
    function initTable() {
       $grid =  $('#table').bootstrapTable({
            url:"${ctx}/model/list",
            //classes:'table',
            height:550,
            search: false,
            toolbar:'#container',
            // pagination:true,
            pageNumber:1,//初始化加载第一页，默认第一页
            pageSize:2,//每页的记录行数（*）
            // sidePagination:'client',
            pageList: [5, 25, 50, 100],
            clickToSelect: true,
            singleSelect: true,
            //dataField:'list',//后台返回的数据字段
            queryParams: function (params) {
                var queryParams = {
                    limit: params.limit,
                    offset: params.offset
                }
                return queryParams;
            },
            rowStyle:function (row, index) {
                var strClass = "";
                if (index & 1) {
                    strClass = "table-odd";
                } else {
                    strClass = "table-even";
                }
                return { classes: strClass }
            },
            columns: [{
                title:'编号',
                field:'id',
                align:'center'
            },{
                title:'名称',
                field:'name',
                align:'center'
            },{
                title:'key',
                field:'key',
                align:'center'
            },{
                title:'创建时间',
                field:'createTime',
                align:'center'
            },{
                title: '操作',
                field: 'operate',
                align: 'center',
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="deploy(\'{0}\')"><i class="fa fa-user-o"></i>部署</a>', row.id);
                    link += $.boco.format('<a class="btn btn-primary btn-xs" href="${ctx}/model/export/{0}/bpmn"><i class="fa fa-user-o"></i>导出</a>', row.id);
                    link += $.boco.format('<a class="btn btn-primary btn-xs" target="_blank" href="${ctx}/modeler.html?modelId={0}"><i class="fa fa-user-o"></i>编辑</a>', row.id);
                    link += $.boco.format('<a class="btn btn-primary btn-xs" onClick="del(\'{0}\')"><i class="fa fa-user-o"></i>删除</a>', row.id);
                    return link;
                }
            }]
        });
    }

    /**
     * 部署model
     * @param modelId
     */
    function deploy(modelId){
        Common.bs.confirm("你确认要部署该model吗？", function () {
            $.ajax({
                url:'${ctx}/model/deploy/'+modelId,
                method:'get'
            }).done(function(result){
                if(result.success){
                    $grid.bootstrapTable("refresh");
                    Common.bs.msg("部署成功！")
                }else{
                    Common.bs.alert("部署失败");
                }
            }).fail(function(){
                Common.bs.alert("服务器异常");
            });
        });
    }

    /**
     * 删除model
     * @param modelId
     */
    function del(modelId){
        Common.bs.confirm("你确认要删除该model吗？", function () {
            $.ajax({
                url:'${ctx}/model/delete/'+modelId,
                method:'get'
            }).done(function(result){
                if(result.success){
                    $grid.bootstrapTable("refresh");
                }else{
                    Common.bs.alert("删除失败");
                }
            }).fail(function(){
                Common.bs.alert("服务器异常");
            });
        });
    }
</script>
</body>
</html>
