package com.sunyu.activiti.model;

import java.io.Serializable;



/**
 * Table:
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */
public class RolePermission implements Serializable {

    private static final long serialVersionUID = -6618200705598146029L;

   	private Integer rpid;
	//角色编号
	private Integer roleId;
	//权限编号
	private Integer permissionId;

	/**
	 * 角色
	 */
	private Role role;

	//权限
	private Permission permission;

	//getters and setters
   	public Integer getRpid() {
		return rpid;
	}

	public void setRpid(Integer rpid) {
		this.rpid = rpid;
	}

	public Integer getRoleId() {
		return roleId;
	}

	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}

	public Integer getPermissionId() {
		return permissionId;
	}

	public void setPermissionId(Integer permissionId) {
		this.permissionId = permissionId;
	}


	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public Permission getPermission() {
		return permission;
	}

	public void setPermission(Permission permission) {
		this.permission = permission;
	}
}