package com.sunyu.activiti.dao;

import com.sunyu.activiti.model.LeaveApply;

import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-11 19:30:29
 *
 *
 */

public interface LeaveApplyDao {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	int save(LeaveApply entity);

    /**
     * 批量添加数据
     * @param entityList
     * @return
     */
	int batchSave(List<LeaveApply> entityList);

	/**
	 * 更新数据
	 * @param entity
	 * @return
     */
	int update(LeaveApply entity);

	/**
	 * 删除数据
	 * @param id
	 * @return
     */
	int delete(int id);

	/**
	 * 根据id查询数据
	 * @param id
	 * @return
     */
	LeaveApply queryById(int id);

	/**
	 * 分页查询数据
	 * @return
     */
	List<LeaveApply> queryPage();
}