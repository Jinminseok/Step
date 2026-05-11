package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import logis_vo.Log_OutVO;

public class Log_OutDAO {

    // ── 1. 출고 대기 목록 ─────────────────────────────────────────────────
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
        sql.append("WHERE o.ORDER_STATUS = 1 ");
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

    // ── 2. 단건 출고 처리 (OUTBOUND INSERT → 트리거가 STOCK 자동 차감) ──────
    public void processOutbound(Log_OutVO vo) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // [A] OUTBOUND INSERT (트리거 TRG_OUTBOUND_INSERT가 STOCK 자동 차감)
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

            // [B] DELIVERY INSERT
            String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
            int randNum = (int)(Math.random() * 9000) + 1000;
            String fakeInvoice = (vo.getCourier() != null ? vo.getCourier() : "CJ") + "-" + dateStr + "-" + randNum;
            String dlvSql = "INSERT INTO DELIVERY (DLV_NUM, ORDER_NUM, COURIER, INVOICE_NO, DLV_STATUS) "
                          + "VALUES (DELIVERY_SEQ.NEXTVAL, ?, ?, ?, 1)";
            pstmt = conn.prepareStatement(dlvSql);
            pstmt.setInt(1, vo.getOrderNum());
            pstmt.setString(2, vo.getCourier() != null ? vo.getCourier() : "CJ대한통운");
            pstmt.setString(3, fakeInvoice);
            pstmt.executeUpdate();
            pstmt.close();

            // [C] ORDERS 상태 변경 (1 → 2)
            String orderSql = "UPDATE ORDERS SET ORDER_STATUS = 2 WHERE ORDER_NUM = ?";
            pstmt = conn.prepareStatement(orderSql);
            pstmt.setInt(1, vo.getOrderNum());
            pstmt.executeUpdate();
            pstmt.close();

            // ← STOCK 처리 불필요: TRG_OUTBOUND_INSERT 트리거가 자동 처리

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    // ── 3. 출고 이력 조회 ──────────────────────────────────────────────────
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

    // ── 4. 일괄 출고 처리 (OUTBOUND INSERT → 트리거가 STOCK 자동 차감) ──────
    public void processBulkOutbound(List<Log_OutVO> list) throws Exception {
        Connection conn = null;
        PreparedStatement pstmtOut = null;
        PreparedStatement pstmtDlv = null;
        PreparedStatement pstmtOrd = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String outSql   = "INSERT INTO OUTBOUND (OUT_NUM, ORDER_NUM, OPT_NUM, OUT_QTY, ADMIN_NUM, OUT_MEMO) "
                            + "VALUES (OUTBOUND_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
            String dlvSql   = "INSERT INTO DELIVERY (DLV_NUM, ORDER_NUM, COURIER, INVOICE_NO, DLV_STATUS) "
                            + "VALUES (DELIVERY_SEQ.NEXTVAL, ?, ?, ?, 1)";
            String orderSql = "UPDATE ORDERS SET ORDER_STATUS = 2 WHERE ORDER_NUM = ?";

            pstmtOut = conn.prepareStatement(outSql);
            pstmtDlv = conn.prepareStatement(dlvSql);
            pstmtOrd = conn.prepareStatement(orderSql);

            String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

            for (Log_OutVO vo : list) {
                // [A] OUTBOUND (트리거 TRG_OUTBOUND_INSERT가 STOCK 자동 차감)
                pstmtOut.setInt(1, vo.getOrderNum());
                pstmtOut.setInt(2, vo.getOptNum());
                pstmtOut.setInt(3, vo.getOrderItemQty());
                pstmtOut.setInt(4, vo.getAdminNum());
                pstmtOut.setString(5, vo.getOutMemo());
                pstmtOut.addBatch();

                // [B] DELIVERY
                int randNum = (int)(Math.random() * 9000) + 1000;
                String courier     = (vo.getCourier()   != null) ? vo.getCourier()   : "CJ대한통운";
                String fakeInvoice = (vo.getInvoiceNo() != null) ? vo.getInvoiceNo() : ("CJ-" + dateStr + "-" + randNum);
                pstmtDlv.setInt(1, vo.getOrderNum());
                pstmtDlv.setString(2, courier);
                pstmtDlv.setString(3, fakeInvoice);
                pstmtDlv.addBatch();

                // [C] ORDERS 상태 변경
                pstmtOrd.setInt(1, vo.getOrderNum());
                pstmtOrd.addBatch();

                // ← STOCK 처리 불필요: TRG_OUTBOUND_INSERT 트리거가 자동 처리
            }

            pstmtOut.executeBatch();
            pstmtDlv.executeBatch();
            pstmtOrd.executeBatch();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmtOut, null);
            DBUtil.executeClose(null, pstmtDlv, null);
            DBUtil.executeClose(null, pstmtOrd, conn);
        }
    }

    // ── 5. 출고 취소 (OUTBOUND DELETE → 트리거가 STOCK 자동 복원) ───────────
    public void cancelOutbound(int outNum, int orderNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. OUTBOUND 삭제 (트리거 TRG_OUTBOUND_DELETE가 STOCK 자동 복원)
            String sql1 = "DELETE FROM OUTBOUND WHERE OUT_NUM = ?";
            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, outNum);
            pstmt1.executeUpdate();

            // 2. DELIVERY 삭제
            String sql2 = "DELETE FROM DELIVERY WHERE ORDER_NUM = ?";
            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, orderNum);
            pstmt2.executeUpdate();

            // 3. ORDERS 상태 롤백 (2 → 1)
            String sql3 = "UPDATE ORDERS SET ORDER_STATUS = 1 WHERE ORDER_NUM = ?";
            pstmt3 = conn.prepareStatement(sql3);
            pstmt3.setInt(1, orderNum);
            pstmt3.executeUpdate();

            // ← STOCK 복원 불필요: TRG_OUTBOUND_DELETE 트리거가 자동 처리

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmt1, null);
            DBUtil.executeClose(null, pstmt2, null);
            DBUtil.executeClose(null, pstmt3, conn);
        }
    }
}
