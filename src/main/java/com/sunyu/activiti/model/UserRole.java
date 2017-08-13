package com.sunyu.activiti.model;

import java.io.Serializable;



/**
 * Table:
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */
public class UserRole implements Serializable {

    private static final long serialVersionUID = -8693043104015562325L;

   	private Integer urid;
	//用户id
	private Long userId;
	//角色id
	private Long roleId;
	//主键id
	private Long id;

	//getters and setters
   	public Integer getUrid() {
		return urid;
	}

	public void setUrid(Integer urid) {
		this.urid = urid;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public Long getRoleId() {
		return roleId;
	}

	public void setRoleId(Long roleId) {
		this.roleId = roleId;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}


    @Override
    public String toString() {
        return "UserRole{" + 
                "urid =" + urid +
                ",userId =" + userId +
                ",roleId =" + roleId +
                ",id =" + id +
                '}';
    }
}