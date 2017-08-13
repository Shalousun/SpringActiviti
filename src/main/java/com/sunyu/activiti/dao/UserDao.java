package com.sunyu.activiti.dao;

import com.sunyu.activiti.model.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-11 19:30:30
 *
 *
 */

public interface UserDao {

	/**
	 * 保存数据
	 * @param entity
	 * @return
     */
	int save(User entity);

	/**
	 * 更新数据
	 * @param entity
	 * @return
     */
	int update(User entity);

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
	User queryById(int id);

	/**
	 * 根据用户名获取用户
	 * @param username
	 * @return
     */
	User queryByUserName(@Param("username") String username);

	/**
	 * 分页查询数据
	 * @return
     */
	List<User> queryPage();
}