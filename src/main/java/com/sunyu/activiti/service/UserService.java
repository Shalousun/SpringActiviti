package com.sunyu.activiti.service;

import com.github.pagehelper.PageInfo;
import com.boco.common.model.CommonResult;
import com.sunyu.activiti.model.User;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */

public interface UserService {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	CommonResult save(User entity);

	/**
	 * 修改数据
	 * @param entity
	 * @return
     */
	CommonResult update(User entity);

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
	 * 根据用户名查询用户
	 * @param userName
	 * @return
     */
	CommonResult<User> queryByUserName(String userName);

	/**
     * 分页查询
     * @param offset 偏移量
     * @param limit 每页大小
     * @return
     */
    PageInfo queryPage(int offset, int limit);
}