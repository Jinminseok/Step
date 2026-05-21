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
        
        // 🎯 핵심: po.SIZE_VAL, po.COLOR, r.IS_GOOD 데이터까지 싹 다 SELECT 해와야 합니다!
        String sql = "SELECT r.RET_NUM, r.ORDER_NUM, r.PROD_NUM, r.OPT_NUM, r.USER_NUM, r.TP, r.REASON, r.RET_NOTE, r.RET_STATUS, "
                + "       DECODE(r.IS_GOOD, 1, '양품', 2, '불량', '상태미상') AS IS_GOOD_STR, "
                + "       p.PROD_NAME AS PROD_NAME, po.SIZE_VAL AS SIZE_VAL, po.COLOR AS COLOR, "
                + "       o.RECV_NAME AS RECV_NAME, o.RECV_PHONE AS RECV_PHONE, (o.RECV_ADDR1 || ' ' || o.RECV_ADDR2) AS RECV_ADDR "
                + "FROM RETURNS r "
                + "JOIN ORDERS o ON r.ORDER_NUM = o.ORDER_NUM "
                + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                + "JOIN PROD_OPTIONS po ON r.OPT_NUM = po.OPT_NUM "
                + "WHERE r.RET_STATUS = 3 " // 🚨 DB의 상태값과 형님의 데이터가 일치하는지 꼭 확인하셔야 합니다!
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
             vo.setReason(rs.getString("REASON"));
             vo.setRet_note(rs.getString("RET_NOTE"));
             vo.setIs_good_str(rs.getString("IS_GOOD_STR")); 
             vo.setProd_name(rs.getString("PROD_NAME"));
             
             // 🚨 형님의 Log_ReturnVO 멤버 변수가 소문자 size_val, color 인지 철저하게 매칭 검증
             vo.setSize_val(rs.getString("SIZE_VAL"));       
             vo.setColor(rs.getString("COLOR"));             
             
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
        
        // 🎯 물류 완료 상태인 4(양품복구)와 5(불량폐기)만 깔끔하게 긁어옵니다.
        String sql = "SELECT r.RET_NUM, r.ORDER_NUM, r.TP, r.RET_NOTE, r.RET_STATUS, p.PROD_NAME, "
                   + "       DECODE(r.RET_STATUS, 4, '양품복구', 5, '불량폐기', '검수중') AS PROC_TYPE, "
                   + "       (SELECT d.COURIER || ' ' || d.INVOICE_NO FROM DELIVERY d WHERE d.ORDER_NUM = r.ORDER_NUM AND ROWNUM = 1) AS INVOICE_NO "
                   + "FROM RETURNS r "
                   + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                   + "WHERE r.RET_STATUS IN (4, 5) "
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
                vo.setReason(rs.getString("PROC_TYPE")); // 매핑 바인딩용 컬럼 우회 활용
                vo.setInvoice_no(rs.getString("INVOICE_NO"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ── [3] 반품/교환 최종 검수 처리 트랜잭션 ──
    public void processClaimTransaction(int retNum, int orderNum, int tp, String processType, String courier, String invoiceNo, String adminMemo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtRet = null;
        PreparedStatement pstmtStock = null;
        PreparedStatement pstmtDlv = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 락 가동

            int stockDelta = 0;
            int nextStatus = 4;

            if (tp == 1) { // [반품]
                if ("RECOVERY".equals(processType)) { stockDelta = 1; nextStatus = 4; }
                else if ("DISPOSAL".equals(processType)) { stockDelta = 0; nextStatus = 5; }
            } else if (tp == 2) { // [교환]
                if ("RECOVERY".equals(processType)) { stockDelta = 0; nextStatus = 4; }
                else if ("DISPOSAL".equals(processType)) { stockDelta = -1; nextStatus = 5; }
            }

            // 1. RETURNS 테이블 상태 및 메모 스왑 쿼리 (물음표 총 5개)
            String updateRetSql = "UPDATE RETURNS SET RET_STATUS = ?, "
                               + "       RET_NOTE = CASE WHEN ? IS NULL OR TRIM(?) = '' THEN "
                               + "                     TRIM(TRAILING CHR(10) FROM CASE WHEN INSTR(RET_NOTE, CHR(10)) > 0 THEN SUBSTR(RET_NOTE, 1, INSTR(RET_NOTE, CHR(10)) - 1) ELSE RET_NOTE END) "
                               + "                  ELSE "
                               + "                     TRIM(TRAILING CHR(10) FROM CASE WHEN INSTR(RET_NOTE, CHR(10)) > 0 THEN SUBSTR(RET_NOTE, 1, INSTR(RET_NOTE, CHR(10)) - 1) ELSE RET_NOTE END) || CHR(10) || ? "
                               + "                  END "
                               + "WHERE RET_NUM = ?";
                               
            pstmtRet = conn.prepareStatement(updateRetSql);
            // 🚨 물음표 매핑 번호 정밀 싱크 매칭
            pstmtRet.setInt(1, nextStatus);
            pstmtRet.setString(2, adminMemo);
            pstmtRet.setString(3, adminMemo);
            pstmtRet.setString(4, adminMemo); 
            pstmtRet.setInt(5, retNum); // 🎯 정확하게 5번째 인덱스로 꽂아 넣습니다.
            pstmtRet.executeUpdate();

            // 2. 창고 실재고 증감 타격 (물음표 총 2개)
            if (stockDelta != 0) {
                String updateStockSql = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
                                     + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
                pstmtStock = conn.prepareStatement(updateStockSql);
                pstmtStock.setInt(1, stockDelta);
                pstmtStock.setInt(2, retNum);
                pstmtStock.executeUpdate();
            }

            // 3. [교환전용] 새 송장 번호 DELIVERY 테이블 UPDATE (물음표 총 3개)
            if (tp == 2 && courier != null && !courier.trim().isEmpty()) {
                String updateDlvSql = "UPDATE DELIVERY SET COURIER = ?, INVOICE_NO = ?, DLV_STATUS = 1 WHERE ORDER_NUM = ?";
                pstmtDlv = conn.prepareStatement(updateDlvSql);
                
                // 🚨 독립된 pstmtDlv 객체이므로 다시 1번부터 차례대로 매핑해야 에러가 안 납니다!
                pstmtDlv.setString(1, courier);
                pstmtDlv.setString(2, invoiceNo);
                pstmtDlv.setInt(3, orderNum); 
                pstmtDlv.executeUpdate();
            }

            conn.commit(); // 트랜잭션 완결 성공!
            System.out.println("🚀 [WMS] 클레임 접수번호 " + retNum + "번 처리 및 교환 송장 반영 완결!");
            
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmtRet, null);
            DBUtil.executeClose(null, pstmtStock, null);
            DBUtil.executeClose(null, pstmtDlv, conn);
        }
    }
    
 // ── [신규 1] 이력 건에 대한 물류 담당자 특이사항(메모)만 실시간 수정 ──
    public void updateClaimMemo(int retNum, String adminMemo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE RETURNS SET "
                + "       RET_NOTE = CASE WHEN ? IS NULL OR TRIM(?) = '' THEN "
                + "                     TRIM(TRAILING CHR(10) FROM CASE WHEN INSTR(RET_NOTE, CHR(10)) > 0 THEN SUBSTR(RET_NOTE, 1, INSTR(RET_NOTE, CHR(10)) - 1) ELSE RET_NOTE END) "
                + "                  ELSE "
                + "                     TRIM(TRAILING CHR(10) FROM CASE WHEN INSTR(RET_NOTE, CHR(10)) > 0 THEN SUBSTR(RET_NOTE, 1, INSTR(RET_NOTE, CHR(10)) - 1) ELSE RET_NOTE END) || CHR(10) || ? "
                + "                  END "
                + "WHERE RET_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, adminMemo);
            pstmt.setString(2, adminMemo);
            pstmt.setString(3, adminMemo);
            pstmt.setInt(4, retNum);
            pstmt.executeUpdate();
            
            System.out.println("⚙️ [WMS 순정 스왑] 접수번호 " + retNum + "번 물류메모 깔끔하게 교체 완료!");
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
    
    // ── [신규 2] 처리 완료 건 취소 및 재고 원상복구 트랜잭션 (핵심 정밀 수식) ──
    public void cancelClaimTransaction(int retNum, int orderNum, int tp, int currentStatus) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtRet = null;
        PreparedStatement pstmtStock = null;
        PreparedStatement pstmtDlv = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            int rollbackStockDelta = 0;

            if (tp == 1) { // [반품 취소]
                if (currentStatus == 4) rollbackStockDelta = -1;
                else if (currentStatus == 5) rollbackStockDelta = 0;
            } else if (tp == 2) { // [교환 취소]
                if (currentStatus == 4) rollbackStockDelta = 0;
                else if (currentStatus == 5) rollbackStockDelta = 1;
            }

            // 🎯 [범인 체포 및 수정] 기존에 있던 RET_NOTE = NULL을 완전히 삭제했습니다!
            // 이제 원래 들어있던 쇼핑몰 전달메모는 건드리지 않고, 상태(RET_STATUS)만 대기(3)로 되돌립니다.
            String sqlRet = "UPDATE RETURNS SET RET_STATUS = 3 WHERE RET_NUM = ?";
            pstmtRet = conn.prepareStatement(sqlRet);
            pstmtRet.setInt(1, retNum);
            pstmtRet.executeUpdate();

            // 창고 실재고 역산 타격
            if (rollbackStockDelta != 0) {
                String sqlStock = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
                                + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
                pstmtStock = conn.prepareStatement(sqlStock);
                pstmtStock.setInt(1, rollbackStockDelta);
                pstmtStock.setInt(2, retNum);
                pstmtStock.executeUpdate();
            }

            // 교환 운송장 폭파
            if (tp == 2) {
                String sqlDlv = "UPDATE DELIVERY SET COURIER = NULL, INVOICE_NO = NULL, DLV_STATUS = 0 WHERE ORDER_NUM = ?";
                pstmtDlv = conn.prepareStatement(sqlDlv);
                pstmtDlv.setInt(1, orderNum);
                pstmtDlv.executeUpdate();
            }

            conn.commit();
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