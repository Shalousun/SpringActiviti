package com.sunyu.activiti.service;

import com.github.pagehelper.PageInfo;
import com.boco.common.model.CommonResult;
import com.sunyu.activiti.model.Permission;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:52
 *
 */

public interface PermissionService {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	CommonResult save(Permission entity);

	/**
	 * 修改数据
	 * @param entity
	 * @return
     */
	CommonResult update(Permission entity);

	/**
	 * 删除数据
	 * @param id
	 * @return
     */
	CommonResult delete(int id);

	/**
	 * 根据id查询数据
	 * @param id
	 * @return
     */
	CommonResult queryById(int id);

	/**
     * 分页查询
     * @param offset 偏移量
     * @param limit 每页大小
     * @return
     */
    PageInfo queryPage(int offset, int limit);
}