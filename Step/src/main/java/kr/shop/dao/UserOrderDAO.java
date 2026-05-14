package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import kr.util.DBUtil;

public class UserOrderDAO {
	// 싱글턴 패턴
	private static UserOrderDAO instance = new UserOrderDAO();
	public static UserOrderDAO getInstance() { return instance; }
	private UserOrderDAO() {}

	//  주문 트랜잭션 처리
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

			// 1. ORDERS_SEQ 시퀀스로 새 주문번호(ORDER_NUM) 미리 발급받기
			pstmt = conn.prepareStatement("SELECT ORDERS_SEQ.NEXTVAL FROM DUAL");
			rs = pstmt.executeQuery();
			if (rs.next()) orderNum = rs.getLong(1);
			DBUtil.executeClose(rs, pstmt, null);

			// 2. ORDERS 테이블에 주문 정보 INSERT
			String sql1 = "INSERT INTO ORDERS (ORDER_NUM, USER_NUM, TOTAL_PRICE, PAY_PRICE, RECV_NAME, RECV_PHONE, RECV_ZIP, RECV_ADDR1, RECV_ADDR2, ORDER_STATUS) "
					    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setLong(1, orderNum);
			pstmt.setLong(2, userNum);
			pstmt.setInt(3, totalPrice);
			pstmt.setInt(4, totalPrice); // 현재 할인 로직이 없으므로 동일하게 넣습니다.
			pstmt.setString(5, recvName);
			pstmt.setString(6, recvPhone);
			pstmt.setString(7, recvZip);
			pstmt.setString(8, recvAddr1);
			pstmt.setString(9, recvAddr2);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// (동적 쿼리를 위한 물음표 세팅 "?, ?, ?")
			String placeholders = "";
			for(int i=0; i<cartNums.length; i++) {
				placeholders += "?";
				if(i < cartNums.length - 1) placeholders += ",";
			}

			// ORDER_ITEMS 테이블에 상세 정보 INSERT (CART, PROD_OPTIONS, PRODUCTS 조인)
			String sql2 = "INSERT INTO ORDER_ITEMS (ITEM_NUM, ORDER_NUM, PROD_NUM, OPT_NUM, ORDER_ITEM_QTY, ORDER_ITEM_PRICE) "
					    + "SELECT ORDER_ITEMS_SEQ.NEXTVAL, ?, o.PROD_NUM, c.OPT_NUM, c.CART_QTY, p.PROD_PRICE "
					    + "FROM CART c "
					    + "JOIN PROD_OPTIONS o ON c.OPT_NUM = o.OPT_NUM "
					    + "JOIN PRODUCTS p ON o.PROD_NUM = p.PROD_NUM "
					    + "WHERE c.CART_NUM IN (" + placeholders + ")";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setLong(1, orderNum);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(i + 2, Long.parseLong(cartNums[i]));
			}
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// 재고 차감 - 장바구니 개수만큼 반복 차감
			String sql3 = "UPDATE STOCK s SET STOCK_QTY = STOCK_QTY - "
					    + "(SELECT CART_QTY FROM CART c WHERE c.OPT_NUM = s.OPT_NUM AND c.CART_NUM = ?) "
					    + "WHERE s.OPT_NUM = (SELECT OPT_NUM FROM CART WHERE CART_NUM = ?)";
			pstmt = conn.prepareStatement(sql3);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(1, Long.parseLong(cartNums[i]));
				pstmt.setLong(2, Long.parseLong(cartNums[i]));
				pstmt.executeUpdate();
			}
			DBUtil.executeClose(null, pstmt, null);

			// 테이블에 결제 내역 추가
			String sql4 = "INSERT INTO PAYMENTS (PAY_NUM, ORDER_NUM, METHOD, AMOUNT, PAY_STATUS) VALUES (PAYMENTS_SEQ.NEXTVAL, ?, ?, ?, 1)";
			pstmt = conn.prepareStatement(sql4);
			pstmt.setLong(1, orderNum);
			pstmt.setString(2, payMethod);
			pstmt.setInt(3, totalPrice);
			pstmt.executeUpdate();
			DBUtil.executeClose(null, pstmt, null);

			// 장바구니 목록 비우기
			String sql5 = "DELETE FROM CART WHERE CART_NUM IN (" + placeholders + ")";
			pstmt = conn.prepareStatement(sql5);
			for(int i=0; i<cartNums.length; i++) {
				pstmt.setLong(i + 1, Long.parseLong(cartNums[i]));
			}
			pstmt.executeUpdate();

			// 전부 실행되면 커밋
			conn.commit();

		} catch (Exception e) {
			if (conn != null) conn.rollback(); // 단 하나라도 실패하면 전부 원상 복구!
			throw new Exception(e);
		} finally {
			if (conn != null) conn.setAutoCommit(true); // 커밋 상태 원상 복구
			DBUtil.executeClose(rs, pstmt, conn);
		}
	}
}