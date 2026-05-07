package kr.shop.dao;

import java.sql.*;
import java.util.*;
import kr.shop.vo.AdminOrderVO;
import kr.util.DBUtil;

public class AdminOrderDAO {
	private static AdminOrderDAO instance = new AdminOrderDAO();

	public static AdminOrderDAO getInstance() {
		return instance;
	}

	private AdminOrderDAO() {
	}

	// 주문 생성 (트랜잭션 처리 필요할 수 있음)
	public void insertOrder(AdminOrderVO order) throws Exception {
		// ... INSERT INTO orders ... 쿼리 작성
	}

	// 내 주문 내역 리스트
	public List<AdminOrderVO> getMyOrderList(long userNum) throws Exception {
		// ... 쿼리 작성
		return null;
	}
}