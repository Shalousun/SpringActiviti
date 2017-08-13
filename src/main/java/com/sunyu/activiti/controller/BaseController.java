package com.sunyu.activiti.controller;

/**
 * Created by yu on 2017/7/12.
 */
public abstract class BaseController {

    /**
     * 重定向
     * @param path
     * @return
     */
    public String redirect(String path){
        return "redirect:"+path;
    }

    /**
     * 服务器转发
     * @param path
     * @return
     */
    public String forward(String path){
        return "forward:"+path;
    }
}
