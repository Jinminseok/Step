package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class UserProductDAO {
	// 싱글턴 패턴
	private static UserProductDAO instance = new UserProductDAO();

	public static UserProductDAO getInstance() {
		return instance;
	}

	private UserProductDAO() {}

	// 상품 기본 상세 정보, 브랜드명 가져오기
	public AdminProductVO getProductDetail(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AdminProductVO vo = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT p.prod_num, p.prod_name, p.sku, p.prod_price, p.sale_rate, p.prod_text, "
			    + "p.cat_num, p.brand_num, p.gender, b.brand_name "
			    + "FROM products p JOIN brands b ON p.brand_num = b.brand_num WHERE p.prod_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vo = new AdminProductVO();
				vo.setProd_num(rs.getInt("prod_num"));
				vo.setProd_name(rs.getString("prod_name"));
				vo.setSku(rs.getString("sku"));
				vo.setProd_price(rs.getInt("prod_price"));
				vo.setSale_rate(rs.getInt("sale_rate"));
				vo.setBrand_name(rs.getString("brand_name"));
				vo.setProd_text(rs.getString("prod_text"));
				vo.setCat_num(rs.getInt("cat_num"));
				vo.setBrand_num(rs.getInt("brand_num"));
				vo.setGender(rs.getInt("gender"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return vo;
	}

	// 해당 상품의 모든 다중 이미지 가져오기
	public List<String> getProductImages(int prod_num) throws Exception {
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT prod_img_url FROM prod_imgs WHERE prod_num = ?
					ORDER BY is_main DESC, prod_img_sort_no ASC
					""";
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

	// 해당 상품의 고유 색상 목록 가져오기
	public List<String> getProductColors(int prod_num) throws Exception {
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT DISTINCT color FROM prod_options WHERE prod_num = ? AND prod_use_yn = 'Y'";
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

	// 해당 상품의 고유 사이즈 목록 가져오기
	public List<Integer> getProductSizes(int prod_num) throws Exception {
		List<Integer> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT DISTINCT size_val FROM prod_options WHERE prod_num = ? AND prod_use_yn = 'Y'
					ORDER BY size_val ASC
					""";
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

	// *** 상품 총 재고량 계산 (물리 재고 - 배송 대기 중인 재고) ***
	public int getProductTotalStock(int prod_num) throws Exception {
		int total = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			// DUAL 테이블을 이용하여 (실제 재고) - (결제완료 상태인 총 주문량)을 뺌
			sql = """
					SELECT 
					    (SELECT NVL(SUM(stock_qty), 0) FROM stock WHERE prod_num = ?) - 
					    (SELECT NVL(SUM(oi.order_item_qty), 0) 
					     FROM order_items oi 
					     JOIN orders o ON oi.order_num = o.order_num 
					     WHERE oi.prod_num = ? AND o.order_status = 1) 
					FROM DUAL
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			pstmt.setInt(2, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				total = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return total;
	}

	// 메인 화면용 상품 목록 조회
	public List<AdminProductVO> getMainProductList(AdminProductVO filter) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = null;
		String sql = null;
		
		// 판매중(prod_status = 1) 조건
		String sub_sql = "WHERE p.prod_status = 1 ";
		int cnt = 0;

		try {
			conn = DBUtil.getConnection();

			if (filter.getGender() != -1) {
				sub_sql += "AND p.gender = ? ";
			}
			if (filter.getKeyword() != null && !filter.getKeyword().isEmpty()) {
				sub_sql += "AND p.prod_name LIKE ? ";
			}
			if (filter.getCat_num() > 0) {
				sub_sql += "AND p.cat_num = ? ";
			}

			sql = "SELECT * FROM (SELECT a.*, rownum rnum FROM "
					+ "(SELECT p.prod_num, p.prod_name, p.prod_price, p.gender, p.prod_status, p.prod_created_at, p.cat_num, "
					+ "b.brand_name, i.prod_img_url " 
					+ "FROM products p "
					+ "LEFT JOIN brands b ON p.brand_num = b.brand_num "
					+ "LEFT JOIN prod_imgs i ON p.prod_num = i.prod_num AND i.is_main = 'Y' "
					+ sub_sql + " ORDER BY p.prod_created_at DESC) a) " 
					+ "WHERE rnum >= ? AND rnum <= ?";

			pstmt = conn.prepareStatement(sql);

			if (filter.getGender() != -1) {
				pstmt.setInt(++cnt, filter.getGender());
			}
			if (filter.getKeyword() != null && !filter.getKeyword().isEmpty()) {
				pstmt.setString(++cnt, "%" + filter.getKeyword() + "%");
			}
			if (filter.getCat_num() > 0) {
				pstmt.setInt(++cnt, filter.getCat_num());
			}

			pstmt.setInt(++cnt, filter.getStart_row());
			pstmt.setInt(++cnt, filter.getEnd_row());

			rs = pstmt.executeQuery();
			list = new ArrayList<AdminProductVO>();

			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setProd_num(rs.getInt("prod_num"));
				vo.setProd_name(rs.getString("prod_name"));
				vo.setProd_price(rs.getInt("prod_price"));
				vo.setGender(rs.getInt("gender"));
				vo.setProd_status(rs.getInt("prod_status"));
				vo.setProd_created_at(rs.getDate("prod_created_at"));
				vo.setBrand_name(rs.getString("brand_name"));
				vo.setProd_img_url(rs.getString("prod_img_url"));

				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 메인페이지 하단 페이징
	public int getMainProductCount(AdminProductVO filter) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String sql = null;
		String sub_sql = "";
		int cnt = 0;

		try {
			conn = DBUtil.getConnection();
			if(filter.getCat_num() > 0) {
				sub_sql += " AND cat_num = ? ";
			}
			if(filter.getBrand_num() > 0) {
				sub_sql += " AND brand_num = ? ";
			}
			if(filter.getGender() != -1) {
				sub_sql += " AND gender = ? ";
			}

			sql = "SELECT COUNT(*) FROM PRODUCTS WHERE prod_status = 1 " + sub_sql;

			pstmt = conn.prepareStatement(sql);

			if(filter.getCat_num() > 0) {
				pstmt.setInt(++cnt, filter.getCat_num());
			}
			if(filter.getBrand_num() > 0) {
				pstmt.setInt(++cnt, filter.getBrand_num());
			}
			if(filter.getGender() != -1) {
				pstmt.setInt(++cnt, filter.getGender());
			}

			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		} catch(Exception e) {
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}

		return count;
	}

	// 자바스크립트용 옵션별 재고표 생성 메서드
	public String getOptionStockJson(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder json = new StringBuilder("[");
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = """
					  SELECT o.opt_num, o.color, o.size_val, 
					         (NVL(s.stock_qty, 0) - NVL((
					             SELECT SUM(oi.order_item_qty) 
					             FROM order_items oi 
					             JOIN orders od ON oi.order_num = od.order_num 
					             WHERE oi.opt_num = o.opt_num AND od.order_status = 1
					         ), 0)) AS available_stock 
					  FROM prod_options o 
					  LEFT JOIN stock s ON o.opt_num = s.opt_num 
					  WHERE o.prod_num = ? AND o.prod_use_yn = 'Y'
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();

			boolean first = true;
			while (rs.next()) {
				if (!first) json.append(",");
				json.append("{")
				.append("\"opt_num\":").append(rs.getInt("opt_num")).append(",") 
				.append("\"color\":\"").append(rs.getString("color")).append("\",")
				.append("\"size\":").append(rs.getInt("size_val")).append(",")
				.append("\"stock\":").append(rs.getInt("available_stock"))
				.append("}");
				first = false;
			}
			json.append("]");
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return json.toString();
	}
	
	// 추천 상품 가져오기 (같은 카테고리, 브랜드 중 현재 상품 제외 랜덤 4개)
	public List<AdminProductVO> getRecommendProducts(int cat_num, int brand_num, int current_prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM ( "
					   + "SELECT p.prod_num, p.prod_name, p.prod_price, i.prod_img_url "
					   + "FROM products p "
					   + "LEFT JOIN prod_imgs i ON p.prod_num = i.prod_num AND i.is_main = 'Y' "
					   + "WHERE p.prod_status = 1 AND p.prod_num != ? "
					   + "AND (p.cat_num = ? OR p.brand_num = ?) "
					   + "ORDER BY DBMS_RANDOM.VALUE "
					   + ") WHERE ROWNUM <= 4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, current_prod_num);
			pstmt.setInt(2, cat_num);
			pstmt.setInt(3, brand_num);
			rs = pstmt.executeQuery();
			while(rs.next()){
				AdminProductVO vo = new AdminProductVO();
				vo.setProd_num(rs.getInt("prod_num"));
				vo.setProd_name(rs.getString("prod_name"));
				vo.setProd_price(rs.getInt("prod_price"));
				vo.setProd_img_url(rs.getString("prod_img_url"));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}