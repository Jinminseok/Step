package kr.shop.dao;

import java.sql.*;
import java.util.*;
import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class AdminProductDAO {
	private static AdminProductDAO instance = new AdminProductDAO();

	public static AdminProductDAO getInstance() {
		return instance;
	}

	private AdminProductDAO() {
	}

	public List<AdminProductVO> getProductList(AdminProductVO filter) throws Exception {
		List<AdminProductVO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 문자열 합칠 때 앞뒤 공백을 명확하게 줌 (특수 공백 제거됨)
		String sql = "SELECT * FROM ( " + "  SELECT a.*, rownum rnum FROM ( " + "    SELECT p.*, b.brand_name, "
				+ "           (SELECT i.prod_img_url FROM prod_imgs i "
				+ "            WHERE i.prod_num = p.prod_num AND i.is_main = 1) as main_img_url "
				+ "    FROM products p " + "    JOIN brands b ON p.brand_num = b.brand_num "
				+ "    ORDER BY p.prod_num DESC " + "  ) a WHERE rownum <= ? " + ") WHERE rnum >= ?";

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);

			// 콘솔에서 파라미터 값 확인용 (에러 추적용)
			System.out.println("LOG - Start Row: " + filter.getStart_row());
			System.out.println("LOG - End Row: " + filter.getEnd_row());

			pstmt.setInt(1, filter.getEnd_row());
			pstmt.setInt(2, filter.getStart_row());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setProdNum(rs.getInt("prod_num"));
				vo.setProdName(rs.getString("prod_name"));
				vo.setProdPrice(rs.getInt("prod_price"));
				vo.setSaleRate(rs.getDouble("sale_rate"));
				vo.setGender(rs.getInt("gender"));
				vo.setBrandName(rs.getString("brand_name"));
				vo.setMainImgUrl(rs.getString("main_img_url"));
				list.add(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}