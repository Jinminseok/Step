package logis.dao;

import java.sql.*;
import java.util.*;
import logis_vo.Log_ProdVO;
import kr.util.DBUtil;

public class Log_ProdDAO {

	// ── 공통 SQL 조각 ──────────────────────────────────────────────────────
	private static final String SELECT_BASE =
		    "SELECT p.PROD_NUM, p.SKU, b.BRAND_NAME, p.PROD_NAME, p.PROD_CREATED_AT,"
		  + "       c.CAT_NAME, p.PROD_PRICE, p.PROD_STATUS, p.PROD_TEXT, "
		  // ↓ LEFT JOIN STOCK 제거하고 서브쿼리로 교체
		  + "       (SELECT NVL(SUM(STOCK_QTY), 0) FROM STOCK "
		  + "        WHERE PROD_NUM = p.PROD_NUM) AS STOCK_QTY, "
		  + "       i.PROD_IMG_URL, "
		  + "       (SELECT COUNT(DISTINCT COLOR) FROM PROD_OPTIONS "
		  + "        WHERE PROD_NUM = p.PROD_NUM AND PROD_USE_YN = 'Y') AS COLOR_CNT, "
		  + "       (SELECT MIN(SIZE_VAL) || '~' || MAX(SIZE_VAL) FROM PROD_OPTIONS "
		  + "        WHERE PROD_NUM = p.PROD_NUM AND PROD_USE_YN = 'Y') AS SIZE_RANGE, "
		  + "       (SELECT LISTAGG(DISTINCT COLOR, ',') WITHIN GROUP (ORDER BY COLOR) "
		  + "        FROM PROD_OPTIONS "
		  + "        WHERE PROD_NUM = p.PROD_NUM AND PROD_USE_YN = 'Y') AS COLOR_LIST, "
		  + "       (SELECT LISTAGG(SIZE_VAL, ',') WITHIN GROUP (ORDER BY SIZE_VAL) "
		  + "        FROM (SELECT DISTINCT SIZE_VAL FROM PROD_OPTIONS "
		  + "              WHERE PROD_NUM = p.PROD_NUM AND PROD_USE_YN = 'Y')) AS SIZE_LIST "
		  + "FROM   PRODUCTS p "
		  + "LEFT JOIN BRANDS     b ON p.BRAND_NUM = b.BRAND_NUM "
		  + "LEFT JOIN CATEGORIES c ON p.CAT_NUM   = c.CAT_NUM "
		  // ↓ LEFT JOIN STOCK 완전 삭제
		  + "LEFT JOIN PROD_IMGS  i ON p.PROD_NUM  = i.PROD_NUM AND i.IS_MAIN = 'Y' ";

	// ── ResultSet → VO 변환 (공통) ────────────────────────────────────────
	private Log_ProdVO toVO(ResultSet rs) throws SQLException {
		Log_ProdVO vo = new Log_ProdVO();
		vo.setProdNum   (rs.getInt   ("PROD_NUM"));
		vo.setSku       (rs.getString("SKU"));
		vo.setBrandName (rs.getString("BRAND_NAME"));
		vo.setProdName  (rs.getString("PROD_NAME"));
		vo.setCatName   (rs.getString("CAT_NAME"));
		vo.setProdPrice (rs.getInt   ("PROD_PRICE"));
		vo.setProdStatus(rs.getInt   ("PROD_STATUS"));
		vo.setProdText  (rs.getString("PROD_TEXT"));
		vo.setStockQty  (rs.getInt   ("STOCK_QTY"));
		vo.setColorCnt  (rs.getInt   ("COLOR_CNT"));
		vo.setSizeRange (rs.getString("SIZE_RANGE"));
		vo.setColorList (rs.getString("COLOR_LIST")); 
		vo.setSizeList  (rs.getString("SIZE_LIST"));  
		vo.setProdImgUrl(rs.getString("PROD_IMG_URL"));
		vo.setProdCreatedAt(rs.getDate("PROD_CREATED_AT"));
		vo.setMaxStock  (100);
		return vo;
	}

	// ── 상품 목록 조회 (전체) ──────────────────────────────────────────────
	public List<Log_ProdVO> getProdList() throws Exception {
		return getProdList(null, null, null);
	}

