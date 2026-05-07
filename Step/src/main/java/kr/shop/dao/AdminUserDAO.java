package kr.shop.dao;

import java.sql.*;
import kr.shop.vo.AdminUserVO;
import kr.util.DBUtil;

public class AdminUserDAO {
	private static AdminUserDAO instance = new AdminUserDAO();

	public static AdminUserDAO getInstance() {
		return instance;
	}

	private AdminUserDAO() {
	}

	// 로그인 체크
	public AdminUserVO checkLogin(String id, String pwd) throws Exception {
		// ... SELECT * FROM users WHERE user_id=? AND pwd=? 쿼리 작성
		return null;
	}

	// 회원 상세 정보 가져오기
	public AdminUserVO getUserDetail(long userNum) throws Exception {
		// ... 쿼리 작성
		return null;
	}
}