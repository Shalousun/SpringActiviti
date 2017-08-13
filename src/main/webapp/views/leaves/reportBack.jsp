<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../include/taglib.jsp" %>
<html>
<head>
    <title>销假</title>
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
            <input type="text" class="form-control" id="role-name" placeholder="请假类型">
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
<div class="modal fade" id="modify-modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="add-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">我要销假</h4>
            </div>
            <div class="modal-body">
                <form action="" role="form" class="form-horizontal" id="modify-form">
                    <input type="hidden" id="task-id" name="taskId">
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
                        <label for="real-start-time" class="col-md-3 control-label">实际开始时间</label>
                        <div class="col-md-9">
                            <input class="form-control" id="real-start-time" name="realStartTime">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="real-end-time" class="col-md-3 control-label">实际结束时间</label>
                        <div class="col-md-9">
                            <input class="form-control" id="real-end-time" name="realEndTime">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="modify-save">确定</button>
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
            url: '${ctx}/leave/xjTaskList',
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
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="dealApply(\'{0}\')"><i class="fa fa-user-o"></i>销假</a>', row.taskId);
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

    //销假
    $("#modify-save").on('click', function () {
        var params = $("#modify-form").serialize();//序列化获取表单内容
        $.ajax({
            url: '${ctx}/leave/task/reportComplete',
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
        $("#task-id").val(taskId);//绑定taskId到销假表单中
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
                $modifyModal.modal({backdrop: false});
            }else{
                Common.bs.alert(result.message);
            }
        }).fail(function(){
            Common.bs.alert("服务器内部错误，请联系管理员");
        });
    }

    //日志
    var startTime = {
        elem: '#real-start-time',
        format: 'YYYY-MM-DD',
        max: laydate.now(),
        istoday: false,
        choose: function (data) {
            endTime.min = data; // 开始日选好后，重置结束日的最小日期
            endTime.start = data;// 将结束日的初始值设定为开始日
        }
    };

    var endTime = {
        elem: '#real-end-time',
        format: 'YYYY-MM-DD',
        max: laydate.now(),
        istoday: true,
        choose: function (data) {
            startTime.max = data; // 结束日选好后，重置开始日的最大日期
        }

    }
    laydate(startTime);
    laydate(endTime);
</script>

</body>
</html>
