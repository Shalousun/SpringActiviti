package com.sunyu.activiti.service.impl;

import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.dao.RolePermissionDao;
import com.sunyu.activiti.model.RolePermission;
import com.sunyu.activiti.service.RolePermissionService;
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
@Service("rolePermissionService")
public class RolePermissionServiceImpl  implements RolePermissionService{

    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(RolePermissionService.class);

    @Resource
    private RolePermissionDao rolePermissionDao;
    @Override
    public CommonResult save(RolePermission entity) {
        return null;
    }

    @Override
    public CommonResult update(RolePermission entity) {
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
    public List<RolePermission> getRolePermissions(Long roleId) {
        return this.rolePermissionDao.getRolePermissions(roleId);
    }
}