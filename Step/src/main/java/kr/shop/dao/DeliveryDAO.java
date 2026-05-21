package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class DeliveryDAO {
	private static DeliveryDAO instance = new DeliveryDAO();
	public static DeliveryDAO getInstance() { return instance; }
	private DeliveryDAO() {}

	// 배송 목록 조회 (상태별 필터)
	public List<Map<String, Object>> getDeliveryList(String status, String keyword) throws Exception {
		List<Map<String, Object>> list = new ArrayList<>();
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

		StringBuilder sql = new StringBuilder();
		sql.append("SELECT d.DLV_NUM, d.ORDER_NUM, d.COURIER, d.INVOICE_NO, ");
		sql.append("       d.DLV_STATUS, d.DLV_SHIPPED_AT, d.DLV_DONE_AT, ");
		sql.append("       o.USER_NUM, o.RECV_NAME, o.RECV_PHONE, ");
		sql.append("       o.RECV_ADDR1, o.RECV_ADDR2, o.PAY_PRICE, ");
		sql.append("       o.ORDER_CREATED_AT, o.ORDER_STATUS, ");
		sql.append("       ud.USER_NAME ");
		sql.append("FROM DELIVERY d ");
		sql.append("JOIN ORDERS o ON d.ORDER_NUM = o.ORDER_NUM ");
		sql.append("JOIN USERS_DETAIL ud ON o.USER_NUM = ud.USER_NUM ");
		sql.append("WHERE 1=1 ");
		if (status != null && !status.trim().isEmpty()) {
			sql.append("AND d.DLV_STATUS = ? ");
		}
		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append("AND (o.RECV_NAME LIKE ? OR d.INVOICE_NO LIKE ? OR TO_CHAR(d.ORDER_NUM) LIKE ?) ");
		}
		sql.append("ORDER BY d.DLV_NUM DESC");

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			int idx = 1;
			if (status != null && !status.trim().isEmpty())
				pstmt.setInt(idx++, Integer.parseInt(status));
			if (keyword != null && !keyword.trim().isEmpty()) {
				String kw = "%" + keyword + "%";
				pstmt.setString(idx++, kw);
				pstmt.setString(idx++, kw);
				pstmt.setString(idx++, kw);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("dlvNum",        rs.getInt("DLV_NUM"));
				map.put("orderNum",      rs.getInt("ORDER_NUM"));
				map.put("courier",       rs.getString("COURIER"));
				map.put("invoiceNo",     rs.getString("INVOICE_NO"));
				map.put("dlvStatus",     rs.getInt("DLV_STATUS"));
				map.put("dlvShippedAt",  rs.getString("DLV_SHIPPED_AT"));
				map.put("dlvDoneAt",     rs.getString("DLV_DONE_AT"));
				map.put("userNum",       rs.getInt("USER_NUM"));
				map.put("recvName",      rs.getString("RECV_NAME"));
				map.put("recvPhone",     rs.getString("RECV_PHONE"));
				map.put("recvAddr1",     rs.getString("RECV_ADDR1"));
				map.put("recvAddr2",     rs.getString("RECV_ADDR2"));
				map.put("payPrice",      rs.getInt("PAY_PRICE"));
				map.put("orderCreatedAt",rs.getString("ORDER_CREATED_AT"));
				map.put("orderStatus",   rs.getInt("ORDER_STATUS"));
				map.put("userName",      rs.getString("USER_NAME"));
				list.add(map);
			}
		} finally { DBUtil.executeClose(rs, pstmt, conn); }
		return list;
	}

	// 배송 상태별 건수
	public Map<String, Integer> getStatusCount() throws Exception {
		Map<String, Integer> map = new HashMap<>();
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		String sql = "SELECT DLV_STATUS, COUNT(*) AS CNT FROM DELIVERY GROUP BY DLV_STATUS";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			map.put("wait", 0); map.put("ready", 0);
			map.put("shipping", 0); map.put("done", 0); map.put("cancel", 0);
			while (rs.next()) {
				int st = rs.getInt("DLV_STATUS");
				int cnt = rs.getInt("CNT");
				if (st == 1) map.put("wait", cnt);
				else if (st == 2) map.put("ready", cnt);
				else if (st == 3) map.put("shipping", cnt);
				else if (st == 4) map.put("done", cnt);
				else if (st == 5) map.put("cancel", cnt);
			}
		} finally { DBUtil.executeClose(rs, pstmt, conn); }
		return map;
	}

	// 배송 상태 + 택배사/송장번호 업데이트
	public void updateDelivery(int dlvNum, int dlvStatus, String courier, String invoiceNo) throws Exception {
		Connection conn = null; PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			StringBuilder sql = new StringBuilder();
			sql.append("UPDATE DELIVERY SET DLV_STATUS = ?, COURIER = ?, INVOICE_NO = ? ");
			if (dlvStatus == 2) sql.append(", DLV_SHIPPED_AT = SYSDATE ");
			if (dlvStatus == 4) sql.append(", DLV_DONE_AT = SYSDATE ");
			sql.append("WHERE DLV_NUM = ?");

			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, dlvStatus);
			pstmt.setString(2, courier);
			pstmt.setString(3, invoiceNo);
			pstmt.setInt(4, dlvNum);
			pstmt.executeUpdate();
			pstmt.close();

			// ORDERS 상태도 동기화
			int orderStatus = dlvStatus; // 동일한 상태 코드 사용
			pstmt = conn.prepareStatement(
					"UPDATE ORDERS SET ORDER_STATUS = ? WHERE ORDER_NUM = " +
							"(SELECT ORDER_NUM FROM DELIVERY WHERE DLV_NUM = ?)"
					);
			pstmt.setInt(1, orderStatus);
			pstmt.setInt(2, dlvNum);
			pstmt.executeUpdate();

			conn.commit();
		} catch (Exception e) {
			if (conn != null) conn.rollback();
			throw e;
		} finally { DBUtil.executeClose(null, pstmt, conn); }
	}

	// 주문 취소 처리 (배송상태 5, 재고복구, 알림)
	public void cancelOrder(int dlvNum, int orderNum, int userNum) throws Exception {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			// 1. DELIVERY 상태 취소(5)로 변경
			pstmt = conn.prepareStatement(
					"UPDATE DELIVERY SET DLV_STATUS = 5 WHERE DLV_NUM = ?");
			pstmt.setInt(1, dlvNum);
			pstmt.executeUpdate();
			pstmt.close();

			// 2. ORDERS 상태 취소(5)로 변경 + 취소일시 기록
			pstmt = conn.prepareStatement(
					"UPDATE ORDERS SET ORDER_STATUS = 5, ORDER_DELETE_AT = SYSDATE WHERE ORDER_NUM = ?");
			pstmt.setInt(1, orderNum);
			pstmt.executeUpdate();
			pstmt.close();

			// 3. ORDER_ITEMS에서 상품/수량 조회 후 재고 복구
			pstmt = conn.prepareStatement(
					"SELECT OPT_NUM, ORDER_ITEM_QTY FROM ORDER_ITEMS WHERE ORDER_NUM = ?");
			pstmt.setInt(1, orderNum);
			rs = pstmt.executeQuery();

			List<int[]> items = new ArrayList<>();
			while (rs.next()) {
				items.add(new int[]{rs.getInt("OPT_NUM"), rs.getInt("ORDER_ITEM_QTY")});
			}
			rs.close();
			pstmt.close();

			// 재고 복구
			for (int[] item : items) {
				pstmt = conn.prepareStatement(
						"UPDATE STOCK SET STOCK_QTY = STOCK_QTY + ?, STOCK_UPDATED_AT = SYSDATE " +
						"WHERE OPT_NUM = ?");
				pstmt.setInt(1, item[1]);
				pstmt.setInt(2, item[0]);
				pstmt.executeUpdate();
				pstmt.close();
			}

			// 4. NOTIFY 알림 추가
			pstmt = conn.prepareStatement(
					"INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, " +
							"NOTIFY_CONTENT, REF_ID, READ_YN, NOTIFY_CREATED_AT) " +
							"VALUES (NOTIFY_SEQ.NEXTVAL, ?, 2, '주문이 취소되었습니다.', " +
					"'주문번호 ' || ? || '이 취소 처리되었습니다. 불편을 드려 죄송합니다.', ?, 'N', SYSDATE)");
			pstmt.setInt(1, userNum);
			pstmt.setInt(2, orderNum);
			pstmt.setInt(3, orderNum);
			pstmt.executeUpdate();

			conn.commit();
		} catch (Exception e) {
			if (conn != null) conn.rollback();
			throw e;
		} finally { DBUtil.executeClose(rs, pstmt, conn); }
	}

	// 주문 생성 시 DELIVERY 자동 생성
	public void createDelivery(int orderNum, Connection conn) throws Exception {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(
					"INSERT INTO DELIVERY (DLV_NUM, ORDER_NUM, DLV_STATUS) " +
					"VALUES (DELIVERY_SEQ.NEXTVAL, ?, 1)");
			pstmt.setInt(1, orderNum);
			pstmt.executeUpdate();
		} finally {
			if (pstmt != null) pstmt.close();
		}
	}

	public void cancelDeliveryByOrderNum(int orderNum) throws Exception {
		Connection conn = null; PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(
					"UPDATE DELIVERY SET DLV_STATUS = 5 WHERE ORDER_NUM = ?");
			pstmt.setInt(1, orderNum);
			pstmt.executeUpdate();
		} finally { DBUtil.executeClose(null, pstmt, conn); }
	}

	// 주문 상품 상세 조회
	public List<Map<String, Object>> getOrderItems(int orderNum) throws Exception {
		List<Map<String, Object>> list = new ArrayList<>();
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

		String sql = "SELECT oi.ITEM_NUM, oi.ORDER_ITEM_QTY, oi.ORDER_ITEM_PRICE, "
				+ "       p.PROD_NAME, p.PROD_PRICE, p.SALE_RATE, "
				+ "       b.BRAND_NAME, c.CAT_NAME, "
				+ "       po.SIZE_VAL, po.COLOR, "
				+ "       pi.PROD_IMG_URL "
				+ "FROM ORDER_ITEMS oi "
				+ "JOIN PRODUCTS p    ON oi.PROD_NUM = p.PROD_NUM "
				+ "JOIN PROD_OPTIONS po ON oi.OPT_NUM = po.OPT_NUM "
				+ "LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
				+ "LEFT JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM "
				+ "LEFT JOIN PROD_IMGS pi ON p.PROD_NUM = pi.PROD_NUM AND pi.IS_MAIN = 'Y' "
				+ "WHERE oi.ORDER_NUM = ? "
				+ "ORDER BY oi.ITEM_NUM ASC";

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, orderNum);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("itemNum",       rs.getInt("ITEM_NUM"));
				map.put("prodName",      rs.getString("PROD_NAME"));
				map.put("brandName",     rs.getString("BRAND_NAME"));
				map.put("catName",       rs.getString("CAT_NAME"));
				map.put("sizeVal",       rs.getInt("SIZE_VAL"));
				map.put("color",         rs.getString("COLOR"));
				map.put("qty",           rs.getInt("ORDER_ITEM_QTY"));
				map.put("itemPrice",     rs.getInt("ORDER_ITEM_PRICE"));
				map.put("prodImgUrl",    rs.getString("PROD_IMG_URL"));
				list.add(map);
			}
		} finally { DBUtil.executeClose(rs, pstmt, conn); }
		return list;
	}
	// 주문번호로 배송번호(dlvNum) 조회
	public int getDlvNumByOrderNum(int orderNum) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int dlvNum = 0;
	    
	    try {
	        conn = DBUtil.getConnection();
	        String sql = "SELECT DLV_NUM FROM DELIVERY WHERE ORDER_NUM = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, orderNum);
	        rs = pstmt.executeQuery();
	        if (rs.next()) dlvNum = rs.getInt("DLV_NUM");
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return dlvNum;
	}
}


















