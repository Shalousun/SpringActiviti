package com.sunyu.activiti.controller;

import com.sunyu.activiti.vo.DataGrid;
import com.sunyu.activiti.vo.CustomerProcess;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.ProcessDefinition;
import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * 流程处理的controller
 */
@Controller
@RequestMapping("process")
public class ProcessController {

    @Resource
    RepositoryService repositoryService;

    /**
     * 获取已经部署的流程
     * @param pageNumber
     *          当前页码
     * @param pageSize
     *          页面大小
     * @return
     */
    @RequestMapping(value = "/getLists")
    @ResponseBody
    public DataGrid<CustomerProcess> getList(int pageNumber,  int pageSize) {
        int firstRow = (pageNumber - 1) * pageSize;
        List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery().listPage(firstRow,pageSize);
        int total = repositoryService.createProcessDefinitionQuery().list().size();
        List<CustomerProcess> myList = new ArrayList<>();
        for (ProcessDefinition definition:list) {
            CustomerProcess p = new CustomerProcess();
            p.setDeploymentId(definition.getDeploymentId());
            p.setId(definition.getId());
            p.setKey(definition.getKey());
            p.setName(definition.getName());
            p.setResourceName(definition.getResourceName());
            p.setDiagramResourceName(definition.getDiagramResourceName());
            myList.add(p);
        }
        DataGrid<CustomerProcess> grid = new DataGrid<>();
        grid.setCurrent(pageNumber);
        grid.setRowCount(pageSize);
        grid.setRows(myList);
        grid.setTotal(total);
        return grid;
    }

    /**
     * 查看流程资源(显示bpm源码或者bpm图片)
     * @param pdid
     *          流程实例编号
     * @param resource
     *          bpm资源
     * @param response
     * @throws Exception
     */
    @RequestMapping("/showResource")
    public void export(@RequestParam("pdid") String pdid, @RequestParam("resource") String resource, HttpServletResponse response) throws Exception {
        ProcessDefinition def = repositoryService.createProcessDefinitionQuery().processDefinitionId(pdid).singleResult();
        InputStream is = repositoryService.getResourceAsStream(def.getDeploymentId(), resource);
        ServletOutputStream output = response.getOutputStream();
        IOUtils.copy(is, output);
    }

    /**
     * 上传流程
     * @param uploadfile
     * @param request
     * @return
     */
    @RequestMapping("/uploadWorkflow")
    public String fileupload(@RequestParam MultipartFile uploadfile, HttpServletRequest request) {
        try {
            MultipartFile file = uploadfile;
            String filename = file.getOriginalFilename();
            InputStream is = file.getInputStream();
            repositoryService.createDeployment().addInputStream(filename, is).deploy();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "index";
    }

    @GetMapping("/toProcessList")
    public String toProcessLists(){
        return "/processList";
    }
}
