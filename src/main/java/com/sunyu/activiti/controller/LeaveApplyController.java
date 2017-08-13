package com.sunyu.activiti.controller;

import com.alibaba.fastjson.JSON;
import com.boco.common.model.CommonResult;
import com.boco.common.util.StringUtil;
import com.sunyu.activiti.constant.GlobConstants;
import com.sunyu.activiti.model.LeaveApply;
import com.sunyu.activiti.model.Permission;
import com.sunyu.activiti.model.RolePermission;
import com.sunyu.activiti.model.UserRole;
import com.sunyu.activiti.service.LeaveApplyService;
import com.sunyu.activiti.service.RolePermissionService;
import com.sunyu.activiti.service.UserRoleService;
import com.sunyu.activiti.vo.DataGrid;
import com.sunyu.activiti.vo.HistoryProcess;
import com.sunyu.activiti.vo.LeaveTask;
import com.sunyu.activiti.vo.RunningProcess;
import org.activiti.engine.HistoryService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricProcessInstanceQuery;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.runtime.ProcessInstanceQuery;
import org.activiti.engine.task.Task;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yu on 2017/7/11.
 */
@Controller
@RequestMapping("leave")
public class LeaveApplyController {

    private static final Logger logger = LoggerFactory.getLogger(LeaveApplyController.class);

    @Resource
    private LeaveApplyService leaveApplyService;

    @Resource
    private UserRoleService userRoleService;


    @Resource
    private RolePermissionService rolePermissionService;

    @Resource
    private RuntimeService runtimeService;

    @Resource
    private RepositoryService repositoryService;

    @Resource
    private HistoryService historyService;

    @Resource
    private TaskService taskservice;

    /**
     * 开始请假
     *
     * @param apply
     * @param session
     * @return
     */
    @RequestMapping(value = "/startLeave", method = RequestMethod.POST)
    @ResponseBody
    public CommonResult start_leave(@RequestBody LeaveApply apply, HttpSession session) {
        CommonResult result = new CommonResult();
        String userId = (String) session.getAttribute("username");
        Map<String, Object> variables = new HashMap<>();
        variables.put("applyuserid", userId);
        ProcessInstance ins = leaveApplyService.startWorkflow(apply, userId, variables);
        logger.debug("流程id:{} 已启动", ins.getId());
        result.setMessage("流程启动成功");
        result.setSuccess(true);
        return result;
    }

