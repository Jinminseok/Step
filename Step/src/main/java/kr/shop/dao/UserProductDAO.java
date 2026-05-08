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
		String sql = "SELECT P.PROD_NUM, P.PROD_NAME, P.SKU, P.PROD_PRICE, P.SALE_RATE, P.PROD_TEXT, B.BRAND_NAME "
				+ "FROM PRODUCTS P JOIN BRANDS B ON P.BRAND_NUM = B.BRAND_NUM " + "WHERE P.PROD_NUM = ?";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vo = new AdminProductVO();
				// 세터 메서드명을 VO에 정의된 스네이크 케이스 기반으로 수정
				vo.setProd_num(rs.getInt("PROD_NUM"));
				vo.setProd_name(rs.getString("PROD_NAME"));
				vo.setSku(rs.getString("SKU"));
				vo.setProd_price(rs.getInt("PROD_PRICE"));
				vo.setSale_rate(rs.getInt("SALE_RATE")); // VO가 int이므로 getInt 사용
				vo.setBrand_name(rs.getString("BRAND_NAME"));
				vo.setProd_text(rs.getString("PROD_TEXT"));
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
		String sql = "SELECT PROD_IMG_URL FROM PROD_IMGS WHERE PROD_NUM = ? ORDER BY IS_MAIN DESC, PROD_IMG_SORT_NO ASC";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("PROD_IMG_URL"));
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
		String sql = "SELECT DISTINCT COLOR FROM PROD_OPTIONS WHERE PROD_NUM = ? AND PROD_USE_YN = 'Y'";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("COLOR"));
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
		String sql = "SELECT DISTINCT SIZE_VAL FROM PROD_OPTIONS WHERE PROD_NUM = ? AND PROD_USE_YN = 'Y' ORDER BY SIZE_VAL ASC";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getInt("SIZE_VAL"));
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
		String sql = "SELECT SUM(STOCK_QTY) FROM STOCK WHERE PROD_NUM = ?";
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