	// ── 상품 목록 조회 (검색/필터) ────────────────────────────────────────
	public List<Log_ProdVO> getProdList(String keyword, String brandName, String status) throws Exception {
		List<Log_ProdVO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		StringBuilder sql = new StringBuilder(SELECT_BASE);
		sql.append("WHERE 1=1 ");

		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append("AND (p.SKU LIKE ? OR p.PROD_NAME LIKE ?) ");
		}
		if (brandName != null && !brandName.trim().isEmpty()) {
			sql.append("AND b.BRAND_NAME = ? ");
		}
		if (status != null && !status.trim().isEmpty()) {
			if      (status.equals("판매중")) sql.append("AND p.PROD_STATUS = 1 ");
			else if (status.equals("숨김"))   sql.append("AND p.PROD_STATUS = 2 ");
			else if (status.equals("품절"))   sql.append("AND p.PROD_STATUS = 3 ");
		}
		sql.append("ORDER BY p.PROD_NUM DESC");

		try {
			conn  = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql.toString());

			int idx = 1;
			if (keyword != null && !keyword.trim().isEmpty()) {
				pstmt.setString(idx++, "%" + keyword.trim() + "%");
				pstmt.setString(idx++, "%" + keyword.trim() + "%");
			}
			if (brandName != null && !brandName.trim().isEmpty()) {
				pstmt.setString(idx++, brandName.trim());
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(toVO(rs));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// ── 상품 등록 (PRODUCTS + PROD_OPTIONS + PROD_IMGS) ─────────────────
	public int insertProd(Log_ProdVO vo) throws Exception {
	    int result = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String[] sizes  = (vo.getSizes()  != null && !vo.getSizes().isEmpty())
	                      ? vo.getSizes().split(",")  : new String[0];
	    String[] colors = (vo.getColors() != null && !vo.getColors().isEmpty())
	                      ? vo.getColors().split(",") : new String[]{"기본"};

	    try {
	        conn = DBUtil.getConnection();
	        conn.setAutoCommit(false);

	        // ① PRODUCTS INSERT (1개만)
	        String sql = "INSERT INTO PRODUCTS "
	                   + "(PROD_NUM, CAT_NUM, BRAND_NUM, SKU, PROD_NAME, "
	                   + " GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS, PROD_CREATED_AT) "
	                   + "VALUES (PRODUCTS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";

	        pstmt = conn.prepareStatement(sql, new String[]{"PROD_NUM"});
	        pstmt.setInt   (1, vo.getCatNum());
	        pstmt.setInt   (2, vo.getBrandNum());
	        pstmt.setString(3, vo.getSku());
	        pstmt.setString(4, vo.getProdName());
	        pstmt.setInt   (5, vo.getGender());
	        pstmt.setInt   (6, vo.getProdPrice());
	        pstmt.setInt   (7, vo.getSaleRate());
	        pstmt.setString(8, vo.getProdText());
	        pstmt.setInt   (9, vo.getProdStatus());
	        pstmt.executeUpdate();

	        int newProdNum = 0;
	        rs = pstmt.getGeneratedKeys();
	        if (rs.next()) newProdNum = rs.getInt(1);
	        rs.close();
	        pstmt.close();

	        // ② PROD_OPTIONS INSERT (사이즈 × 컬러 조합)
	        String optSql = "INSERT INTO PROD_OPTIONS "
	                      + "(OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
	                      + "VALUES (PROD_OPTIONS_SEQ.NEXTVAL, ?, ?, ?, 0, 'Y')";

	        pstmt = conn.prepareStatement(optSql, new String[]{"OPT_NUM"});
	        int firstOptNum = 0;

	        for (String size : sizes) {
	            for (String color : colors) {
	                pstmt.setInt   (1, newProdNum);
	                pstmt.setInt   (2, Integer.parseInt(size.trim()));
	                pstmt.setString(3, color.trim());
	                pstmt.executeUpdate();

	                if (firstOptNum == 0) {
	                    ResultSet optKeyRs = pstmt.getGeneratedKeys();
	                    if (optKeyRs.next()) firstOptNum = optKeyRs.getInt(1);
	                    optKeyRs.close();
	                }
	            }
	        }
	        pstmt.close();

	        // ③ PRODUCTS.OPT_NUM 업데이트
	        String updateOptSql = "UPDATE PRODUCTS SET OPT_NUM = ? WHERE PROD_NUM = ?";
	        pstmt = conn.prepareStatement(updateOptSql);
	        pstmt.setInt(1, firstOptNum);
	        pstmt.setInt(2, newProdNum);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // ④ 이미지 있을 때만 PROD_IMGS INSERT + IMG_NUM 업데이트 ← 여기가 빠져있었음
	        if (vo.getProdImgUrl() != null && !vo.getProdImgUrl().isEmpty()) {
	            String imgSql = "INSERT INTO PROD_IMGS "
	                          + "(PROD_IMG_NUM, PROD_NUM, PROD_IMG_URL, IS_MAIN, PROD_IMG_SORT_NO) "
	                          + "VALUES (PROD_IMGS_SEQ.NEXTVAL, ?, ?, 'Y', 1)";

	            pstmt = conn.prepareStatement(imgSql, new String[]{"PROD_IMG_NUM"});
	            pstmt.setInt   (1, newProdNum);
	            pstmt.setString(2, vo.getProdImgUrl());
	            pstmt.executeUpdate();

	            int imgNum = 0;
	            ResultSet imgKeyRs = pstmt.getGeneratedKeys();
	            if (imgKeyRs.next()) imgNum = imgKeyRs.getInt(1);
	            imgKeyRs.close();
	            pstmt.close();

	            String updateImgSql = "UPDATE PRODUCTS SET IMG_NUM = ? WHERE PROD_NUM = ?";
	            pstmt = conn.prepareStatement(updateImgSql);
	            pstmt.setInt(1, imgNum);
	            pstmt.setInt(2, newProdNum);
	            pstmt.executeUpdate();
	            pstmt.close();
	        }

	        conn.commit();
	        result = 1;

	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw e;
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return result;
	}

	// ── 상품 수정 ─────────────────────────────────────────────────────────
	public int updateProd(Log_ProdVO vo) throws Exception {
		int result = 0;
		Connection conn  = null;
		PreparedStatement pstmt = null;

		String sql = "UPDATE PRODUCTS SET "
				+ "  CAT_NUM         = ?, "
				+ "  BRAND_NUM       = ?, "
				+ "  SKU             = ?, "
				+ "  PROD_NAME       = ?, "
				+ "  GENDER          = ?, "
				+ "  PROD_PRICE      = ?, "
				+ "  SALE_RATE       = ?, "
				+ "  PROD_TEXT       = ?, "
				+ "  PROD_STATUS     = ?, "
				+ "  PROD_UPDATED_AT = SYSDATE "
				+ "WHERE PROD_NUM = ?";

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt   (1,  vo.getCatNum());
			pstmt.setInt   (2,  vo.getBrandNum());
			pstmt.setString(3,  vo.getSku());
			pstmt.setString(4,  vo.getProdName());
			pstmt.setInt   (5,  vo.getGender());
			pstmt.setInt   (6,  vo.getProdPrice());
			pstmt.setInt   (7,  vo.getSaleRate());
			pstmt.setString(8,  vo.getProdText());
			pstmt.setInt   (9,  vo.getProdStatus());
			pstmt.setInt   (10, vo.getProdNum());
			result = pstmt.executeUpdate();
			pstmt.close();

			// ── 이미지 수정 (새 파일 올렸을 때만) ────────────────────────
			if (vo.getProdImgUrl() != null && !vo.getProdImgUrl().isEmpty()) {

				//  기존 대표 이미지 삭제
				String delImgSql = "DELETE FROM PROD_IMGS WHERE PROD_NUM = ? AND IS_MAIN = 'Y'";
				PreparedStatement delImgStmt = conn.prepareStatement(delImgSql);
				delImgStmt.setInt(1, vo.getProdNum());
				delImgStmt.executeUpdate();
				delImgStmt.close();

				//  새 이미지 PROD_IMGS INSERT
				String imgSeqSql = "SELECT NVL(MAX(PROD_IMG_NUM), 0) + 1 FROM PROD_IMGS";
				String imgSql    = "INSERT INTO PROD_IMGS "
						+ "(PROD_IMG_NUM, PROD_NUM, PROD_IMG_URL, IS_MAIN, PROD_IMG_SORT_NO) "
						+ "VALUES (?, ?, ?, 'Y', 1)";

				PreparedStatement imgSeqStmt = conn.prepareStatement(imgSeqSql);
				ResultSet imgSeqRs = imgSeqStmt.executeQuery();
				int imgNum = 1;
				if (imgSeqRs.next()) imgNum = imgSeqRs.getInt(1);
				imgSeqRs.close();
				imgSeqStmt.close();

				PreparedStatement imgStmt = conn.prepareStatement(imgSql);
				imgStmt.setInt   (1, imgNum);
				imgStmt.setInt   (2, vo.getProdNum());
				imgStmt.setString(3, vo.getProdImgUrl());
				imgStmt.executeUpdate();
				imgStmt.close();

				// PRODUCTS.IMG_NUM 업데이트
				String updateImgSql = "UPDATE PRODUCTS SET IMG_NUM = ? WHERE PROD_NUM = ?";
				PreparedStatement updateImgStmt = conn.prepareStatement(updateImgSql);
				updateImgStmt.setInt(1, imgNum);
				updateImgStmt.setInt(2, vo.getProdNum());
				updateImgStmt.executeUpdate();
				updateImgStmt.close();
			}

			// ── 컬러·사이즈 수정 ──────────────────────────────────────────
			String[] colors = (vo.getColors() != null && !vo.getColors().isEmpty())
					? vo.getColors().split(",") : new String[0];
			String[] sizes  = (vo.getSizes()  != null && !vo.getSizes().isEmpty())
					? vo.getSizes().split(",")  : new String[0];

			if (colors.length > 0 && sizes.length > 0) {

				// 기존 옵션 전체 비활성화
				String deactivateSql = "UPDATE PROD_OPTIONS SET PROD_USE_YN = 'N' WHERE PROD_NUM = ?";
				PreparedStatement deactivateStmt = conn.prepareStatement(deactivateSql);
				deactivateStmt.setInt(1, vo.getProdNum());
				deactivateStmt.executeUpdate();
				deactivateStmt.close();

				// 현재 최대 OPT_NUM 조회
				String optSeqSql = "SELECT NVL(MAX(OPT_NUM), 0) + 1 FROM PROD_OPTIONS";
				PreparedStatement optSeqStmt = conn.prepareStatement(optSeqSql);
				ResultSet optSeqRs = optSeqStmt.executeQuery();
				int optNum = 1;
				if (optSeqRs.next()) optNum = optSeqRs.getInt(1);
				optSeqRs.close();
				optSeqStmt.close();

				String checkSql  = "SELECT OPT_NUM FROM PROD_OPTIONS "
						+ "WHERE PROD_NUM=? AND SIZE_VAL=? AND COLOR=?";
				String insertSql = "INSERT INTO PROD_OPTIONS "
						+ "(OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
						+ "VALUES (?, ?, ?, ?, 0, 'Y')";
				String updateSql = "UPDATE PROD_OPTIONS SET PROD_USE_YN='Y' "
						+ "WHERE PROD_NUM=? AND SIZE_VAL=? AND COLOR=?";

				for (String color : colors) {
					for (String size : sizes) {
						int    sizeVal   = Integer.parseInt(size.trim());
						String colorTrim = color.trim();

						// 기존에 있으면 재활성화, 없으면 새로 INSERT
						PreparedStatement checkStmt = conn.prepareStatement(checkSql);
						checkStmt.setInt   (1, vo.getProdNum());
						checkStmt.setInt   (2, sizeVal);
						checkStmt.setString(3, colorTrim);
						ResultSet checkRs = checkStmt.executeQuery();

						if (checkRs.next()) {
							PreparedStatement updateStmt = conn.prepareStatement(updateSql);
							updateStmt.setInt   (1, vo.getProdNum());
							updateStmt.setInt   (2, sizeVal);
							updateStmt.setString(3, colorTrim);
							updateStmt.executeUpdate();
							updateStmt.close();
						} else {
							PreparedStatement insertStmt = conn.prepareStatement(insertSql);
							insertStmt.setInt   (1, optNum++);
							insertStmt.setInt   (2, vo.getProdNum());
							insertStmt.setInt   (3, sizeVal);
							insertStmt.setString(4, colorTrim);
							insertStmt.executeUpdate();
							insertStmt.close();
						}
						checkRs.close();
						checkStmt.close();
					}
				}
			}

		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
		return result;
	}

	// ── 상품 삭제 ─────────────────────────────────────────────────────────
	public int deleteProd(int prodNum) throws Exception {
		int result = 0;
		Connection conn  = null;
		PreparedStatement pstmt = null;

		String sql = "DELETE FROM PRODUCTS WHERE PROD_NUM = ?";

		try {
			conn  = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prodNum);
			result = pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
		return result;
	}

	// ── 브랜드 목록 조회 ──────────────────────────────────────────────────
	public List<Map<String, Object>> getBrandList() throws Exception {
		List<Map<String, Object>> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT BRAND_NUM, BRAND_NAME FROM BRANDS "
				+ "WHERE BRAND_USE_YN = 'Y' ORDER BY BRAND_NUM";
		try {
			conn  = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs    = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("brandNum",  rs.getInt("BRAND_NUM"));
				map.put("brandName", rs.getString("BRAND_NAME"));
				list.add(map);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// ── 카테고리 목록 조회 ────────────────────────────────────────────────
	public List<Map<String, Object>> getCatList() throws Exception {
		List<Map<String, Object>> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT CAT_NUM, CAT_NAME FROM CATEGORIES "
				+ "WHERE CAT_USE_YN = 'Y' ORDER BY CAT_SORT_NO";
		try {
			conn  = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs    = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("catNum",  rs.getInt("CAT_NUM"));
				map.put("catName", rs.getString("CAT_NAME"));
				list.add(map);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}