package com.sunyu.activiti.model;

import java.io.Serializable;



/**
 * Table:
 * @author yu
 * @date 2017-07-11 22:47:52
 *
 */
public class Permission implements Serializable {

    private static final long serialVersionUID = -8644309338224539904L;

   	private Integer pid;
	//权限名称
	private String permissionName;

	//getters and setters
   	public Integer getPid() {
		return pid;
	}

	public void setPid(Integer pid) {
		this.pid = pid;
	}

	public String getPermissionName() {
		return permissionName;
	}

	public void setPermissionName(String permissionName) {
		this.permissionName = permissionName;
	}


    @Override
    public String toString() {
        return "Permission{" + 
                "pid =" + pid +
                ",permissionName ='" + permissionName + '\'' +
                '}';
    }
}