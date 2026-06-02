package kr.admin.order.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class AdminOrderDAO {
    // 싱글톤 패턴
    private static AdminOrderDAO instance = new AdminOrderDAO();
    public static AdminOrderDAO getInstance() { return instance; }
    private AdminOrderDAO() {}

    //페이징 및 검색을 위한 전체 주문 개수 구하기 
    public int getOrderCount(Map<String, Object> map) throws Exception {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM ORDERS o ");
        //USERS 대신 USERS_DETAIL 테이블과 조인
        sql.append("JOIN USERS_DETAIL ud ON o.USER_NUM = ud.USER_NUM ");
        sql.append("WHERE 1=1 ");
        
        appendSearchCondition(sql, map);

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            setSearchCondition(pstmt, map, 1);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }

    //실제 화면에 뿌려줄 주문 목록 조회 (10개씩)
    public List<Map<String, Object>> getOrderList(Map<String, Object> map) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM ( ");
        sql.append("  SELECT a.*, rownum rnum FROM ( ");
        sql.append("    SELECT o.ORDER_NUM, ");
        sql.append("           o.ORDER_CREATED_AT, ");
        
        //USERS_DETAIL(ud)의 USER_NAME을 가져옵니다!
        sql.append("           ud.USER_NAME AS ORDER_NAME, "); 
        
        sql.append("           o.RECV_NAME, ");
        sql.append("           o.PAY_PRICE, ");
        sql.append("           o.ORDER_STATUS, ");
        sql.append("           pay.METHOD AS PAY_METHOD, ");
        
        sql.append("           (SELECT p.PROD_NAME FROM ORDER_ITEMS oi JOIN PRODUCTS p ON oi.PROD_NUM = p.PROD_NUM WHERE oi.ORDER_NUM = o.ORDER_NUM AND ROWNUM = 1) AS MAIN_PROD_NAME, ");
        sql.append("           (SELECT COUNT(*) FROM ORDER_ITEMS WHERE ORDER_NUM = o.ORDER_NUM) AS ITEM_CNT ");
        
        sql.append("    FROM ORDERS o ");
        //여기서도 USERS_DETAIL과 조인!
        sql.append("    JOIN USERS_DETAIL ud ON o.USER_NUM = ud.USER_NUM ");
        sql.append("    LEFT JOIN PAYMENTS pay ON o.ORDER_NUM = pay.ORDER_NUM AND pay.PAY_STATUS = 1 ");
        sql.append("    WHERE 1=1 ");
        
        appendSearchCondition(sql, map);
        
        sql.append("    ORDER BY o.ORDER_NUM DESC ");
        sql.append("  ) a ");
        sql.append(") WHERE rnum >= ? AND rnum <= ?");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            int bindIndex = setSearchCondition(pstmt, map, 1);
            pstmt.setInt(bindIndex++, (Integer) map.get("startRow"));
            pstmt.setInt(bindIndex++, (Integer) map.get("endRow"));
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("ordNum", rs.getInt("ORDER_NUM"));
                order.put("orderDate", rs.getString("ORDER_CREATED_AT"));
                order.put("orderName", rs.getString("ORDER_NAME"));
                order.put("recvName", rs.getString("RECV_NAME"));
                order.put("payPrice", rs.getInt("PAY_PRICE"));
                order.put("orderStatus", rs.getInt("ORDER_STATUS"));
                order.put("payMethod", rs.getString("PAY_METHOD") == null ? "미결제" : rs.getString("PAY_METHOD"));
                
                String mainProdName = rs.getString("MAIN_PROD_NAME");
                int itemCnt = rs.getInt("ITEM_CNT");
                if (itemCnt > 1) {
                    order.put("prodTitle", mainProdName + " 외 " + (itemCnt - 1) + "건");
                } else {
                    order.put("prodTitle", mainProdName);
                }
                
                list.add(order);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 동적 쿼리 조건 조립을 위한 헬퍼 메서드
    private void appendSearchCondition(StringBuilder sql, Map<String, Object> map) {
        String sDate = (String) map.get("sDate");
        String eDate = (String) map.get("eDate");
        String sStatus = (String) map.get("sStatus");
        String sKeywordType = (String) map.get("sKeywordType");
        String sKeyword = (String) map.get("sKeyword");

        if (sDate != null && !sDate.isEmpty() && eDate != null && !eDate.isEmpty()) {
            sql.append(" AND TO_CHAR(o.ORDER_CREATED_AT, 'YYYY-MM-DD') BETWEEN ? AND ? ");
        }
        if (sStatus != null && !sStatus.equals("ALL")) {
            sql.append(" AND o.ORDER_STATUS = ? ");
        }
        if (sKeyword != null && !sKeyword.trim().isEmpty()) {
            if ("ordNum".equals(sKeywordType)) {
                sql.append(" AND TO_CHAR(o.ORDER_NUM) LIKE ? ");
            } else if ("orderName".equals(sKeywordType)) {
                sql.append(" AND ud.USER_NAME LIKE ? ");
            } else if ("recvName".equals(sKeywordType)) {
                sql.append(" AND o.RECV_NAME LIKE ? ");
            } else if ("recvPhone".equals(sKeywordType)) {
                sql.append(" AND o.RECV_PHONE LIKE ? ");
            }
        }
    }

    //동적 쿼리 바인딩을 위한 헬퍼 메서드
    private int setSearchCondition(PreparedStatement pstmt, Map<String, Object> map, int idx) throws Exception {
        String sDate = (String) map.get("sDate");
        String eDate = (String) map.get("eDate");
        String sStatus = (String) map.get("sStatus");
        String sKeywordType = (String) map.get("sKeywordType");
        String sKeyword = (String) map.get("sKeyword");

        if (sDate != null && !sDate.isEmpty() && eDate != null && !eDate.isEmpty()) {
            pstmt.setString(idx++, sDate);
            pstmt.setString(idx++, eDate);
        }
        if (sStatus != null && !sStatus.equals("ALL")) {
            pstmt.setInt(idx++, Integer.parseInt(sStatus));
        }
        if (sKeyword != null && !sKeyword.trim().isEmpty()) {
            pstmt.setString(idx++, "%" + sKeyword + "%");
        }
        return idx;
    }
    
 //모달용: 주문 기본 정보 (수령인, 결제 정보 등)
    public Map<String, Object> getOrderMaster(int ordNum) throws Exception {
        Map<String, Object> map = new HashMap<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        
        String sql = "SELECT o.*, ud.USER_NAME AS ORDER_NAME, pay.METHOD AS PAY_METHOD " +
                     "FROM ORDERS o " +
                     "JOIN USERS_DETAIL ud ON o.USER_NUM = ud.USER_NUM " +
                     "LEFT JOIN PAYMENTS pay ON o.ORDER_NUM = pay.ORDER_NUM AND pay.PAY_STATUS = 1 " +
                     "WHERE o.ORDER_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, ordNum);
            rs = pstmt.executeQuery();
            if(rs.next()){
                map.put("orderName", rs.getString("ORDER_NAME"));
                map.put("recvName", rs.getString("RECV_NAME"));
                map.put("recvPhone", rs.getString("RECV_PHONE"));
                map.put("recvZip", rs.getString("RECV_ZIP"));
                map.put("recvAddr1", rs.getString("RECV_ADDR1"));
                map.put("recvAddr2", rs.getString("RECV_ADDR2") == null ? "" : rs.getString("RECV_ADDR2"));
                map.put("orderDate", rs.getString("ORDER_CREATED_AT"));
                map.put("orderStatus", rs.getInt("ORDER_STATUS"));
                map.put("payMethod", rs.getString("PAY_METHOD") == null ? "미결제" : rs.getString("PAY_METHOD"));
                map.put("payPrice", rs.getInt("PAY_PRICE"));
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return map;
    }

    //모달용: 주문 상세 상품 목록
    public List<Map<String, Object>> getOrderItems(int ordNum) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        
        String sql = "SELECT oi.PROD_NUM, p.PROD_NAME, po.COLOR, po.SIZE_VAL, oi.ORDER_ITEM_QTY, oi.ORDER_ITEM_PRICE " +
                     "FROM ORDER_ITEMS oi " +
                     "JOIN PRODUCTS p ON oi.PROD_NUM = p.PROD_NUM " +
                     "JOIN PROD_OPTIONS po ON oi.OPT_NUM = po.OPT_NUM " +
                     "WHERE oi.ORDER_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, ordNum);
            rs = pstmt.executeQuery();
            while(rs.next()){
                Map<String, Object> map = new HashMap<>();
                map.put("prodNum", rs.getInt("PROD_NUM"));
                map.put("prodName", rs.getString("PROD_NAME"));
                map.put("color", rs.getString("COLOR"));
                map.put("size", rs.getInt("SIZE_VAL"));
                map.put("qty", rs.getInt("ORDER_ITEM_QTY"));
                map.put("price", rs.getInt("ORDER_ITEM_PRICE"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }
    
}