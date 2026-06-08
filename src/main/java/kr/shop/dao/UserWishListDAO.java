package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.UserWishListVO;
import kr.util.DBUtil;

public class UserWishListDAO {
	// 싱글턴 패턴
	private static UserWishListDAO instance = new UserWishListDAO();
	public static UserWishListDAO getInstance() { return instance; }
	private UserWishListDAO() {}

	public void insertWish(UserWishListVO wish) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "INSERT INTO wishList (wish_num, user_num, prod_num) VALUES (wishlist_seq.nextval, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, wish.getUser_num());
			pstmt.setLong(2, wish.getProd_num());
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	// 찜(즐겨찾기) 목록 조회
	public List<UserWishListVO> getWishList(long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<UserWishListVO> list = new ArrayList<>();
		
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT w.wish_num, w.user_num, w.prod_num, 
					p.prod_name, p.prod_price, i.prod_img_url, b.brand_name 
					FROM wishlist w 
					JOIN products p ON w.prod_num = p.prod_num 
					LEFT JOIN brands b ON p.brand_num = b.brand_num 
					LEFT JOIN prod_imgs i ON p.prod_num = i.prod_num AND i.is_main = 'Y' 
					WHERE w.user_num = ? ORDER BY w.wish_num DESC
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				UserWishListVO wish = new UserWishListVO();
				wish.setWish_num(rs.getInt("wish_num"));
				wish.setUser_num(rs.getLong("user_num"));
				wish.setProd_num(rs.getInt("prod_num"));
				wish.setProd_name(rs.getString("prod_name"));
				wish.setProd_price(rs.getInt("prod_price"));
				wish.setProd_img_url(rs.getString("prod_img_url"));
				wish.setBrand_name(rs.getString("brand_name"));
				
				list.add(wish);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 찜(즐겨찾기) 취소(삭제)
	public void deleteWish(long user_num, int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "DELETE FROM wishlist WHERE user_num = ? AND prod_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			pstmt.setLong(2, prod_num);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// 찜 전체 개수 가져오기 (뱃지)
	public int getWishCount(Long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String sql = null;
		
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT COUNT(*) FROM wishlist WHERE user_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}
	
	// 찜(즐겨찾기) 여부 확인 (있으면 true, 없으면 false)
	public boolean checkWish(long user_num, int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean result = false;
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM wishlist WHERE user_num = ? AND prod_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			pstmt.setLong(2, prod_num);
			rs = pstmt.executeQuery();
			if(rs.next()) result = true;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return result;
	}

}