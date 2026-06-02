package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import logis_vo.Log_OutVO;

public class Log_OutDAO {

    //출고 대기 목록
	public List<Log_OutVO> getPendingOutboundList(String keyword, String startDate, String endDate) throws Exception {
        List<Log_OutVO> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.ORDER_NUM, o.RECV_NAME, o.RECV_PHONE, o.RECV_ADDR1, o.RECV_ADDR2, ");
        sql.append("       o.ORDER_CREATED_AT, oi.ITEM_NUM, oi.ORDER_ITEM_QTY, ");
        sql.append("       p.PROD_NUM, p.SKU, p.PROD_NAME, po.OPT_NUM, po.SIZE_VAL, po.COLOR ");
        sql.append("FROM ORDERS o ");
        sql.append("JOIN ORDER_ITEMS oi ON o.ORDER_NUM = oi.ORDER_NUM ");
        sql.append("JOIN PRODUCTS p ON oi.PROD_NUM = p.PROD_NUM ");
        sql.append("JOIN PROD_OPTIONS po ON oi.OPT_NUM = po.OPT_NUM ");
        sql.append("WHERE o.ORDER_STATUS IN (1, 2) "); 
        
        sql.append("AND NOT EXISTS ( ");
        sql.append("    SELECT 1 FROM OUTBOUND ob ");
        sql.append("    WHERE ob.ORDER_NUM = oi.ORDER_NUM AND ob.OPT_NUM = oi.OPT_NUM ");
        sql.append(") ");
        sql.append("AND o.ORDER_CREATED_AT BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.PROD_NAME LIKE ? OR TO_CHAR(o.ORDER_NUM) LIKE ?) ");
        }
        sql.append("ORDER BY o.ORDER_CREATED_AT ASC");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            if (keyword != null && !keyword.trim().isEmpty()) {
                pstmt.setString(3, "%" + keyword + "%");
                pstmt.setString(4, "%" + keyword + "%");
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Log_OutVO vo = new Log_OutVO();
                vo.setOrderNum(rs.getInt("ORDER_NUM"));
                vo.setRecvName(rs.getString("RECV_NAME"));
                vo.setRecvPhone(rs.getString("RECV_PHONE"));
                vo.setRecvAddr1(rs.getString("RECV_ADDR1"));
                vo.setRecvAddr2(rs.getString("RECV_ADDR2"));
                vo.setOrderCreatedAt(rs.getString("ORDER_CREATED_AT"));
                vo.setItemNum(rs.getInt("ITEM_NUM"));
                vo.setOrderItemQty(rs.getInt("ORDER_ITEM_QTY"));
                vo.setProdNum(rs.getInt("PROD_NUM"));
                vo.setSku(rs.getString("SKU"));
                vo.setProdName(rs.getString("PROD_NAME"));
                vo.setOptNum(rs.getInt("OPT_NUM"));
                vo.setSizeVal(rs.getInt("SIZE_VAL"));
                vo.setColor(rs.getString("COLOR"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //단건 출고 처리 (OUTBOUND INSERT → 트리거가 STOCK 자동 차감)
    public void processOutbound(Log_OutVO vo) throws Exception {
        Connection conn = null; 
        PreparedStatement pstmt = null;
        PreparedStatement pstmtCheck = null;
        ResultSet rsCheck = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 🚨 트랜잭션 가동

            //OUTBOUND INSERT (개별 상품 단위이므로 몇 번을 실행해도 유니크 에러가 안 납니다)
            String outSql = "INSERT INTO OUTBOUND (OUT_NUM, ORDER_NUM, OPT_NUM, OUT_QTY, ADMIN_NUM, OUT_MEMO) "
                          + "VALUES (OUTBOUND_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(outSql);
            pstmt.setInt(1, vo.getOrderNum());
            pstmt.setInt(2, vo.getOptNum());
            pstmt.setInt(3, vo.getOrderItemQty());
            pstmt.setInt(4, vo.getAdminNum());
            pstmt.setString(5, vo.getOutMemo());
            pstmt.executeUpdate();
            pstmt.close();

            //DELIVERY 중복 검사 (해당 주문의 운송장이 이미 발행되었는지 테이블 실시간 카운트)
            String checkDlvSql = "SELECT COUNT(*) FROM DELIVERY WHERE ORDER_NUM = ?";
            pstmtCheck = conn.prepareStatement(checkDlvSql);
            pstmtCheck.setInt(1, vo.getOrderNum());
            rsCheck = pstmtCheck.executeQuery();
            
            boolean hasDelivery = false;
            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                hasDelivery = true;
            }
            rsCheck.close();
            pstmtCheck.close();

            if (!hasDelivery) {
                String dlvSql = "INSERT INTO DELIVERY (DLV_NUM, ORDER_NUM, COURIER, INVOICE_NO, DLV_STATUS) "
                              + "VALUES (DELIVERY_SEQ.NEXTVAL, ?, ?, ?, 1)";
                pstmt = conn.prepareStatement(dlvSql);
                pstmt.setInt(1, vo.getOrderNum());
                pstmt.setString(2, vo.getCourier() != null ? vo.getCourier() : "CJ대한통운");
                pstmt.setString(3, vo.getInvoiceNo());
                pstmt.executeUpdate();
                pstmt.close();
            }

            //ORDERS 상태 변경 (묶음 상품 중 마지막 남은 상품까지 창고에서 다 완전히 나갔을 때만 1 -> 2로 변환)
            String orderSql = "UPDATE ORDERS o SET o.ORDER_STATUS = 2 "
                            + "WHERE o.ORDER_NUM = ? "
                            + "  AND NOT EXISTS ( "
                            + "      SELECT 1 FROM ORDER_ITEMS oi "
                            + "      WHERE oi.ORDER_NUM = o.ORDER_NUM "
                            + "        AND oi.OPT_NUM NOT IN ( "
                            + "            SELECT ob.OPT_NUM FROM OUTBOUND ob WHERE ob.ORDER_NUM = o.ORDER_NUM "
                            + "        ) "
                            + "  )";
            pstmt = conn.prepareStatement(orderSql);
            pstmt.setInt(1, vo.getOrderNum());
            pstmt.executeUpdate();
            pstmt.close();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback(); 
            throw e;
        } finally {
            if (rsCheck != null) try { rsCheck.close(); } catch(Exception e) {}
            if (pstmtCheck != null) try { pstmtCheck.close(); } catch(Exception e) {}
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    //출고 이력 조회
    public List<Log_OutVO> getOutboundHistoryList(String histKeyword, String histStartDate, String histEndDate) throws Exception {
        List<Log_OutVO> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ob.OUT_NUM, ob.OUT_DATE, ob.OUT_QTY, ob.ADMIN_NUM, ");
        sql.append("       o.ORDER_NUM, o.RECV_NAME, ");
        sql.append("       p.SKU, p.PROD_NAME, po.SIZE_VAL, po.COLOR, ");
        sql.append("       d.COURIER, d.INVOICE_NO ");
        sql.append("FROM OUTBOUND ob ");
        sql.append("JOIN ORDERS o ON ob.ORDER_NUM = o.ORDER_NUM ");
        sql.append("JOIN PROD_OPTIONS po ON ob.OPT_NUM = po.OPT_NUM ");
        sql.append("JOIN PRODUCTS p ON po.PROD_NUM = p.PROD_NUM ");
        sql.append("JOIN DELIVERY d ON o.ORDER_NUM = d.ORDER_NUM ");
        sql.append("WHERE ob.OUT_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 0.99999 ");
        if (histKeyword != null && !histKeyword.trim().isEmpty()) {
            sql.append("AND (p.PROD_NAME LIKE ? OR TO_CHAR(o.ORDER_NUM) LIKE ?) ");
        }
        sql.append("ORDER BY ob.OUT_NUM DESC");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.setString(1, histStartDate);
            pstmt.setString(2, histEndDate);
            if (histKeyword != null && !histKeyword.trim().isEmpty()) {
                pstmt.setString(3, "%" + histKeyword + "%");
                pstmt.setString(4, "%" + histKeyword + "%");
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Log_OutVO vo = new Log_OutVO();
                vo.setOutNum(rs.getInt("OUT_NUM"));
                vo.setOutDate(rs.getString("OUT_DATE"));
                vo.setOrderItemQty(rs.getInt("OUT_QTY"));
                vo.setAdminNum(rs.getInt("ADMIN_NUM"));
                vo.setOrderNum(rs.getInt("ORDER_NUM"));
                vo.setRecvName(rs.getString("RECV_NAME"));
                vo.setSku(rs.getString("SKU"));
                vo.setProdName(rs.getString("PROD_NAME"));
                vo.setSizeVal(rs.getInt("SIZE_VAL"));
                vo.setColor(rs.getString("COLOR"));
                vo.setCourier(rs.getString("COURIER"));
                vo.setInvoiceNo(rs.getString("INVOICE_NO"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //일괄 출고 처리 (OUTBOUND INSERT → 트리거가 STOCK 자동 차감)
    public void processBulkOutbound(List<Log_OutVO> list) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtOut = null;
        PreparedStatement pstmtDlv = null;
        PreparedStatement pstmtOrd = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); 

            //OUTBOUND는 개별 상품이므로 무조건 INSERT
            String outSql   = "INSERT INTO OUTBOUND (OUT_NUM, ORDER_NUM, OPT_NUM, OUT_QTY, ADMIN_NUM, OUT_MEMO) "
                            + "VALUES (OUTBOUND_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
                            
            String dlvSql   = "INSERT INTO DELIVERY (DLV_NUM, ORDER_NUM, COURIER, INVOICE_NO, DLV_STATUS) "
                            + "SELECT DELIVERY_SEQ.NEXTVAL, ?, ?, ?, 1 FROM DUAL "
                            + "WHERE NOT EXISTS (SELECT 1 FROM DELIVERY WHERE ORDER_NUM = ?)";

            String orderSql = "UPDATE ORDERS o SET o.ORDER_STATUS = 2 "
                            + "WHERE o.ORDER_NUM = ? "
                            + "  AND NOT EXISTS ( "
                            + "      SELECT 1 FROM ORDER_ITEMS oi "
                            + "      WHERE oi.ORDER_NUM = o.ORDER_NUM "
                            + "        AND oi.OPT_NUM NOT IN ( "
                            + "            SELECT ob.OPT_NUM FROM OUTBOUND ob WHERE ob.ORDER_NUM = o.ORDER_NUM "
                            + "        ) "
                            + "  )";

            pstmtOut = conn.prepareStatement(outSql);
            pstmtDlv = conn.prepareStatement(dlvSql);
            pstmtOrd = conn.prepareStatement(orderSql);

            java.util.Set<Integer> processedOrders = new java.util.HashSet<>();
            java.util.Random random = new java.util.Random();
            String[] courierPool = {"CJ대한통운", "롯데택배", "한진택배", "우체국택배"};

            for (Log_OutVO vo : list) {
                // OUTBOUND
                pstmtOut.setInt(1, vo.getOrderNum());
                pstmtOut.setInt(2, vo.getOptNum());
                pstmtOut.setInt(3, vo.getOrderItemQty());
                pstmtOut.setInt(4, vo.getAdminNum());
                pstmtOut.setString(5, vo.getOutMemo());
                pstmtOut.addBatch();

                // DELIVERY 및 ORDERS
                if (!processedOrders.contains(vo.getOrderNum())) {
                    String courier = (vo.getCourier() != null && !vo.getCourier().trim().isEmpty()) ? vo.getCourier() : courierPool[random.nextInt(courierPool.length)];
                    
                    // 프리픽스 세팅
                    String prefix = "CJ";
                    if(courier.equals("롯데택배")) prefix = "LOTTE";
                    else if(courier.equals("한진택배")) prefix = "HJ";
                    else if(courier.equals("우체국택배")) prefix = "POST";
                    
                    String dateStr = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
                    String invoiceNo = (vo.getInvoiceNo() != null && !vo.getInvoiceNo().trim().isEmpty()) ? vo.getInvoiceNo() : prefix + "-" + dateStr + "-" + (random.nextInt(9000)+1000);

                    pstmtDlv.setInt(1, vo.getOrderNum());
                    pstmtDlv.setString(2, courier);
                    pstmtDlv.setString(3, invoiceNo);
                    pstmtDlv.setInt(4, vo.getOrderNum()); 
                    pstmtDlv.addBatch();

                    pstmtOrd.setInt(1, vo.getOrderNum());
                    pstmtOrd.addBatch();

                    processedOrders.add(vo.getOrderNum()); 
                }
            }

            pstmtOut.executeBatch();
            pstmtDlv.executeBatch();
            pstmtOrd.executeBatch();

            conn.commit(); 
            System.out.println("✅ [단건/일괄 통합 출고 완료] 오라클 DUAL 쿼리로 중복 에러 영구 차단!");
        } catch (Exception e) {
            if (conn != null) conn.rollback(); 
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmtOut, null);
            DBUtil.executeClose(null, pstmtDlv, null);
            DBUtil.executeClose(null, pstmtOrd, conn);
        }
    }

    //(OUTBOUND DELETE → 트리거가 STOCK 자동 복원)
    public void cancelOutbound(int outNum, int orderNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 가동

            String sql1 = "DELETE FROM OUTBOUND WHERE OUT_NUM = ?";
            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, outNum);
            pstmt1.executeUpdate();

            String sql2 = "DELETE FROM DELIVERY WHERE ORDER_NUM = ? "
                        + "  AND NOT EXISTS (SELECT 1 FROM OUTBOUND WHERE ORDER_NUM = ?)";
            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, orderNum);
            pstmt2.setInt(2, orderNum);
            pstmt2.executeUpdate();

            String sql3 = "UPDATE ORDERS SET ORDER_STATUS = 1 WHERE ORDER_NUM = ? "
                        + "  AND NOT EXISTS (SELECT 1 FROM OUTBOUND WHERE ORDER_NUM = ?)";
            pstmt3 = conn.prepareStatement(sql3);
            pstmt3.setInt(1, orderNum);
            pstmt3.setInt(2, orderNum);
            pstmt3.executeUpdate();

            conn.commit(); 
            System.out.println("✅ [개별 취소 완료] 출고번호: " + outNum + "번 단건 취소 및 주문 상태 동적 방어 성공!");
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmt1, null);
            DBUtil.executeClose(null, pstmt2, null);
            DBUtil.executeClose(null, pstmt3, conn);
        }
    }
    
 //상태별 주문 건수 카운트 (KPI 배송중/배송완료 실시간 연동용)
    public int getDeliveryStatusCount(int dlvStatus) throws Exception {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       
        String sql = "SELECT COUNT(*) FROM DELIVERY WHERE DLV_STATUS = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dlvStatus);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return count;
    }
    
}
