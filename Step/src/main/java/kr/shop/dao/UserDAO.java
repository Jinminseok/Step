package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import kr.shop.vo.UserVO;
import kr.util.DBUtil;

public class UserDAO {
	// 싱글턴 패턴
	private static UserDAO instance = new UserDAO();
	
	public static UserDAO getInstance() {
		return instance;
	}
	private UserDAO() {}
	
	// 회원가입
	public void insertMember(UserVO user) throws Exception{
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String sql = null;
		long user_num = 0; // 시퀀스 번호 저장
		int cnt = 0;
		
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);
			// 회원번호 생성
			sql = "SELECT users_seq.nextval FROM dual";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_num = rs.getLong(1);
			}
			
			sql = "INSERT INTO users (users_num, user_id) VALUES (?,?)";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setLong(1, user_num);
			pstmt2.setString(2, user.getUser_id());
			pstmt2.executeUpdate();
			
			sql = """
					INSERT INTO users_detail
					(user_num, user_name, pwd, phone, email, zipcode, addr1, addr2)
					VALUES (?,?,?,?,?,?,?,?)
					""";
			pstmt3 = conn.prepareStatement(sql);
			
			pstmt3.setLong(++cnt, user_num);
			pstmt3.setString(++cnt, user.getUser_name());
			pstmt3.setString(++cnt, user.getPwd());
			pstmt3.setString(++cnt, user.getPhone());
			pstmt3.setString(++cnt, user.getEmail());
			pstmt3.setString(++cnt, user.getZipcode());
			pstmt3.setString(++cnt, user.getAddr1());
			pstmt3.setString(++cnt, user.getAddr2());
			
			pstmt3.executeUpdate();
			
			// SQL문 실행시 모두 성공하면 커밋
			conn.commit();
		} catch(Exception e) {
			// 하나라도 실패시 롤백
			conn.rollback();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt3, null);
			DBUtil.executeClose(null, pstmt2, null);
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}
}
