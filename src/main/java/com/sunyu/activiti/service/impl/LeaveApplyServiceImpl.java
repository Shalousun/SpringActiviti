package com.sunyu.activiti.service.impl;

import com.sunyu.activiti.dao.LeaveApplyDao;
import com.sunyu.activiti.model.LeaveApply;
import com.sunyu.activiti.service.LeaveApplyService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.PvmTransition;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * @author yu
 * @date 2017-07-11 19:30:29
 */
@Service("leaveApplyService")
public class LeaveApplyServiceImpl implements LeaveApplyService {

    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(LeaveApplyService.class);

    @Resource
    private LeaveApplyDao leaveApplyDao;

    @Resource
    IdentityService identityservice;

    @Resource
    RuntimeService runtimeservice;

    @Resource
    TaskService taskservice;


    @Override
    public ProcessInstance startWorkflow(LeaveApply apply, String userId, Map<String, Object> variables) {
        apply.setApplyTime(new Date().toString());
        apply.setUserId(userId);
        leaveApplyDao.save(apply);
        //使用leaveapply表的主键作为businesskey,连接业务数据和流程数据
        String businessKey = String.valueOf(apply.getId());
        identityservice.setAuthenticatedUserId(userId);
        ProcessInstance instance = runtimeservice.startProcessInstanceByKey("leave", businessKey, variables);
        System.out.println(businessKey);
        String instanceId = instance.getId();
        apply.setProcessInstanceId(instanceId);
        leaveApplyDao.update(apply);
        return instance;
    }

