package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class ReviewDAO {
	private static ReviewDAO instance = new ReviewDAO();
	public static ReviewDAO getInstance() { return instance; }
	private ReviewDAO() {}

	public boolean isDuplicateReview(long userNum, long orderNum, int prodNum) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean result = false;
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT 1 FROM reviews "
					+ "WHERE user_num = ? AND order_num = ? AND prod_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, userNum);
			pstmt.setLong(2, orderNum);
			pstmt.setInt(3, prodNum);
			rs = pstmt.executeQuery();
			if (rs.next()) result = true;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return result;
	}

	/**
	 * 리뷰 INSERT
	 */
	public void insertReview(long userNum, long orderNum, int prodNum,
			int rating, String content) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "INSERT INTO reviews "
					+ "(review_num, user_num, prod_num, order_num, "
					+ " rating, review_content, review_status, "
					+ " review_created_at, review_updated_at) "
					+ "VALUES (reviews_seq.nextval, ?, ?, ?, ?, ?, 1, SYSDATE, SYSDATE)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, userNum);
			pstmt.setInt(2, prodNum);
			pstmt.setLong(3, orderNum);
			pstmt.setInt(4, rating);
			pstmt.setString(5, content);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	// 리뷰 수정
	public void updateReview(int reviewNum, int rating, String content) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE REVIEWS SET RATING=?, REVIEW_CONTENT=?, REVIEW_UPDATED_AT=SYSDATE "
					+ "WHERE REVIEW_NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rating);
			pstmt.setString(2, content);
			pstmt.setInt(3, reviewNum);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	// 리뷰 삭제
	public void deleteReview(int reviewNum, long userNum) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			// user_num 조건 추가로 본인 리뷰만 삭제 가능
			String sql = "DELETE FROM REVIEWS WHERE REVIEW_NUM=? AND USER_NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, reviewNum);
			pstmt.setLong(2, userNum);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// 상품 상세페이지 - 해당 상품의 리뷰 목록을 조회
	public List<Map<String, Object>> getReviewListByProd(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT r.*, u.user_name FROM REVIEWS r "
					   + "JOIN USERS_DETAIL u ON r.user_num = u.user_num "
					   + "WHERE r.prod_num = ? ORDER BY r.review_created_at DESC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new java.util.HashMap<>();
				map.put("review_num", rs.getInt("review_num"));
				map.put("user_name", rs.getString("user_name"));
				map.put("rating", rs.getInt("rating"));
				map.put("content", rs.getString("review_content"));
				map.put("date", rs.getDate("review_created_at"));
				list.add(map);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
	
	// 구매한 해당 상품에 대한 가장 최근 order_num을 가져오기
	public Long getRecentOrderNum(long userNum, int prodNum) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    Long orderNum = null;
	    try {
	        conn = DBUtil.getConnection();
	        String sql = "SELECT MAX(o.order_num) FROM orders o JOIN order_items oi ON o.order_num = oi.order_num "
	                   + "WHERE o.user_num = ? AND oi.prod_num = ? AND o.order_status = 4"; // 4: 배송완료
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, userNum);
	        pstmt.setInt(2, prodNum);
	        rs = pstmt.executeQuery();
	        if(rs.next()) orderNum = rs.getLong(1);
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return orderNum;
	}
	
}