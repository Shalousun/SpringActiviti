package com.sunyu.activiti.dao;

import com.sunyu.activiti.model.RolePermission;

import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-13 22:39:31
 *
 *
 */

public interface RolePermissionDao {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	int save(RolePermission entity);

    /**
     * 批量添加数据
     * @param entityList
     * @return
     */
	int batchSave(List<RolePermission> entityList);

	/**
	 * 更新数据
	 * @param entity
	 * @return
     */
	int update(RolePermission entity);

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
	RolePermission queryById(int id);

	/**
	 * 分页查询数据
	 * @return
     */
	List<RolePermission> getRolePermissions(Long roleId);
}