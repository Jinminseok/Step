package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;

public class AiChatDAO {

    private static AiChatDAO instance = new AiChatDAO();
    public static AiChatDAO getInstance() { return instance; }
    private AiChatDAO() {}

    // 실제 재고가 있는 상품만 조회 (STOCK_QTY > 0 인 것만)
    public List<String> getProductListForAI() throws Exception {
        List<String> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // STOCK 테이블 JOIN → 재고 있는 상품만 추출
        String sql = "SELECT p.PROD_NAME, b.BRAND_NAME, p.PROD_PRICE, p.SALE_RATE, "
                   + "      MAX(p.PROD_TEXT) AS PROD_TEXT, p.GENDER, "
                   + "       SUM(s.STOCK_QTY) AS TOTAL_STOCK "
                   + "FROM PRODUCTS p "
                   + "LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
                   + "JOIN PROD_OPTIONS po ON p.PROD_NUM = po.PROD_NUM "
                   + "JOIN STOCK s       ON po.OPT_NUM  = s.OPT_NUM "
                   + "WHERE p.PROD_STATUS = 1 "   // 판매중 상품만
                   + "  AND po.PROD_USE_YN = 'Y' " // 활성 옵션만
                   + "  AND s.STOCK_QTY > 0 "      // 재고 있는 것만
                   + "GROUP BY p.PROD_NUM, p.PROD_NAME, b.BRAND_NAME, "
                   + "         p.PROD_PRICE, p.SALE_RATE,  p.GENDER "
                   + "ORDER BY p.PROD_NUM DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String prodName   = rs.getString("PROD_NAME");
                String brand      = rs.getString("BRAND_NAME");
                int    price      = rs.getInt("PROD_PRICE");
                int    saleRate   = rs.getInt("SALE_RATE");
                java.sql.Clob clob = rs.getClob("PROD_TEXT");
                String text = (clob != null) ? clob.getSubString(1, (int) clob.length()) : "";
                int    gender     = rs.getInt("GENDER");
                int    totalStock = rs.getInt("TOTAL_STOCK");

                // 할인가 계산
                int finalPrice = saleRate > 0 ? price - (price * saleRate / 100) : price;

                // 성별 텍스트
                String genderTxt = gender == 1 ? "남성" : gender == 2 ? "여성" : "공용";

                StringBuilder sb = new StringBuilder();
                sb.append("상품명: ").append(prodName != null ? prodName : "미등록");
                sb.append(", 브랜드: ").append(brand != null ? brand : "미등록");
                sb.append(", 가격: ").append(String.format("%,d", finalPrice)).append("원");
                if (saleRate > 0) {
                    sb.append(" (").append(saleRate).append("% 할인, 정가 ")
                      .append(String.format("%,d", price)).append("원)");
                }
                sb.append(", 성별: ").append(genderTxt);
                sb.append(", 재고: ").append(totalStock).append("개");
                if (text != null && !text.trim().isEmpty()) {
                    sb.append(", 설명: ").append(text);
                }

                list.add(sb.toString());
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
}