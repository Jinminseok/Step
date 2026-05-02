package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminVO;
import kr.util.DBUtil;

public class AdminDAO {
	private static AdminDAO instance = new AdminDAO();

	public static AdminDAO getInstance() {
		return instance;
	}

	private AdminDAO() {
	}

	// 1. [추가] 카테고리 목록 조회 (C-4 요구사항: 등록 폼 선택용)[cite: 7, 8]
	public List<AdminVO> getCategoryList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminVO> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			// 설계서: CAT_USE_YN='Y'인 것만, CAT_SORT_NO 순으로 정렬
			String sql = "SELECT CAT_NUM, CAT_NAME FROM CATEGORIES WHERE CAT_USE_YN = 'Y' ORDER BY CAT_SORT_NO ASC";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setCat_num(rs.getInt("CAT_NUM"));
				vo.setCat_name(rs.getString("CAT_NAME"));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 2. [추가] 브랜드 목록 조회 (C-4 요구사항: 등록 폼 선택용)[cite: 7, 8]
	public List<AdminVO> getBrandList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminVO> list = new ArrayList<>();
		try {
			conn = DBUtil.getConnection();
			// 설계서: BRAND_USE_YN='Y'인 것만 조회[cite: 8]
			String sql = "SELECT BRAND_NUM, BRAND_NAME FROM BRANDS WHERE BRAND_USE_YN = 'Y' ORDER BY BRAND_NAME ASC";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setBrand_num(rs.getInt("BRAND_NUM"));
				vo.setBrand_name(rs.getString("BRAND_NAME"));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 3. 상품 등록 (상품 + 이미지 + 옵션 트랜잭션)[cite: 7, 8]
	public int insertProduct(AdminVO product) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmtImg = null;
		PreparedStatement pstmtOpt = null;
		PreparedStatement pstmtStock = null; // 재고 등록용 추가
		int count = 0;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 1. PRODUCTS 등록
			String sql = "INSERT INTO PRODUCTS (PROD_NUM, CAT_NUM, BRAND_NUM, SKU, PROD_NAME, "
					+ "GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS) "
					+ "VALUES (products_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, product.getCat_num());
			pstmt.setInt(2, product.getBrand_num());
			pstmt.setString(3, product.getSku());
			pstmt.setString(4, product.getProd_name());
			pstmt.setInt(5, product.getGender());
			pstmt.setInt(6, product.getProd_price());
			pstmt.setInt(7, product.getSale_rate());
			pstmt.setString(8, product.getProd_text());
			pstmt.setInt(9, product.getProd_status());
			count = pstmt.executeUpdate();

			// 2. 대표 이미지 등록
			if (product.getProd_img_url() != null && !product.getProd_img_url().isEmpty()) {
				String imgSql = "INSERT INTO PROD_IMGS (PROD_IMG_NUM, PROD_NUM, PROD_IMG_URL, IS_MAIN) "
						+ "VALUES (prod_imgs_seq.nextval, products_seq.currval, ?, 'Y')";
				pstmtImg = conn.prepareStatement(imgSql);
				pstmtImg.setString(1, product.getProd_img_url());
				pstmtImg.executeUpdate();
			}

			// 3. 옵션 등록 및 초기 재고 생성 (배치 처리)
			if (product.getOptionList() != null && !product.getOptionList().isEmpty()) {
				// 옵션 INSERT 문
				String optSql = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE) "
						+ "VALUES (prod_options_seq.nextval, products_seq.currval, ?, ?, ?)";

				// 초기 재고(STOCK) INSERT 문 (초기 수량 0, 최소 재고 10 설정)
				String stockSql = "INSERT INTO STOCK (STOCK_NUM, OPT_NUM, PROD_NUM, STOCK_QTY, STOCK_MIN_QTY) "
						+ "VALUES (stock_seq.nextval, prod_options_seq.currval, products_seq.currval, 0, 10)";

				pstmtOpt = conn.prepareStatement(optSql);
				pstmtStock = conn.prepareStatement(stockSql);

				for (var opt : product.getOptionList()) {
					// 옵션 배치 추가
					pstmtOpt.setInt(1, opt.getSize_val());
					pstmtOpt.setString(2, opt.getColor());
					pstmtOpt.setInt(3, opt.getAdd_price());
					pstmtOpt.addBatch();

					// 해당 옵션에 대한 재고 배치 추가
					pstmtStock.addBatch();
				}

				pstmtOpt.executeBatch();
				pstmtStock.executeBatch();
			}

