package logis.dao;

import java.sql.*;
import java.util.*;
import logis_vo.Log_ProdVO;
import kr.util.DBUtil;   

public class Log_ProdDAO {
	
	//상품 목록 조회 
    public List<Log_ProdVO> getProdList() throws Exception {
        List<Log_ProdVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT p.PROD_NUM, p.SKU, b.BRAND_NAME, p.PROD_NAME, "
                   + "       c.CAT_NAME, p.PROD_PRICE, p.PROD_STATUS, "
                   + "       NVL(s.STOCK_QTY, 0) AS STOCK_QTY "
                   + "FROM   PRODUCTS p "
                   + "LEFT JOIN BRANDS     b ON p.BRAND_NUM = b.BRAND_NUM "
                   + "LEFT JOIN CATEGORIES c ON p.CAT_NUM   = c.CAT_NUM "
                   + "LEFT JOIN STOCK      s ON p.PROD_NUM  = s.PROD_NUM "
                   + "ORDER BY p.PROD_NUM DESC";

        try {
            conn  = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs    = pstmt.executeQuery();

            while (rs.next()) {
                Log_ProdVO vo = new Log_ProdVO();
                vo.setProdNum   (rs.getInt   ("PROD_NUM"));
                vo.setSku       (rs.getString("SKU"));
                vo.setBrandName (rs.getString("BRAND_NAME"));
                vo.setProdName  (rs.getString("PROD_NAME"));
                vo.setCatName   (rs.getString("CAT_NAME"));
                vo.setProdPrice (rs.getInt   ("PROD_PRICE"));
                vo.setProdStatus(rs.getInt   ("PROD_STATUS"));
                vo.setStockQty  (rs.getInt   ("STOCK_QTY"));
                vo.setMaxStock  (100);   // 임시 고정값
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
    
    //상품 등록
    public int insertProd(Log_ProdVO vo) throws Exception {
        int result = 0;
        Connection conn   = null;
        PreparedStatement pstmt = null;

        // PROD_NUM 최댓값 + 1 로 채번 (시퀀스 없을 경우)
        String seqSql = "SELECT NVL(MAX(PROD_NUM), 0) + 1 FROM PRODUCTS";

        String sql = "INSERT INTO PRODUCTS "
                   + "(PROD_NUM, CAT_NUM, BRAND_NUM, SKU, PROD_NAME, "
                   + " GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS, "
                   + " PROD_CREATED_AT) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";

        try {
            conn = DBUtil.getConnection();

            // ① PROD_NUM 채번
            PreparedStatement seqStmt = conn.prepareStatement(seqSql);
            ResultSet seqRs = seqStmt.executeQuery();
            int newProdNum = 1;
            if (seqRs.next()) {
                newProdNum = seqRs.getInt(1);
            }
            seqRs.close();
            seqStmt.close();

            // ② INSERT 실행
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt   (1, newProdNum);
            pstmt.setInt   (2, vo.getCatNum());
            pstmt.setInt   (3, vo.getBrandNum());
            pstmt.setString(4, vo.getSku());
            pstmt.setString(5, vo.getProdName());
            pstmt.setInt   (6, vo.getGender());
            pstmt.setInt   (7, vo.getProdPrice());
            pstmt.setInt   (8, vo.getSaleRate());
            pstmt.setString(9, vo.getProdText());
            pstmt.setInt   (10, vo.getProdStatus());

            result = pstmt.executeUpdate();

        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
        return result;
    }
    //브랜드 목록 조회
    
 // ── 브랜드 목록 조회 ──────────────────────────────
    public List<Map<String,Object>> getBrandList() throws Exception {
        List<Map<String,Object>> list = new ArrayList<>();
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
                Map<String,Object> map = new HashMap<>();
                map.put("brandNum",  rs.getInt("BRAND_NUM"));
                map.put("brandName", rs.getString("BRAND_NAME"));
                list.add(map);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ── 카테고리 목록 조회 ────────────────────────────
    public List<Map<String,Object>> getCatList() throws Exception {
        List<Map<String,Object>> list = new ArrayList<>();
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
                Map<String,Object> map = new HashMap<>();
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