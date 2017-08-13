package com.sunyu.activiti.controller;


import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.model.Permission;
import com.sunyu.activiti.service.PermissionService;
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
@RequestMapping("permission")
public class PermissionController {
    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(PermissionController.class);

	@Resource
	private PermissionService permissionService;

	@ResponseBody
	@PostMapping(value = "/add")
	public CommonResult save(Permission entity) {
		return permissionService.save(entity);
	}

	@ResponseBody
	@PostMapping(value = "/update")
	public CommonResult update(Permission entity) {
		return permissionService.update(entity);
	}

	@ResponseBody
	@GetMapping(value = "/delete/{id}")
	public CommonResult delete(@PathVariable int id) {
		return permissionService.delete(id);
	}

	@ResponseBody
	@GetMapping(value = "/query/{id}")
	public CommonResult queryById(@PathVariable int id) {
		return permissionService.queryById(id);
	}

    @ResponseBody
    @GetMapping(value = "/page")
    public PageInfo queryPage(int offset,int limit) {
        return permissionService.queryPage(offset,limit);
    }

	@GetMapping(value = "/listPage")
	public String toListPage(){
		return "/permissionList";
	}
}