<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
    <title>用户信息列表</title>
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/statics/js/bootstrap-table/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/statics/css/pageCommon.css">
    <link rel="stylesheet" href="${ctx}/statics/js/easyui/themes/bootstrap/easyui.css">
    <link rel="stylesheet" href="${ctx}/statics/css/font-awesome.min.css">
</head>
<body>
<div id="toolbar-container">
    <form class="form-inline" role="form">
        <div class="form-group">
            <input type="text" class="form-control" id="userName" placeholder="用户名或姓名查询">
        </div>
        <div class="form-group">
            <div class="col-sm-4">
                <button type="button" class="btn btn-primary" id="searchBtn">查询</button>
            </div>
            <div class="col-sm-3">
                <button type="button" class="btn btn-success" id="insertBtn">新增</button>
            </div>
        </div>
    </form>
</div>
<div id="table-container">
    <table id="table">
    </table>
</div>
<!--add platform modal-->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="add-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">新增用户信息</h4>
            </div>
            <div class="modal-body">
                <form action="" role="form" class="form-horizontal" id="add-form">
                    <div class="form-group controls-row">

                        <label for="add-name" class="control-label col-md-3 inline"><span class="text-red">*</span>用户名:</label>
                        <div class="col-md-3">
                            <input type="text" class="form-control" placeholder="用户名" name="username" id="add-Name">
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
<!--grant modal-->
<div class="modal fade" id="grantModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="grant-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">用户角色分配</h4>
            </div>
            <div class="modal-body">
                <form action="" role="form" class="form-horizontal" id="grant-form">
                    <input type="hidden" id="grant-userId" name="userId">
                    <div class="form-group controls-row">
                        <label for="grant-name" class="control-label col-md-3 inline"><span class="text-red">*</span>姓名:</label>
                        <div class="col-md-7">
                            <input type="text" class="form-control" placeholder="姓名" name="name" id="grant-name"
                                   readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="grant-role" class="control-label col-md-3 inline">角色:</label>
                        <div class="col-md-7 scroll-roleList" id="grant-role">

                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="grant-save">确定</button>
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
<script src="${ctx}/statics/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery-validation/jquery.validate.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/layer/layer.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/easyui/extJs.js"></script>
<script>
    var $table = $("#table");
    $(function () {
        //console.log("md5加密："+hex_md5("123456"));
        initTable();
    });
    var $grid;
    function initTable() {
        $grid = $table.bootstrapTable({
            url: '${ctx}/user/page',
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
                    offset: params.offset,
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
                title: '登录名',
                field: 'username',
                align: 'center',
                width: 100
            }, {
                title: '密码',
                field: 'password',
                align: 'center',
                width: 100
            }, {
                title: '拥有的角色',
                field: 'roleList',
                align: 'center',
                width: 150,
                formatter: function (value, row) {
                    var str = "";
                    var length = value.length;
                    for(var i =0;i<value.length;i++){
                        if(i<length-1){
                            str += value[i].roleName+" ,"
                        }else {
                            str += value[i].roleName;
                        }
                    }
                    return str;
                }
            },{
                title: '电话',
                field: 'tel',
                align: 'center',
                width: 150
            }, {
                title: '年龄',
                field: 'age',
                align: 'center',
                width: 150
            }, {
                title: '操作',
                field: 'operate',
                align: 'center',
                width: 500,
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="grant(\'{0}\')""><i class="fa fa-plus"></i>授权角色</a>',row.uid);
                    return link;
                }
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
    var $pwdModal = $("#pwdModal");
    $("#insertBtn").on('click', function () {
        $addModal.modal({backdrop: false});
    });

    //新增保存信息
    $("#add-save").on('click', function () {
        var params = $.boco.serialize("#add-form");
        if (params.orgId == "--请选择--") {
            params.orgId = 0;
        }
        if (params.departmentCode == "--请选择--") {
            params.departmentCode = 0
        }
        console.log(JSON.stringify(params));
        $.ajax({
            url: '${ctx}/sysUser/add',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function (result) {
                if (result.success) {
                    $.boco.clearForm("#add-form");
                    $addModal.modal('hide');
                    Common.bs.msg('添加用户信息成功');
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
    //修改保存
    $("#update-save").on('click', function () {
        var params = $.boco.serialize("#update-form");
        $.ajax({
            url: '${ctx}/sysUser/update',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function (result) {
                if (result.success) {
                    $updateModal.modal('hide');
                    Common.bs.msg('修改用户信息成功');
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
     * 修改
     * @param id
     */
    function update(id) {
        $.ajax({
            url: '${ctx}/sysUser/query/' + id,
            method: 'get',
            success: function (result) {
                if (result.success) {
                    $("#update-id").val(result.data.id);
                    $("#update-name").val(result.data.name);
                    $("#update-realName").val(result.data.realName);
                    $("#update-memo").val(result.data.memo);
                    $("#update-post").val(result.data.post);
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


    /**
     * 删除
     * @param id
     */
    function del(id, delFlag) {
        var message = delFlag == 0 ? "恢复" : "删除";
        Common.bs.confirm("你确认要" + message + "该用户信息吗？", function () {
            $.ajax({
                //url: '${ctx}/sysUser/delete/' + id+"/"+delFlag,
                url: '${ctx}/sysUser/deleteById?id=' + id,
                method: 'get',
                success: function (result) {
                    if (result.success) {
                        Common.bs.msg(message + "成功！");
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
     * 角色分配
     * @param id
     */
    function grant(name, id) {
        $("#grant-name").val(name);
        $("#grant-userId").val(id);
        $.ajax({
            url: '${ctx}/sysUserRole/roles',
            method: 'post',
            data: {
                userId: id
            },
            success: function (result) {
                if (result.success) {
                    var opts = "";
                    for (var i = 0; i < result.data.length; i++) {
                        var role = result.data[i];
                        opts += "<label class='checkbox-inline'>";
                        if (role.checked) {
                            opts += "&nbsp;<input type='checkbox' name='role' value='" + role.id + "' checked='checked'>" + role.name + "</input>";
                        } else {
                            opts += "&nbsp;<input type='checkbox' name='role' value='" + role.id + "'>" + role.name + "</input>";
                        }
                        opts += "</label>"
                    }
                    $("#grant-role").html(opts);
                } else {
                    Common.bs.alert(result.message);
                }
            },
            error: function () {
                Common.bs.alert("服务器内部错误，请联系管理员");
            }
        });
        $grantModal.modal({backdrop: false});
    }
    //授权保存
    $("#grant-save").on('click', function () {
        var params = $.boco.serialize("#grant-form");
        $.ajax({
            url: '${ctx}/sysUserRole/grant',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function (result) {
                if (result.success) {
                    $grantModal.modal('hide');
                    Common.bs.msg('分配角色成功');
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
</script>

</body>
</html>
