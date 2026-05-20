package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminOrderVO;
import kr.util.DBUtil;
import logis_vo.Log_ReturnVO;

public class Log_ReturnDAO {
    // 싱글톤 패턴
    private static Log_ReturnDAO instance = new Log_ReturnDAO();
    public static Log_ReturnDAO getInstance() { return instance; }
    private Log_ReturnDAO() {}

 // ── [1] 쇼핑몰 관리자가 처리를 완료하여 '물류 창고'에 실물이 도착한 대기 목록 조회 ──
    public List<Log_ReturnVO> getClaimWaitList() throws Exception {
        List<Log_ReturnVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 🎯 쇼핑몰 관리자가 완료한 상태(RET_STATUS = 3)인 것만 타겟팅하여 가져옵니다.
        String sql = "SELECT r.RET_NUM, r.ORDER_NUM, r.PROD_NUM, r.OPT_NUM, r.USER_NUM, r.TP, r.REASON, r.RET_NOTE, r.RET_STATUS, "
                   + "       p.PROD_NAME, o.RECV_NAME, o.RECV_PHONE, (o.RECV_ADDR1 || ' ' || o.RECV_ADDR2) AS RECV_ADDR "
                   + "FROM RETURNS r "
                   + "JOIN ORDERS o ON r.ORDER_NUM = o.ORDER_NUM "
                   + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                   + "WHERE r.RET_STATUS = 3 " 
                   + "ORDER BY r.RET_NUM DESC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                Log_ReturnVO vo = new Log_ReturnVO();
                vo.setRet_num(rs.getInt("RET_NUM"));
                vo.setOrder_num(rs.getInt("ORDER_NUM"));
                vo.setProd_num(rs.getInt("PROD_NUM"));
                vo.setOpt_num(rs.getInt("OPT_NUM"));
                vo.setUser_num(rs.getInt("USER_NUM"));
                vo.setTp(rs.getInt("TP"));
                vo.setReason(rs.getString("REASON"));
                vo.setRet_note(rs.getString("RET_NOTE"));
                vo.setRet_status(rs.getInt("RET_STATUS"));
                vo.setProd_name(rs.getString("PROD_NAME"));
                vo.setRecv_name(rs.getString("RECV_NAME"));
                vo.setRecv_phone(rs.getString("RECV_PHONE"));
                vo.setRecv_addr(rs.getString("RECV_ADDR"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ── [2] 물류 관리자가 최종 완결 지은 이력 목록 조회 (양품/불량 텍스트 직접 매핑) ──
    public List<Log_ReturnVO> getClaimHistoryList() throws Exception {
        List<Log_ReturnVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 🎯 후속 버그 방지를 위해 오라클 자체에서 DECODE로 '양품복구' / '불량폐기' 글자를 박아서 가져옵니다.
        String sql = "SELECT r.RET_NUM, r.ORDER_NUM, r.TP, r.RET_NOTE, r.RET_STATUS, p.PROD_NAME, "
                   + "       DECODE(r.RET_STATUS, 3, '양품복구', 4, '불량폐기', '검수중') AS PROC_TYPE, "
                   + "       (SELECT d.COURIER || ' ' || d.INVOICE_NO FROM DELIVERY d WHERE d.ORDER_NUM = r.ORDER_NUM AND ROWNUM = 1) AS INVOICE_NO "
                   + "FROM RETURNS r "
                   + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                   + "WHERE r.RET_STATUS IN (3, 4) "
                   + "ORDER BY r.RET_NUM DESC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                Log_ReturnVO vo = new Log_ReturnVO();
                vo.setRet_num(rs.getInt("RET_NUM"));
                vo.setOrder_num(rs.getInt("ORDER_NUM"));
                vo.setTp(rs.getInt("TP"));
                vo.setRet_note(rs.getString("RET_NOTE"));
                vo.setRet_status(rs.getInt("RET_STATUS"));
                vo.setProd_name(rs.getString("PROD_NAME"));
                // 🌟 중요: 이력 조회 글자가 깨지거나 고정되던 버그 완벽 차단!
                vo.setReason(rs.getString("PROC_TYPE")); // VO의 임시 스트링 필드로 활용하거나 별도 세팅 가능 (JSP 매핑용)
                vo.setInvoice_no(rs.getString("INVOICE_NO"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ── [3] 🎯 형님의 WMS 철학을 반영한 재고 증감 연산 트랜잭션 ──
    public void processClaimTransaction(int retNum, int orderNum, int tp, String processType, String courier, String invoiceNo, String adminMemo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtRet = null;
        PreparedStatement pstmtStock = null;
        PreparedStatement pstmtDlv = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 락 온!

            int stockDelta = 0;
            int nextStatus = 3; // 기본값 3: 양품복구 완료 상태

            // 🎯 형님이 말씀하신 WMS 전용 완벽 재고 가감 공식 적용 구역
            if (tp == 1) { 
                // 🔄 [반품 상품]일 때
                if (processType.equals("RECOVERY")) {
                    stockDelta = 1;     // 양품이면 재고 +1
                    nextStatus = 3;
                } else if (processType.equals("DISPOSAL")) {
                    stockDelta = -1;    // 불량이면 재고 -1
                    nextStatus = 4;
                }
            } else if (tp == 2) { 
                // 🔄 [교환 상품]일 때
                if (processType.equals("RECOVERY")) {
                    stockDelta = 0;     // 양품이면 재고 변동 없음 (0)
                    nextStatus = 3;
                } else if (processType.equals("DISPOSAL")) {
                    stockDelta = -1;    // 불량이 오면 재고 -1
                    nextStatus = 4;
                }
            }

            // 1. RETURNS 테이블에 최종 결과 및 메모 업뎃
            String updateRetSql = "UPDATE RETURNS SET RET_STATUS = ?, RET_NOTE = ? WHERE RET_NUM = ?";
            pstmtRet = conn.prepareStatement(updateRetSql);
            pstmtRet.setInt(1, nextStatus);
            pstmtRet.setString(2, adminMemo);
            pstmtRet.setInt(3, retNum);
            pstmtRet.executeUpdate();

            // 2. 창고 실재고(STOCK) 증감 타격 (0일 때는 쿼리 안 날리고 스킵해서 안전성 확보)
            if (stockDelta != 0) {
                String updateStockSql = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
                                     + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
                pstmtStock = conn.prepareStatement(updateStockSql);
                pstmtStock.setInt(1, stockDelta);
                pstmtStock.setInt(2, retNum);
                pstmtStock.executeUpdate();
            }

            // 3. 교환 처리 시에만 택배사 정보 및 랜덤 송장 번호를 DELIVERY 테이블에 등록!
            if (tp == 2 && courier != null && !courier.trim().isEmpty()) {
                String insertDlvSql = "INSERT INTO DELIVERY (DLV_NUM, ORDER_NUM, COURIER, INVOICE_NO, DLV_STATUS) "
                                    + "VALUES (DELIVERY_SEQ.NEXTVAL, ?, ?, ?, 1)";
                pstmtDlv = conn.prepareStatement(insertDlvSql);
                pstmtDlv.setInt(1, orderNum);
                pstmtDlv.setString(2, courier);
                pstmtDlv.setString(3, invoiceNo);
                pstmtDlv.executeUpdate();
            }

            conn.commit(); // 전 과정 성공 시 오라클 최종 커밋!
            
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmtRet, null);
            DBUtil.executeClose(null, pstmtStock, null);
            DBUtil.executeClose(null, pstmtDlv, conn);
        }
    }
    
    
}