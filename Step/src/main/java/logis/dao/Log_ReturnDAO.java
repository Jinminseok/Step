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
            conn.setAutoCommit(false); // 트랜잭션 시작

            int stockDelta = 0; // 물류 검수 시점의 재고 변동값
            int nextStatus = 4; // 기본값 4: 물류 양품복구 완료 상태

            // 🎯 형님의 WMS 철학과 주문 시점(-1)을 반영한 완벽 재고 가감 공식
            if (tp == 1) { 
                // 🔄 [반품 상품] 일 때
                if (processType.equals("RECOVERY")) {
                    stockDelta = 1;     // ✨ 양품이면 창고에 다시 채우기 (+1) -> 최종 누적재고: 0
                    nextStatus = 4;     // 양품복구완료(4)
                } else if (processType.equals("DISPOSAL")) {
                    stockDelta = 0;     // 🗑️ 불량이 오면 창고에 넣을 게 없음 (0) -> 주문할 때 깎인 상태 그대로 최종 누적재고: -1
                    nextStatus = 5;     // 불량폐기완료(5)
                }
            } else if (tp == 2) { 
                // 🔄 [교환 상품] 일 때
                if (processType.equals("RECOVERY")) {
                    stockDelta = 0;     // ✨ 양품 반입(+1) + 새 상품 출고(-1) = 변동 없음 (0) -> 최종 누적재고: -1
                    nextStatus = 4;     // 양품복구완료(4)
                } else if (processType.equals("DISPOSAL")) {
                    stockDelta = -1;    // 🗑️ 불량 반입(0) + 새 상품 출고(-1) = 재고 차감 (-1) -> 최종 누적재고: -2
                    nextStatus = 5;     // 불량폐기완료(5)
                }
            }

            // 1. RETURNS 테이블 상태를 완료(4 또는 5)로 업데이트하여 대기실에서 아웃!
            String updateRetSql = "UPDATE RETURNS SET RET_STATUS = ?, RET_NOTE = ? WHERE RET_NUM = ?";
            pstmtRet = conn.prepareStatement(updateRetSql);
            pstmtRet.setInt(1, nextStatus);
            pstmtRet.setString(2, adminMemo);
            pstmtRet.setInt(3, retNum);
            pstmtRet.executeUpdate();

            // 2. 창고 실재고(STOCK) 증감 타격 (변동치인 stockDelta가 0이 아닐 때만 오라클에 레이저 사격)
            if (stockDelta != 0) {
                String updateStockSql = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
                                     + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
                pstmtStock = conn.prepareStatement(updateStockSql);
                pstmtStock.setInt(1, stockDelta);
                pstmtStock.setInt(2, retNum);
                pstmtStock.executeUpdate();
            }

            // 3. 교환 처리 시 기존 DELIVERY 레코드에 새 송장 번호 UPDATE 
            if (tp == 2 && courier != null && !courier.trim().isEmpty()) {
                String updateDlvSql = "UPDATE DELIVERY SET COURIER = ?, INVOICE_NO = ?, DLV_STATUS = 1 WHERE ORDER_NUM = ?";
                pstmtDlv = conn.prepareStatement(updateDlvSql);
                pstmtDlv.setString(1, courier);
                pstmtDlv.setString(2, invoiceNo);
                pstmtDlv.setInt(3, orderNum);
                pstmtDlv.executeUpdate();
            }

            conn.commit(); // 모든 연산 무사 통과 시 오라클 최종 저장!
            System.out.println("✅ [재고 동기화 완결] 구분: " + (tp==1?"반품":"교환") + " | 판정: " + processType + " | 이번 변동치: " + stockDelta);
            
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