package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class AdminDAO {
	private static AdminDAO instance = new AdminDAO();

	public static AdminDAO getInstance() {
		return instance;
	}

	private AdminDAO() {
	}

	// 카테고리/브랜드명을 받아서 번호(PK)를 반환 (없으면 생성)
	private int getOrCreateTarget(Connection conn, String tableName, String colName, String val) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int num = 0;
		String pkCol = tableName.equals("CATEGORIES") ? "CAT_NUM" : "BRAND_NUM";

		// 1. 이미 존재하는지 확인
		String sql = "SELECT " + pkCol + " FROM " + tableName + " WHERE " + colName + " = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, val);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			num = rs.next() ? rs.getInt(pkCol) : 0; // 결과가 있으면 번호 획득
		}

		// 2. 없으면 새로 등록
		if (num == 0) {
			String seq = tableName.equals("CATEGORIES") ? "categories_seq" : "brands_seq";
			sql = "INSERT INTO " + tableName + " (" + pkCol + ", " + colName + ") VALUES (" + seq + ".nextval, ?)";
			DBUtil.executeClose(null, pstmt, null); // 기존 pstmt 닫기
			pstmt = conn.prepareStatement(sql, new String[] { pkCol });
			pstmt.setString(1, val);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys(); // 새로 생성된 PK 가져오기
			if (rs.next())
				num = rs.getInt(1);
		}
		return num;
	}

	public int insertProduct(AdminProductVO product, String catName, String brandName) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int count = 0;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 카테고리 & 브랜드 번호 가져오기 (없으면 자동 생성)
			int catNum = getOrCreateTarget(conn, "CATEGORIES", "CAT_NAME", catName);
			int brandNum = getOrCreateTarget(conn, "BRANDS", "BRAND_NAME", brandName);

			String sql = "INSERT INTO PRODUCTS (PROD_NUM, CAT_NUM, BRAND_NUM, OPT_NUM, IMG_NUM, "
					+ "SKU, PROD_NAME, GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS) "
					+ "VALUES (products_seq.nextval, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, catNum);
			pstmt.setInt(2, brandNum);
			pstmt.setString(3, product.getSku());
			pstmt.setString(4, product.getName());
			pstmt.setInt(5, product.getGender());
			pstmt.setInt(6, product.getPrice());
			pstmt.setInt(7, product.getSale_rate());
			pstmt.setString(8, product.getProd_text());
			pstmt.setInt(9, product.getStatus());

			count = pstmt.executeUpdate();
			conn.commit(); // 모두 성공 시 확정
		} catch (Exception e) {
			if (conn != null)
				conn.rollback(); // 하나라도 실패 시 되돌리기
			throw e;
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
		return count;
	}

	// 상품 전체 목록 조회 메서드 추가
	public List<AdminProductVO> showProductList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminProductVO> list = null;

		try {
			conn = DBUtil.getConnection();
			// 테이블명과 컬럼명은 기존 insertProduct 로직에 맞춰 PRODUCTS, CATEGORIES, BRANDS로 세팅함
			String sql = "SELECT p.*, c.CAT_NAME, b.BRAND_NAME " + "FROM PRODUCTS p "
					+ "LEFT JOIN CATEGORIES c ON p.cat_num = c.cat_num "
					+ "LEFT JOIN BRANDS b ON p.brand_num = b.brand_num " + "ORDER BY p.prod_num DESC";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			list = new ArrayList<AdminProductVO>();

			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setProd_num(rs.getInt("prod_num"));
				vo.setSku(rs.getString("sku"));
				vo.setName(rs.getString("prod_name"));
				vo.setPrice(rs.getInt("prod_price"));
				vo.setSale_rate(rs.getInt("sale_rate"));
				vo.setGender(rs.getInt("gender"));
				vo.setStatus(rs.getInt("prod_status"));
				vo.setProd_created_at(rs.getDate("prod_created_at"));

				// JOIN 결과물 담기
				vo.setCat_name(rs.getString("cat_name"));
				vo.setBrand_name(rs.getString("brand_name"));

				list.add(vo);
			}
		} catch (Exception e) {
			throw e;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}