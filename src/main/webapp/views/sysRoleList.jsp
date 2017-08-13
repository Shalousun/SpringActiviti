<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
    <title>角色信息列表</title>
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
            <label for="name"  class="control-label">角色名称</label>
            <input type="text" class="form-control" id="name" placeholder="角色名称" style="width: 150px">
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
                <h4 class="modal-title">新增角色信息</h4>
            </div>
            <div class="modal-body">
                <form action="" role="form" class="form-horizontal" id="add-form">

                    <div class="form-group">
                        <label for="add-name" class="control-label col-md-3 inline"><span
                                class="text-red">*</span>角色名称:</label>
                        <div class="col-md-3">
                            <input type="text" class="form-control" placeholder="角色名称" name="name" id="add-name">
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
    <div class="modal-dialog" style="height: 350px;width:550px;">
        <div class="modal-content">
            <div class="modal-header" id="grant-modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">分配权限</h4>
            </div>
            <div class="modal-body">
                <div id="roleGrantLayout" class="" style="width:400px;height: 400px;margin: 0 auto;">
                    <div class="row" style="overflow:auto;width: 300px;height: 305px; padding: 1px;float: left">
                        <div class="well well-small">
                            <form id="roleGrantForm" method="post">
                                <input name="id" id="grant-roleId" type="hidden" value="" readonly="readonly">
                                <ul id="resourceTree"></ul>
                                <input id="resourceIds" name="resourceIds" type="hidden"/>
                            </form>
                        </div>
                    </div>
                    <div style="overflow: hidden; padding: 10px;float:right">
                        <div>
                            <button class="btn btn-success" onclick="checkAll();">全选</button>
                            <br/> <br/>
                            <button class="btn btn-warning" onclick="checkInverse();">反选</button>
                            <br/> <br/>
                            <button class="btn btn-inverse" onclick="unCheckAll();">取消</button>
                        </div>
                    </div>
                </div>
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
<script src="${ctx}/statics/js/easyui/extJs.js"></script>
<script>
    var $table = $("#table");
    $(function () {
        initTable();
    });
    var $grid;
    function initTable() {
        $grid = $table.bootstrapTable({
            url: '${ctx}/role/page',
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
                field: 'rid',
                align: 'center',
                width: 100
            },{
                title: '角色名称',
                field: 'roleName',
                align: 'center',
                width: 100
            }, {
                title: '拥有权限',
                field: 'permissionList',
                align: 'center',
                width: 100,
                formatter: function (value, row) {
                    var str = "";
                    var length = value.length;
                    for(var i =0;i<value.length;i++){
                        if(i<length-1){
                            str += value[i].permissionName+","
                        }else {
                            str += value[i].permissionName;
                        }
                    }
                    return str;
                }
            }, {
                title: '操作',
                field: 'operate',
                align: 'center',
                formatter: function (value, row) {
                    var link = $.boco.format('<a class="btn btn-primary btn-xs" onClick="grant(\'{0}\')"><i class="fa fa-user-o"></i>授权</a>',row.rid);
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
    	loadSystems("#add-systemId",0);
        $addModal.modal({backdrop: false});
    });

    //新增保存信息
    $("#add-save").on('click', function () {
        var params = $.boco.serialize("#add-form");
        console.log(JSON.stringify(params));
        $.ajax({
            url: '${ctx}/sysRole/add',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function (result) {
                if (result.success) {
                    $addModal.modal('hide');
                    $.boco.clearForm("#add-form");
                    Common.bs.msg('添加角色信息成功');
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
    var $resourceTree;
    /**
     * 角色授权
     * @param name
     * @param id
     */
    function grant(name, id,systemId) {
        $("#grant-roleId").val(id);
        $resourceTree = $('#resourceTree').tree({
            url: '${ctx}/sysResources/allResourceTree?systemId='+systemId,
            method: 'get',
            parentField: 'pid',
            lines: true,
            checkbox: true,
            onClick: function (node) {
            },
            onLoadSuccess: function (node, data) {
                $.post('${ctx}/sysRoleResource/resourceIdList', {
                    roleId: id,
                    systemId:systemId
                }, function (result) {
                    var ids;
                    if (result.success && result.data != undefined) {
                        var ids = result.data;
                        for (var i = 0; i < ids.length; i++) {
                            if ($resourceTree.tree('find', ids[i])) {
                                $resourceTree.tree('check', $resourceTree.tree('find', ids[i]).target);
                            }
                        }
                    }
                }, 'json');
                $("#roleGrantLayout").show();
            },
            cascadeCheck: true
        });
        $grantModal.modal({backdrop: false});
    }
    $("#grant-save").click(function () {
        //var checkNodes = $resourceTree.tree('getChecked');
        var checkNodes = $('#resourceTree').tree('getChecked',['checked','indeterminate']);
        var ids = [];
        if (checkNodes && checkNodes.length > 0) {
             for (var i = 0; i < checkNodes.length; i++) {
                ids.push(checkNodes[i].id);
            }             
        }
        console.log("ids:"+ids);   
        $.ajax({
            url: '${ctx}/sysRoleResource/grant/',
            method: 'post',
            dataType: 'json',
            traditional:true,
            data: {
            	roleId: $("#grant-roleId").val(),
                resourcesId: ids
            },
            success: function (result) {
                if (result.success) {
                    Common.bs.msg("授权成功！");
                    $grantModal.modal('hide');
                } else {
                    Common.bs.alert(result.message);
                }
            },
            error: function () {
                Common.bs.alert("服务器内部错误，请联系管理员");
            }
        });
    })
    function checkAll() {
        var nodes = $resourceTree.tree('getChecked', 'unchecked');
        if (nodes && nodes.length > 0) {
            for (var i = 0; i < nodes.length; i++) {
                $resourceTree.tree('check', nodes[i].target);
            }
        }
    }
    function unCheckAll() {
        var nodes = $resourceTree.tree('getChecked');
        if (nodes && nodes.length > 0) {
            for (var i = 0; i < nodes.length; i++) {
                $resourceTree.tree('uncheck', nodes[i].target);
            }
        }
    }
    function checkInverse() {
        var unCheckNodes = $resourceTree.tree('getChecked', 'unchecked');
        var checkNodes = $resourceTree.tree('getChecked');
        if (unCheckNodes && unCheckNodes.length > 0) {
            for (var i = 0; i < unCheckNodes.length; i++) {
                $resourceTree.tree('check', unCheckNodes[i].target);
            }
        }
        if (checkNodes && checkNodes.length > 0) {
            for (var i = 0; i < checkNodes.length; i++) {
                $resourceTree.tree('uncheck', checkNodes[i].target);
            }
        }
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
    /**
     * 树的回显
     * @param appender 附加到该dom
     * @param id 用于回显选中的值
     * @param treeUrl加载当前树的url
     */
    function initComboTree(appender, value, treeUrl) {
        $(appender).combotree({
            url: treeUrl,
            method: 'get',
            parentField: 'pid',
            lines: true,
            panelHeight: 'auto',
            value: value
        });
    }
    
    /**
     * 查询系统信息，根据系统编号绑定选中
     * @param appender 需要附加到的元素
     * @param systemId
     * @return deferred对象
     */
    function loadSystems(appender, systemId) {
        return $.ajax({
            url: '${ctx}/sysSystem/list',
            method: 'get',
            dataType: "json",
            success: function (result) {
            	if(result.platforms != null && result.systems != null){
            		var opts;
            		opts += '<option value="0">--请选择--</option>';
            		for(var i = 0;i<result.platforms.length;i++){
            			opts += '<optgroup label="'+result.platforms[i].platformName+'">';
            			var platformId = result.platforms[i].id;  
            			for(var j = 0;j<result.systems.length;j++){
            				if(platformId == result.systems[j].sysPlatformId){
            					if (result.systems[j].id == systemId) {
                                    opts += '<option value="' + result.systems[j].id + '" selected>' + result.systems[j].systemName + '</option>';
                                } else {
                                    opts += '<option value="' + result.systems[j].id + '">' + result.systems[j].systemName + '</option>';
                                }
            				}
            			}
            			opts += '</optgroup>';
            		}
            	}
                $(appender).empty().append(opts);
            },
            error: function () {
                Common.bs.alert("服务器内部错误，请联系管理员");
            }
        });
    }
    
</script>

</body>
</html>
