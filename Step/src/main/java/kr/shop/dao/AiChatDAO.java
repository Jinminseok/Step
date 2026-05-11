package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;

public class AiChatDAO {
	
	private static AiChatDAO instance = new AiChatDAO();
	public static AiChatDAO getInstance() {
		return instance;
	}
	private AiChatDAO() {}
	
	// Claude AI에게 넘길 상품 목록 조회
	public List<String> getProductListForAI() throws Exception{
		
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT p.PROD_NAME, b.BRAND_NAME, p.PROD_PRICE, p.SALE_RATE, "
                + "       p.PROD_TEXT, p.GENDER, c.CAT_NAME "
                + "FROM PRODUCTS p "
                + "LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
                + "LEFT JOIN CATEGORIES c ON p.CAT_NUM = c.CAT_NUM "
                + "WHERE p.PROD_STATUS = 1 "
                + "ORDER BY p.PROD_CREATED_AT DESC";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String prodName = rs.getString("PROD_NAME");
				String brand = rs.getString("BRAND_NAME");
				int price = rs.getInt("PROD_PRICE");
				int saleRate = rs.getInt("SALE_RATE");
				String text = rs.getString("PROD_TEXT");
				int gender = rs.getInt("GENDER");
				String catName = rs.getString("CAT_NAME");
				
				// 할인가 계산
                int finalPrice = saleRate > 0 ? price - (price * saleRate / 100) : price;

                // 성별 텍스트 변환
                String genderTxt = gender == 1 ? "남성" : gender == 2 ? "여성" : "공용";
				
             // Claude에게 넘길 상품 정보 텍스트 구성
                StringBuilder sb = new StringBuilder();
                sb.append("상품명: ").append(prodName);
                sb.append(", 브랜드: ").append(brand != null ? brand : "미등록");
                sb.append(", 카테고리: ").append(catName != null ? catName : "미등록");
                sb.append(", 가격: ").append(String.format("%,d", finalPrice)).append("원");
                if (saleRate > 0) {
                    sb.append(" (").append(saleRate).append("% 할인)");
                }
                sb.append(", 성별: ").append(genderTxt);
                if (text != null && !text.isEmpty()) {
                    sb.append(", 설명: ").append(text);
                }

                list.add(sb.toString());
				
				
			}
		}finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}
