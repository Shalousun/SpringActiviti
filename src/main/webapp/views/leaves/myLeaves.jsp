<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../include/taglib.jsp" %>
<html>
<head>
    <title>我发起的请假列表</title>
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
            <input type="text" class="form-control" id="role-name" placeholder="请假">
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
<!--add modal-->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="add-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">新增请假</h4>
            </div>
            <div class="modal-body">
                <form action="" role="form" class="form-horizontal" id="add-form">

                    <div class="form-group">
                        <label for="leave-type" class="col-md-3 control-label">请假类型</label>
                        <div class="col-md-9">
                            <select name="leaveType" id="leave-type" class="form-control">
                                <option value="事假">事假</option>
                                <option value="病假">病假</option>
                                <option value="年假">年假</option>
                                <option value="丧假">丧假</option>
                                <option value="产假">产假</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="start-time" class="col-md-3 control-label">开始时间</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="startTime" id="start-time" placeholder="开始时间" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="end-time" class="col-md-3 control-label">结束时间</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="endTime" id="end-time" placeholder="结束时间" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">请假原因</label>
                        <div class="col-md-9">
                            <textarea class="form-control" name="reason" rows="3"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="add-save">确定</button>
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
            url: '${ctx}/leave/setupProcess',
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
            queryParamsType:'',
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
                title: '执行ID',
                field: 'executionId',
                align: 'center',
                width: 100
            },{
                title: '流程实例ID',
                field: 'processInstanceId',
                align: 'center',
                width: 100
            },{
                title: '当前节点',
                field: 'activityId',
                align: 'center',
                width: 100
            },{
                title: '业务号',
                field: 'businessKey',
                align: 'center',
                width: 100
            }, {
                title: '操作',
                field: 'operate',
                align: 'center',
                formatter: function (value, row) {
                    var link = '';
                            //$.boco.format('<a class="btn btn-primary btn-xs" onClick="grant(\'{0}\')"><i class="fa fa-user-o"></i>授权</a>',row.rid);
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


    var $addModal = $('#addModal');
    var $updateModal = $("#updateModal");
    var $grantModal = $("#grantModal");
    $("#insertBtn").on('click', function () {
        $addModal.modal({backdrop: false});
    });

    //新增保存信息
    $("#add-save").on('click', function () {
        var params = $.boco.serialize("#add-form");
        $.ajax({
            url: '${ctx}/leave/startLeave',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function (result) {
                if (result.success) {
                    $addModal.modal('hide');
                    $.boco.clearForm("#add-form");
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
    //编辑保存
    $("#update-save").on('click', function () {
        var params = $.boco.serialize("#update-form");
        params.departmentId = $.boco.parseInt(params.departmentId);
        $.ajax({
            url: '${ctx}/sysRole/update',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function (result) {
                if (result.success) {
                    $.boco.clearForm("#update-form");
                    $updateModal.modal('hide');
                    Common.bs.msg('编辑角色信息成功');
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
     * 删除
     * @param id
     */
    function delPlatform(id,delFlag) {
        var message = delFlag == 0 ? "恢复" : "停用";
        Common.bs.confirm("你确认要"+message+"该角色信息吗？", function () {
            $.ajax({
                url: '${ctx}/sysRole/delete/' + id +"/" +delFlag,
                method: 'get',
                success: function (result) {
                    if (result.success) {
                        Common.bs.msg(message+"成功！");
                        $grid.bootstrapTable("refresh");
                    } else {
                        Common.bs.alert(result.message);
                    }
                },
                error: function () {
                    Common.bs.alert("服务器内部错误，请联系管理员");
                }
            });
        })
    }


    /**
     * 编辑
     * @param id
     */
    function update(id) {
        $.ajax({
            url: '${ctx}/sysRole/query/' + id,
            method: 'get',
            success: function (result) {
                if (result.success) {
                    loadSystems("#update-systemId",result.data.systemId);
                    $("#update-id").val(result.data.id);
                    $("#update-name").val(result.data.name);
                    $("#update-englishName").val(result.data.englishName);
                    $("#update-memo").val(result.data.memo);
                    $.boco.setSelectByValue("update-isSystemData",result.data.isSystemData);
                    $.boco.setSelectByValue("update-dataRange",result.data.dataRange);
                    $.boco.setSelectByValue("update-roleType",result.data.roleType);
                    $.boco.setSelectByValue("update-isUsable",result.data.isUsable);
                    $.boco.setSelectByValue("update-systemId",result.data.systemId);
                    $updateModal.modal({backdrop: false});
                } else {
                    Common.bs.alert(result.message);
                }
            },
            error: function () {
                Common.bs.alert("服务器内部错误，请联系管理员");
            }
        });
    }


    //日志
    var startTime = {
        elem: '#start-time',
        format: 'YYYY-MM-DD',
        max: laydate.now(),
        istoday: false,
        choose: function (data) {
            endTime.min = data; // 开始日选好后，重置结束日的最小日期
            endTime.start = data;// 将结束日的初始值设定为开始日
        }
    };

    var endTime = {
        elem: '#end-time',
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
