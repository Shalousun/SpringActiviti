package com.sunyu.activiti.service.impl;

import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.dao.UserRoleDao;
import com.sunyu.activiti.model.UserRole;
import com.sunyu.activiti.service.UserRoleService;
import org.apache.commons.lang.math.NumberUtils;
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
@Service("userRoleService")
public class UserRoleServiceImpl  implements UserRoleService{

    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(UserRoleService.class);

    @Resource
    private UserRoleDao userRoleDao;
    @Override
    public CommonResult save(UserRole entity) {
        return null;
    }

    @Override
    public CommonResult update(UserRole entity) {
        return null;
    }

    @Override
    public CommonResult delete(int id) {
        return null;
    }

    @Override
    public CommonResult queryById(int id) {
        return null;
    }

    @Override
    public PageInfo queryPage(int offset, int limit) {
        return null;
    }

    @Override
    public List<UserRole> getByUserId(String userId) {
        return userRoleDao.queryByUserId(NumberUtils.toInt(userId,0));
    }
}