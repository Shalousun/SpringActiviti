package com.sunyu.activiti.controller;


import com.boco.common.model.CommonResult;
import com.github.pagehelper.PageInfo;
import com.sunyu.activiti.model.User;
import com.sunyu.activiti.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

/**
 *
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */
@Controller
@RequestMapping("user")
public class UserController {
    /**
     * 日志
     */
    private static Logger logger = LoggerFactory.getLogger(UserController.class);

	@Resource
	private UserService userService;

	@ResponseBody
	@PostMapping(value = "/add")
	public CommonResult save(User entity) {
		return userService.save(entity);
	}

	@ResponseBody
	@PostMapping(value = "/update")
	public CommonResult update(User entity) {
		return userService.update(entity);
	}

	@ResponseBody
	@GetMapping(value = "/delete/{id}")
	public CommonResult delete(@PathVariable int id) {
		return userService.delete(id);
	}

	@ResponseBody
	@GetMapping(value = "/query/{id}")
	public CommonResult queryById(@PathVariable int id) {
		return userService.queryById(id);
	}

    @ResponseBody
    @GetMapping(value = "/page")
    public PageInfo queryPage(int offset,int limit) {
        return userService.queryPage(offset,limit);
    }

	@GetMapping(value = "/listPage")
	public String toListPage(){
		return "/systemUserList";
	}
}