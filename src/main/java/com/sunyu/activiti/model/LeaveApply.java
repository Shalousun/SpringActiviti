package com.sunyu.activiti.model;

import org.activiti.engine.task.Task;

import java.io.Serializable;



/**
 * Table:请假申请表
 * @author yu
 * @date 2017-07-11 19:30:29
 *
 */
public class LeaveApply implements Serializable {

    private static final long serialVersionUID = -9063363123653152458L;

   	private Integer id;
	//流程id
	private String processInstanceId;
	//用户编号
	private String userId;
	//开始时间
	private String startTime;
	//结束时间
	private String endTime;
	//请假类型
	private String leaveType;
	//请假原因
	private String reason;
	//请假时间
	private String applyTime;
	//真实起始时间
	private String realityStartTime;
	//真实结束时间
	private String realityEndTime;


	private Task task;

	//getters and setters
   	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getProcessInstanceId() {
		return processInstanceId;
	}

	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getApplyTime() {
		return applyTime;
	}

	public void setApplyTime(String applyTime) {
		this.applyTime = applyTime;
	}

	public String getRealityStartTime() {
		return realityStartTime;
	}

	public void setRealityStartTime(String realityStartTime) {
		this.realityStartTime = realityStartTime;
	}

	public String getRealityEndTime() {
		return realityEndTime;
	}

	public void setRealityEndTime(String realityEndTime) {
		this.realityEndTime = realityEndTime;
	}

	public Task getTask() {
		return task;
	}

	public void setTask(Task task) {
		this.task = task;
	}


}