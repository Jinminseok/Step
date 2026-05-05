package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminVO;
import kr.util.DBUtil;

public class AdminDAO {

	// 싱글톤 패턴
	private static AdminDAO instance = new AdminDAO();

	private AdminDAO() {
	}

	public static AdminDAO getInstance() {
		return instance;
	}

	/**
	 * 1. 상품 통합 등록 (상품 + 옵션 + 이미지 테이블 트랜잭션 처리)
	 */
	public boolean insertProduct(AdminVO vo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean isSuccess = false;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// (1) PRODUCTS 테이블 등록
			// 수정: PROD_SEQ -> PRODUCTS_SEQ (DB 확인 결과 반영)
			sql = "INSERT INTO PRODUCTS (PROD_NUM, CAT_NUM, BRAND_NUM, SKU, PROD_NAME, GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS, PROD_CREATED_AT) "
					+ "VALUES (PRODUCTS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, 1, SYSDATE)";

			pstmt = conn.prepareStatement(sql, new String[] { "PROD_NUM" });
			pstmt.setInt(1, vo.getCat_num());
			pstmt.setInt(2, vo.getBrand_num());
			pstmt.setString(3, vo.getSku());
			pstmt.setString(4, vo.getProd_name());
			pstmt.setInt(5, vo.getGender());
			pstmt.setInt(6, vo.getProd_price());
			pstmt.setInt(7, vo.getSale_rate());
			pstmt.setString(8, vo.getProd_text());
			pstmt.executeUpdate();

			// 생성된 PROD_NUM 가져오기
			rs = pstmt.getGeneratedKeys();
			int prodNum = 0;
			if (rs.next()) {
				prodNum = rs.getInt(1);
			}

			// (2) PROD_OPTIONS 테이블 등록
			// 수정: OPT_SEQ -> PROD_OPTIONS_SEQ (DB 확인 결과 반영)
			if (pstmt != null)
				pstmt.close();
			sql = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
					+ "VALUES (PROD_OPTIONS_SEQ.NEXTVAL, ?, ?, ?, ?, 'Y')";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prodNum);
			pstmt.setInt(2, vo.getSize_val());
			pstmt.setString(3, vo.getColor());
			pstmt.setInt(4, vo.getAdd_price());
			pstmt.executeUpdate();

			// (3) PROD_IMGS 테이블 등록
			// 수정: IMG_SEQ -> PROD_IMGS_SEQ (DB 확인 결과 반영)
			if (vo.getProd_img_url() != null && !vo.getProd_img_url().isEmpty()) {
				if (pstmt != null)
					pstmt.close();
				sql = "INSERT INTO PROD_IMGS (PROD_IMG_NUM, PROD_NUM, PROD_IMG_URL, IS_MAIN, PROD_IMG_SORT_NO) "
						+ "VALUES (PROD_IMGS_SEQ.NEXTVAL, ?, ?, 'Y', 1)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, prodNum);
				pstmt.setString(2, vo.getProd_img_url());
				pstmt.executeUpdate();
			}

