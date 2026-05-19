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

	// ==================================
	// [리팩토링] 메인 대시보드 통계용 메서드들
	// ==================================

	// 1. 오늘 신규 주문 건수 조회 (TRUNC 함수 적용)
	public int getTodayOrderCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT COUNT(*) FROM ORDERS WHERE TRUNC(ORDER_CREATED_AT) = TRUNC(SYSDATE)";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 2. 미결제 (결제 대기중) 건수 조회 (ORDER_STATUS = 1)
	public int getPendingPaymentCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT COUNT(*) FROM ORDERS WHERE ORDER_STATUS = 1";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 3. 배송 준비중 건수 조회 (ORDER_STATUS = 2)
	public int getReadyForShippingCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT COUNT(*) FROM ORDERS WHERE ORDER_STATUS = 2";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 4. 취소/반품/교환 요청 건수 조회 (ORDER_STATUS = 5)
	public int getCancelRequestCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT COUNT(*) FROM ORDERS WHERE ORDER_STATUS = 5";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 5. 품절 임박 상품 건수 조회 (재고 5개 미만, IN_STATUS=1, PROD_STATUS 1~4)
	public int getLowStockCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			sql.append("SELECT COUNT(DISTINCT o.opt_num) FROM PRODUCTS p ");
			sql.append("JOIN PROD_OPTIONS o ON p.prod_num = o.prod_num ");
			sql.append("JOIN STOCK S ON o.opt_num = s.opt_num ");
			sql.append("WHERE s.stock_qty < 5 ");
			sql.append("AND p.prod_status IN (1, 2, 3, 4) ");
			sql.append("AND EXISTS (SELECT 1 FROM inbound i WHERE i.opt_num = o.opt_num AND i.in_status = 1)");
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 6. 대시보드 전용 전체 등록 상품 수 조회 (중복 제거 적용)
	public int getDashboardProductTotalCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			sql.append("SELECT COUNT(DISTINCT p.prod_num) FROM products p ");
			sql.append("JOIN prod_options o ON p.prod_num = o.prod_num ");
			sql.append("JOIN stock s ON o.opt_num = s.opt_num ");
			sql.append("WHERE p.prod_status IN (1, 2, 3, 4) ");
			sql.append("AND EXISTS (SELECT 1 FROM inbound i WHERE i.opt_num = o.opt_num AND i.in_status = 1) ");

			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// ============================
	// 상품 목록 및 동적 필터 조회 메서드
	// ============================

	// 1. IN_STATUS=1 상태인 총 상품 데이터 개수 조회
	public int getProductTotalCount(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		int count = 0;

		try {
			conn = DBUtil.getConnection();

			sql.append("SELECT COUNT(*) FROM products p ");
			sql.append("JOIN prod_options o ON p.prod_num = o.prod_num ");
			sql.append("JOIN stock s ON o.opt_num = s.opt_num ");
			sql.append("WHERE EXISTS (SELECT 1 FROM inbound i WHERE i.opt_num = o.opt_num AND i.in_status = 1) ");

			if (vo.getSearch_status() != null && !"".equals(vo.getSearch_status())) {
				sql.append(" AND p.prod_status = ?");
			}
			if (vo.getCat_num() > 0) {
				sql.append(" AND p.cat_num = ?");
			}
			if (vo.getBrand_num() > 0) {
				sql.append(" AND p.brand_num = ?");
			}

			pstmt = conn.prepareStatement(sql.toString());

			int n = 0;
			if (vo.getSearch_status() != null && !"".equals(vo.getSearch_status())) {
				pstmt.setString(++n, vo.getSearch_status());
			}
			if (vo.getCat_num() > 0) {
				pstmt.setInt(++n, vo.getCat_num());
			}
			if (vo.getBrand_num() > 0) {
				pstmt.setInt(++n, vo.getBrand_num());
			}

			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 2. IN_STATUS=1 상태인 상품 및 옵션 색상별 이미지 매칭 목록 조회
	public List<AdminProductVO> getProductList(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();
		StringBuilder sub_sql = new StringBuilder();

		try {
			conn = DBUtil.getConnection();

			sub_sql.append(" WHERE EXISTS (SELECT 1 FROM inbound i WHERE i.opt_num = o.opt_num AND i.in_status = 1) ");

			if (vo.getSearch_status() != null && !"".equals(vo.getSearch_status())) {
				sub_sql.append(" AND p.prod_status = ? ");
			}
			if (vo.getCat_num() > 0) {
				sub_sql.append(" AND p.cat_num = ? ");
			}
			if (vo.getBrand_num() > 0) {
				sub_sql.append(" AND p.brand_num = ? ");
			}

			// 🚨 정렬 기준 동적 처리 (1: 최신입고순 먼저 / 2: 마지막입고순 먼저(오래된순))
			String orderSql = "p.PROD_NUM DESC"; // 기본값 (최신순)
			if ("2".equals(vo.getOrder_type())) {
				orderSql = "p.PROD_NUM ASC"; // 마지막 입고순 (과거순)
			}

			// 🚨 텍스트 블록과 변수 연결 구문 매칭 수정 완료
			String sql = """
					SELECT * FROM (
					    SELECT a.*, ROWNUM rnum FROM (
					        SELECT
					            p.PROD_NUM,
					            p.SKU,
					            p.PROD_NAME,
					            p.PROD_PRICE,
					            p.PROD_STATUS,
					            p.PROD_CREATED_AT,
					            b.brand_name,
					            c.cat_name,
					            s.stock_qty,
					            o.size_val,
					            o.color,
					            COALESCE(
					                (SELECT PROD_IMG_URL
					                 FROM PROD_IMGS
					                 WHERE PROD_NUM = p.PROD_NUM
					                   AND LOWER(PROD_IMG_URL) LIKE '%' ||
					                       CASE
					                           WHEN o.color = '블랙' THEN 'black'
					                           WHEN o.color = '화이트' THEN 'white'
					                           WHEN o.color = '레드' THEN 'red'
					                           WHEN o.color = '블루' THEN 'blue'
					                           WHEN o.color = '그레이' THEN 'gray'
					                           ELSE LOWER(o.color)
					                       END || '%'
					                   AND ROWNUM = 1),
					                (SELECT PROD_IMG_URL FROM PROD_IMGS WHERE PROD_NUM = p.PROD_NUM AND ROWNUM = 1)
					            ) AS PROD_IMG_URL
					        FROM PRODUCTS p
					        JOIN PROD_OPTIONS o ON p.PROD_NUM = o.PROD_NUM
					        JOIN STOCK s ON o.OPT_NUM = s.OPT_NUM
					        LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM
					        LEFT JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM
					""" + sub_sql.toString() + """
					ORDER BY p.PROD_STATUS ASC, """ + orderSql + """
					        , o.color ASC, o.size_val ASC
					    ) a
					) WHERE rnum >= ? AND rnum <= ?
					""";

			pstmt = conn.prepareStatement(sql);

			int n = 0;
			if (vo.getSearch_status() != null && !"".equals(vo.getSearch_status())) {
				pstmt.setString(++n, vo.getSearch_status());
			}
			if (vo.getCat_num() > 0) {
				pstmt.setInt(++n, vo.getCat_num());
			}
			if (vo.getBrand_num() > 0) {
				pstmt.setInt(++n, vo.getBrand_num());
			}
			pstmt.setInt(++n, vo.getStart_row());
			pstmt.setInt(++n, vo.getEnd_row());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO product = new AdminProductVO();
				product.setProd_num(rs.getInt("PROD_NUM"));
				product.setSku(rs.getString("SKU"));
				product.setProd_name(rs.getString("PROD_NAME"));
				product.setProd_price(rs.getInt("PROD_PRICE"));
				product.setProd_status(rs.getInt("PROD_STATUS"));
				product.setProd_created_at(rs.getDate("PROD_CREATED_AT"));
				product.setProd_img_url(rs.getString("PROD_IMG_URL"));
				product.setBrand_name(rs.getString("brand_name"));
				product.setCat_name(rs.getString("cat_name"));
				product.setStock_qty(rs.getInt("stock_qty"));
				product.setSize_val(rs.getInt("size_val"));
				product.setColor(rs.getString("color"));

				list.add(product);
			}
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

		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT p.*, b.brand_name, c.cat_name " + "FROM products p "
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
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return product;
	}

	// 4. 상품 등록 (트랜잭션: 상품 + 옵션 + 메인이미지)
	public void insertProduct(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String sql = "";
		int prod_num = 0;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			sql = "SELECT PRODUCTS_SEQ.NEXTVAL FROM DUAL";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				prod_num = rs.getInt(1);

			sql = "INSERT INTO products (prod_num, sku, prod_name, gender, brand_num, cat_num, "
					+ "prod_price, sale_rate, prod_status, prod_text, prod_img_url) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setInt(1, prod_num);
			pstmt2.setString(2, vo.getSku());
			pstmt2.setString(3, vo.getProd_name());
			pstmt2.setInt(4, vo.getGender());
			pstmt2.setInt(5, vo.getBrand_num());
			pstmt2.setInt(6, vo.getCat_num());
			pstmt2.setInt(7, vo.getProd_price());
			pstmt2.setInt(8, vo.getSale_rate());
			pstmt2.setInt(9, vo.getProd_status());
			pstmt2.setString(10, vo.getProd_text());
			pstmt2.setString(11, vo.getProd_img_url());
			pstmt2.executeUpdate();

			sql = "INSERT INTO prod_options (opt_num, prod_num, size_val, color, add_price) "
					+ "VALUES (PROD_OPTIONS_SEQ.NEXTVAL, ?, ?, ?, ?)";
			pstmt3 = conn.prepareStatement(sql);
			pstmt3.setInt(1, prod_num);
			pstmt3.setInt(2, vo.getSize_val());
			pstmt3.setString(3, vo.getColor());
			pstmt3.setInt(4, vo.getAdd_price());
			pstmt3.executeUpdate();

			conn.commit();
		} catch (Exception e) {
			if (conn != null)
				conn.rollback();
			throw e;
		} finally {
			DBUtil.executeClose(null, pstmt3, null);
			DBUtil.executeClose(null, pstmt2, null);
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}

	// 5. 상품 수정
	public void updateProduct(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE products SET sku=?, prod_name=?, gender=?, brand_num=?, cat_num=?, "
					+ "prod_price=?, sale_rate=?, prod_status=?, prod_text=?, prod_img_url=?, "
					+ "prod_updated_at=SYSDATE WHERE prod_num=?";

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

		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM prod_options WHERE prod_num = ? ORDER BY opt_num ASC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO option = new AdminProductVO();
				option.setOpt_num(rs.getInt("opt_num"));
				option.setProd_num(rs.getInt("prod_num"));
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

	// 7. 상품 삭제
	public void deleteProduct(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement("DELETE FROM prod_options WHERE prod_num=?");
			pstmt1.setInt(1, prod_num);
			pstmt1.executeUpdate();

			pstmt2 = conn.prepareStatement("DELETE FROM products WHERE prod_num=?");
			pstmt2.setInt(1, prod_num);
			pstmt2.executeUpdate();

			conn.commit();
		} catch (Exception e) {
			if (conn != null)
				conn.rollback();
			throw e;
		} finally {
			DBUtil.executeClose(null, pstmt2, null);
			DBUtil.executeClose(null, pstmt1, conn);
		}
	}

	// 8. 브랜드 리스트 (Y인 것만)
	public List<AdminProductVO> getBrandList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT brand_num, brand_name FROM brands WHERE brand_use_yn = 'Y' ORDER BY brand_name";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setBrand_num(rs.getInt(1));
				vo.setBrand_name(rs.getString(2));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 9. 카테고리 리스트 (Y인 것만)
	public List<AdminProductVO> getCategoryList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT cat_num, cat_name FROM categories WHERE cat_use_yn = 'Y' ORDER BY cat_sort_no";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setCat_num(rs.getInt(1));
				vo.setCat_name(rs.getString(2));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}