package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminOrderVO;
import kr.util.DBUtil;

public class Log_ReturnDAO {
    // 싱글톤 패턴
    private static Log_ReturnDAO instance = new Log_ReturnDAO();
    public static Log_ReturnDAO getInstance() { return instance; }
    private Log_ReturnDAO() {}

    // ── 🌟 1. [검수 대기] 목록 가져오기 (RET_STATUS = 2: 수거진행/도착완료 상태) ──
    public List<AdminOrderVO> getWaitList() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AdminOrderVO> list = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();            

            String sql = "SELECT r.*, p.PROD_NAME, "
                    + "(SELECT SIZE_VAL || ' / ' || COLOR FROM PROD_OPTIONS WHERE OPT_NUM = r.OPT_NUM) AS OPT_INFO, "
                    + "(SELECT ORDER_ITEM_QTY FROM ORDER_ITEMS WHERE ORDER_NUM = r.ORDER_NUM AND PROD_NUM = r.PROD_NUM AND OPT_NUM = r.OPT_NUM AND ROWNUM = 1) AS QTY "
                    + "FROM RETURNS r "
                    + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                    + "WHERE r.RET_STATUS = 2 "
                    + "ORDER BY r.RET_NUM ASC";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AdminOrderVO item = new AdminOrderVO();
                item.setRet_num(rs.getInt("RET_NUM"));
                item.setOrder_num(rs.getInt("ORDER_NUM"));
                item.setTp(rs.getInt("TP"));
                item.setProd_name(rs.getString("PROD_NAME"));
                item.setReason(rs.getString("REASON"));
                item.setOpt_num(rs.getInt("OPT_NUM"));
                item.setRet_created_at(rs.getDate("RET_CREATED_AT"));
                
                // VO에 새로 추가가 필요한 임시 변수들 (Action에서 map으로 넘기거나 VO에 추가 필요)
                item.setOpt_info(rs.getString("OPT_INFO")); // 옵션명(사이즈)
                item.setQty(rs.getInt("QTY"));              // 수량
                
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ── 🌟 2. [처리 내역] 목록 가져오기 (RET_STATUS = 3: 물류 처리완료 상태) ──
    public List<AdminOrderVO> getHistList() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AdminOrderVO> list = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT r.*, p.PROD_NAME, "
                    + "(SELECT SIZE_VAL || ' / ' || COLOR FROM PROD_OPTIONS WHERE OPT_NUM = r.OPT_NUM) AS OPT_INFO, "
                    + "(SELECT ORDER_ITEM_QTY FROM ORDER_ITEMS WHERE ORDER_NUM = r.ORDER_NUM AND PROD_NUM = r.PROD_NUM AND OPT_NUM = r.OPT_NUM AND ROWNUM = 1) AS QTY "
                    + "FROM RETURNS r "
                    + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                    + "WHERE r.RET_STATUS = 3 "
                    + "ORDER BY r.RET_UPDATED_AT DESC";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AdminOrderVO item = new AdminOrderVO();
                item.setRet_num(rs.getInt("RET_NUM"));
                item.setOrder_num(rs.getInt("ORDER_NUM"));
                item.setTp(rs.getInt("TP"));
                item.setProd_name(rs.getString("PROD_NAME"));
                item.setOpt_num(rs.getInt("OPT_NUM"));
                item.setIs_good(rs.getInt("IS_GOOD"));
                item.setRet_updated_at(rs.getDate("RET_UPDATED_AT"));
                
                item.setOpt_info(rs.getString("OPT_INFO")); 
                item.setQty(rs.getInt("QTY")); 
                
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ── 🌟 3. [반품 실물 검수 확정] 상태 변경 및 재고 복구 (트랜잭션 적용) ──
    public void processReturnStock(int retNum, int isGood, int qty, int optNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtStatus = null;
        PreparedStatement pstmtStock = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 🚨 트랜잭션 시작 (둘 중 하나라도 실패하면 롤백)

            // 1. 반품 상태 업데이트 (처리완료: 3, 검수결과 기록)
            String sqlStatus = "UPDATE RETURNS SET RET_STATUS = 3, IS_GOOD = ?, RET_UPDATED_AT = SYSDATE WHERE RET_NUM = ?";
            pstmtStatus = conn.prepareStatement(sqlStatus);
            pstmtStatus.setInt(1, isGood);
            pstmtStatus.setInt(2, retNum);
            pstmtStatus.executeUpdate();

            // 2. 양품(1) 판정 시에만 STOCK 테이블의 재고(STOCK_QTY)를 플러스 복구!
            if (isGood == 1) {
                String sqlStock = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ?, STOCK_UPDATED_AT = SYSDATE WHERE OPT_NUM = ?"; 
                pstmtStock = conn.prepareStatement(sqlStock);
                pstmtStock.setInt(1, qty);
                pstmtStock.setInt(2, optNum);
                pstmtStock.executeUpdate();
            }

            conn.commit(); // 🚨 모든 작업이 성공하면 확정
        } catch (Exception e) {
            if (conn != null) conn.rollback(); // 에러 나면 재고 원상복구
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(null, pstmtStock, null);
            DBUtil.executeClose(null, pstmtStatus, conn);
        }
    }

    // ── 🌟 4. [교환 실물 검수 확정] 상태 변경 및 구/신 재고 조절 (트랜잭션 적용) ──
    public void processExchangeStock(int retNum, int isGood, int qty, int oldOptNum, int newOptNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtStatus = null;
        PreparedStatement pstmtOldStock = null;
        PreparedStatement pstmtNewStock = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 🚨 트랜잭션 시작

            // 1. 교환 상태 업데이트
            String sqlStatus = "UPDATE RETURNS SET RET_STATUS = 3, IS_GOOD = ?, RET_UPDATED_AT = SYSDATE WHERE RET_NUM = ?";
            pstmtStatus = conn.prepareStatement(sqlStatus);
            pstmtStatus.setInt(1, isGood);
            pstmtStatus.setInt(2, retNum);
            pstmtStatus.executeUpdate();

            // 2. 회수한 헌 상품이 양품(1)이면 기존 옵션 재고(STOCK_QTY) 플러스 복구
            if (isGood == 1) {
                String sqlOld = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ?, STOCK_UPDATED_AT = SYSDATE WHERE OPT_NUM = ?";
                pstmtOldStock = conn.prepareStatement(sqlOld);
                pstmtOldStock.setInt(1, qty);
                pstmtOldStock.setInt(2, oldOptNum);
                pstmtOldStock.executeUpdate();
            }

            // 3. 내보낼 새 상품 옵션 재고 마이너스 삭감! (교환 출고)
            if (newOptNum > 0) { // 새 옵션 번호가 정상적으로 들어왔을 때
                String sqlNew = "UPDATE STOCK SET STOCK_QTY = STOCK_QTY - ?, STOCK_UPDATED_AT = SYSDATE WHERE OPT_NUM = ?";
                pstmtNewStock = conn.prepareStatement(sqlNew);
                pstmtNewStock.setInt(1, qty);
                pstmtNewStock.setInt(2, newOptNum);
                pstmtNewStock.executeUpdate();
            }

            conn.commit(); // 🚨 확정
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(null, pstmtNewStock, null);
            DBUtil.executeClose(null, pstmtOldStock, null);
            DBUtil.executeClose(null, pstmtStatus, conn);
        }
    }
}