			conn.commit(); // 모든 작업 성공 시 커밋
		} catch (Exception e) {
			if (conn != null)
				conn.rollback(); // 하나라도 실패 시 롤백
			throw e;
		} finally {
			// 자원 해제 (사용한 모든 PreparedStatement 닫기)
			if (pstmtImg != null)
				pstmtImg.close();
			if (pstmtOpt != null)
				pstmtOpt.close();
			if (pstmtStock != null)
				pstmtStock.close();
			DBUtil.executeClose(null, pstmt, conn);
		}
		return count;
	}

	// 4. 상품 목록 조회 (페이징 + 검색 + 재고합계)[cite: 7, 8]
	public List<AdminVO> showProductList(int start, int end, String keyfield, String keyword) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminVO> list = new ArrayList<>();
		String sub_sql = "";
		int cnt = 0;

		try {
			conn = DBUtil.getConnection();
			if (keyword != null && !"".equals(keyword)) {
				if (keyfield.equals("1"))
					sub_sql = "WHERE p.PROD_NAME LIKE '%' || ? || '%'";
				else if (keyfield.equals("2"))
					sub_sql = "WHERE p.PROD_TEXT LIKE '%' || ? || '%'";
			}

			String sql = "SELECT * FROM (SELECT a.*, rownum rnum FROM ( "
					+ "SELECT p.PROD_NUM, p.SKU, p.PROD_NAME, p.PROD_PRICE, p.SALE_RATE, "
					+ "p.GENDER, p.PROD_STATUS, p.PROD_CREATED_AT, c.CAT_NAME, b.BRAND_NAME, "
					+ "i.PROD_IMG_URL, NVL(SUM(s.STOCK_QTY), 0) AS TOTAL_STOCK " + "FROM PRODUCTS p "
					+ "LEFT JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM "
					+ "LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
					+ "LEFT JOIN PROD_IMGS i ON p.PROD_NUM = i.PROD_NUM AND i.IS_MAIN = 'Y' "
					+ "LEFT JOIN STOCK s ON p.PROD_NUM = s.PROD_NUM " + sub_sql
					+ " GROUP BY p.PROD_NUM, p.SKU, p.PROD_NAME, p.PROD_PRICE, p.SALE_RATE, "
					+ "p.GENDER, p.PROD_STATUS, p.PROD_CREATED_AT, c.CAT_NAME, b.BRAND_NAME, i.PROD_IMG_URL "
					+ "ORDER BY p.PROD_NUM DESC) a) WHERE rnum >= ? AND rnum <= ?";

			pstmt = conn.prepareStatement(sql);
			if (keyword != null && !"".equals(keyword))
				pstmt.setString(++cnt, keyword);
			pstmt.setInt(++cnt, start);
			pstmt.setInt(++cnt, end);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminVO vo = new AdminVO();
				vo.setProd_num(rs.getInt("PROD_NUM"));
				vo.setSku(rs.getString("SKU"));
				vo.setProd_name(rs.getString("PROD_NAME"));
				vo.setProd_price(rs.getInt("PROD_PRICE"));
				vo.setSale_rate(rs.getInt("SALE_RATE"));
				vo.setGender(rs.getInt("GENDER"));
				vo.setProd_status(rs.getInt("PROD_STATUS"));
				vo.setProd_created_at(rs.getTimestamp("PROD_CREATED_AT"));
				vo.setCat_name(rs.getString("CAT_NAME"));
				vo.setBrand_name(rs.getString("BRAND_NAME"));
				vo.setProd_img_url(rs.getString("PROD_IMG_URL"));
				vo.setStock_qty(rs.getInt("TOTAL_STOCK"));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 5. 페이징용 카운트 조회
	public int getProductCount(String keyfield, String keyword) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sub_sql = "";
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			if (keyword != null && !"".equals(keyword)) {
				if (keyfield.equals("1"))
					sub_sql = "WHERE PROD_NAME LIKE '%' || ? || '%'";
				else if (keyfield.equals("2"))
					sub_sql = "WHERE PROD_TEXT LIKE '%' || ? || '%'";
			}
			String sql = "SELECT COUNT(*) FROM PRODUCTS " + sub_sql;
			pstmt = conn.prepareStatement(sql);
			if (keyword != null && !"".equals(keyword))
				pstmt.setString(1, keyword);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}
}