    /**
     * 部门领导任务
     *
     * @param session
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/deptTaskList", produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public DataGrid<LeaveTask> getDeptTaskList(HttpSession session, int pageNumber, int pageSize) throws Exception {
        DataGrid<LeaveTask> grid = new DataGrid<>();
        grid.setRowCount(pageSize);
        grid.setCurrent(pageNumber);
        grid.setTotal(0);
        grid.setRows(new ArrayList<LeaveTask>());
        //先做权限检查，对于没有部门领导审批权限的用户,直接返回空
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        int id = (Integer) session.getAttribute(GlobConstants.USER_ID);

        List<UserRole> userRoles = userRoleService.getByUserId(String.valueOf(id));
        System.out.println("userRole:" + JSON.toJSONString(userRoles));
        if (userRoles == null) {
            //没有权限
            return grid;
        }
        boolean flag = false;//默认没有权限
        for (UserRole userRole : userRoles) {
            Long roleId = userRole.getRoleId();
            List<RolePermission> rolePermissions = rolePermissionService.getRolePermissions(roleId);
            System.out.println("rolePermissions:" + JSON.toJSONString(rolePermissions));
            for (RolePermission rolePermission : rolePermissions) {
                Permission permission = rolePermission.getPermission();
                if ("部门领导审批".equals(permission.getPermissionName())) {
                    flag = true;
                } else {
                    continue;
                }
            }
        }

        //无权限
        if (flag == false) {
            return grid;
        } else {
            int firstRow = (pageNumber - 1) * pageSize;
            List<LeaveApply> results = null;
            try {
                results = leaveApplyService.getPageDeptTask(userId, firstRow, pageSize);
            } catch (Exception e) {
                e.printStackTrace();
            }

            int totalSize = leaveApplyService.getAllDeptTask(userId);
            List<LeaveTask> tasks = new ArrayList<>();
            for (LeaveApply apply : results) {
                LeaveTask task = new LeaveTask();
                task.setApplyTime(apply.getApplyTime());
                task.setUserId(apply.getUserId());
                task.setEndTime(apply.getEndTime());
                task.setId(apply.getId());
                task.setLeaveType(apply.getLeaveType());
                task.setProcessInstanceId(apply.getProcessInstanceId());
                task.setProcessDefid(apply.getTask().getProcessDefinitionId());
                task.setReason(apply.getReason());
                task.setStartTime(apply.getStartTime());
                task.setTaskCreateTime(apply.getTask().getCreateTime());
                task.setTaskId(apply.getTask().getId());
                task.setTaskName(apply.getTask().getName());
                tasks.add(task);
            }
            grid.setRowCount(pageSize);
            grid.setCurrent(pageNumber);
            grid.setTotal(totalSize);
            grid.setRows(tasks);
            return grid;
        }
    }

    @ResponseBody
    @GetMapping(value = "/testDeptTask")
    public List<LeaveApply> getPageDeptTask() {
        List<LeaveApply> result = leaveApplyService.getPageDeptTask("35", 0, 100);

        return result;
    }

    /**
     * hr的审批任务
     *
     * @param session
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/hrTaskList", produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public DataGrid<LeaveTask> getHrTaskList(HttpSession session, int pageNumber, int pageSize) throws Exception {
        DataGrid<LeaveTask> grid = new DataGrid<>();
        grid.setRowCount(pageSize);
        grid.setCurrent(pageNumber);
        grid.setTotal(0);
        grid.setRows(new ArrayList<LeaveTask>());
        //先做权限检查，对于没有部门领导审批权限的用户,直接返回空
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        int id = (Integer) session.getAttribute(GlobConstants.USER_ID);

        List<UserRole> userRoles = userRoleService.getByUserId(String.valueOf(id));

        if (userRoles == null) {
            //没有权限
            return grid;
        }
        boolean flag = false;//默认没有权限
        for (UserRole userRole : userRoles) {
            Long roleId = userRole.getRoleId();
            List<RolePermission> rolePermissions = rolePermissionService.getRolePermissions(roleId);
            for (RolePermission rolePermission : rolePermissions) {
                Permission permission = rolePermission.getPermission();
                if ("人事审批".equals(permission.getPermissionName())) {
                    flag = true;
                } else {
                    continue;
                }
            }
        }

        //无权限
        if (flag == false) {
            return grid;
        } else {
            int firstRow = (pageNumber - 1) * pageSize;
            List<LeaveApply> results = leaveApplyService.getPageHRTask(userId, firstRow, pageSize);
            int totalSize = leaveApplyService.getAllHRTask(userId);
            List<LeaveTask> tasks = new ArrayList<>();
            for (LeaveApply apply : results) {
                LeaveTask task = new LeaveTask();
                task.setApplyTime(apply.getApplyTime());
                task.setUserId(apply.getUserId());
                task.setEndTime(apply.getEndTime());
                task.setId(apply.getId());
                task.setLeaveType(apply.getLeaveType());
                task.setProcessInstanceId(apply.getProcessInstanceId());
                task.setProcessDefid(apply.getTask().getProcessDefinitionId());
                task.setReason(apply.getReason());
                task.setStartTime(apply.getStartTime());
                task.setTaskCreateTime(apply.getTask().getCreateTime());
                task.setTaskId(apply.getTask().getId());
                task.setTaskName(apply.getTask().getName());
                tasks.add(task);
            }
            grid.setRowCount(pageSize);
            grid.setCurrent(pageNumber);
            grid.setTotal(totalSize);
            grid.setRows(tasks);
            return grid;
        }
    }

    /**
     * 我发起的请假流程
     *
     * @param session
     * @param pageNumber 当前页码
     * @param pageSize   页面大小
     * @return
     */
    @RequestMapping("setupProcess")
    @ResponseBody
    public DataGrid<RunningProcess> setupProcess(HttpSession session, int pageNumber, int pageSize) {
        int firstRow = (pageNumber - 1) * pageSize;
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        ProcessInstanceQuery query = runtimeService.createProcessInstanceQuery();
        int total = (int) query.count();
        List<ProcessInstance> a = query.processDefinitionKey("leave").involvedUser(userId).listPage(firstRow, total);
        List<RunningProcess> list = new ArrayList<>();
        for (ProcessInstance p : a) {
            RunningProcess process = new RunningProcess();
            process.setActivityId(p.getActivityId());
            process.setBusinessKey(p.getBusinessKey());
            process.setExecutionId(p.getId());
            process.setProcessInstanceId(p.getProcessInstanceId());
            LeaveApply l = leaveApplyService.getLeave(Integer.parseInt(p.getBusinessKey()));
            if (l.getUserId().equals(userId)) {
                list.add(process);
            } else {
                continue;
            }
        }
        DataGrid<RunningProcess> grid = new DataGrid<>();
        grid.setCurrent(pageNumber);
        grid.setRowCount(pageSize);
        grid.setTotal(total);
        grid.setRows(list);
        return grid;
    }

