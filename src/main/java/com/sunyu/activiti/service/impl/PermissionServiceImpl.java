package com.sunyu.activiti.service.impl;

import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.dao.PermissionDao;
import com.sunyu.activiti.model.Permission;
import com.sunyu.activiti.service.PermissionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:52
 *
 */
@Service("permissionService")
public class PermissionServiceImpl  implements PermissionService{

    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(PermissionService.class);

	@Resource
	private PermissionDao permissionDao;

	@Override
	public CommonResult save(Permission entity) {
		CommonResult result = new CommonResult();
        try {
        	permissionDao.save(entity);
        	result.setSuccess(true);
        } catch (Exception e) {
        	result.setMessage("添加数据失败");
        	logger.error("添加数据异常：",e);
        }
        return result;
	}

	@Override
	public CommonResult update(Permission entity) {
		CommonResult result = new CommonResult();
        try {
            permissionDao.update(entity);
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
            permissionDao.delete(id);
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
	    Permission entity = permissionDao.queryById(id);
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
    public PageInfo queryPage(int offset, int limit) {
        PageHelper.offsetPage(offset,limit);
        List<Permission> list = permissionDao.queryPage();
        return new PageInfo(list);
    }

}