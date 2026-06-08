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

    public List<String> getProductListForAI() throws Exception {
        List<String> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT p.PROD_NAME, b.BRAND_NAME, c.CAT_NAME, "
                   + "       p.PROD_PRICE, p.SALE_RATE, p.PROD_TEXT, p.GENDER, "
                   + "       stock.TOTAL_STOCK, stock.COLORS, stock.SIZES "
                   + "FROM PRODUCTS p "
                   + "LEFT JOIN BRANDS b     ON p.BRAND_NUM = b.BRAND_NUM "
                   + "LEFT JOIN CATEGORIES c ON p.CAT_NUM   = c.CAT_NUM "
                   + "JOIN ( "
                   + "    SELECT po.PROD_NUM, "
                   + "           SUM(s.STOCK_QTY) AS TOTAL_STOCK, "
                   + "           LISTAGG(DISTINCT po.COLOR, ', ') "
                   + "               WITHIN GROUP (ORDER BY po.COLOR) AS COLORS, "
                   + "           LISTAGG(DISTINCT TO_CHAR(po.SIZE_VAL), ', ') "
                   + "               WITHIN GROUP (ORDER BY po.SIZE_VAL) AS SIZES "
                   + "    FROM PROD_OPTIONS po "
                   + "    JOIN STOCK s ON po.OPT_NUM = s.OPT_NUM "
                   + "    WHERE po.PROD_USE_YN = 'Y' "
                   + "      AND s.STOCK_QTY > 0 "
                   + "    GROUP BY po.PROD_NUM "
                   + ") stock ON p.PROD_NUM = stock.PROD_NUM "
                   + "WHERE p.PROD_STATUS = 1 "
                   + "ORDER BY p.PROD_NUM DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String prodName   = rs.getString("PROD_NAME");
                String brand      = rs.getString("BRAND_NAME");
                String catName    = rs.getString("CAT_NAME");
                int    price      = rs.getInt("PROD_PRICE");
                int    saleRate   = rs.getInt("SALE_RATE");
                int    gender     = rs.getInt("GENDER");
                int    totalStock = rs.getInt("TOTAL_STOCK");
                String colors     = rs.getString("COLORS");
                String sizes      = rs.getString("SIZES");

               
                String text = "";
                try {
                    java.sql.Clob clob = rs.getClob("PROD_TEXT");
                    if (clob != null) {
                        text = clob.getSubString(1, (int) clob.length());
                    }
                } catch (Exception e) {
                    text = "";
                }

                // 할인가 계산
                int finalPrice = saleRate > 0 ? price - (price * saleRate / 100) : price;

                // 성별 텍스트
                String genderTxt = gender == 1 ? "남성" : gender == 2 ? "여성" : "공용";

                StringBuilder sb = new StringBuilder();
                sb.append("상품명: ").append(prodName != null ? prodName : "미등록");
                sb.append(", 브랜드: ").append(brand != null ? brand : "미등록");
                sb.append(", 카테고리: ").append(catName != null ? catName : "미등록");
                sb.append(", 가격: ").append(String.format("%,d", finalPrice)).append("원");
                if (saleRate > 0) {
                    sb.append(" (").append(saleRate).append("% 할인, 정가 ")
                      .append(String.format("%,d", price)).append("원)");
                }
                sb.append(", 성별: ").append(genderTxt);
                sb.append(", 재고: ").append(totalStock).append("개");
                sb.append(", 색상: ").append(colors != null ? colors : "정보없음");
                sb.append(", 사이즈: ").append(sizes != null ? sizes : "정보없음");

                
                if (text != null && !text.trim().isEmpty()) {
                    String safeText = text.replaceAll("[\\r\\n\\t]+", " ").trim();
                    if (safeText.length() > 200) {
                        safeText = safeText.substring(0, 200) + "...";
                    }
                    sb.append(", 설명: ").append(safeText);
                }

                list.add(sb.toString());
            }

            System.out.println("[AiChatDAO] 상품 목록 조회 성공: " + list.size() + "개");

        } catch (Exception e) {
            System.err.println("[AiChatDAO] 상품 목록 조회 실패: " + e.getMessage());
            throw e;
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
}