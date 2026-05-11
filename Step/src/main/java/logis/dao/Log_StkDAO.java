package logis.dao;

import java.sql.*;
import java.util.*;
import kr.util.DBUtil;

public class Log_StkDAO {

    private static Log_StkDAO instance = new Log_StkDAO();
    public static Log_StkDAO getInstance() { return instance; }
    private Log_StkDAO() {}

    public int getTotalStock() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(s.STOCK_QTY), 0) FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "WHERE po.PROD_USE_YN = 'Y'";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    public int getLowStockCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT COUNT(*) FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "WHERE po.PROD_USE_YN = 'Y' AND s.STOCK_QTY > 0 AND s.STOCK_QTY < 10";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    public int getZeroStockCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT COUNT(*) FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "WHERE po.PROD_USE_YN = 'Y' AND s.STOCK_QTY = 0";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }


    public int getOkStockCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT COUNT(*) FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "WHERE po.PROD_USE_YN = 'Y' AND s.STOCK_QTY >= 10";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

  
    public int getTotalOptCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT COUNT(*) FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "WHERE po.PROD_USE_YN = 'Y'";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

  
    public List<Map<String, Object>> getStockList(String keyword, String brandName, String status) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.PROD_NUM, p.SKU, b.BRAND_NAME, p.PROD_NAME, c.CAT_NAME, ");
        sql.append("       (SELECT NVL(SUM(s2.STOCK_QTY), 0) FROM STOCK s2 ");
        sql.append("        JOIN PROD_OPTIONS po2 ON s2.OPT_NUM = po2.OPT_NUM ");
        sql.append("        WHERE po2.PROD_NUM = p.PROD_NUM ");
        sql.append("        AND po2.PROD_USE_YN = 'Y') AS STOCK_QTY, ");
        sql.append("       (SELECT COUNT(DISTINCT COLOR) FROM PROD_OPTIONS ");
        sql.append("        WHERE PROD_NUM = p.PROD_NUM AND PROD_USE_YN = 'Y') AS COLOR_CNT, ");
        sql.append("       (SELECT MIN(SIZE_VAL) || '~' || MAX(SIZE_VAL) FROM PROD_OPTIONS ");
        sql.append("        WHERE PROD_NUM = p.PROD_NUM AND PROD_USE_YN = 'Y') AS SIZE_RANGE ");
        sql.append("FROM PRODUCTS p ");
        sql.append("LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM ");
        sql.append("LEFT JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND (p.PROD_NAME LIKE ? OR p.SKU LIKE ? OR b.BRAND_NAME LIKE ?) ");
        if (brandName != null && !brandName.trim().isEmpty())
            sql.append("AND b.BRAND_NAME = ? ");
        if ("부족".equals(status))
            sql.append("AND (SELECT NVL(SUM(s2.STOCK_QTY),0) FROM STOCK s2 "
                     + "     JOIN PROD_OPTIONS po2 ON s2.OPT_NUM = po2.OPT_NUM "
                     + "     WHERE po2.PROD_NUM = p.PROD_NUM AND po2.PROD_USE_YN = 'Y') BETWEEN 1 AND 9 ");
        else if ("품절".equals(status))
            sql.append("AND (SELECT NVL(SUM(s2.STOCK_QTY),0) FROM STOCK s2 "
                     + "     JOIN PROD_OPTIONS po2 ON s2.OPT_NUM = po2.OPT_NUM "
                     + "     WHERE po2.PROD_NUM = p.PROD_NUM AND po2.PROD_USE_YN = 'Y') = 0 ");
        else if ("정상".equals(status))
            sql.append("AND (SELECT NVL(SUM(s2.STOCK_QTY),0) FROM STOCK s2 "
                     + "     JOIN PROD_OPTIONS po2 ON s2.OPT_NUM = po2.OPT_NUM "
                     + "     WHERE po2.PROD_NUM = p.PROD_NUM AND po2.PROD_USE_YN = 'Y') >= 10 ");

        sql.append("ORDER BY p.PROD_NUM DESC");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                pstmt.setString(idx++, "%" + keyword + "%");
                pstmt.setString(idx++, "%" + keyword + "%");
                pstmt.setString(idx++, "%" + keyword + "%");
            }
            if (brandName != null && !brandName.trim().isEmpty())
                pstmt.setString(idx++, brandName);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("prodNum",   rs.getInt("PROD_NUM"));
                map.put("sku",       rs.getString("SKU"));
                map.put("brandName", rs.getString("BRAND_NAME"));
                map.put("prodName",  rs.getString("PROD_NAME"));
                map.put("catName",   rs.getString("CAT_NAME"));
                map.put("stockQty",  rs.getInt("STOCK_QTY"));
                map.put("colorCnt",  rs.getInt("COLOR_CNT"));
                map.put("sizeRange", rs.getString("SIZE_RANGE"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // ⑦ 재고 부족 옵션 목록 (사이즈별, qty 0 초과 10 미만)
    public List<Map<String, Object>> getLowStockList() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT p.SKU, b.BRAND_NAME, p.PROD_NAME, "
                   + "       po.SIZE_VAL, po.COLOR, s.STOCK_QTY "
                   + "FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
                   + "WHERE s.STOCK_QTY > 0 AND s.STOCK_QTY < 10 "
                   + "ORDER BY s.STOCK_QTY ASC";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sku",       rs.getString("SKU"));
                map.put("brandName", rs.getString("BRAND_NAME"));
                map.put("prodName",  rs.getString("PROD_NAME"));
                map.put("sizeVal",   rs.getInt("SIZE_VAL"));
                map.put("color",     rs.getString("COLOR"));
                map.put("stockQty",  rs.getInt("STOCK_QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // ⑧ 품절 옵션 목록 (qty = 0)
    public List<Map<String, Object>> getZeroStockList() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT p.SKU, b.BRAND_NAME, p.PROD_NAME, "
                   + "       po.SIZE_VAL, po.COLOR, s.STOCK_QTY, "
                   + "       (SELECT TO_CHAR(MAX(IN_DATE), 'YYYY-MM-DD') FROM INBOUND "
                   + "        WHERE OPT_NUM = po.OPT_NUM) AS LAST_IN_DATE "
                   + "FROM STOCK s "
                   + "JOIN PROD_OPTIONS po ON s.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
                   + "WHERE s.STOCK_QTY = 0 "
                   + "ORDER BY p.PROD_NUM, po.SIZE_VAL";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sku",        rs.getString("SKU"));
                map.put("brandName",  rs.getString("BRAND_NAME"));
                map.put("prodName",   rs.getString("PROD_NAME"));
                map.put("sizeVal",    rs.getInt("SIZE_VAL"));
                map.put("color",      rs.getString("COLOR"));
                map.put("stockQty",   rs.getInt("STOCK_QTY"));
                map.put("lastInDate", rs.getString("LAST_IN_DATE") != null ? rs.getString("LAST_IN_DATE") : "-");
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // ⑨ 사이즈별 상세 재고 (모달용)
    public List<Map<String, Object>> getSizeStockDetail(int prodNum) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT po.SIZE_VAL, po.COLOR, NVL(s.STOCK_QTY, 0) AS STOCK_QTY "
                   + "FROM PROD_OPTIONS po "
                   + "LEFT JOIN STOCK s ON po.OPT_NUM = s.OPT_NUM "
                   + "WHERE po.PROD_NUM = ? AND po.PROD_USE_YN = 'Y' "
                   + "ORDER BY po.SIZE_VAL, po.COLOR";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, prodNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sizeVal",  rs.getInt("SIZE_VAL"));
                map.put("color",    rs.getString("COLOR"));
                map.put("stockQty", rs.getInt("STOCK_QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // ⑩ 브랜드 목록 (필터용)
    public List<Map<String, Object>> getBrandList() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT BRAND_NUM, BRAND_NAME FROM BRANDS WHERE BRAND_USE_YN = 'Y' ORDER BY BRAND_NUM";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("brandNum",  rs.getInt("BRAND_NUM"));
                map.put("brandName", rs.getString("BRAND_NAME"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }
}