package com.sunyu.activiti.dao;

import com.sunyu.activiti.model.Permission;

import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:52
 *
 *
 */

public interface PermissionDao {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	int save(Permission entity);

    /**
     * 批量添加数据
     * @param entityList
     * @return
     */
	int batchSave(List<Permission> entityList);

	/**
	 * 更新数据
	 * @param entity
	 * @return
     */
	int update(Permission entity);

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
	Permission queryById(int id);

	/**
	 * 分页查询数据
	 * @return
     */
	List<Permission> queryPage();
}