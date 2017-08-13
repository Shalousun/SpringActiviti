package com.sunyu.activiti.service.impl;

import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.dao.UserDao;
import com.sunyu.activiti.model.User;
import com.sunyu.activiti.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */
@Service("userService")
public class UserServiceImpl  implements UserService{

    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(UserService.class);

	@Resource
	private UserDao userDao;

	@Override
	public CommonResult save(User entity) {
		CommonResult result = new CommonResult();
        try {
        	userDao.save(entity);
        	result.setSuccess(true);
        } catch (Exception e) {
        	result.setMessage("添加数据失败");
        	logger.error("添加数据异常：",e);
        }
        return result;
	}

	@Override
	public CommonResult update(User entity) {
		CommonResult result = new CommonResult();
        try {
            userDao.update(entity);
            result.setSuccess(true);
        } catch (Exception e) {
            result.setMessage("修改数据失败");
            logger.error("修改数据异常：",e);
        }
        return result;
	}

	@Override
	public CommonResult delete(int id) {
		CommonResult result = new CommonResult();
        try {
            userDao.delete(id);
            result.setSuccess(true);
        } catch (Exception e) {
            result.setMessage("删除数据失败");
            logger.error("删除数据异常：",e);
        }
        return result;
	}



	@Override
	public CommonResult queryById(int id) {
	    CommonResult result = new CommonResult();
	    User entity = userDao.queryById(id);
	    if (null != entity) {
        	result.setData(entity);//成功返回数据
        	result.setSuccess(true);
        } else {
        	result.setMessage("没有找到匹配数据");
        	logger.info("未查询到数据，编号：{}",id);
        }
        return result;
	}

    @Override
    public CommonResult<User> queryByUserName(String userName) {
        CommonResult<User> result = new CommonResult();
        User entity = userDao.queryByUserName(userName);
        if(null != entity){
            result.setData(entity);
            result.setSuccess(true);
        }else{
            result.setMessage("用户名不匹配");
            logger.info("用户名不匹配，username:{}",userName);
        }
        return result;
    }

    @Override
    public PageInfo queryPage(int offset, int limit) {
        PageHelper.offsetPage(offset,limit);
        List<User> list = userDao.queryPage();
        return new PageInfo(list);
    }

}