			conn.commit();
			isSuccess = true;
		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException se) {
				se.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return isSuccess;
	}

	/**
	 * 2. 페이징을 위한 전체 상품 개수 조회
	 */
	public int getProductCount(AdminVO filter) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();

		try {
			conn = DBUtil.getConnection();
			sql.append("SELECT COUNT(*) FROM PRODUCTS WHERE 1=1 ");

			if (filter.getCat_num() > 0)
				sql.append("AND CAT_NUM = ? ");
			if (filter.getGender() >= 0)
				sql.append("AND GENDER = ? ");
			if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
				sql.append("AND (PROD_NAME LIKE ? OR SKU LIKE ?) ");
			}

			pstmt = conn.prepareStatement(sql.toString());
			int idx = 1;
			if (filter.getCat_num() > 0)
				pstmt.setInt(idx++, filter.getCat_num());
			if (filter.getGender() >= 0)
				pstmt.setInt(idx++, filter.getGender());
			if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
				String kw = "%" + filter.getKeyword().trim() + "%";
				pstmt.setString(idx++, kw);
				pstmt.setString(idx++, kw);
			}

			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	/**
	 * 3. 상품 전체 목록 조회 (페이징 및 검색 필터 포함)
	 */
	public List<AdminVO> getProductList(AdminVO filter) {
		List<AdminVO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();

		try {
			conn = DBUtil.getConnection();

			// Oracle용 페이징 처리 쿼리
			sql.append("SELECT * FROM (SELECT a.*, rownum rnum FROM (");
			sql.append("SELECT p.PROD_NUM, p.PROD_NAME, p.SKU, p.PROD_PRICE, p.SALE_RATE, ");
			sql.append("p.GENDER, p.PROD_STATUS, p.PROD_CREATED_AT, ");
			sql.append("c.CAT_NAME, b.BRAND_NAME, i.PROD_IMG_URL ");
			sql.append("FROM PRODUCTS p ");
			sql.append("JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM ");
			sql.append("JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM ");
			sql.append("LEFT JOIN PROD_IMGS i ON p.PROD_NUM = i.PROD_NUM AND i.IS_MAIN = 'Y' ");
			sql.append("WHERE 1=1 ");

			// 필터링 조건 추가
			if (filter.getCat_num() > 0)
				sql.append("AND p.CAT_NUM = ? ");
			if (filter.getGender() >= 0)
				sql.append("AND p.GENDER = ? ");
			if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
				sql.append("AND (p.PROD_NAME LIKE ? OR p.SKU LIKE ?) ");
			}
			sql.append("ORDER BY p.PROD_CREATED_AT DESC) a) ");
			sql.append("WHERE rnum >= ? AND rnum <= ?");

			pstmt = conn.prepareStatement(sql.toString());
			int idx = 1;
			if (filter.getCat_num() > 0)
				pstmt.setInt(idx++, filter.getCat_num());
			if (filter.getGender() >= 0)
				pstmt.setInt(idx++, filter.getGender());
			if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
				String kw = "%" + filter.getKeyword().trim() + "%";
				pstmt.setString(idx++, kw);
				pstmt.setString(idx++, kw);
			}

			// VO의 필드명(start_row, end_row)에 맞게 Getter 호출 수정
			pstmt.setInt(idx++, filter.getStart_row());
			pstmt.setInt(idx++, filter.getEnd_row());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setProd_num(rs.getInt("PROD_NUM"));
				vo.setProd_name(rs.getString("PROD_NAME"));
				vo.setSku(rs.getString("SKU"));
				vo.setProd_price(rs.getInt("PROD_PRICE"));
				vo.setSale_rate(rs.getInt("SALE_RATE"));
				vo.setGender(rs.getInt("GENDER"));
				vo.setProd_status(rs.getInt("PROD_STATUS"));
				vo.setProd_created_at(rs.getDate("PROD_CREATED_AT"));
				vo.setCat_name(rs.getString("CAT_NAME"));
				vo.setBrand_name(rs.getString("BRAND_NAME"));
				vo.setProd_img_url(rs.getString("PROD_IMG_URL"));
				list.add(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	/**
	 * 4. 상품 상세 조회
	 */
	public AdminVO getProductDetail(int prod_num) {
		AdminVO vo = null;
		String sql = "SELECT * FROM PRODUCTS WHERE PROD_NUM = ?";

		try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, prod_num);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					vo = new AdminVO();
					vo.setProd_num(rs.getInt("PROD_NUM"));
					vo.setCat_num(rs.getInt("CAT_NUM"));
					vo.setBrand_num(rs.getInt("BRAND_NUM"));
					vo.setSku(rs.getString("SKU"));
					vo.setProd_name(rs.getString("PROD_NAME"));
					vo.setGender(rs.getInt("GENDER"));
					vo.setProd_price(rs.getInt("PROD_PRICE"));
					vo.setSale_rate(rs.getInt("SALE_RATE"));
					vo.setProd_text(rs.getString("PROD_TEXT"));
					vo.setProd_status(rs.getInt("PROD_STATUS"));
					vo.setProd_created_at(rs.getDate("PROD_CREATED_AT"));
					vo.setProd_updated_at(rs.getDate("PROD_UPDATED_AT"));
				}
			}
		} catch (SQLException e) {
			System.err.println("상품 상세 조회 중 오류 발생 (PROD_NUM: " + prod_num + "): " + e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vo;
	}

	/**
	 * 5. 카테고리 목록 조회
	 */
	public List<AdminVO> getCategoryList() {
		List<AdminVO> list = new ArrayList<>();
		String sql = "SELECT cat_num, cat_name FROM CATEGORIES WHERE cat_use_yn = 'Y' ORDER BY cat_sort_no ASC";

		try (Connection conn = DBUtil.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setCat_num(rs.getInt("cat_num"));
				vo.setCat_name(rs.getString("cat_name"));
				list.add(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 6. 브랜드 목록 조회
	 */
	public List<AdminVO> getBrandList() {
		List<AdminVO> list = new ArrayList<>();
		String sql = "SELECT brand_num, brand_name FROM BRANDS WHERE brand_use_yn = 'Y' ORDER BY brand_name ASC";

		try (Connection conn = DBUtil.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setBrand_num(rs.getInt("brand_num"));
				vo.setBrand_name(rs.getString("brand_name"));
				list.add(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 7. 상품 정보 수정
	 */
	public void updateProduct(AdminVO vo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE PRODUCTS SET CAT_NUM=?, BRAND_NUM=?, SKU=?, PROD_NAME=?, "
					+ "GENDER=?, PROD_PRICE=?, SALE_RATE=?, PROD_TEXT=?, PROD_STATUS=?, "
					+ "PROD_UPDATED_AT=SYSDATE WHERE PROD_NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, vo.getCat_num());
			pstmt.setInt(2, vo.getBrand_num());
			pstmt.setString(3, vo.getSku());
			pstmt.setString(4, vo.getProd_name());
			pstmt.setInt(5, vo.getGender());
			pstmt.setInt(6, vo.getProd_price());
			pstmt.setInt(7, vo.getSale_rate());
			pstmt.setString(8, vo.getProd_text());
			pstmt.setInt(9, vo.getProd_status());
			pstmt.setInt(10, vo.getProd_num());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	/**
	 * 8. 상품 상태 변경 (논리적 삭제 등)
	 */
	public void updateProductStatus(int prod_num, int prod_status) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE PRODUCTS SET PROD_STATUS=?, PROD_UPDATED_at=SYSDATE WHERE PROD_NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_status);
			pstmt.setInt(2, prod_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	/**
	 * 9. 상품 물리적 삭제
	 */
	public void deleteProduct(int prod_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "DELETE FROM PRODUCTS WHERE PROD_NUM=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
}