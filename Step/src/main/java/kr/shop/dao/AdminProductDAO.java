package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import kr.shop.vo.AdminProductVO;

public class AdminProductDAO {

	private static AdminProductDAO instance = new AdminProductDAO();

	public static AdminProductDAO getInstance() {
		return instance;
	}

	private AdminProductDAO() {
	}

	// 1. 전체상품 개수 구하기
	public int getProductTotalCount(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		String sub_sql = "";
		int cnt = 0;
		int count = 0;

		try {
			conn = DBUtil.getConnection();

			if (vo.getKeyword() != null && !"".equals(vo.getKeyword())) {
				if ("prod_name".equals(vo.getSearch_type())) {
					sub_sql += " WHERE prod_name LIKE '%' || ? || '%'";
				} else if ("sku".equals(vo.getSearch_type())) {
					sub_sql += " WHERE sku LIKE '%' || ? || '%'";
				}
			}

			sql = "SELECT COUNT(*) FROM products" + sub_sql;
			pstmt = conn.prepareStatement(sql);

			if (vo.getKeyword() != null && !"".equals(vo.getKeyword())) {
				pstmt.setString(++cnt, vo.getKeyword());
			}

			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 2. 상품 목록 불러오기
	public List<AdminProductVO> getProductList(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();
		String sql = null;
		String sub_sql = "";
		int cnt = 0;

		try {
			conn = DBUtil.getConnection();

			if (vo.getKeyword() != null && !"".equals(vo.getKeyword())) {
				if ("prod_name".equals(vo.getSearch_type())) {
					sub_sql += " WHERE p.prod_name LIKE '%' || ? || '%'";
				} else if ("sku".equals(vo.getSearch_type())) {
					sub_sql += " WHERE p.sku LIKE '%' || ? || '%'";
				}
			}

			sql = "SELECT * FROM ( " + "    SELECT a.*, ROWNUM rnum FROM ( "
					+ "        SELECT p.PROD_NUM, p.SKU, p.PROD_NAME, p.PROD_PRICE, p.PROD_STATUS, "
					+ "               p.PROD_CREATED_AT, p.IMG_NUM, " // PROD_IMG_URL 대신 IMG_NUM 사용
					+ "               b.brand_name, c.cat_name " + "        FROM PRODUCTS p "
					+ "        LEFT JOIN brands b ON p.BRAND_NUM = b.BRAND_NUM "
					+ "        LEFT JOIN categories c ON p.CAT_NUM = c.CAT_NUM " + sub_sql
					+ "        ORDER BY p.PROD_NUM DESC " + "    ) a " + ") WHERE rnum >= ? AND rnum <= ?";

			pstmt = conn.prepareStatement(sql);

			if (vo.getKeyword() != null && !"".equals(vo.getKeyword())) {
				pstmt.setString(++cnt, vo.getKeyword());
			}

			pstmt.setInt(++cnt, vo.getStart_row());
			pstmt.setInt(++cnt, vo.getEnd_row());

			rs = pstmt.executeQuery();

			while (rs.next()) {
				AdminProductVO product = new AdminProductVO();
				product.setProd_num(rs.getInt("PROD_NUM"));
				product.setSku(rs.getString("SKU"));
				product.setProd_name(rs.getString("PROD_NAME"));
				product.setProd_price(rs.getInt("PROD_PRICE"));
				product.setProd_status(rs.getInt("PROD_STATUS"));
				product.setProd_created_at(rs.getDate("PROD_CREATED_AT"));
				product.setBrand_name(rs.getString("brand_name"));
				product.setCat_name(rs.getString("cat_name"));

				list.add(product);

			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 3. 상품 상세 조회
	public AdminProductVO getProduct(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AdminProductVO product = null;
		String sql = null;

		try {
			conn = DBUtil.getConnection();

			sql = "SELECT p.*, b.brand_name, c.cat_name " + "FROM products p "
					+ "LEFT JOIN brands b ON p.brand_num = b.brand_num "
					+ "LEFT JOIN categories c ON p.cat_num = c.cat_num " + "WHERE p.prod_num = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				product = new AdminProductVO();
				product.setProd_num(rs.getInt("prod_num"));
				product.setSku(rs.getString("sku"));
				product.setProd_name(rs.getString("prod_name"));
				product.setGender(rs.getInt("gender"));
				product.setProd_price(rs.getInt("prod_price"));
				product.setSale_rate(rs.getInt("sale_rate"));
				product.setProd_text(rs.getString("prod_text"));
				product.setProd_status(rs.getInt("prod_status"));
				product.setCat_num(rs.getInt("cat_num"));
				product.setBrand_num(rs.getInt("brand_num"));
				product.setBrand_name(rs.getString("brand_name"));
				product.setCat_name(rs.getString("cat_name"));
				product.setProd_img_url(rs.getString("prod_img_url"));
				product.setProd_created_at(rs.getDate("prod_created_at"));
				product.setProd_updated_at(rs.getDate("prod_updated_at"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return product;
	}

	// 4. 상품 및 옵션 등록
	public void insertProduct(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String sql = null;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			sql = "INSERT INTO products (prod_num, sku, prod_name, gender, "
					+ "brand_num, cat_num, prod_price, sale_rate, prod_status, prod_text, prod_img_url) "
					+ "VALUES (PRODUCTS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, vo.getSku());
			pstmt.setString(2, vo.getProd_name());
			pstmt.setInt(3, vo.getGender());
			pstmt.setInt(4, vo.getBrand_num());
			pstmt.setInt(5, vo.getCat_num());
			pstmt.setInt(6, vo.getProd_price());
			pstmt.setInt(7, vo.getSale_rate());
			pstmt.setInt(8, vo.getProd_status());
			pstmt.setString(9, vo.getProd_text());
			pstmt.setString(10, vo.getProd_img_url());
			pstmt.executeUpdate();

			// 옵션등
			sql = "INSERT INTO prod_options (opt_num, prod_num, size_val, color, add_price) "
					+ "VALUES (PROD_OPTIONS_SEQ.NEXTVAL, PRODUCTS_SEQ.CURRVAL, ?, ?, ?)";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setInt(1, vo.getSize_val());
			pstmt2.setString(2, vo.getColor());
			pstmt2.setInt(3, vo.getAdd_price());
			pstmt2.executeUpdate();

			conn.commit();
		} catch (Exception e) {
			if (conn != null)
				conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(null, pstmt2, null);
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	// 5. 상품 수정
	public void updateProduct(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;

		try {
			conn = DBUtil.getConnection();
			sql = "UPDATE products SET sku=?, prod_name=?, gender=?, "
					+ "brand_num=?, cat_num=?, prod_price=?, sale_rate=?, prod_status=?, prod_text=?, "
					+ "prod_img_url=?, prod_updated_at=SYSDATE WHERE prod_num=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, vo.getSku());
			pstmt.setString(2, vo.getProd_name());
			pstmt.setInt(3, vo.getGender());
			pstmt.setInt(4, vo.getBrand_num());
			pstmt.setInt(5, vo.getCat_num());
			pstmt.setInt(6, vo.getProd_price());
			pstmt.setInt(7, vo.getSale_rate());
			pstmt.setInt(8, vo.getProd_status());
			pstmt.setString(9, vo.getProd_text());
			pstmt.setString(10, vo.getProd_img_url());
			pstmt.setInt(11, vo.getProd_num());

			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	// 6. 상품 옵션 목록 조회
	public List<AdminProductVO> getProductOptions(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();
		String sql = "SELECT * FROM prod_options WHERE prod_num = ? ORDER BY size_val";

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO option = new AdminProductVO();
				option.setOpt_num(rs.getInt("opt_num"));
				option.setSize_val(rs.getInt("size_val"));
				option.setColor(rs.getString("color"));
				option.setAdd_price(rs.getInt("add_price"));
				list.add(option);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 7. 상품 삭제 (연관된 이미지, 옵션 처리는 DB 제약조건 또는 추가 로직 필요)
	public void deleteProduct(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "DELETE FROM products WHERE prod_num=?";

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
}