package logis.dao;

import java.sql.*;
import java.util.*;
import kr.util.DBUtil;

public class Log_DashDAO {

    private static Log_DashDAO instance = new Log_DashDAO();
    public static Log_DashDAO getInstance() { return instance; }
    private Log_DashDAO() {}

    //오늘 입고 총 수량
    public int getTodayInQty() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(IN_QTY), 0) FROM INBOUND "
                   + "WHERE TRUNC(IN_DATE) = TRUNC(SYSDATE)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return total;
    }

    //전체 재고 총 수량
    public int getTotalStock() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(STOCK_QTY), 0) FROM STOCK";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return total;
    }

    //재고 부족 상품 수 (STOCK_QTY < STOCK_MIN_QTY)
    public int getLowStockCount() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String sql = "SELECT COUNT(*) FROM STOCK "
                   + "WHERE STOCK_QTY < STOCK_MIN_QTY AND STOCK_QTY > 0";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return count;
    }

    //최근 입고 내역 4건
    public List<Map<String, Object>> getRecentInboundList() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM ("
                   + "  SELECT P.PROD_NAME, O.SIZE_VAL, O.COLOR, I.IN_QTY, "
                   + "         TO_CHAR(I.IN_CREATED_AT, 'HH24:MI') AS IN_TIME, "
                   + "         TO_CHAR(I.IN_DATE, 'YYYY-MM-DD') AS IN_DATE, "
                   + "         NVL(U.USER_NAME, '관리자') AS USER_NAME "
                   + "  FROM INBOUND I "
                   + "  JOIN PRODUCTS P ON I.PROD_NUM = P.PROD_NUM "
                   + "  JOIN PROD_OPTIONS O ON I.OPT_NUM = O.OPT_NUM "
                   + "  LEFT JOIN USERS_DETAIL U ON I.ADMIN_NUM = U.USER_NUM "
                   + "  ORDER BY I.IN_NUM DESC"
                   + ") WHERE ROWNUM <= 4";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("prodName", rs.getString("PROD_NAME"));
                map.put("sizeVal",  rs.getInt("SIZE_VAL"));
                map.put("color",    rs.getString("COLOR"));
                map.put("inQty",    rs.getInt("IN_QTY"));
                map.put("inTime",   rs.getString("IN_TIME"));
                map.put("inDate",   rs.getString("IN_DATE"));
                map.put("userName", rs.getString("USER_NAME"));
                list.add(map);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //재고 부족 TOP 5
    public List<Map<String, Object>> getLowStockTop5() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM ("
                   + "  SELECT P.PROD_NAME, O.SIZE_VAL, S.STOCK_QTY "
                   + "  FROM STOCK S "
                   + "  JOIN PROD_OPTIONS O ON S.OPT_NUM = O.OPT_NUM "
                   + "  JOIN PRODUCTS P ON S.PROD_NUM = P.PROD_NUM "
                   + "  WHERE S.STOCK_QTY < S.STOCK_MIN_QTY "
                   + "  ORDER BY S.STOCK_QTY ASC"
                   + ") WHERE ROWNUM <= 5";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("prodName", rs.getString("PROD_NAME"));
                map.put("sizeVal",  rs.getInt("SIZE_VAL"));
                map.put("stockQty", rs.getInt("STOCK_QTY"));
                list.add(map);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
 //오늘 출고 수량
    public int getTodayOutQty() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(OUT_QTY), 0) FROM OUTBOUND "
                   + "WHERE TRUNC(OUT_DATE) = TRUNC(SYSDATE)";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //어제 입고 수량
    public int getYesterdayInQty() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(IN_QTY), 0) FROM INBOUND "
                   + "WHERE TRUNC(IN_DATE) = TRUNC(SYSDATE) - 1";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //어제 출고 수량
    public int getYesterdayOutQty() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int total = 0;
        String sql = "SELECT NVL(SUM(OUT_QTY), 0) FROM OUTBOUND "
                   + "WHERE TRUNC(OUT_DATE) = TRUNC(SYSDATE) - 1";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) total = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return total;
    }

    //주간 입고 현황 (이번 주 월~오늘)
    public List<Map<String, Object>> getWeeklyInbound() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT TO_CHAR(IN_DATE, 'MM/DD') AS DAY_LABEL, "
                   + "       NVL(SUM(IN_QTY), 0) AS QTY "
                   + "FROM INBOUND "
                   + "WHERE IN_DATE >= TRUNC(SYSDATE, 'IW') "
                   + "  AND IN_DATE <  TRUNC(SYSDATE) + 1 "
                   + "GROUP BY TO_CHAR(IN_DATE, 'MM/DD'), TRUNC(IN_DATE) "
                   + "ORDER BY TRUNC(IN_DATE)";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("dayLabel", rs.getString("DAY_LABEL"));
                map.put("qty",      rs.getInt("QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    //주간 출고 현황 (이번 주 월~오늘)
    public List<Map<String, Object>> getWeeklyOutbound() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT TO_CHAR(OUT_DATE, 'MM/DD') AS DAY_LABEL, "
                   + "       NVL(SUM(OUT_QTY), 0) AS QTY "
                   + "FROM OUTBOUND "
                   + "WHERE OUT_DATE >= TRUNC(SYSDATE, 'IW') "
                   + "  AND OUT_DATE <  TRUNC(SYSDATE) + 1 "
                   + "GROUP BY TO_CHAR(OUT_DATE, 'MM/DD'), TRUNC(OUT_DATE) "
                   + "ORDER BY TRUNC(OUT_DATE)";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("dayLabel", rs.getString("DAY_LABEL"));
                map.put("qty",      rs.getInt("QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    //출고 대기 주문 TOP 5 (ORDER_STATUS = 1)
    public List<Map<String, Object>> getPendingOutboundList() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT * FROM ("
                   + "  SELECT o.ORDER_NUM, p.PROD_NAME, oi.ORDER_ITEM_QTY "
                   + "  FROM ORDERS o "
                   + "  JOIN ORDER_ITEMS oi ON o.ORDER_NUM = oi.ORDER_NUM "
                   + "  JOIN PRODUCTS p ON oi.PROD_NUM = p.PROD_NUM "
                   + "  WHERE o.ORDER_STATUS = 1 "
                   + "  ORDER BY o.ORDER_CREATED_AT ASC"
                   + ") WHERE ROWNUM <= 5";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("orderNum",  rs.getInt("ORDER_NUM"));
                map.put("prodName",  rs.getString("PROD_NAME"));
                map.put("qty",       rs.getInt("ORDER_ITEM_QTY"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }
 // 출고 대기 실제 건수 (카운트용)
    public int getPendingOutboundCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        String sql = "SELECT COUNT(*) FROM ORDERS WHERE ORDER_STATUS = 1";
        try {
            conn = DBUtil.getConnection(); pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }
}