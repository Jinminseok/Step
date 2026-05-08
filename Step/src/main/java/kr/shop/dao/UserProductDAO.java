package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class UserProductDAO {
	private static UserProductDAO instance = new UserProductDAO();

	public static UserProductDAO getInstance() {
		return instance;
	}

	private UserProductDAO() {
	}

	// 1. 상품 기본 상세 정보 + 브랜드명 가져오기
	public AdminProductVO getProductDetail(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AdminProductVO vo = null;

		// PROD_TEXT가 누락되어 있어 추가함
		String sql = "SELECT p.prod_num, p.prod_name, p.sku, p.prod_price, p.sale_rate, p.prod_text, b.brand_name "
				+ "FROM products p JOIN brands b ON p.brand_num = b.brand_num WHERE p.prod_num = ?";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vo = new AdminProductVO();
				// 세터 메서드명을 VO에 정의된 스네이크 케이스 기반으로 수정
				vo.setProd_num(rs.getInt("prod_num"));
				vo.setProd_name(rs.getString("prod_name"));
				vo.setSku(rs.getString("sku"));
				vo.setProd_price(rs.getInt("prod_price"));
				vo.setSale_rate(rs.getInt("sale_rate")); // VO가 int이므로 getInt 사용
				vo.setBrand_name(rs.getString("brand_name"));
				vo.setProd_text(rs.getString("prod_text"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return vo;
	}

	// 2. 해당 상품의 모든 다중 이미지 가져오기
	public List<String> getProductImages(int prod_num) throws Exception {
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 메인 사진이 제일 먼저 오도록 정렬
		String sql = "SELECT prod_img_url FROM prod_imgs WHERE prod_num = ? ORDER BY is_main DESC, prod_img_sort_no ASC";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("prod_img_url"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 3. 해당 상품의 고유 색상 목록 가져오기
	public List<String> getProductColors(int prod_num) throws Exception {
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT DISTINCT color FROM prod_options WHERE prod_num = ? AND prod_use_yn = 'Y'";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("color"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 4. 해당 상품의 고유 사이즈 목록 가져오기
	public List<Integer> getProductSizes(int prod_num) throws Exception {
		List<Integer> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 작은 사이즈부터 오름차순
		String sql = "SELECT DISTINCT size_val FROM prod_options WHERE prod_num = ? AND prod_use_yn = 'Y' ORDER BY size_val ASC";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getInt("size_val"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 5. 상품 총 재고량 계산하기
	public int getProductTotalStock(int prod_num) throws Exception {
		int total = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT sum(stock_qty) FROM stock WHERE prod_num = ?";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				total = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return total;
	}
}