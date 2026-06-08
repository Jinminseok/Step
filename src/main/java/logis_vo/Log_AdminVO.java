package logis_vo;

import java.sql.Date;

import org.mindrot.jbcrypt.BCrypt;

public class Log_AdminVO {
	private long user_num;
	private String user_id;
	private int auth;
	private String user_name;
	private String pwd;
	private String phone;
	private String email;
	private String zipcode;
	private String addr1;
	private String addr2;
	private int grade;
	private Date user_created_at;
	private Date user_updated_at;
	private Date last_login;
	
	// 비밀번호 일치 여부 체크
		public boolean isCheckedPassword(String userPwd) {
			//회원등급(auth) : 0탈퇴, 1정지, 2일반, 9관리자
			if(auth > 1 && BCrypt.checkpw(userPwd, pwd)) {
				return true;
			}
			return false;
		}

		public long getUser_num() {
			return user_num;
		}

		public void setUser_num(long user_num) {
			this.user_num = user_num;
		}

		public String getUser_id() {
			return user_id;
		}

		public void setUser_id(String user_id) {
			this.user_id = user_id;
		}

		public int getAuth() {
			return auth;
		}

		public void setAuth(int auth) {
			this.auth = auth;
		}

		public String getUser_name() {
			return user_name;
		}

		public void setUser_name(String user_name) {
			this.user_name = user_name;
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

		public Date getUser_created_at() {
			return user_created_at;
		}

		public void setUser_created_at(Date user_created_at) {
			this.user_created_at = user_created_at;
		}

		public Date getUser_updated_at() {
			return user_updated_at;
		}

		public void setUser_updated_at(Date user_updated_at) {
			this.user_updated_at = user_updated_at;
		}

		public Date getLast_login() {
			return last_login;
		}

		public void setLast_login(Date last_login) {
			this.last_login = last_login;
		}
		
}
