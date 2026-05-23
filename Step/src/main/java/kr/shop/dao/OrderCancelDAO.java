package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;

public class OrderCancelDAO {
	
	private static OrderCancelDAO instance = new OrderCancelDAO();
	public static OrderCancelDAO getInstance() { return instance; }
	private OrderCancelDAO() {}

	public void cancelOrder(long orderNum, long userNum) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);

			// ✅ 1. 본인 주문 + 배송대기(status=1) 인지 검증
			String checkSql = "SELECT order_status, pay_price FROM orders "
			                + "WHERE order_num = ? AND user_num = ?";
			pstmt = conn.prepareStatement(checkSql);
			pstmt.setLong(1, orderNum);
			pstmt.setLong(2, userNum);
			rs = pstmt.executeQuery();

			if (!rs.next()) throw new Exception("존재하지 않는 주문입니다.");
			int status = rs.getInt("order_status");
			int payPrice = rs.getInt("pay_price"); // (추가)취소 시 금액 반영을 위한 금액 저장
			
			if (status != 1) throw new Exception("취소 가능한 상태가 아닙니다.");
			DBUtil.executeClose(rs, pstmt, null);

			// ✅ 2. ORDERS 상태 → 5(취소)
			String cancelOrderSql = "UPDATE orders SET order_status = 5 "
			                      + "WHERE order_num = ?";
			pstmt = conn.prepareStatement(cancelOrderSql);
			pstmt.setLong(1, orderNum);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// ✅ 3. PAYMENTS 취소 처리
			String cancelPaySql = "UPDATE payments "
			                    + "SET pay_status = 2, pay_canceled_at = SYSDATE "
			                    + "WHERE order_num = ?";
			pstmt = conn.prepareStatement(cancelPaySql);
			pstmt.setLong(1, orderNum);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// ✅ 4. 출고 내역 조회 (재고 복구용)
			String outSql = "SELECT opt_num, out_qty FROM outbound "
			              + "WHERE order_num = ? AND out_status = 1";
			pstmt = conn.prepareStatement(outSql);
			pstmt.setLong(1, orderNum);
			rs = pstmt.executeQuery();

			// opt_num, qty 목록 수집
			List<long[]> outList = new ArrayList<>();
			while (rs.next()) {
				outList.add(new long[]{rs.getLong("opt_num"), rs.getLong("out_qty")});
			}
			DBUtil.executeClose(rs, pstmt, null);

			// ✅ 5. 재고 복구 (출고됐던 수량만큼 STOCK에 다시 더하기)
			if (!outList.isEmpty()) {
				String restockSql = "UPDATE stock SET stock_qty = stock_qty + ?, "
				                  + "stock_updated_at = SYSDATE "
				                  + "WHERE opt_num = ?";
				for (long[] out : outList) {
					pstmt = conn.prepareStatement(restockSql);
					pstmt.setLong(1, out[1]); // out_qty
					pstmt.setLong(2, out[0]); // opt_num
					pstmt.executeUpdate();
					DBUtil.executeClose(null, pstmt, null);
				}

				// ✅ 6. OUTBOUND 출고 상태 → 0(취소)
				String cancelOutSql = "UPDATE outbound SET out_status = 0 "
				                    + "WHERE order_num = ? AND out_status = 1";
				pstmt = conn.prepareStatement(cancelOutSql);
				pstmt.setLong(1, orderNum);
				pstmt.executeUpdate();
				DBUtil.executeClose(null, pstmt, null);
			}

			// 7. 회원 누적 결제 금액 차감
			if (payPrice > 0) {
				String deductSql = "UPDATE users_detail SET total_amount = total_amount - ? WHERE user_num = ?";
				pstmt = conn.prepareStatement(deductSql);
				pstmt.setInt(1, payPrice);
				pstmt.setLong(2, userNum);
				pstmt.executeUpdate();
				DBUtil.executeClose(null, pstmt, null);
			}

			conn.commit();

		} catch (Exception e) {
			if (conn != null) conn.rollback();
			throw new Exception(e);
		} finally {
			if (conn != null) conn.setAutoCommit(true);
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}
}