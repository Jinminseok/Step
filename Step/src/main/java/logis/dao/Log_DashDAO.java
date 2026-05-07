package logis.dao;

import java.sql.*;
import java.util.*;
import kr.util.DBUtil;

public class Log_DashDAO {

    private static Log_DashDAO instance = new Log_DashDAO();
    public static Log_DashDAO getInstance() { return instance; }
    private Log_DashDAO() {}

    // ① 오늘 입고 총 수량
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

    // ② 전체 재고 총 수량
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

    // ③ 재고 부족 상품 수 (STOCK_QTY < STOCK_MIN_QTY)
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

    // ④ 최근 입고 내역 4건
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

    // ⑤ 재고 부족 TOP 5
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
}