    /**
     * 获取历史请记录
     *
     * @param session
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping("/getFinishProcess")
    @ResponseBody
    public DataGrid<HistoryProcess> getHistory(HttpSession session, int pageNumber, int pageSize) {
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        HistoricProcessInstanceQuery process = historyService.createHistoricProcessInstanceQuery().processDefinitionKey("leave").startedBy(userId).finished();
        int total = (int) process.count();
        int firstRow = (pageNumber - 1) * pageSize;
        List<HistoricProcessInstance> info = process.listPage(firstRow, pageSize);
        List<HistoryProcess> list = new ArrayList<>();
        for (HistoricProcessInstance history : info) {
            HistoryProcess his = new HistoryProcess();
            String businessKey = history.getBusinessKey();
            LeaveApply apply = leaveApplyService.getLeave(Integer.parseInt(businessKey));
            his.setLeaveApply(apply);
            his.setBusinessKey(businessKey);
            his.setProcessDefinitionId(history.getProcessDefinitionId());
            list.add(his);
        }
        DataGrid<HistoryProcess> grid = new DataGrid<>();
        grid.setCurrent(pageNumber);
        grid.setRowCount(pageSize);
        grid.setTotal(total);
        grid.setRows(list);
        return grid;
    }

    /**
     * 部门领导审批
     *
     * @param session
     * @param taskId
     * @param req
     * @return
     */
    @RequestMapping(value = "/task/deptComplete")
    @ResponseBody
    public CommonResult deptComplete(HttpSession session, String taskId, HttpServletRequest req) {
        CommonResult result = new CommonResult();
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        Map<String, Object> variables = new HashMap<>();
        String approve = req.getParameter("approve");
        if (StringUtil.isEmpty(approve)) {
            result.setMessage("审批意见不能空");
            return result;
        }
        if (StringUtil.isEmpty(taskId)) {
            result.setMessage("数据异常，无法进行审批操作");
            return result;
        }
        //deptleaderapprove必须和流程中设计的名称一样
        variables.put("deptleaderapprove", approve);
        taskservice.claim(taskId, userId);
        taskservice.complete(taskId, variables);
        result.setSuccess(true);
        result.setMessage("success");
        return result;
    }

    /**
     * hr审批领导
     *
     * @param session
     * @param taskId
     * @param req
     * @return
     */
    @RequestMapping(value = "/task/hrComplete")
    @ResponseBody
    public CommonResult hrComplete(HttpSession session, String taskId, HttpServletRequest req) {
        CommonResult result = new CommonResult();
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        Map<String, Object> variables = new HashMap<>();
        String approve = req.getParameter("approve");
        if (StringUtil.isEmpty(approve)) {
            result.setMessage("审批意见不能空");
            return result;
        }
        if (StringUtil.isEmpty(taskId)) {
            result.setMessage("数据异常，无法进行审批操作");
            return result;
        }
        //hrapprove必须和流程中设计的名称一样
        variables.put("hrapprove", approve);
        taskservice.claim(taskId, userId);
        taskservice.complete(taskId, variables);
        result.setMessage("审批成功");
        result.setSuccess(true);
        return result;
    }

