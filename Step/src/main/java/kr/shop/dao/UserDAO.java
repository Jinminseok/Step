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
	public void insertUser(UserVO user) throws Exception{
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String sql = null;
		long user_num = 0;
		int cnt = 0;
		
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);
			sql = "SELECT users_seq.nextval FROM dual";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_num = rs.getLong(1);
			}
			
			sql = "INSERT INTO users (user_num, user_id) VALUES (?,?)";
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
			conn.commit();
		} catch(Exception e) {
			conn.rollback();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt3, null);
			DBUtil.executeClose(null, pstmt2, null);
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}
	
	// 아이디 중복 체크, 로그인 처리
	public UserVO checkUser(String user_id) throws Exception{
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserVO user = null;
		String sql = null;
		
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT * FROM users
					LEFT OUTER JOIN users_detail
					USING(user_num) WHERE user_id=?
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user = new UserVO();
				user.setUser_num(rs.getLong("user_num"));
				user.setUser_id(rs.getString("user_id"));
				user.setAuth(rs.getInt("auth"));
				user.setPwd(rs.getString("pwd"));
				user.setEmail(rs.getString("email"));
			}
		} catch(Exception e) {
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return user;
	}

	// 마지막 로그인 시간 업데이트
	public void updateLastLogin(long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "UPDATE USERS_DETAIL SET LAST_LOGIN = SYSDATE WHERE USER_NUM = ?";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// 마이페이지 회원 상세 정보 전체 가져오기
	public UserVO getUserDetail(long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserVO user = null;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM users u JOIN users_detail d ON u.user_num = d.user_num WHERE u.user_num = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				user = new UserVO();
				user.setUser_num(rs.getLong("user_num"));
				user.setUser_id(rs.getString("user_id"));
				user.setAuth(rs.getInt("auth"));
				user.setUser_name(rs.getString("user_name"));
				user.setPwd(rs.getString("pwd"));
				user.setPhone(rs.getString("phone"));
				user.setEmail(rs.getString("email"));
				user.setZipcode(rs.getString("zipcode"));
				user.setGrade(rs.getInt("grade"));
				user.setAddr1(rs.getString("addr1"));
				user.setAddr2(rs.getString("addr2"));
				user.setUser_created_at(rs.getDate("user_created_at"));
				user.setUser_updated_at(rs.getDate("user_updated_at"));
				user.setLast_login(rs.getDate("last_login"));
				user.setTotal_amount(rs.getLong("total_amount"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return user;
	}
	
	// 마이페이지 회원 정보 수정
	public void updateUser(UserVO user) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE users_detail SET user_name=?, phone=?, email=?, zipcode=?, addr1=?, addr2=?, pwd=?, user_updated_at=SYSDATE WHERE user_num=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_name());
			pstmt.setString(2, user.getPhone());
			pstmt.setString(3, user.getEmail());
			pstmt.setString(4, user.getZipcode());
			pstmt.setString(5, user.getAddr1());
			pstmt.setString(6, user.getAddr2());
			pstmt.setString(7, user.getPwd());
			pstmt.setLong(8, user.getUser_num());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
		
	// 마이페이지 누적 금액에 따른 회원 등급 갱신
	public void updateUserGrade(long user_num) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    
	    try {
	        conn = DBUtil.getConnection();
	        // total_amount 기준 자동 계산 등급과 현재 등급 중 높은 값 유지
	        String sql = "UPDATE users_detail SET grade = CASE "
	                   + "  WHEN total_amount >= 500000 THEN "
	                   + "    CASE WHEN grade > 4 THEN grade ELSE 4 END "
	                   + "  WHEN total_amount >= 300000 THEN "
	                   + "    CASE WHEN grade > 3 THEN grade ELSE 3 END "
	                   + "  WHEN total_amount >= 100000 THEN "
	                   + "    CASE WHEN grade > 2 THEN grade ELSE 2 END "
	                   + "  ELSE "
	                   + "    CASE WHEN grade > 1 THEN grade ELSE 1 END "
	                   + "END WHERE user_num = ?";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, user_num);
	        pstmt.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new Exception(e);
	    } finally {
	        DBUtil.executeClose(null, pstmt, conn);
	    }
	}
	
}