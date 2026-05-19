package kr.shop.dao;

import java.sql.*;
import java.util.*;
import kr.util.DBUtil;

public class RestockAlertDAO {

    private static RestockAlertDAO instance = new RestockAlertDAO();
    public static RestockAlertDAO getInstance() { return instance; }
    private RestockAlertDAO() {}

    // ① 재입고 신청 등록 (중복 체크 포함)
    public String insertAlert(int userNum, int optNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();

            // 중복 신청 체크
            String checkSql = """
                SELECT COUNT(*) FROM RESTOCK_ALERT
                WHERE USER_NUM = ? AND OPT_NUM = ? AND SENT_YN = 'N'
                """;
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, userNum);
            pstmt.setInt(2, optNum);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) return "duplicate";
            DBUtil.executeClose(rs, pstmt, null);

            // INSERT
            String sql = """
                INSERT INTO RESTOCK_ALERT (ALERT_NUM, USER_NUM, OPT_NUM)
                VALUES (RESTOCK_ALERT_SEQ.NEXTVAL, ?, ?)
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            pstmt.setInt(2, optNum);
            pstmt.executeUpdate();
            return "success";
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
    }

    // ② 마이페이지 - 사용자의 재입고 알림 목록 조회
    public List<Map<String, Object>> getAlertListByUser(int userNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            String sql = """
                SELECT ra.alert_num, ra.opt_num, ra.sent_yn,
                       TO_CHAR(ra.alert_created_at, 'YYYY-MM-DD') AS reg_date,
                       p.prod_name, b.brand_name,
                       po.color, po.size_val,
                       i.prod_img_url
                FROM RESTOCK_ALERT ra
                JOIN PROD_OPTIONS po ON ra.opt_num = po.opt_num
                JOIN PRODUCTS p ON po.prod_num = p.prod_num
                JOIN BRANDS b ON p.brand_num = b.brand_num
                LEFT JOIN PROD_IMGS i ON p.prod_num = i.prod_num AND i.is_main = 'Y'
                WHERE ra.user_num = ?
                ORDER BY ra.alert_created_at DESC
                """;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("alert_num",    rs.getInt("alert_num"));
                map.put("sent_yn",      rs.getString("sent_yn"));
                map.put("reg_date",     rs.getString("reg_date"));
                map.put("prod_name",    rs.getString("prod_name"));
                map.put("brand_name",   rs.getString("brand_name"));
                map.put("color",        rs.getString("color"));
                map.put("size_val",     rs.getInt("size_val"));
                map.put("prod_img_url", rs.getString("prod_img_url"));
                list.add(map);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ③ 재고 입고 시 알림 발송 처리 (StockDAO나 관리자 재고수정 Action에서 호출)
    public void sendRestockNotify(int optNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 해당 opt_num으로 신청한 미발송 유저 목록 + 상품명 조회
            String selectSql = """
                SELECT ra.alert_num, ra.user_num,
                       p.prod_num, p.prod_name, po.color, po.size_val
                FROM RESTOCK_ALERT ra
                JOIN PROD_OPTIONS po ON ra.opt_num = po.opt_num
                JOIN PRODUCTS p ON po.prod_num = p.prod_num
                WHERE ra.opt_num = ? AND ra.sent_yn = 'N'
                """;
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, optNum);
            rs = pstmt.executeQuery();

            List<int[]> alertNums = new ArrayList<>();
            String notifyInsert = """
                INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT, REF_ID)
                VALUES (NOTIFY_SEQ.NEXTVAL, ?, 'RESTOCK', ?, ?, ?)
                """;
            PreparedStatement notifyPstmt = conn.prepareStatement(notifyInsert);

            while (rs.next()) {
                int alertNum = rs.getInt("alert_num");
                int userNum  = rs.getInt("user_num");
                int prodNum  = rs.getInt("prod_num");
                String title = "재입고 알림: " + rs.getString("prod_name");
                String content = rs.getString("color") + " / " 
                                 + rs.getInt("size_val") + " 사이즈가 재입고되었습니다.";

                notifyPstmt.setInt(1, userNum);
                notifyPstmt.setString(2, title);
                notifyPstmt.setString(3, content);
                notifyPstmt.setInt(4, prodNum);
                notifyPstmt.addBatch();

                alertNums.add(new int[]{alertNum});
            }
            notifyPstmt.executeBatch();
            DBUtil.executeClose(rs, pstmt, null);

            // SENT_YN = 'Y' 처리
            String updateSql = "UPDATE RESTOCK_ALERT SET SENT_YN = 'Y' WHERE ALERT_NUM = ?";
            pstmt = conn.prepareStatement(updateSql);
            for (int[] a : alertNums) {
                pstmt.setInt(1, a[0]);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.setAutoCommit(true);
            DBUtil.executeClose(rs, pstmt, conn);
        }
    }

    // ④ 알림 취소
    public void deleteAlert(int alertNum, int userNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM RESTOCK_ALERT WHERE ALERT_NUM = ? AND USER_NUM = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alertNum);
            pstmt.setInt(2, userNum);
            pstmt.executeUpdate();
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
}