<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../include/taglib.jsp" %>
<html>
<head>
    <title>我正在参与的流程</title>
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap-table/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/statics/css/font-awesome.min.css">
    <link rel="stylesheet" href="${ctx}/statics/css/pageCommon.css">
</head>
<body>
<div id="toolbar-container">
    <form class="form-inline" role="form">

        <div class="form-group">
            <label for="leave-type" class="control-label">请假类型：</label>
            <input type="text" class="form-control" id="leave-type" placeholder="请假类型">
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
<script src="${ctx}/statics/js/laydate/laydate.js"></script>
<script>
    var $table = $("#table");
    $(function () {
        initTable();
    });
    var $grid;
    function initTable() {
        $grid = $table.bootstrapTable({
            url: '${ctx}/leave/involvedProcess',
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
            queryParamsType: '',
//            queryParams: function (params) {
//                var queryParams = {
//                    limit: params.limit,
//                    offset: params.offset
//                }
//                return queryParams;
//            },
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
                title: '申请人',
                field: 'userId',
                align: 'center',
                width: 100
            }, {
                title: '类型',
                field: 'leaveType',
                align: 'center',
                width: 100
            }, {
                title: '请假开始时间',
                field: 'startTime',
                align: 'center',
                width: 100
            }, {
                title: '请假结束时间',
                field: 'endTime',
                align: 'center',
                width: 100
            }, {
                title: '请假原因',
                field: 'reason',
                align: 'center',
                width: 100
            }, {
                title: '任务ID',
                field: 'taskId',
                align: 'center',
                width: 100
            }, {
                title: '任务名称',
                field: 'taskName',
                align: 'center',
                width: 100
            }, {
                title: '流程实例ID',
                field: 'processInstanceId',
                align: 'center',
                width: 100
            }, {
                title: '任务创建时间',
                field: 'taskCreateTime',
                align: 'center',
                width: 100
            }, {
                title: '操作',
                field: 'operate',
                align: 'center',
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="dealApply(\'{0}\')"><i class="fa fa-user-o"></i>审批</a>', row.taskId);
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


    var $modifyModal = $('#modify-modal');

    //调整申请保存
    $("#modify-save").on('click', function () {
        var params = $("#modify-form").serialize();//序列化获取表单内容
        $.ajax({
            url: '${ctx}/task/hrComplete',
            method: 'post',
            data: params,
            success: function (result) {
                if (result.success) {
                    $modifyModal.modal('hide');
                    $.boco.clearForm("#modify-form");
                    Common.bs.msg('保存成功');
                    $grid.bootstrapTable("refresh");
                } else {
                    Common.bs.alert(result.message);
                }
            },
            error: function () {
                Common.bs.alert("服务器内部错误，请联系管理员");
            }
        });
    });

    /**
     * 处理申请
     * @param taskId
     */
    function dealApply(taskId) {
        $("#task-id").val(taskId);//绑定taskId到审核表单中
        $modifyModal.modal({backdrop: false});
    }
</script>

</body>
</html>
