package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminOrderVO;
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
	public void insertUser(UserVO user) throws Exception {
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
	        if (rs.next()) {
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
	    } catch (Exception e) {
	        conn.rollback();
	        throw new Exception(e);
	    } finally {
	        DBUtil.executeClose(null, pstmt3, null);
	        DBUtil.executeClose(null, pstmt2, null);
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	}

	// 가입한 user_id로 user_num 조회
	public long getUserNumByUserId(String user_id) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    long user_num = 0;
	    try {
	        conn = DBUtil.getConnection();
	        String sql = "SELECT USER_NUM FROM USERS WHERE USER_ID = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, user_id);
	        rs = pstmt.executeQuery();
	        if (rs.next()) user_num = rs.getLong("USER_NUM");
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return user_num;
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
	
	// 회원 탈퇴
	public void deleteUser(long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String sql = null;
		
		try {
			conn = DBUtil.getConnection();
			// 오토커밋 해제
			conn.setAutoCommit(false);
			
			sql = "UPDATE users SET auth = 0 WHERE user_num=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			pstmt.executeUpdate();
			
			sql = "DELETE FROM users_detail WHERE user_num=?";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setLong(1, user_num);
			pstmt2.executeUpdate();
			
			// 모든 SQL문의 실행이 성공하면 커밋
			conn.commit();
		} catch(Exception e) {
			// SQL문이 하나라도 실패하면 롤백
			conn.rollback();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt2, null);
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// 임시 비밀번호 변경
	public void updatePassword(String pwd, long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE users_detail SET pwd=? WHERE user_num=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pwd);
			pstmt.setLong(2, user_num);
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// ── 🌟 마이페이지용: 내 주문 내역 전체 가져오기 ──
	public List<AdminOrderVO> getMyOrderList(long user_num) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<AdminOrderVO> list = new ArrayList<>();

	    try {
	        conn = DBUtil.getConnection();

	        String sql = "SELECT o.ORDER_NUM, o.PAY_PRICE, o.ORDER_STATUS, "
	                   + "  TO_CHAR(o.ORDER_CREATED_AT, 'YYYY.MM.DD') AS ORDER_CREATED_AT, "
	                   + "  p.PROD_NUM, p.PROD_NAME, "
	                   + "  (SELECT img.PROD_IMG_URL FROM PROD_IMGS img "
	                   + "   WHERE img.PROD_NUM = p.PROD_NUM AND img.IS_MAIN = 'Y' AND ROWNUM = 1) AS PROD_IMG_URL, "
	                   + "  po.SIZE_VAL || 'mm / ' || po.COLOR AS OPT_INFO, "
	                   + "  oi.ORDER_ITEM_QTY, oi.ORDER_ITEM_PRICE, "
	                   
	                   + "  (SELECT r.REVIEW_NUM FROM REVIEWS r "
	                   + "   WHERE r.ORDER_NUM = o.ORDER_NUM AND r.USER_NUM = o.USER_NUM "
	                   + "   AND r.PROD_NUM = p.PROD_NUM AND ROWNUM = 1) AS REVIEW_NUM, "
	                   + "  (SELECT r.RATING FROM REVIEWS r "
	                   + "   WHERE r.ORDER_NUM = o.ORDER_NUM AND r.USER_NUM = o.USER_NUM "
	                   + "   AND r.PROD_NUM = p.PROD_NUM AND ROWNUM = 1) AS REVIEW_RATING, "
	                   + "  (SELECT r.REVIEW_CONTENT FROM REVIEWS r "
	                   + "   WHERE r.ORDER_NUM = o.ORDER_NUM AND r.USER_NUM = o.USER_NUM "
	                   + "   AND r.PROD_NUM = p.PROD_NUM AND ROWNUM = 1) AS REVIEW_CONTENT "
	                   + "FROM ORDERS o "
	                   + "JOIN ORDER_ITEMS oi ON o.ORDER_NUM = oi.ORDER_NUM "
	                   + "JOIN PRODUCTS p ON oi.PROD_NUM = p.PROD_NUM "
	                   + "JOIN PROD_OPTIONS po ON oi.OPT_NUM = po.OPT_NUM "
	                   + "WHERE o.USER_NUM = ? "
	                   + "ORDER BY o.ORDER_NUM DESC, oi.ITEM_NUM ASC";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, user_num);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            AdminOrderVO order = new AdminOrderVO();
	            order.setOrder_num(rs.getInt("ORDER_NUM"));
	            order.setPay_price(rs.getInt("PAY_PRICE"));
	            order.setOrder_status(rs.getInt("ORDER_STATUS"));
	            order.setOrder_created_at(rs.getString("ORDER_CREATED_AT"));
	            order.setProd_num(rs.getInt("PROD_NUM"));
	            order.setProd_name(rs.getString("PROD_NAME"));
	            order.setProd_img_url(rs.getString("PROD_IMG_URL"));
	            order.setOpt_info(rs.getString("OPT_INFO"));
	            order.setOrder_item_qty(rs.getInt("ORDER_ITEM_QTY"));       
	            order.setOrder_item_price(rs.getInt("ORDER_ITEM_PRICE"));   
	            order.setReview_num(rs.getInt("REVIEW_NUM"));
	            order.setReview_rating(rs.getInt("REVIEW_RATING"));
	            order.setReview_content(rs.getString("REVIEW_CONTENT"));
	            list.add(order);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new Exception(e);
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return list;
	}
	
	//마이페이지 반품 콤보박스용: 배송완료(상태4)된 개별 상품 목록 조회
	public List<AdminOrderVO> getDeliveredItemList(int userNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AdminOrderVO> list = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT o.ORDER_NUM, i.PROD_NUM, i.OPT_NUM, p.PROD_NAME, "
                + "       (SELECT SIZE_VAL || ' / ' || COLOR FROM PROD_OPTIONS WHERE OPT_NUM = i.OPT_NUM) AS OPT_INFO "
                + "FROM ORDERS o "
                + "JOIN ORDER_ITEMS i ON o.ORDER_NUM = i.ORDER_NUM "
                + "JOIN PRODUCTS p ON i.PROD_NUM = p.PROD_NUM "
                + "WHERE o.USER_NUM = ? AND o.ORDER_STATUS = 4 "
                + "  AND NOT EXISTS ( "
                + "      SELECT 1 FROM RETURNS r "
                + "      WHERE r.ORDER_NUM = o.ORDER_NUM "
                + "        AND r.PROD_NUM = i.PROD_NUM "
                + "        AND r.OPT_NUM = i.OPT_NUM "
                + "        AND r.RET_STATUS IN (1, 2, 3, 4) " 
                + "  ) "
                + "ORDER BY o.ORDER_NUM DESC";
                       
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                AdminOrderVO item = new AdminOrderVO();
                item.setOrder_num(rs.getInt("ORDER_NUM"));
                item.setProd_num(rs.getInt("PROD_NUM"));
                item.setOpt_num(rs.getInt("OPT_NUM"));
                item.setProd_name(rs.getString("PROD_NAME"));
                item.setOpt_info(rs.getString("OPT_INFO"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //개별 상품 정보(주문, 상품, 옵션)가 포함된 반품/교환 데이터 생성
    public void insertReturnRequest(int userNum, int orderNum, int prodNum, int optNum, int tp, String reason, String retNote) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "INSERT INTO RETURNS (RET_NUM, ORDER_NUM, USER_NUM, TP, REASON, PROD_NUM, OPT_NUM, RET_NOTE, RET_STATUS, RET_CREATED_AT) "
                       + "VALUES (RETURNS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, 1, SYSDATE)";
                       
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderNum);
            pstmt.setInt(2, userNum);
            pstmt.setInt(3, tp);
            pstmt.setString(4, reason);
            pstmt.setInt(5, prodNum);
            pstmt.setInt(6, optNum);
            pstmt.setString(7, retNote);
            
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
	
}