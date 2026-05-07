package kr.shop.vo;

import java.util.Date;

public class AdminUserVO extends AdminBaseVO {
	private long userNum;
	private String userId;
	private String auth;
	private String userName;
	private String pwd;
	private String phone;
	private String email;
	private String zipcode;
	private String addr1;
	private String addr2;
	private int grade;
	private Date userCreatedAt;
	private Date userUpdatedAt;
	private Date lastLogin;

	public long getUserNum() {
		return userNum;
	}

	public void setUserNum(long userNum) {
		this.userNum = userNum;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getAddr1() {
		return addr1;
	}

	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}

	public String getAddr2() {
		return addr2;
	}

	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	public Date getUserCreatedAt() {
		return userCreatedAt;
	}

	public void setUserCreatedAt(Date userCreatedAt) {
		this.userCreatedAt = userCreatedAt;
	}

	public Date getUserUpdatedAt() {
		return userUpdatedAt;
	}

	public void setUserUpdatedAt(Date userUpdatedAt) {
		this.userUpdatedAt = userUpdatedAt;
	}

	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}

}