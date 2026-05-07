package kr.shop.dao;

import java.sql.*;
import kr.shop.vo.AdminStockInOutVO;
import kr.util.DBUtil;

public class AdminStockDAO {
	private static AdminStockDAO instance = new AdminStockDAO();

	public static AdminStockDAO getInstance() {
		return instance;
	}

	private AdminStockDAO() {
	}

	// 재고 수정 (입출고 발생 시 호출)
	public void updateStockQty(int optNum, int qty) throws Exception {
		// ... UPDATE stock SET stock_qty = stock_qty + ? WHERE opt_num = ?
	}
}