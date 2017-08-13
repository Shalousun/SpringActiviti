package com.sunyu.activiti.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by yu on 2017/7/12.
 */
@Controller
public class IndexController extends BaseController {

    /**
     * 跳转到首页登录
     * @return
     */
    @GetMapping("/login")
    public String toLogin(){
        return this.forward("/index.html");
    }

    /**
     * 跳转到首页登录
     * @return
     */
    @GetMapping("/")
    public String toIndex(){
        return this.redirect("/index.html");
    }

    /**
     * 跳转到后台首页
     * @return
     */
    @GetMapping("/admin/index")
    public String toAdminIndex(){
        return "/index";
    }

    @ResponseBody
    @RequestMapping(value = "/test",method = RequestMethod.POST)
    public String test(){
        return "hello world";
    }


}
