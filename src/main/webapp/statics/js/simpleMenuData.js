var menuData = [{
    name: "我的请假",
    icon: "fa fa-edit",
    children: [{
        name: '我发起的请假',
        url: '../leave/myLeaveList'
    },{
        name:'我的历史请假',
        url:'../leave/myFinishLeaveList'
    },{
        name:'调整请假',
        url:'../leave/toModifyList'
    },{
        name:'销假',
        url:'../leave/toReportBackList'
    }]
}, {
    name : '我的待办任务',
    icon : 'fa fa-desktop',
    children : [ {
        name : '部门经理审批',
        url : '../leave/deptLeaderAudit'
    }, {
        name : '人事审批',
        url : '../leave/toHrAudit'
    }]
},  {
    name : '流程管理',
    icon : 'fa fa-cc-visa',
    children : [ {
        name : '已部署的流程',
        url : '../process/toProcessList'
    },{
        name:'设计流程',
        url:'../modeler.jsp'
    },{
        name:'模型管理',
        url:'../model/listPage'
    }]
}, {
    name : '权限管理',
    icon : 'fa fa-share-alt',
    children : [ {
        name : '用户管理',
        url : '../user/listPage'
    }, {
        name : '角色管理',
        url : '../role/listPage'
    },{
        name:'权限管理',
        url:'../permission/listPage'
    } ]
}]