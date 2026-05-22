package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;
import kr.shop.vo.AdminProductVO;

public class AdminProductDAO {

	private static AdminProductDAO instance = new AdminProductDAO();

	public static AdminProductDAO getInstance() {
		return instance;
	}

	private AdminProductDAO() {
	}

	// [대시보드용 - adminMain.jsp] 당일 주문 건수 조회
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

	// [대시보드용 - 보류/추후사용] 결제 대기 상태(1) 건수 조회
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

	// [대시보드용 - 보류/추후사용] 배송 준비 상태(2) 건수 조회
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

	// [대시보드용 - adminMain.jsp] 취소/반품 요청 상태(5) 건수 조회
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

	// [대시보드용 - adminMain.jsp] 재고 부족 (5개 미만) 상품 옵션 건수 조회
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

	// [대시보드용 - 보류/추후사용] 입고 완료된 활성 상품의 총 개수 조회
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

	// [대시보드용 - adminMain.jsp] 오늘 매출 금액 합계
	public long getTodaySalesAmount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long total = 0;
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT NVL(SUM(pay_price), 0) FROM orders WHERE TRUNC(order_created_at) = TRUNC(SYSDATE) AND order_status IN (1, 2, 3, 4)";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				total = rs.getLong(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return total;
	}

	// [대시보드용 - adminMain.jsp] 당일 가입한 신규 회원 수
	public int getTodayNewUserCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT COUNT(*) FROM users_detail WHERE TRUNC(user_created_at) = TRUNC(SYSDATE)";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// [대시보드용 - adminMain.jsp] 최근 4개월 월별 매출 통계 (차트용)
	public List<Map<String, Object>> getMonthlySales() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT TO_CHAR(order_created_at, 'MM') AS month, NVL(SUM(pay_price), 0) AS sales "
					+ "FROM orders " + "WHERE order_created_at >= TRUNC(ADD_MONTHS(SYSDATE, -3), 'MM') "
					+ "GROUP BY TO_CHAR(order_created_at, 'MM') " + "ORDER BY month";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("MONTH", rs.getString("month"));
				map.put("SALES", rs.getLong("sales"));
				list.add(map);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// [대시보드용 - adminMain.jsp] 인기 상품 TOP 4 통계 (차트용)
	public List<Map<String, Object>> getTopProducts() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM (" + "  SELECT p.prod_name, SUM(oi.order_item_qty) AS sales_count "
					+ "  FROM order_items oi " + "  JOIN products p ON oi.prod_num = p.prod_num "
					+ "  GROUP BY p.prod_name " + "  ORDER BY sales_count DESC" + ") WHERE ROWNUM <= 4";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("PROD_NAME", rs.getString("prod_name"));
				map.put("SALES_COUNT", rs.getInt("sales_count"));
				list.add(map);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// [대시보드용 - adminMain.jsp] 최신 주문 목록 5건 조회
	public List<Map<String, Object>> getRecentOrders() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM (" + "  SELECT " + "    o.order_num, "
					+ "    NVL(u.user_id, '비회원') AS user_id, "
					+ "    (SELECT p.prod_name FROM order_items oi JOIN products p ON oi.prod_num = p.prod_num WHERE oi.order_num = o.order_num AND ROWNUM = 1) AS main_prod_name, "
					+ "    (SELECT COUNT(*) FROM order_items WHERE order_num = o.order_num) AS item_cnt, "
					+ "    o.pay_price, " + "    o.order_status, " + "    o.order_created_at " + "  FROM orders o "
					+ "  LEFT JOIN users u ON o.user_num = u.user_num " + "  ORDER BY o.order_created_at DESC"
					+ ") WHERE ROWNUM <= 5";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("ORDER_NUM", rs.getString("order_num"));
				map.put("USER_ID", rs.getString("user_id"));

				String mainProdName = rs.getString("main_prod_name");
				int itemCnt = rs.getInt("item_cnt");

				if (itemCnt > 1) {
					map.put("PROD_NAME", mainProdName + " 외 " + (itemCnt - 1) + "건");
				} else {
					map.put("PROD_NAME", mainProdName != null ? mainProdName : "상품정보없음");
				}

				map.put("PAY_PRICE", rs.getInt("pay_price"));
				map.put("ORDER_STATUS", rs.getInt("order_status"));
				map.put("ORDER_DATE", rs.getDate("order_created_at"));
				list.add(map);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// [상품관리용 - productList.jsp 등] 검색 조건에 맞는 상품 총 레코드 수 (페이징 처리용)
	public int getProductTotalCount(AdminProductVO vo) throws Exception {
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

	// [상품관리용 - productList.jsp 등] 조건에 맞는 전체 상품 목록 조회
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

			String orderSql = "p.PROD_NUM DESC";
			if ("2".equals(vo.getOrder_type())) {
				orderSql = "p.PROD_NUM ASC";
			}

			String sql = """
					SELECT * FROM (
					    SELECT a.*, ROWNUM rnum FROM (
					        SELECT
					            base.PROD_NUM, base.SKU, base.PROD_NAME, base.PROD_PRICE, base.PROD_STATUS, base.PROD_CREATED_AT,
					            base.brand_name, base.cat_name, base.min_size, base.max_size, base.color, base.color_cnt,
					            (SELECT PROD_IMG_URL FROM PROD_IMGS WHERE PROD_NUM = base.PROD_NUM AND ROWNUM = 1) AS PROD_IMG_URL
					        FROM (
					            SELECT
					                p.PROD_NUM, p.SKU, p.PROD_NAME, p.PROD_PRICE, p.PROD_STATUS, p.PROD_CREATED_AT,
					                b.brand_name, c.cat_name,
					                -- 👇 핵심: 재고가 0 초과인 경우만 사이즈를 수집함. 재고가 없으면 0으로 표시.
					                NVL(MIN(CASE WHEN NVL(s.stock_qty, 0) > 0 THEN o.size_val END), 0) AS min_size,
					                NVL(MAX(CASE WHEN NVL(s.stock_qty, 0) > 0 THEN o.size_val END), 0) AS max_size,
					                MIN(o.color) AS color, COUNT(DISTINCT o.color) AS color_cnt
					            FROM PRODUCTS p
					            JOIN PROD_OPTIONS o ON p.PROD_NUM = o.PROD_NUM
					            LEFT JOIN STOCK s ON o.opt_num = s.opt_num  -- 재고 테이블 조인 추가
					            LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM
					            LEFT JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM
					"""
					+ sub_sql.toString()
					+ """
							GROUP BY p.PROD_NUM, p.SKU, p.PROD_NAME, p.PROD_PRICE, p.PROD_STATUS, p.PROD_CREATED_AT, b.brand_name, c.cat_name
							ORDER BY p.PROD_STATUS ASC, """
					+ orderSql + """
							        ) base
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

				product.setMin_size(rs.getInt("min_size"));
				product.setMax_size(rs.getInt("max_size"));
				product.setColor(rs.getString("color"));
				product.setColor_cnt(rs.getInt("color_cnt"));

				list.add(product);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// [상품관리용 - productDetail.jsp 등] 특정 상품의 옵션별 사이즈, 색상, 재고량 조회
	public List<AdminProductVO> getProductStockDetails(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();

		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT o.size_val, o.color, NVL(s.stock_qty, 0) as stock_qty "
					+ "FROM prod_options o LEFT JOIN stock s ON o.opt_num = s.opt_num "
					+ "WHERE o.prod_num = ? ORDER BY o.size_val ASC, o.color ASC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setSize_val(rs.getInt("size_val"));
				vo.setColor(rs.getString("color"));
				vo.setStock_qty(rs.getInt("stock_qty"));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// [상품관리용 - productDetail.jsp / modifyForm.jsp] 특정 상품 단건 정보 조회
	public AdminProductVO getProduct(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AdminProductVO product = null;

		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT p.*, b.brand_name, c.cat_name FROM products p "
					+ "LEFT JOIN brands b ON p.brand_num = b.brand_num "
					+ "LEFT JOIN categories c ON p.cat_num = c.cat_num WHERE p.prod_num = ?";

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

	// [상품관리용 - Action 클래스 처리] 새 상품 및 옵션 등록 프로세스
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

	// [상품관리용 - Action 클래스 처리] 기존 상품 정보 수정 프로세스
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

	// [상품관리용 - productDetail.jsp / modifyForm.jsp] 특정 상품의 옵션 목록 조회
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

	// [상품관리용 - Action 클래스 처리] 상품 삭제 프로세스 (옵션 먼저 삭제 후 상품 삭제)
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

	// [공통/상품관리 폼용] 셀렉트 박스 구성을 위한 브랜드 목록 조회
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

	// [공통/상품관리 폼용] 셀렉트 박스 구성을 위한 카테고리 목록 조회
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