    @Override
    public List<LeaveApply> getPageDeptTask(String userId, int firstRow, int rowCount) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateGroup("部门经理").listPage(firstRow, rowCount);
        return this.taskToLeaveApply(tasks);

    }

    @Override
    public int getAllDeptTask(String userId) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateGroup("部门经理").list();
        return tasks.size();
    }

    @Override
    public List<LeaveApply> getPageHRTask(String userId, int firstRow, int rowCount) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateGroup("人事").listPage(firstRow, rowCount);
        return this.taskToLeaveApply(tasks);
    }

    @Override
    public int getAllHRTask(String userId) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateGroup("人事").list();
        return tasks.size();
    }

    @Override
    public List<LeaveApply> getPageCancelLeaveTask(String userId, int firstRow, int rowCount) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateOrAssigned(userId).taskName("销假")
                .listPage(firstRow, rowCount);
        return this.taskToLeaveApply(tasks);
    }

    @Override
    public int getAllCancelLeaveTask(String userId) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateGroup("销假").list();
        return tasks.size();
    }


    @Override
    public List<LeaveApply> getPageUpdateApplyTask(String userId, int firstRow, int rowCount) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateOrAssigned(userId).taskName("调整申请")
                .listPage(firstRow, rowCount);
        return this.taskToLeaveApply(tasks);
    }

    @Override
    public int getAllUpdateApplyTask(String userId) {
        List<Task> tasks = taskservice.createTaskQuery().taskCandidateGroup("销假申请").list();
        return tasks.size();
    }


    @Override
    public void completeReportBack(String taskId, String realStartTime, String realEndTime) {
        Task task = taskservice.createTaskQuery().taskId(taskId).singleResult();
        String instanceId = task.getProcessInstanceId();
        ProcessInstance ins = runtimeservice.createProcessInstanceQuery().processInstanceId(instanceId).singleResult();
        String businessKey = ins.getBusinessKey();
        LeaveApply a = leaveApplyDao.queryById(Integer.parseInt(businessKey));
        a.setRealityStartTime(realStartTime);
        a.setRealityEndTime(realEndTime);
        leaveApplyDao.update(a);
        taskservice.complete(taskId);
    }

    @Override
    public void updateComplete(String taskId, LeaveApply leave, String reapply) {
        Task task = taskservice.createTaskQuery().taskId(taskId).singleResult();
        String instanceId = task.getProcessInstanceId();
        ProcessInstance ins = runtimeservice.createProcessInstanceQuery().processInstanceId(instanceId).singleResult();
        String businessKey = ins.getBusinessKey();
        LeaveApply a = leaveApplyDao.queryById(Integer.parseInt(businessKey));
        a.setLeaveType(leave.getLeaveType());
        a.setStartTime(leave.getStartTime());
        a.setEndTime(leave.getEndTime());
        a.setReason(leave.getReason());
        Map<String, Object> variables = new HashMap<>();
        variables.put("reapply", reapply);
        if ("true".equals(reapply)) {
            leaveApplyDao.update(a);
            taskservice.complete(taskId, variables);
        } else {
            taskservice.complete(taskId, variables);
        }
    }

    @Override
    public List<String> getHighLightedFlows(ProcessDefinitionEntity processDefinitionEntity,
                                            List<HistoricActivityInstance> historicActivityInstances) {

        List<String> highFlows = new ArrayList<>();// 用以保存高亮的线flowId
        // 对历史流程节点进行遍历
        for (int i = 0; i < historicActivityInstances.size(); i++) {
            // 得 到节点定义的详细信息
            ActivityImpl activityImpl = processDefinitionEntity
                    .findActivity(historicActivityInstances.get(i).getActivityId());
            List<ActivityImpl> sameStartTimeNodes = new ArrayList<>();// 用以保存后需开始时间相同的节点
            if ((i + 1) >= historicActivityInstances.size()) {
                break;
            }
            // 将后面第一个节点放在时间相同节点的集合里
            ActivityImpl sameActivityImpl1 = processDefinitionEntity
                    .findActivity(historicActivityInstances.get(i + 1).getActivityId());
            sameStartTimeNodes.add(sameActivityImpl1);
            for (int j = i + 1; j < historicActivityInstances.size() - 1; j++) {
                // 后续第一个节点
                HistoricActivityInstance activityImpl1 = historicActivityInstances.get(j);
                // 后续第二个节点
                HistoricActivityInstance activityImpl2 = historicActivityInstances.get(j + 1);
                // 如果第一个节点和第二个节点开始时间相同保存
                if (activityImpl1.getStartTime().equals(activityImpl2.getStartTime())) {
                    ActivityImpl sameActivityImpl2 = processDefinitionEntity.findActivity(activityImpl2.getActivityId());
                    sameStartTimeNodes.add(sameActivityImpl2);
                } else {
                    // 有不相同跳出循环
                    break;
                }
            }
            // 取出节点的所有出去的线
            List<PvmTransition> pvmTransitions = activityImpl.getOutgoingTransitions();
            // 对所有的线进行遍历
            for (PvmTransition pvmTransition : pvmTransitions) {
                // 如果取出的线的目标节点存在时间相同的节点里，保存该线的id，进行高亮显示
                ActivityImpl pvmActivityImpl = (ActivityImpl) pvmTransition.getDestination();
                if (sameStartTimeNodes.contains(pvmActivityImpl)) {
                    highFlows.add(pvmTransition.getId());
                }
            }
        }
        return highFlows;
    }


    /**
     * 将task数组转化成leaveApply数据
     * @param taskList
     * @return
     */
    private List<LeaveApply> taskToLeaveApply(List<Task> taskList) {
        List<LeaveApply> results = new ArrayList<>();
        for (Task task : taskList) {
            String instanceId = task.getProcessInstanceId();
            ProcessInstance ins = runtimeservice.createProcessInstanceQuery().processInstanceId(instanceId).singleResult();
            String businessKey = ins.getBusinessKey();
            LeaveApply a = leaveApplyDao.queryById(Integer.parseInt(businessKey));
            a.setTask(task);
            results.add(a);
        }
        return results;
    }

    @Override
    public LeaveApply getLeave(int id) {
        return leaveApplyDao.queryById(id);
    }
}