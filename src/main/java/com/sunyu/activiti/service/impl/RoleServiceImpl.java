package com.sunyu.activiti.service.impl;

import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.dao.RoleDao;
import com.sunyu.activiti.model.Role;
import com.sunyu.activiti.service.RoleService;
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
@Service("roleService")
public class RoleServiceImpl  implements RoleService{

    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(RoleService.class);

	@Resource
	private RoleDao roleDao;

	@Override
	public CommonResult save(Role entity) {
		CommonResult result = new CommonResult();
        try {
        	roleDao.save(entity);
        	result.setSuccess(true);
        } catch (Exception e) {
        	result.setMessage("添加数据失败");
        	logger.error("添加数据异常：",e);
        }
        return result;
	}

	@Override
	public CommonResult update(Role entity) {
		CommonResult result = new CommonResult();
        try {
            roleDao.update(entity);
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
            roleDao.delete(id);
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
	    Role entity = roleDao.queryById(id);
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
        List<Role> list = roleDao.queryPage();
        return new PageInfo(list);
    }

}