package com.sunyu.activiti.model;

import java.io.Serializable;
import java.util.List;


/**
 * Table:
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */
public class Role implements Serializable {

    private static final long serialVersionUID = -5125610979026841876L;

   	private Integer rid;
	private String roleName;


	private List<Permission> permissionList;
	//getters and setters

	public Integer getRid() {
		return rid;
	}

	public void setRid(Integer rid) {
		this.rid = rid;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public List<Permission> getPermissionList() {
		return permissionList;
	}

	public void setPermissionList(List<Permission> permissionList) {
		this.permissionList = permissionList;
	}
}