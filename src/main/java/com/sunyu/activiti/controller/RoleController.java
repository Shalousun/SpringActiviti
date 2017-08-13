package com.sunyu.activiti.controller;


import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.model.Role;
import com.sunyu.activiti.service.RoleService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:52
 *
 */
@Controller
@RequestMapping("role")
public class RoleController {
    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(RoleController.class);

	@Resource
	private RoleService roleService;

	@ResponseBody
	@PostMapping(value = "/add")
	public CommonResult save(Role entity) {
		return roleService.save(entity);
	}

	@ResponseBody
	@PostMapping(value = "/update")
	public CommonResult update(Role entity) {
		return roleService.update(entity);
	}

	@ResponseBody
	@GetMapping(value = "/delete/{id}")
	public CommonResult delete(@PathVariable int id) {
		return roleService.delete(id);
	}

	@ResponseBody
	@GetMapping(value = "/query/{id}")
	public CommonResult queryById(@PathVariable int id) {
		return roleService.queryById(id);
	}

    @ResponseBody
    @GetMapping(value = "/page")
    public PageInfo queryPage(int offset,int limit) {
        return roleService.queryPage(offset,limit);
    }

	@GetMapping(value = "/listPage")
	public String toListPage(){
		return "/sysRoleList";
	}
}