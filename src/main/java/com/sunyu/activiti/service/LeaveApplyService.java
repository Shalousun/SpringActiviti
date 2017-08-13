package com.sunyu.activiti.service;

import com.sunyu.activiti.model.LeaveApply;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.runtime.ProcessInstance;

import java.util.List;
import java.util.Map;

/**
 *
 * @author yu
 * @date 2017-07-11 19:21:57
 *
 */

public interface LeaveApplyService {


	/**
	 * 开启工作流
	 * @param apply
	 * @param userId
	 * @param variables
     * @return
     */
	ProcessInstance startWorkflow(LeaveApply apply, String userId, Map<String, Object> variables);

	/**
	 * 部门领导审批任务列表
	 * @param userId
	 * 			用户编号
	 * @param firstRow
	 * 			分页查询起始位置
	 * @param rowCount
	 * 			每次分页查询多少条
     * @return
     */
	List<LeaveApply> getPageDeptTask(String userId, int firstRow, int rowCount);


	/**
	 * 查询部门领导的所有审批任务数
	 * @param userId
	 * @return
     */
	int getAllDeptTask(String userId);

	/**
	 * 分页查询hr的审批任务
	 * @param userId
	 * @param firstRow
	 * @param rowCount
     * @return
     */
	List<LeaveApply> getPageHRTask(String userId,int firstRow,int rowCount);

	/**
	 * 查询统计hr的所有审批任务数
	 * @param userId
	 * 			用户编号
	 * @return
     */
	int getAllHRTask(String userId);

	/**
	 * 分页查询销假的任务列表
	 * @param userId
	 * 			用户编号
	 * @param firstRow
	 * 			分页的起始页码
	 * @param rowCount
	 * 			每页的大小
     * @return
     */
	List<LeaveApply> getPageCancelLeaveTask(String userId,int firstRow,int rowCount);

	/**
	 * 查询统计所有的销假记录
	 * @param userId
	 * 			用户编号
	 * @return
     */
	int getAllCancelLeaveTask(String userId);

	/**
	 * 分页获取调整申请数据的任务
	 * @param userId
	 * 			用户编号
	 * @param firstRow
	 * 			分页起始位置
	 * @param rowCount
	 * 			每页的大小
     * @return
     */
	List<LeaveApply> getPageUpdateApplyTask(String userId,int firstRow,int rowCount);

	/**
	 * 根据用户编号查询调整请假任务数
	 * @param userId
	 * @return
     */
	int getAllUpdateApplyTask(String userId);

	/**
	 * 销假后的处理
	 * @param taskId
	 * @param realStartTime
	 * @param realEndTime
     */
	void completeReportBack(String taskId, String realStartTime, String realEndTime);

	/**
	 * 更新销假处理
	 * @param taskId
	 * @param leave
	 * @param reapply
	 * 			再申请
     */
	void updateComplete(String taskId, LeaveApply leave,String reapply);

	/**
	 * 获取高亮流程
	 * @param deployedProcessDefinition
	 * @param historicActivityInstances
     * @return
     */
	List<String> getHighLightedFlows(ProcessDefinitionEntity deployedProcessDefinition,
									 List<HistoricActivityInstance> historicActivityInstances);

	/**
	 * 根据业务编号获取请假流程
	 * @param id
	 * @return
     */
	LeaveApply getLeave(int id);

}