    /**
     * 调整申请的请假记录
     *
     * @param session
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/updateTaskList", produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public String getUpdateTaskList(HttpSession session, int pageNumber, int pageSize) {
        int firstRow = (pageNumber - 1) * pageSize;
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        List<LeaveApply> results = leaveApplyService.getPageUpdateApplyTask(userId, firstRow, pageSize);
        int totalSize = leaveApplyService.getAllUpdateApplyTask(userId);
        List<LeaveTask> tasks = new ArrayList<>();
        for (LeaveApply apply : results) {
            LeaveTask task = new LeaveTask();
            task.setApplyTime(apply.getApplyTime());
            task.setUserId(apply.getUserId());
            task.setEndTime(apply.getEndTime());
            task.setId(apply.getId());
            task.setLeaveType(apply.getLeaveType());
            task.setProcessInstanceId(apply.getProcessInstanceId());
            task.setProcessDefid(apply.getTask().getProcessDefinitionId());
            task.setReason(apply.getReason());
            task.setStartTime(apply.getStartTime());
            task.setTaskCreateTime(apply.getTask().getCreateTime());
            task.setTaskId(apply.getTask().getId());
            task.setTaskName(apply.getTask().getName());
            tasks.add(task);
        }
        DataGrid<LeaveTask> grid = new DataGrid<>();
        grid.setRowCount(pageSize);
        grid.setCurrent(pageNumber);
        grid.setTotal(totalSize);
        grid.setRows(tasks);
        return JSON.toJSONString(grid);
    }

    /**
     * 完成调整申请记录
     *
     * @param taskId  任务名称
     * @param leave   请假对象
     * @param reapply 是否重新审true或者false
     * @return
     */
    @RequestMapping(value = "/task/updateComplete")
    @ResponseBody
    public CommonResult updateComplete(@RequestParam("taskId") String taskId,
                                       @ModelAttribute("leave") LeaveApply leave,
                                       @RequestParam("reapply") String reapply) {
        CommonResult result = new CommonResult();
        if (StringUtil.isEmpty(taskId)) {
            result.setMessage("未接收到taskId参数");
            return result;
        }
        if (StringUtil.isEmpty(reapply)) {
            result.setMessage("请选择你是否需要调整请假申请");
            return result;
        }

        leaveApplyService.updateComplete(taskId, leave, reapply);
        return result;
    }

    /**
     * 销假列表
     *
     * @param session
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/xjTaskList", produces = {"application/json;charset=UTF-8"})
    @ResponseBody
    public String getXJTaskList(HttpSession session, int pageNumber, int pageSize) {
        int firstRow = (pageNumber - 1) * pageSize;
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        List<LeaveApply> results = leaveApplyService.getPageCancelLeaveTask(userId, firstRow, pageSize);
        int totalSize = leaveApplyService.getAllCancelLeaveTask(userId);
        List<LeaveTask> tasks = new ArrayList<>();
        for (LeaveApply apply : results) {
            LeaveTask task = new LeaveTask();
            task.setApplyTime(apply.getApplyTime());
            task.setUserId(apply.getUserId());
            task.setEndTime(apply.getEndTime());
            task.setId(apply.getId());
            task.setLeaveType(apply.getLeaveType());
            task.setProcessInstanceId(apply.getProcessInstanceId());
            task.setProcessDefid(apply.getTask().getProcessDefinitionId());
            task.setReason(apply.getReason());
            task.setStartTime(apply.getStartTime());
            task.setTaskCreateTime(apply.getTask().getCreateTime());
            task.setTaskId(apply.getTask().getId());
            task.setTaskName(apply.getTask().getName());
            tasks.add(task);
        }
        DataGrid<LeaveTask> grid = new DataGrid<>();
        grid.setRowCount(pageSize);
        grid.setCurrent(pageNumber);
        grid.setTotal(totalSize);
        grid.setRows(tasks);
        return JSON.toJSONString(grid);
    }

    /**
     * //参与的正在运行的请假流程
     * @param session
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping("involvedProcess")
    @ResponseBody
    public DataGrid<RunningProcess> allExecution(HttpSession session,int pageNumber,int pageSize) {
        int firstRow = (pageNumber- 1) * pageSize;
        String userId = (String) session.getAttribute(GlobConstants.USER_NAME);
        ProcessInstanceQuery query = runtimeService.createProcessInstanceQuery();
        int total = (int) query.count();
        List<ProcessInstance> a = query.processDefinitionKey("leave").involvedUser(userId).listPage(firstRow,pageSize);
        List<RunningProcess> list = new ArrayList<>();
        for (ProcessInstance p : a) {
            RunningProcess process = new RunningProcess();
            process.setActivityId(p.getActivityId());
            process.setBusinessKey(p.getBusinessKey());
            process.setExecutionId(p.getId());
            process.setProcessInstanceId(p.getProcessInstanceId());
            list.add(process);
        }
        DataGrid<RunningProcess> grid = new DataGrid<>();
        grid.setCurrent(pageNumber);
        grid.setRowCount(pageSize);
        grid.setTotal(total);
        grid.setRows(list);
        return grid;
    }
    /**
     * 获取已经处理的任务信息
     *
     * @param taskId 任务编号
     * @return
     */
    @RequestMapping(value = "/dealTask/{taskId}")
    @ResponseBody
    public CommonResult taskDeal(@PathVariable String taskId) {

        CommonResult result = new CommonResult();
        Task task = taskservice.createTaskQuery().taskId(taskId).singleResult();
        ProcessInstance process = runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult();
        LeaveApply leave = leaveApplyService.getLeave(new Integer(process.getBusinessKey()));
        if (null != leave){
            result.setSuccess(true);
            result.setData(leave);
        }else{
            result.setMessage("未查询到相关任务");
        }
        return result;
    }

