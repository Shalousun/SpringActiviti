<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../include/taglib.jsp" %>
<html>
<head>
    <title>我的历史请假记录</title>
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
        </div>
    </form>
</div>
<div id="table-container">
    <table id="table">
    </table>
</div>

<!--process info modal-->
<div class="modal fade" id="process-info-modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="grant-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">流程活动记录</h4>
            </div>
            <div class="modal-body" id="modal-body">
                <table id="processData" class="table table-striped">
                    <thead>
                        <tr>
                            <th>活动名称</th>
                            <th>活动类型</th>
                            <th>办理人</th>
                            <th>活动开始时间</th>
                            <th>活动结束时间</th>
                        </tr>
                    </thead>
                    <tbody id="activity">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
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
<script src="${ctx}/statics/js/jquery.formatDate.js"></script>
<script src="${ctx}/statics/js/laydate/laydate.js"></script>
<script>
    var $table = $("#table");
    $(function () {
        initTable();
    });
    var $grid;
    function initTable() {
        $grid = $table.bootstrapTable({
            url: '${ctx}/leave/getFinishProcess',
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
                title: '业务号',
                field: 'businessKey',
                align: 'center',
                width: 100
            }, {
                title: '流程实例ID',
                field: 'leaveApply.processInstanceId',
                align: 'center',
                width: 100
            }, {
                title: '申请人',
                field: 'leaveApply.userId',
                align: 'center',
                width: 100
            }, {
                title: '请假类型',
                field: 'leaveApply.leaveType',
                align: 'center',
                width: 100
            }, {
                title: '申请时间',
                field: 'leaveApply.applyTime',
                align: 'center',
                width: 100
            }, {
                title: '操作',
                field: 'operate',
                align: 'center',
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="processInfo(\'{0}\')"><i class="fa fa-user-o"></i>查看详情</a>', row.leaveApply.processInstanceId);
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
    var $processInfoModal = $('#process-info-modal');
    //流程信息
    function processInfo(processInstanceId) {
        <%--$("#modal-body").bootstrapTable({--%>
            <%--url: "${ctx}/leave/processInfo/" + processInstanceId,--%>
            <%--method: 'get',--%>
            <%--pagination:false,--%>
            <%--sidePagination:'client',--%>
            <%--rowStyle: function (row, index) {--%>
                <%--var strClass = "";--%>
                <%--if (index & 1) {--%>
                    <%--strClass = "table-odd";--%>
                <%--} else {--%>
                    <%--strClass = "table-even";--%>
                <%--}--%>
                <%--return {classes: strClass}--%>
            <%--},--%>
            <%--columns: [{--%>
                <%--title: '活动名称',--%>
                <%--field: 'activityName',--%>
                <%--align: 'center',--%>
                <%--width: 100--%>
            <%--},{--%>
                <%--title: '活动类型',--%>
                <%--field: 'activityType',--%>
                <%--align: 'center',--%>
                <%--width: 100--%>
            <%--},{--%>
                <%--title: '办理人',--%>
                <%--field: 'assignee',--%>
                <%--align: 'center',--%>
                <%--width: 100--%>
            <%--},{--%>
                <%--title: '活动开始时间',--%>
                <%--field: 'startTime',--%>
                <%--align: 'center',--%>
                <%--width: 100--%>
            <%--},{--%>
                <%--title: '活动结束时间',--%>
                <%--field: 'endTime',--%>
                <%--align: 'center',--%>
                <%--width: 100--%>
            <%--}]--%>
        <%--});--%>
        $.ajax({
            url: "${ctx}/leave/processInfo/" + processInstanceId
        }).done(function (result) {
            var formatStr = "yyyy-MM-dd";
            $("#activity").empty();
            for (var i = 0; i < result.length; i++) {
                var data = result[i];
                if(!data.assignee){
                    data.assignee = '系统处理';
                }
                $("#activity").append("<tr><td>" + data.activityName + "</td><td>" + data.activityType + "</td><td>" + data.assignee+ "</td>" +
                        "<td>" + $.formatDate(formatStr,data.startTime)  + "</td><td>"  + $.formatDate(formatStr,data.endTime) + "</td></tr>");
            }
            $processInfoModal.modal({backdrop: false});
        }).fail(function () {
            Common.bs.alert("服务器内部错误，请联系管理员");
        });
    }
</script>

</body>
</html>
