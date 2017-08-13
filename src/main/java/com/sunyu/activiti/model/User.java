package com.sunyu.activiti.model;

import java.io.Serializable;
import java.util.List;


/**
 * Table:
 * @author yu
 * @date 2017-07-11 22:47:53
 *
 */
public class User implements Serializable {

    private static final long serialVersionUID = -6962913394214410324L;

   	private Integer uid;
	private String username;
	//密码
	private String password;
	private String tel;
	private Integer age;

	List<Role> roleList;
	public Integer getUid() {
		return uid;
	}

	public void setUid(Integer uid) {
		this.uid = uid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public List<Role> getRoleList() {
		return roleList;
	}

	public void setRoleList(List<Role> roleList) {
		this.roleList = roleList;
	}
}