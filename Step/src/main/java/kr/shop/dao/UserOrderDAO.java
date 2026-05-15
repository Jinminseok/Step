package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import kr.util.DBUtil;

public class UserOrderDAO {
	// 싱글턴 패턴
	private static UserOrderDAO instance = new UserOrderDAO();
	public static UserOrderDAO getInstance() {
		return instance;
	}
	private UserOrderDAO() {}

	// 주문 처리
	public void processOrder(Long userNum, int totalPrice, String recvName, String recvPhone, 
                             String recvZip, String recvAddr1, String recvAddr2, 
                             String[] cartNums, String payMethod) throws Exception {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Long orderNum = 0L;

		try {
			conn = DBUtil.getConnection();
			// 오토커밋 해제
			conn.setAutoCommit(false); 

			// 새 주문번호 발급받기
			pstmt = conn.prepareStatement("SELECT orders_seq.nextval FROM DUAL");
			rs = pstmt.executeQuery();
			if (rs.next()) orderNum = rs.getLong(1);
			DBUtil.executeClose(rs, pstmt, null);

			// 주문 정보 추가
			String sql1 = "INSERT INTO orders (order_num, user_num, total_price, pay_price, recv_name, recv_phone, recv_zip, recv_addr1, recv_addr2, order_status) "
					    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setLong(1, orderNum);
			pstmt.setLong(2, userNum);
			pstmt.setInt(3, totalPrice);
			pstmt.setInt(4, totalPrice);
			pstmt.setString(5, recvName);
			pstmt.setString(6, recvPhone);
			pstmt.setString(7, recvZip);
			pstmt.setString(8, recvAddr1);
			pstmt.setString(9, recvAddr2);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// 동적 쿼리를 위한 세팅
			String placeholders = "";
			for(int i=0; i<cartNums.length; i++) {
				placeholders += "?";
				if(i < cartNums.length) placeholders += ",";
			}

			// 주문 테이블에 상세 정보 추가
			String sql2 = "INSERT INTO order_items (item_num, order_num, prod_num, opt_num, order_item_qty, order_item_price) "
					    + "SELECT order_items_seq.nextval, ?, o.prod_num, c.opt_num, c.cart_qty, p.prod_price "
					    + "FROM cart c "
					    + "JOIN prod_options o ON c.opt_num = o.opt_num "
					    + "JOIN products p ON o.prod_num = p.prod_num "
					    + "WHERE c.cart_num IN (" + placeholders + ")";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setLong(1, orderNum);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(i + 2, Long.parseLong(cartNums[i]));
			}
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// 재고 차감 - 장바구니 개수만큼 반복 차감
			String sql3 = "UPDATE stock s SET stock_qty = stock_qty - "
					    + "(SELECT cart_qty FROM cart c WHERE c.opt_num = s.opt_num AND c.cart_num = ?) "
					    + "WHERE s.opt_num = (SELECT opt_num FROM cart WHERE cart_num = ?)";
			pstmt = conn.prepareStatement(sql3);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(1, Long.parseLong(cartNums[i]));
				pstmt.setLong(2, Long.parseLong(cartNums[i]));
				pstmt.executeUpdate();
			}
			DBUtil.executeClose(null, pstmt, null);

			// 테이블에 결제 내역 추가
			String sql4 = "INSERT INTO payments (pay_num, order_num, method, amount, pay_status) VALUES (payments_seq.nextval, ?, ?, ?, 1)";
			pstmt = conn.prepareStatement(sql4);
			pstmt.setLong(1, orderNum);
			pstmt.setString(2, payMethod);
			pstmt.setInt(3, totalPrice);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// 장바구니 목록 비우기
			String sql5 = "DELETE FROM cart WHERE cart_num IN (" + placeholders + ")";
			pstmt = conn.prepareStatement(sql5);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(i + 1, Long.parseLong(cartNums[i]));
			}
			pstmt.executeUpdate();

			// 전부 실행되면 커밋
			conn.commit();

		} catch (Exception e) {
			// 하나라도 실패하면 롤백
			if (conn != null) conn.rollback(); 
			throw new Exception(e);
		} finally {
			// 커밋 상태 원상 복구
			if (conn != null) conn.setAutoCommit(true);
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}
}