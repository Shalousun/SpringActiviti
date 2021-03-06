<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../include/taglib.jsp" %>
<html>
<head>
    <title>部门领导审批待办任务列表</title>
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap-table/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/statics/css/font-awesome.min.css">
    <link rel="stylesheet" href="${ctx}/statics/css/pageCommon.css">
</head>
<body>
<div id="toolbar-container">
    <form class="form-inline" role="form">
        <div class="form-group">
            <label for="leave-type" class="control-label">待办任务：</label>
            <input type="text" class="form-control" id="role-name" placeholder="待办任务">
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
<!--audit modal-->
<div class="modal fade" id="audit-modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="add-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">处理</h4>
            </div>
            <div class="modal-body">
                <form action="" role="form" class="form-horizontal" id="audit-form">
                    <input type="hidden" id="task-id">
                    <div class="form-group">
                        <label for="user-id" class="col-md-3 control-label">申请人</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="userId" id="user-id" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="apply-time" class="col-md-3 control-label">申请时间</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="applyTime" id="apply-time" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="leave-type" class="col-md-3 control-label">请假类型</label>
                        <div class="col-md-9">
                            <input type="text" id="leave-type" class="form-control" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="start-time" class="col-md-3 control-label">开始时间</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="startTime" id="start-time" placeholder="开始时间"
                                   readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="end-time" class="col-md-3 control-label">结束时间</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="endTime" id="end-time" placeholder="结束时间"
                                   readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">请假原因</label>
                        <div class="col-md-9">
                            <textarea class="form-control" id="reason" name="reason" rows="3" readonly></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">审批意见</label>
                        <div class="col-md-9">
                            <select name="approve" id="approve" class="form-control">
                                <option value="true">同意</option>
                                <option value="false">拒绝</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="audit-save">确定</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
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
            url: '${ctx}/leave/deptTaskList',
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
                width: 150,
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="dealApply(\'{0}\')"><i class="fa fa-user-o"></i>审批</a>', row.taskId);
                    return link;
                }

            }]
        });
    }
    //query
    $("#searchBtn").on('click', function () {
        $grid.bootstrapTable("refresh");
    });


    var $auditModal = $('#audit-modal');

    //审批保存
    $("#audit-save").on('click', function () {
        var params = $.boco.serialize("#audit-form");
        $.ajax({
            url: '${ctx}/leave/task/deptComplete',
            method: 'post',
            data: {
                approve:$("#approve").val(),
                taskId:$("#task-id").val(),
            },
            success: function (result) {
                if (result.success) {
                    $auditModal.modal('hide');
                    $.boco.clearForm("#audit-form");
                    Common.bs.msg('请假成功');
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
        $.ajax({
            url:'${ctx}/leave/dealTask/'+taskId,
            method:'get'
        }).done(function(result){
            if(result.success){
                var data = result.data;
                $("#user-id").val(data.userId);
                $("#apply-time").val(data.applyTime);
                $("#leave-type").val(data.leaveType);
                $("#start-time").val(data.startTime);
                $("#end-time").val(data.endTime);
                $("#reason").val(data.reason);
                $auditModal.modal({backdrop: false});
            }else{
                Common.bs.alert(result.message);
            }
        }).fail(function(){
            Common.bs.alert("服务器内部错误，请联系管理员");
        });
    }
</script>
</body>
</html>
