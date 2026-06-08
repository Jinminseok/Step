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
	public void processOrder(Long userNum, int totalPrice, int discPrice, int payPrice, String recvName, String recvPhone, 
                             String recvZip, String recvAddr1, String recvAddr2, 
                             String[] cartNums, String payMethod, String tid) throws Exception {
		
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
			String sql1 = "INSERT INTO orders (order_num, user_num, total_price, disc_price, pay_price, recv_name, recv_phone, recv_zip, recv_addr1, recv_addr2, order_status) "
					    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setLong(1, orderNum);
			pstmt.setLong(2, userNum);
			pstmt.setInt(3, totalPrice); 
			pstmt.setInt(4, discPrice); 
			pstmt.setInt(5, payPrice);   
			pstmt.setString(6, recvName);
			pstmt.setString(7, recvPhone);
			pstmt.setString(8, recvZip);
			pstmt.setString(9, recvAddr1);
			pstmt.setString(10, recvAddr2);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);
			
			// 동적 쿼리를 위한 세팅
			String placeholders = "";
			for(int i=0; i<cartNums.length; i++) {
				placeholders += "?";
				if(i < cartNums.length -1) placeholders += ",";
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
			
			// 결제 내역
			String sql4 = "INSERT INTO payments (pay_num, order_num, method, tid, amount, pay_status, paid_at) "
					+ "VALUES (payments_seq.nextval, ?, ?, ?, ?, 1, SYSDATE)";
			pstmt = conn.prepareStatement(sql4);
			pstmt.setLong(1, orderNum);
			pstmt.setString(2, payMethod);
			pstmt.setString(3, tid); // 카카오페이면 고유번호, 일반 결제면 null
			pstmt.setInt(4, payPrice); // 결제 테이블엔 실제로 낸 돈(payPrice)을 기록
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);
			
			// 장바구니 목록 비우기
			String sql5 = "DELETE FROM cart WHERE cart_num IN (" + placeholders + ")";
			pstmt = conn.prepareStatement(sql5);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(i + 1, Long.parseLong(cartNums[i]));
			}
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);
			
			// 회원의 총 누적 결제 금액 업데이트
			String sql6 = "UPDATE USERS_DETAIL SET TOTAL_AMOUNT = TOTAL_AMOUNT + ? WHERE USER_NUM = ?";
			pstmt = conn.prepareStatement(sql6);
			pstmt.setInt(1, totalPrice); // 등급 상승을 위한 누적금액은 할인 전 가격으로
			pstmt.setLong(2, userNum);
			pstmt.executeUpdate();

			// 전부 성공했다면 커밋
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
	
	// 해당 유저가 특정 상품을 구매 했는지 확인 (리뷰 작성 권한)
	public boolean checkUserPurchase(long userNum, int prodNum) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean result = false;
		try {
			conn = DBUtil.getConnection();
			// 주문 상태가 1(결제완료) 이상이고, 해당 주문 상세에 이 상품이 있는지 확인
			String sql = "SELECT * FROM orders o JOIN order_items oi ON o.order_num = oi.order_num "
					   + "WHERE o.user_num = ? AND oi.prod_num = ? AND o.order_status >= 4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, userNum);
			pstmt.setInt(2, prodNum);
			rs = pstmt.executeQuery();
			if(rs.next()) result = true;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return result;
	}
		
}