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

		// 1. 단순화된 쿼리 (조인/서브쿼리 제거)
		String sql = "SELECT * FROM ( " + "  SELECT a.*, rownum rnum FROM ( "
				+ "    SELECT * FROM products JOIN brands USING(brand_num) JOIN prod_imgs USING(prod_num) WHERE is_main='Y' ORDER BY prod_num DESC " + "  ) a WHERE rownum <= ? "
				+ ") WHERE rnum >= ?";

		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);


			pstmt.setInt(1, filter.getEnd_row());
			pstmt.setInt(2, filter.getStart_row());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();

				// 2. products 테이블의 기본 컬럼만 매핑
				vo.setProdNum(rs.getInt("prod_num"));
				vo.setProdName(rs.getString("prod_name"));
				vo.setProdPrice(rs.getInt("prod_price"));
				vo.setSaleRate(rs.getDouble("sale_rate"));
				vo.setGender(rs.getInt("gender"));

				// 조인/이미지 정보는 일단 주석 처리 (에러 원인 격리)
				vo.setBrandName(rs.getString("brand_name"));
				vo.setMainImgUrl(rs.getString("prod_img_url"));

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