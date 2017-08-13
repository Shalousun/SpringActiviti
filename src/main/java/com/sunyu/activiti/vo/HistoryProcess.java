package com.sunyu.activiti.vo;


import com.sunyu.activiti.model.LeaveApply;

public class HistoryProcess {
	private String processDefinitionId;
	private String businessKey;
	private LeaveApply leaveApply;

	public String getProcessDefinitionId() {
		return processDefinitionId;
	}

	public void setProcessDefinitionId(String processDefinitionId) {
		this.processDefinitionId = processDefinitionId;
	}

	public String getBusinessKey() {
		return businessKey;
	}

	public void setBusinessKey(String businessKey) {
		this.businessKey = businessKey;
	}

	public LeaveApply getLeaveApply() {
		return leaveApply;
	}

	public void setLeaveApply(LeaveApply leaveApply) {
		this.leaveApply = leaveApply;
	}
}
