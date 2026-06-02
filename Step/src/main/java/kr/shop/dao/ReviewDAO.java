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
	        int rating, String content, java.util.List<String> filenames) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    long reviewNum = 0; 
	    
	    try {
	        conn = DBUtil.getConnection();
	        conn.setAutoCommit(false); 
	        
	        String sql = "SELECT REVIEWS_SEQ.NEXTVAL FROM DUAL";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        if(rs.next()) reviewNum = rs.getLong(1);
	        DBUtil.executeClose(rs, pstmt, null);
	        
	        sql = "INSERT INTO reviews "
	            + "(review_num, user_num, prod_num, order_num, "
	            + " rating, review_content, review_status, "
	            + " review_created_at, review_updated_at) "
	            + "VALUES (?, ?, ?, ?, ?, ?, 1, SYSDATE, SYSDATE)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, reviewNum);
	        pstmt.setLong(2, userNum);
	        pstmt.setInt(3, prodNum);
	        pstmt.setLong(4, orderNum);
	        pstmt.setInt(5, rating);
	        pstmt.setString(6, content);
	        pstmt.executeUpdate();
	        DBUtil.executeClose(null, pstmt, null);
	        
	        //다중 첨부파일 Loop 돌며 저장
	        if (filenames != null && !filenames.isEmpty()) {
	            sql = "INSERT INTO REVIEWS_IMGS (REVIEW_IMG_NUM, REVIEW_NUM, REVIEW_IMG_URL) "
	                + "VALUES (REVIEWS_IMGS_SEQ.NEXTVAL, ?, ?)";
	            pstmt = conn.prepareStatement(sql);
	            for (String fname : filenames) {
	                pstmt.setLong(1, reviewNum);
	                pstmt.setString(2, fname);
	                pstmt.executeUpdate(); 
	            }
	        }
	        
	        conn.commit();
	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw new Exception(e);
	    } finally {
	        if (conn != null) conn.setAutoCommit(true);
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	}
	// 리뷰 수정
	public void updateReview(int reviewNum, int rating, String content, java.util.List<String> filenames) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    
	    try {
	        conn = DBUtil.getConnection();
	        conn.setAutoCommit(false); 
	        
	        String sql1 = "UPDATE REVIEWS SET RATING=?, REVIEW_CONTENT=?, REVIEW_UPDATED_AT=SYSDATE WHERE REVIEW_NUM=?";
	        pstmt = conn.prepareStatement(sql1);
	        pstmt.setInt(1, rating);
	        pstmt.setString(2, content);
	        pstmt.setInt(3, reviewNum);
	        pstmt.executeUpdate();
	        DBUtil.executeClose(null, pstmt, null);
	        
	        if (filenames != null && !filenames.isEmpty()) {
	            String sqlDel = "DELETE FROM REVIEWS_IMGS WHERE REVIEW_NUM=?";
	            pstmt = conn.prepareStatement(sqlDel);
	            pstmt.setInt(1, reviewNum);
	            pstmt.executeUpdate();
	            DBUtil.executeClose(null, pstmt, null);

	            String sqlInsertImg = "INSERT INTO REVIEWS_IMGS (REVIEW_IMG_NUM, REVIEW_NUM, REVIEW_IMG_URL) "
	                                + "VALUES (REVIEWS_IMGS_SEQ.NEXTVAL, ?, ?)";
	            pstmt = conn.prepareStatement(sqlInsertImg);
	            for (String fname : filenames) {
	                pstmt.setInt(1, reviewNum);
	                pstmt.setString(2, fname);
	                pstmt.executeUpdate();
	            }
	        }
	        
	        conn.commit();
	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw new Exception(e);
	    } finally {
	        if (conn != null) conn.setAutoCommit(true);
	        DBUtil.executeClose(null, pstmt, conn);
	    }
	}
	
	// 리뷰 삭제
	public void deleteReview(int reviewNum, long userNum) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			// 본인 리뷰만 삭제
			String sql = "DELETE FROM reviews WHERE review_num=? AND user_num=?";
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
	        String sql = "SELECT r.*, u.user_name, "
	                   + "(SELECT LISTAGG(review_img_url, ',') WITHIN GROUP(ORDER BY review_img_num) "
	                   + " FROM REVIEWS_IMGS WHERE review_num = r.review_num) as img_urls "
	                   + "FROM REVIEWS r JOIN USERS_DETAIL u ON r.user_num = u.user_num "
	                   + "WHERE r.prod_num = ? ORDER BY r.review_created_at DESC";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, prod_num);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> map = new java.util.HashMap<>();
	            map.put("review_num", rs.getInt("review_num"));
	            map.put("user_num", rs.getLong("user_num")); 
	            map.put("user_name", rs.getString("user_name"));
	            map.put("rating", rs.getInt("rating"));
	            map.put("content", rs.getString("review_content"));
	            map.put("date", rs.getDate("review_created_at"));
	            map.put("img_urls", rs.getString("img_urls"));
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
	                   + "WHERE o.user_num = ? AND oi.prod_num = ? AND o.order_status = 4";
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
	
	// 해당 상품의 리뷰 총 개수와 평균 평점
	public Map<String, Object> getReviewSummary(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, Object> map = new java.util.HashMap<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT COUNT(*) cnt, TRUNC(AVG(rating), 1) avg_rating FROM reviews WHERE prod_num = ? AND review_status = 1";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				map.put("count", rs.getInt("cnt"));
				
				map.put("avgRating", rs.getObject("avg_rating") == null ? 0.0 : rs.getDouble("avg_rating"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return map;
	}
	
}