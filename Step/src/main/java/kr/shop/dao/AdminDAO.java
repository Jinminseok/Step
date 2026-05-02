package kr.shop.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import kr.shop.vo.AdminVO;
import kr.util.DBUtil; // DBUtil 경로 확인

public class AdminDAO {

	// ==========================================
	// 1. 상품 CRUD 중 C (통합 등록)
	// ==========================================
	public boolean insertFullProduct(AdminVO vo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean isSuccess = false;

		try {
			conn = DBUtil.getConnection(); // DBUtil 사용
			conn.setAutoCommit(false); // 트랜잭션 시작

			// (1) 상품 기본 정보 등록
			String sqlProd = "INSERT INTO PRODUCTS (PROD_NUM, CAT_NUM, BRAND_NUM, SKU, PROD_NAME, GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS, PROD_CREATED_AT) "
					+ "VALUES (PROD_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, 1, SYSDATE)";

			pstmt = conn.prepareStatement(sqlProd, new String[] { "PROD_NUM" });
			pstmt.setInt(1, vo.getCat_num());
			pstmt.setInt(2, vo.getBrand_num());
			pstmt.setString(3, vo.getSku());
			pstmt.setString(4, vo.getProd_name());
			pstmt.setInt(5, vo.getGender());
			pstmt.setInt(6, vo.getProd_price());
			pstmt.setInt(7, vo.getSale_rate());
			pstmt.setString(8, vo.getProd_text());

			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			int prodNum = 0;
			if (rs.next()) {
				prodNum = rs.getInt(1);
			}

			// (2) 옵션 정보 다중 등록
			if (prodNum > 0 && vo.getOptionList() != null && !vo.getOptionList().isEmpty()) {
				if (pstmt != null)
					pstmt.close();
				String sqlOpt = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
						+ "VALUES (OPT_SEQ.NEXTVAL, ?, ?, ?, ?, 'Y')";
				pstmt = conn.prepareStatement(sqlOpt);

				for (AdminVO opt : vo.getOptionList()) {
					pstmt.setInt(1, prodNum);
					pstmt.setInt(2, opt.getSize_val());
					pstmt.setString(3, opt.getColor());
					pstmt.setInt(4, opt.getAdd_price());
					pstmt.addBatch();
				}
				pstmt.executeBatch();
			}

			// (3) 이미지 정보 다중 등록
			if (prodNum > 0 && vo.getImageList() != null && !vo.getImageList().isEmpty()) {
				if (pstmt != null)
					pstmt.close();
				String sqlImg = "INSERT INTO PROD_IMGS (PROD_IMG_NUM, PROD_NUM, PROD_IMG_URL, IS_MAIN, PROD_IMG_SORT_NO) "
						+ "VALUES (IMG_SEQ.NEXTVAL, ?, ?, ?, ?)";
				pstmt = conn.prepareStatement(sqlImg);

				for (AdminVO img : vo.getImageList()) {
					pstmt.setInt(1, prodNum);
					pstmt.setString(2, img.getProd_img_url());
					pstmt.setString(3, img.getIs_main());
					pstmt.setInt(4, img.getProd_img_sort_no());
					pstmt.addBatch();
				}
				pstmt.executeBatch();
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
			DBUtil.executeClose(rs, pstmt, conn); // 자원 반납 통일
		}
		return isSuccess;
	}

	// ==========================================
	// 2. 상품 CRUD 중 R (목록 조회)
	// ==========================================
	public List<AdminVO> getProductList() {
		List<AdminVO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT p.*, c.CAT_NAME, b.BRAND_NAME " + "FROM PRODUCTS p "
					+ "JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM " + "JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
					+ "ORDER BY p.PROD_NUM DESC";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setProd_num(rs.getInt("PROD_NUM"));
				vo.setProd_name(rs.getString("PROD_NAME"));
				vo.setSku(rs.getString("SKU"));
				vo.setCat_name(rs.getString("CAT_NAME"));
				vo.setBrand_name(rs.getString("BRAND_NAME"));
				vo.setProd_price(rs.getInt("PROD_PRICE"));
				vo.setProd_status(rs.getInt("PROD_STATUS"));
				vo.setProd_created_at(rs.getDate("PROD_CREATED_AT"));
				list.add(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// ==========================================
	// 3. 상품 CRUD 중 U (통합 수정)
	// ==========================================
	public boolean updateFullProduct(AdminVO vo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		boolean isSuccess = false;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			String sqlProd = "UPDATE PRODUCTS SET CAT_NUM=?, BRAND_NUM=?, SKU=?, PROD_NAME=?, "
					+ "GENDER=?, PROD_PRICE=?, SALE_RATE=?, PROD_TEXT=?, PROD_STATUS=?, PROD_UPDATED_AT=SYSDATE "
					+ "WHERE PROD_NUM=?";

			pstmt = conn.prepareStatement(sqlProd);
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

			// 옵션 재등록 로직
			if (vo.getOptionList() != null) {
				if (pstmt != null)
					pstmt.close();
				String sqlDelOpt = "DELETE FROM PROD_OPTIONS WHERE PROD_NUM = ?";
				pstmt = conn.prepareStatement(sqlDelOpt);
				pstmt.setInt(1, vo.getProd_num());
				pstmt.executeUpdate();

				if (!vo.getOptionList().isEmpty()) {
					if (pstmt != null)
						pstmt.close();
					String sqlInsOpt = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
							+ "VALUES (OPT_SEQ.NEXTVAL, ?, ?, ?, ?, 'Y')";
					pstmt = conn.prepareStatement(sqlInsOpt);
					for (AdminVO opt : vo.getOptionList()) {
						pstmt.setInt(1, vo.getProd_num());
						pstmt.setInt(2, opt.getSize_val());
						pstmt.setString(3, opt.getColor());
						pstmt.setInt(4, opt.getAdd_price());
						pstmt.addBatch();
					}
					pstmt.executeBatch();
				}
			}

			// 이미지 재등록 로직
			if (vo.getImageList() != null) {
				if (pstmt != null)
					pstmt.close();
				String sqlDelImg = "DELETE FROM PROD_IMGS WHERE PROD_NUM = ?";
				pstmt = conn.prepareStatement(sqlDelImg);
				pstmt.setInt(1, vo.getProd_num());
				pstmt.executeUpdate();

				if (!vo.getImageList().isEmpty()) {
					if (pstmt != null)
						pstmt.close();
					String sqlInsImg = "INSERT INTO PROD_IMGS (PROD_IMG_NUM, PROD_NUM, PROD_IMG_URL, IS_MAIN, PROD_IMG_SORT_NO) "
							+ "VALUES (IMG_SEQ.NEXTVAL, ?, ?, ?, ?)";
					pstmt = conn.prepareStatement(sqlInsImg);
					for (AdminVO img : vo.getImageList()) {
						pstmt.setInt(1, vo.getProd_num());
						pstmt.setString(2, img.getProd_img_url());
						pstmt.setString(3, img.getIs_main());
						pstmt.setInt(4, img.getProd_img_sort_no());
						pstmt.addBatch();
					}
					pstmt.executeBatch();
				}
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
			DBUtil.executeClose(null, pstmt, conn);
		}
		return isSuccess;
	}

	// ==========================================
	// 4. 상품 CRUD 중 D (물리적 삭제)
	// ==========================================
	public boolean deleteProductPhysical(int prod_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		boolean isSuccess = false;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			String sqlImg = "DELETE FROM PROD_IMGS WHERE PROD_NUM = ?";
			pstmt = conn.prepareStatement(sqlImg);
			pstmt.setInt(1, prod_num);
			pstmt.executeUpdate();
			pstmt.close();

			String sqlOpt = "DELETE FROM PROD_OPTIONS WHERE PROD_NUM = ?";
			pstmt = conn.prepareStatement(sqlOpt);
			pstmt.setInt(1, prod_num);
			pstmt.executeUpdate();
			pstmt.close();

			String sqlProd = "DELETE FROM PRODUCTS WHERE PROD_NUM = ?";
			pstmt = conn.prepareStatement(sqlProd);
			pstmt.setInt(1, prod_num);

			int result = pstmt.executeUpdate();

			if (result > 0) {
				conn.commit();
				isSuccess = true;
			}

		} catch (Exception e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (Exception se) {
				se.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
		return isSuccess;
	}
}