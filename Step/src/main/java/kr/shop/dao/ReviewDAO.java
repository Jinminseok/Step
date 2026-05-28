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
			int rating, String content, String filename) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long reviewNum = 0; // 발급받을 리뷰 번호
		
		try {
			conn = DBUtil.getConnection();
			// 오토커밋 해제
			conn.setAutoCommit(false); 
			
			// 새 리뷰 번호 생성
			String sql = "SELECT reviews_seq.nextval FROM DUAL";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				reviewNum = rs.getLong(1);
			}
			DBUtil.executeClose(rs, pstmt, null);
			
			// REVIEWS 테이블에 기본 내용 저장
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
			
			// 첨부된 파일이 존재한다면 REVIEWS_IMGS 테이블에 저장
			if (filename != null && !filename.isEmpty()) {
				sql = "INSERT INTO reviews_imgs (review_img_num, review_num, review_img_url) "
					+ "VALUES (reviews_imgs_seq.nextval, ?, ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setLong(1, reviewNum);
				pstmt.setString(2, filename);
				pstmt.executeUpdate();
			}
			
			// 전부 성공하면 커밋
			conn.commit();
			
		} catch (Exception e) {
			// 실패 시 롤백
			if (conn != null) conn.rollback(); 
			throw new Exception(e);
		} finally {
			if (conn != null) conn.setAutoCommit(true);
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}
	// 리뷰 수정
	public void updateReview(int reviewNum, int rating, String content, String filename) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBUtil.getConnection();
			// 오토커밋 해제
			conn.setAutoCommit(false);
			
			// 리뷰 기본 내용 수정
			String sql1 = "UPDATE reviews SET rating=?, review_content=?, review_updated_at=SYSDATE WHERE review_num=?";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setInt(1, rating);
			pstmt.setString(2, content);
			pstmt.setInt(3, reviewNum);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);
			
			// 새로운 사진을 올렸을 경우에만 이미지 처리
			if (filename != null && !filename.isEmpty()) {
				// 기존 이미지가 있는지 확인
				String sqlCheck = "SELECT review_img_num FROM reviews_imgs WHERE review_num=?";
				pstmt = conn.prepareStatement(sqlCheck);
				pstmt.setInt(1, reviewNum);
				rs = pstmt.executeQuery();
				
				boolean hasImage = rs.next();
				DBUtil.executeClose(rs, pstmt, null);
				
				if (hasImage) {
					// 기존 사진이 있으면 교체
					String sqlUpdateImg = "UPDATE reviews_imgs SET review_img_url=? WHERE review_num=?";
					pstmt = conn.prepareStatement(sqlUpdateImg);
					pstmt.setString(1, filename);
					pstmt.setInt(2, reviewNum);
					pstmt.executeUpdate();
				} else {
					// 기존 사진이 없었다면 새로 추가
					String sqlInsertImg = "INSERT INTO reviews_imgs (review_img_num, review_num, review_img_url) "
							            + "VALUES (reviews_imgs_seq.nextval, ?, ?)";
					pstmt = conn.prepareStatement(sqlInsertImg);
					pstmt.setInt(1, reviewNum);
					pstmt.setString(2, filename);
					pstmt.executeUpdate();
				}
			}
			
			// 전부 완료되면 커밋
			conn.commit();
		} catch (Exception e) {
			// 실패하면 롤백
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
			String sql = "SELECT r.*, u.user_name, ri.review_img_url FROM REVIEWS r "
					   + "JOIN USERS_DETAIL u ON r.user_num = u.user_num "
					   + "LEFT JOIN REVIEWS_IMGS ri ON r.review_num = ri.review_num "
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
				map.put("img_url", rs.getString("review_img_url"));
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
				// 평점이 없을 땐 0.0
				map.put("avgRating", rs.getObject("avg_rating") == null ? 0.0 : rs.getDouble("avg_rating"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return map;
	}
	
}