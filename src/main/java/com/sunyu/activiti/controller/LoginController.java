package com.sunyu.activiti.controller;

import com.boco.common.model.CommonResult;
import com.boco.common.util.StringUtil;
import com.sunyu.activiti.constant.GlobConstants;
import com.sunyu.activiti.model.User;
import com.sunyu.activiti.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by yu on 2017/7/12.
 */
@Controller
public class LoginController extends BaseController {

    @Resource
    private UserService userService;

    @RequestMapping(value = "/user/login",method = RequestMethod.POST)
    @ResponseBody
    public CommonResult login(HttpServletRequest request){
        CommonResult result = new CommonResult();
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if(StringUtil.isEmpty(username)){
            result.setMessage("用户名不能为空");
            return result;
        }
        if(StringUtil.isEmpty(password)){
            result.setMessage("密码不能为空");
            return result;
        }
        CommonResult<User> result1 = userService.queryByUserName(username);
        if(result1.isSuccess()){
            User user = result1.getData();
            if(password.equals(user.getPassword())){
                result.setSuccess(true);
                HttpSession session = request.getSession();
                session.setAttribute(GlobConstants.USER_ID,user.getUid());
                session.setAttribute(GlobConstants.USER_NAME,username);
            }else{
                result.setMessage("用户名或密码不正确");
            }
        }else{
            result.setMessage("用户名或密码不正确");
        }
        return result;
    }

    @GetMapping("/logout")
    public String logout(HttpSession httpSession){
        httpSession.removeAttribute(GlobConstants.USER_NAME);
        return this.forward("/index.html");
    }
}
