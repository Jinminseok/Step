package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import kr.shop.vo.ProductVO;
import kr.util.DBUtil;

public class AdminDAO {
	
	private static AdminDAO instance = new AdminDAO();

	public static AdminDAO getInstance() { 
	    return instance;
	}

	private AdminDAO() {} 
	
	public void insertProduct(ProductVO product) throws Exception{
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			conn = DBUtil.getConnection();
			sql = "INSERT INTO PRODUCTS (PROD_NUM, CAT_NUM, BRAND_NUM, SKU,"
					+ "PROD_NAME, GENDER, PROD_PRICE, SALE_RATE, PROD_TEXT, PROD_STATUS) "
					+ "VALUES (products_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
			pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, product.getCat_num());
	        pstmt.setInt(2, product.getBrand_num());
	        pstmt.setString(3, product.getSku());
	        pstmt.setString(4, product.getName());
	        pstmt.setInt(5, product.getGender());
	        pstmt.setInt(6, product.getPrice());
	        pstmt.setInt(7, product.getSale_rate());
	        pstmt.setString(8, product.getProd_text()); // getDesc_text -> getProd_text로 수정
	        pstmt.setInt(9, product.getStatus());
	        
	        pstmt.executeUpdate();
		}finally {
			DBUtil.executeClose(null, pstmt, conn);
			
		}
	}
	
}