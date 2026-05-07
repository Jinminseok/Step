package kr.shop.dao;

import java.sql.*;
import java.util.*;
import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class AdminProductDAO {
	// 싱글톤
	private static AdminProductDAO instance = new AdminProductDAO();

	public static AdminProductDAO getInstance() {
		return instance;
	}

	private AdminProductDAO() {
	}

	// 메인화면/목록용 상품 리스트 (BaseVO의 페이징/검색 필드 활용)
	public List<AdminProductVO> getProductList(AdminProductVO filter) throws Exception {
		List<AdminProductVO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM (SELECT a.*, rownum rnum FROM ("
				+ "SELECT * FROM products ORDER BY prod_num DESC) a " + "WHERE rownum <= ?) WHERE rnum >= ?";
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, filter.getEnd_row());
			pstmt.setInt(2, filter.getStart_row());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminProductVO vo = new AdminProductVO();
				vo.setProdNum(rs.getInt("prod_num"));
				vo.setProdName(rs.getString("prod_name"));
				vo.setProdPrice(rs.getInt("prod_price"));
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
}