    /**
     * 处理销假信息
     *
     * @param taskId
     * @param req
     * @return
     */
    @RequestMapping(value = "/task/reportComplete")
    @ResponseBody
    public CommonResult reportBackComplete(String taskId, HttpServletRequest req) {
        CommonResult result = new CommonResult();
        String realStartTime = req.getParameter("realStartTime");
        String realEndTime = req.getParameter("realEndTime");

        if (StringUtil.isEmpty(realStartTime)) {
            result.setMessage("实际申请时间");
            return result;
        }
        if (StringUtil.isEmpty(realEndTime)) {
            result.setMessage("实际结束时间");
            return result;
        }
        if (StringUtil.isEmpty(taskId)) {
            result.setMessage("任务的编号不能为空");
            return result;
        }
        leaveApplyService.completeReportBack(taskId, realStartTime, realEndTime);
        result.setSuccess(true);
        result.setMessage("销假成功");
        return result;
    }

    /**
     * 根据流程实例id查看流程信息
     * @param instanceId
     * @return
     */
    @RequestMapping("/processInfo/{instanceId}")
    @ResponseBody
    public List<HistoricActivityInstance> processInfo(@PathVariable String instanceId) {
        List<HistoricActivityInstance> his = historyService.createHistoricActivityInstanceQuery()
                .processInstanceId(instanceId)
                .orderByHistoricActivityInstanceStartTime().asc().list();
        return his;
    }
    /**
     * 转到我的请假页面
     *
     * @return
     */
    @RequestMapping("/myLeaveList")
    public String toMyLeavePage() {
        return "/leaves/myLeaves";
    }

    /**
     * 转到我的历史请假页面
     *
     * @return
     */
    @RequestMapping("/myFinishLeaveList")
    public String toFinishProcess() {
        return "/leaves/historyProcess";
    }

    /**
     * 转到hr审批页面
     *
     * @return
     */
    @RequestMapping("/toHrAudit")
    public String toHrTaskList() {
        return "/leaves/hrAudit";
    }

    /**
     * 转到部门领导审批页面
     *
     * @return
     */
    @GetMapping("/deptLeaderAudit")
    public String toDeptLeader() {
        return "/leaves/deptLeaderAudit";

    }

    /**
     * 转到调整申请页面
     *
     * @return
     */
    @GetMapping("/toModifyList")
    public String toModifyApply() {
        return "/leaves/modifyApply";
    }

    /**
     * 转到销假页面
     * @return
     */
    @GetMapping("/toReportBackList")
    public String toReportBack(){
        return "/leaves/reportBack";
    }

}
