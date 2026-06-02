package logis.dao;

import java.sql.*;
import java.util.*;
import kr.util.DBUtil;

public class Log_ReportDAO {

    private static Log_ReportDAO instance = new Log_ReportDAO();
    public static Log_ReportDAO getInstance() { return instance; }
    private Log_ReportDAO() {}

    //기간 내 총 입고 수량
    public int getTotalInQty(String startDate, String endDate) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(IN_QTY), 0) FROM INBOUND "
                   + "WHERE IN_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate); pstmt.setString(2, endDate);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //기간 내 총 출고 수량
    public int getTotalOutQty(String startDate, String endDate) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(OUT_QTY), 0) FROM OUTBOUND "
                   + "WHERE OUT_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate); pstmt.setString(2, endDate);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //전월 입고 수량 (전월 대비 계산용)
    public int getLastMonthInQty() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(IN_QTY), 0) FROM INBOUND "
                   + "WHERE IN_DATE >= TRUNC(SYSDATE, 'MM') - INTERVAL '1' MONTH "
                   + "  AND IN_DATE <  TRUNC(SYSDATE, 'MM')";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //전월 출고 수량
    public int getLastMonthOutQty() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(OUT_QTY), 0) FROM OUTBOUND "
                   + "WHERE OUT_DATE >= TRUNC(SYSDATE, 'MM') - INTERVAL '1' MONTH "
                   + "  AND OUT_DATE <  TRUNC(SYSDATE, 'MM')";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //브랜드별 출고 현황
    public List<Map<String, Object>> getBrandOutbound(String startDate, String endDate) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT b.BRAND_NAME, NVL(SUM(ob.OUT_QTY), 0) AS QTY "
                   + "FROM OUTBOUND ob "
                   + "JOIN PROD_OPTIONS po ON ob.OPT_NUM = po.OPT_NUM "
                   + "JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
                   + "WHERE ob.OUT_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999 "
                   + "GROUP BY b.BRAND_NAME ORDER BY QTY DESC";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate); pstmt.setString(2, endDate);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("brandName", rs.getString("BRAND_NAME"));
                map.put("qty",       rs.getInt("QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    //인기 사이즈 TOP5
    public List<Map<String, Object>> getTopSizes(String startDate, String endDate) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT * FROM ("
                   + "  SELECT po.SIZE_VAL, NVL(SUM(ob.OUT_QTY), 0) AS QTY "
                   + "  FROM OUTBOUND ob "
                   + "  JOIN PROD_OPTIONS po ON ob.OPT_NUM = po.OPT_NUM "
                   + "  WHERE ob.OUT_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999 "
                   + "  GROUP BY po.SIZE_VAL ORDER BY QTY DESC"
                   + ") WHERE ROWNUM <= 5";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate); pstmt.setString(2, endDate);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sizeVal", rs.getInt("SIZE_VAL"));
                map.put("qty",     rs.getInt("QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    //인기 카테고리 TOP5
    public List<Map<String, Object>> getTopCategories(String startDate, String endDate) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT * FROM ("
                   + "  SELECT c.CAT_NAME, NVL(SUM(ob.OUT_QTY), 0) AS QTY "
                   + "  FROM OUTBOUND ob "
                   + "  JOIN PROD_OPTIONS po ON ob.OPT_NUM = po.OPT_NUM "
                   + "  JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM "
                   + "  JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM "
                   + "  WHERE ob.OUT_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999 "
                   + "  GROUP BY c.CAT_NAME ORDER BY QTY DESC"
                   + ") WHERE ROWNUM <= 5";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate); pstmt.setString(2, endDate);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("catName", rs.getString("CAT_NAME"));
                map.put("qty",     rs.getInt("QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    //월별 입출고 추이 (최근 6개월)
    public List<Map<String, Object>> getMonthlyTrend() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        String sql = "SELECT mon, NVL(in_qty, 0) AS in_qty, NVL(out_qty, 0) AS out_qty "
                   + "FROM ("
                   + "  SELECT TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'), -LEVEL+1), 'MM\"월\"') AS mon, "
                   + "         ADD_MONTHS(TRUNC(SYSDATE,'MM'), -LEVEL+1) AS mon_date "
                   + "  FROM DUAL CONNECT BY LEVEL <= 3"
                   + ") m "
                   + "LEFT JOIN ("
                   + "  SELECT TRUNC(IN_DATE,'MM') AS d, SUM(IN_QTY) AS in_qty "
                   + "  FROM INBOUND GROUP BY TRUNC(IN_DATE,'MM')"
                   + ") i ON m.mon_date = i.d "
                   + "LEFT JOIN ("
                   + "  SELECT TRUNC(OUT_DATE,'MM') AS d, SUM(OUT_QTY) AS out_qty "
                   + "  FROM OUTBOUND GROUP BY TRUNC(OUT_DATE,'MM')"
                   + ") o ON m.mon_date = o.d "
                   + "ORDER BY m.mon_date ASC";

        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("mon",    rs.getString("MON"));
                map.put("inQty",  rs.getInt("IN_QTY"));
                map.put("outQty", rs.getInt("OUT_QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    //현재 전체 재고
    public int getTotalStock() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(STOCK_QTY), 0) FROM STOCK";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery(); if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }
}