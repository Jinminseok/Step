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

 //쇼핑몰 관리자가 처리를 완료하여 '물류 창고'에 실물이 도착한 대기 목록 조회
    public List<Log_ReturnVO> getClaimWaitList() throws Exception {
        List<Log_ReturnVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT r.RET_NUM, r.ORDER_NUM, r.PROD_NUM, r.OPT_NUM, r.USER_NUM, r.TP, r.REASON, r.RET_NOTE, r.RET_STATUS, "
                + "       DECODE(r.IS_GOOD, 1, '양품', 2, '불량', '상태미상') AS IS_GOOD_STR, "
                + "       p.PROD_NAME AS PROD_NAME, po.SIZE_VAL AS SIZE_VAL, po.COLOR AS COLOR, "
                + "       o.RECV_NAME AS RECV_NAME, o.RECV_PHONE AS RECV_PHONE, (o.RECV_ADDR1 || ' ' || o.RECV_ADDR2) AS RECV_ADDR "
                + "FROM RETURNS r "
                + "JOIN ORDERS o ON r.ORDER_NUM = o.ORDER_NUM "
                + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                + "JOIN PROD_OPTIONS po ON r.OPT_NUM = po.OPT_NUM "
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
             vo.setTp(rs.getInt("TP"));
             vo.setReason(rs.getString("REASON"));
             vo.setRet_note(rs.getString("RET_NOTE"));
             vo.setIs_good_str(rs.getString("IS_GOOD_STR")); 
             vo.setProd_name(rs.getString("PROD_NAME"));
             
             
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

    //물류 관리자가 최종 완결 지은 이력 목록 조회 (양품/불량 텍스트 직접 매핑)
    public List<Log_ReturnVO> getClaimHistoryList() throws Exception {
        List<Log_ReturnVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
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
                vo.setReason(rs.getString("PROC_TYPE")); 
                vo.setInvoice_no(rs.getString("INVOICE_NO"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //[3] 반품/교환 최종 검수 처리 트랜잭션
    public void processClaimTransaction(int retNum, int orderNum, int tp, String processType, 
            String courier, String invoiceNo, String adminMemo, 
            String exColor, String exSize) throws Exception {
			Connection conn = null;
			PreparedStatement pstmtRet = null;
			PreparedStatement pstmtStockOrig = null; // 기존 회수 상품(A상품) 재고 처리용
			PreparedStatement pstmtStockNew = null;  // 신규 출고 교환 상품(B상품) 재고 처리용
			PreparedStatement pstmtDlv = null;
			
			try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false); // 락 발동 (트랜잭션 시작)
			
			// 양품복구면 완결상태 4, 불량폐기면 완결상태 5
			int nextStatus = "RECOVERY".equals(processType) ? 4 : 5;
			
			String systemMemo = adminMemo;
			if (tp == 2 && exColor != null && exSize != null && !exColor.isEmpty() && !exSize.isEmpty()) {
			String token = "[EX_OPT:COLOR=" + exColor.trim().toUpperCase() + ":SIZE=" + exSize.trim() + "]";
			if (adminMemo == null || adminMemo.trim().isEmpty()) {
			systemMemo = token;
			} else {
			systemMemo = adminMemo.trim() + " " + token;
			}
			}
			
			// 1. RETURNS 테이블 상태 변경 및 메모 실시간 스왑
			String updateRetSql = "UPDATE RETURNS SET RET_STATUS = ?, "
			   + "       RET_NOTE = CASE WHEN ? IS NULL OR TRIM(?) = '' THEN "
			   + "                     TRIM(TRAILING CHR(10) FROM CASE WHEN INSTR(RET_NOTE, CHR(10)) > 0 THEN SUBSTR(RET_NOTE, 1, INSTR(RET_NOTE, CHR(10)) - 1) ELSE RET_NOTE END) "
			   + "                  ELSE "
			   + "                     TRIM(TRAILING CHR(10) FROM CASE WHEN INSTR(RET_NOTE, CHR(10)) > 0 THEN SUBSTR(RET_NOTE, 1, INSTR(RET_NOTE, CHR(10)) - 1) ELSE RET_NOTE END) || CHR(10) || ? "
			   + "                  END "
			   + "WHERE RET_NUM = ?";
			   
			pstmtRet = conn.prepareStatement(updateRetSql);
			pstmtRet.setInt(1, nextStatus);
			pstmtRet.setString(2, systemMemo); 
			pstmtRet.setString(3, systemMemo); 
			pstmtRet.setString(4, systemMemo); 
			pstmtRet.setInt(5, retNum); 
			pstmtRet.executeUpdate();

			//[재고 관리 코어 로직] 회수 상품 및 발송 상품의 교차 재고 타격

			if (tp == 1) { 
			int stockDelta = "RECOVERY".equals(processType) ? 1 : 0;
			if (stockDelta != 0) {
			String updateStockSql = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
			             + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
			pstmtStockOrig = conn.prepareStatement(updateStockSql);
			pstmtStockOrig.setInt(1, stockDelta);
			pstmtStockOrig.setInt(2, retNum);
			pstmtStockOrig.executeUpdate();
			}
			} else if (tp == 2) { 
			
			if ("RECOVERY".equals(processType)) {
			String sqlOrigStock = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + 1 "
			            + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
			pstmtStockOrig = conn.prepareStatement(sqlOrigStock);
			pstmtStockOrig.setInt(1, retNum);
			pstmtStockOrig.executeUpdate();
			}
			
			//모달창에서 물류 관리자가 '새로 선택한 옵션' 상품(B상품)의 창고 재고 차감 (-1)
			if (exColor != null && exSize != null && !exColor.isEmpty() && !exSize.isEmpty()) {
			String sqlNewStock = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY - 1 "
			           + "WHERE OPT_NUM = ( "
			           + "    SELECT po.OPT_NUM FROM PROD_OPTIONS po "
			           + "    WHERE po.PROD_NUM = (SELECT r.PROD_NUM FROM RETURNS r WHERE r.RET_NUM = ?) "
			           + "      AND UPPER(po.COLOR) = UPPER(?) "
			           + "      AND po.SIZE_VAL = ? "
			           + ")";
			pstmtStockNew = conn.prepareStatement(sqlNewStock);
			pstmtStockNew.setInt(1, retNum);
			pstmtStockNew.setString(2, exColor.trim());
			pstmtStockNew.setString(3, exSize.trim());
			pstmtStockNew.executeUpdate();
			}
			}
			
			// 3. DELIVERY 테이블에 가출고 배송 정보 업데이트
			if (tp == 2 && courier != null && !courier.trim().isEmpty()) {
			String updateDlvSql = "UPDATE DELIVERY SET COURIER = ?, INVOICE_NO = ?, DLV_STATUS = 1 WHERE ORDER_NUM = ?";
			pstmtDlv = conn.prepareStatement(updateDlvSql);
			pstmtDlv.setString(1, courier);
			pstmtDlv.setString(2, invoiceNo);
			pstmtDlv.setInt(3, orderNum); 
			pstmtDlv.executeUpdate();
			}
			
			conn.commit(); // 모든 물류 연산 깔끔하게 완결 커밋!
			System.out.println("🚀 [WMS] 접수번호 " + retNum + "번 교환 옵션 변동 및 실재고 연산 최종 완료!");
			
			} catch (Exception e) {
			if (conn != null) conn.rollback();
			throw e;
			} finally {
			DBUtil.executeClose(null, pstmtRet, null);
			DBUtil.executeClose(null, pstmtStockOrig, null);
			DBUtil.executeClose(null, pstmtStockNew, null);
			DBUtil.executeClose(null, pstmtDlv, conn);
			}
			}
    
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
    
    //처리 완료 건 취소 및 재고 원상복구 트랜잭션 (핵심 정밀 수식) ──
    public void cancelClaimTransaction(int retNum, int orderNum, int tp, int currentStatus) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtRet = null;
        PreparedStatement pstmtStockOrig = null; // 기존 반납 상품(A상품) 재고 되감기용
        PreparedStatement pstmtStockNew = null;  // 신규 교환 출고 상품(B상품) 재고 되감기용
        PreparedStatement pstmtDlv = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 락 발동 (원자성 트랜잭션 시작)

            String sqlRet = "UPDATE RETURNS SET RET_STATUS = 3 WHERE RET_NUM = ?";
            pstmtRet = conn.prepareStatement(sqlRet);
            pstmtRet.setInt(1, retNum);
            pstmtRet.executeUpdate();

            if (tp == 1) { 
                int rollbackStockDelta = (currentStatus == 4) ? -1 : 0;
                
                if (rollbackStockDelta != 0) {
                    String sqlStock = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
                                    + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
                    pstmtStockOrig = conn.prepareStatement(sqlStock);
                    pstmtStockOrig.setInt(1, rollbackStockDelta);
                    pstmtStockOrig.setInt(2, retNum);
                    pstmtStockOrig.executeUpdate();
                }
                
            } else if (tp == 2) { 
                
                //원래 고객이 주문했던 기존 반납 상품(A상품 - 원래 신발) 재고 되감기
                int origDelta = 0;
                
                if (currentStatus == 4) {
                    //취소할 때는 다시 장부에서 -1을 타격하여 원래 대기 상태인 7개로 정확히 롤백
                    origDelta = -1;
                } else if (currentStatus == 5) {
                    // 취소할 때는 고객에게 실물을 쥐어 보내기 위해 장부에서 강력하게 -1을 깎아서 최종 6개로 롤백
                    origDelta = -1; 
                }
                
                // A상품 재고 깎기 실행
                String sqlStockOrig = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ? "
                                    + "WHERE OPT_NUM = (SELECT OPT_NUM FROM RETURNS WHERE RET_NUM = ?)";
                pstmtStockOrig = conn.prepareStatement(sqlStockOrig);
                pstmtStockOrig.setInt(1, origDelta);
                pstmtStockOrig.setInt(2, retNum);
                pstmtStockOrig.executeUpdate();

                //새로 선택해서 출고시켰던 '새 교환 상품(B상품 - 바꾼 신발)' 재고 복구 (+1)
                String sqlStockNewClean = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + 1 "
                        + "WHERE OPT_NUM = ( "
                        + "    SELECT po.OPT_NUM FROM PROD_OPTIONS po "
                        + "    WHERE po.PROD_NUM = (SELECT r.PROD_NUM FROM RETURNS r WHERE r.RET_NUM = ?) "
                        + "      AND (SELECT UPPER(REPLACE(r2.RET_NOTE, ' ', '')) FROM RETURNS r2 WHERE r2.RET_NUM = ?) "
                        + "          LIKE '%[EX_OPT:COLOR=' || UPPER(REPLACE(po.COLOR, ' ', '')) || ':SIZE=' || UPPER(REPLACE(po.SIZE_VAL, ' ', '')) || ']%' "
                        + ")";

                pstmtStockNew = conn.prepareStatement(sqlStockNewClean);
                pstmtStockNew.setInt(1, retNum);
                pstmtStockNew.setInt(2, retNum);
                
                int resultRows = pstmtStockNew.executeUpdate();
                System.out.println("🎯 [WMS 디버깅] 고유 토큰 추적 -> 새 교환 상품(B상품) 재고 +1 복구 완료 로우 수: " + resultRows + "건");
            }


            // 3. 교환용으로 가출고 잡아서 업데이트했던 운송장 장부 초기화 (NULL 패스)
            if (tp == 2) {
                String sqlDlv = "UPDATE DELIVERY SET COURIER = NULL, INVOICE_NO = NULL, DLV_STATUS = 0 WHERE ORDER_NUM = ?";
                pstmtDlv = conn.prepareStatement(sqlDlv);
                pstmtDlv.setInt(1, orderNum);
                pstmtDlv.executeUpdate();
            }

            conn.commit(); // 모든 물류 역연산 트랜잭션 정상 완결 커밋!
            System.out.println("🔄 [WMS 완결] 접수번호 " + retNum + "번 클레임 관련 모든 자산 완벽하게 원상복구 완료!");
            
        } catch (Exception e) {
            if (conn != null) conn.rollback(); // 단 하나의 쿼리라도 삐끗하면 전체 롤백 방어막
            throw e;
        } finally {
            // 이클립스 DB 커넥션 자원 누수 완전 차단
            DBUtil.executeClose(null, pstmtRet, null);
            DBUtil.executeClose(null, pstmtStockOrig, null);
            DBUtil.executeClose(null, pstmtStockNew, null);
            DBUtil.executeClose(null, pstmtDlv, conn);
        }
    }

    // 파라미터 유틸 헬퍼 (반복 바인딩 예방 코드)
    private void pstmtNumParam(PreparedStatement pstmt, int idx, int val) throws Exception {
        pstmt.setInt(idx, val);
    }
    
    // 특정 상품의 가용 재고(STOCK_QTY > 0)가 존재하는 옵션 목록 실시간 조회
    public List<Log_ReturnVO> getAvailableOptions(int prodNum) throws Exception {
        List<Log_ReturnVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        //재고 수량(STOCK_QTY)이 최소 1개 이상 남아 있는 색상과 사이즈 조합만 실시간 추출
        String sql = "SELECT po.OPT_NUM, po.COLOR, po.SIZE_VAL, s.STOCK_QTY "
                   + "FROM PROD_OPTIONS po "
                   + "JOIN STOCK s ON po.OPT_NUM = s.OPT_NUM "
                   + "WHERE po.PROD_NUM = ? AND s.STOCK_QTY > 0 "
                   + "ORDER BY po.COLOR ASC, TO_NUMBER(po.SIZE_VAL) ASC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, prodNum);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                Log_ReturnVO vo = new Log_ReturnVO();
   
                vo.setOpt_num(rs.getInt("OPT_NUM")); // 필요시 대비 옵션번호 확보
                vo.setColor(rs.getString("COLOR"));
                vo.setSize_val(rs.getString("SIZE_VAL"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
    
    
}