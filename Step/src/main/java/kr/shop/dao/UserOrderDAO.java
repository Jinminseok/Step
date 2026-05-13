package kr.shop.dao;

public class UserOrderDAO {
	// 싱글턴 패턴
	private static UserOrderDAO instance = new UserOrderDAO();
	
	public static UserOrderDAO getInstance() {
		return instance;
	}
	private UserOrderDAO() {}
	
	
}
