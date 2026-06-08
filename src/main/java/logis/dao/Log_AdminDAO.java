package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import kr.shop.vo.UserVO;
import kr.util.DBUtil;
import logis_vo.Log_AdminVO;

public class Log_AdminDAO {

	//싱글턴 패턴
	private static Log_AdminDAO instance = new Log_AdminDAO();
	
	public static Log_AdminDAO getInstance() {
		return instance;
	}
	private Log_AdminDAO() {}
	
	// 아이디 중복 체크, 로그인 처리
		public Log_AdminVO checkUser(String user_id) throws Exception{
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Log_AdminVO user = null;
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
					user = new Log_AdminVO();
					user.setUser_num(rs.getLong("user_num"));
					user.setUser_id(rs.getString("user_id"));
					user.setAuth(rs.getInt("auth"));
					user.setPwd(rs.getString("pwd"));;
					// 회원탈퇴시 필요
					user.setEmail(rs.getString("email"));
				}
			} catch(Exception e) {
				throw new Exception(e);
			} finally {
				DBUtil.executeClose(rs, pstmt, conn);
			}
			return user;
		}
	}