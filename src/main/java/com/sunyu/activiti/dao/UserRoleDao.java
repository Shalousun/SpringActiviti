package com.sunyu.activiti.dao;

import com.sunyu.activiti.model.UserRole;

import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-13 22:39:31
 *
 *
 */

public interface UserRoleDao {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	int save(UserRole entity);

    /**
     * 批量添加数据
     * @param entityList
     * @return
     */
	int batchSave(List<UserRole> entityList);

	/**
	 * 更新数据
	 * @param entity
	 * @return
     */
	int update(UserRole entity);

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
	UserRole queryById(int id);

	/**
	 * 分页查询数据
	 * @return
     */
	List<UserRole> queryByUserId(int userId);
}