package com.sunyu.activiti.vo;

/**
 * Created by yu on 2017/7/14.
 */
public class RunningProcess {

    /**
     * 执行ID
     */
    private String executionId;

    /**
     * 流程实例ID
     */
    private String processInstanceId;
    /**
     *业务号
     */
    private String businessKey;

    /**
     * 当前节点
     */
    private String activityId;

    public String getExecutionId() {
        return executionId;
    }

    public void setExecutionId(String executionId) {
        this.executionId = executionId;
    }

    public String getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(String processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public String getBusinessKey() {
        return businessKey;
    }

    public void setBusinessKey(String businessKey) {
        this.businessKey = businessKey;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }
}
