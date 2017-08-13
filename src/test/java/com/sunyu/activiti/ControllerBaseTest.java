package com.sunyu.activiti;

import com.sunyu.activiti.service.RoleService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import javax.annotation.Resource;

/**
 * service层业务单元测试基础类
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
        "classpath:conf/spring-mybatis.xml"
})
public class ControllerBaseTest {

    @Resource
    private RoleService roleService;

    @Test
    public void testPage(){
        roleService.queryPage(1,10);
    }
}