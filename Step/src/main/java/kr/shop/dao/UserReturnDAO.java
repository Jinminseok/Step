package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import kr.util.DBUtil;

public class UserReturnDAO {
    // 싱글톤 패턴
    private static UserReturnDAO instance = new UserReturnDAO();
    public static UserReturnDAO getInstance() { return instance; }
    private UserReturnDAO() {}

    // ── 🌟 반품/교환 신청 처리 ──
    public void insertReturnRequest(int orderNum, int userNum, int tp, String reason, String retNote) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = DBUtil.getConnection();
            // 트랜잭션 시작 (둘 다 성공해야 커밋)
            conn.setAutoCommit(false);

            // [1단계] RETURNS 테이블에 데이터 INSERT (ORDER_ITEMS 조인)            
            String sql1 = "INSERT INTO RETURNS (RET_NUM, ORDER_NUM, USER_NUM, TP, REASON, PROD_NUM, OPT_NUM, RET_NOTE, RET_STATUS, RET_CREATED_AT) "
                       + "SELECT RETURNS_SEQ.NEXTVAL, oi.ORDER_NUM, ?, ?, ?, oi.PROD_NUM, oi.OPT_NUM, ?, 1, SYSDATE "
                       + "FROM ORDER_ITEMS oi "
                       + "WHERE oi.ORDER_NUM = ?";

            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, userNum);
            pstmt1.setInt(2, tp);       // 1: 반품, 2: 교환
            pstmt1.setString(3, reason);
            pstmt1.setString(4, retNote);
            pstmt1.setInt(5, orderNum);
            pstmt1.executeUpdate();
            
            // [2단계] ORDERS 테이블의 주문 상태를 6(반품/교환 처리중)으로 UPDATE
            String sql2 = "UPDATE ORDERS SET ORDER_STATUS = 6 WHERE ORDER_NUM = ?";
            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, orderNum);
            pstmt2.executeUpdate();

            
            conn.commit();
        } catch (Exception e) {            
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            // 자원 해제 (연 순서의 역순으로)
            DBUtil.executeClose(null, pstmt2, null);
            DBUtil.executeClose(null, pstmt1, conn);
        }
    }
}