package com.sunyu.activiti.dao;

import com.sunyu.activiti.model.Role;

import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:52
 *
 *
 */

public interface RoleDao {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	int save(Role entity);


	/**
	 * 更新数据
	 * @param entity
	 * @return
     */
	int update(Role entity);

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
	Role queryById(int id);

	/**
	 * 分页查询数据
	 * @return
     */
	List<Role> queryPage();
}