package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class AdminDAO {

	// 싱글톤 패턴 (선택 사항이나 보통 DAO에서 권장됨)
	private static AdminDAO instance = new AdminDAO();

	public static AdminDAO getInstance() {
		return instance;
	}

	public AdminDAO() {
	}

	// 1. 상품 목록 조회
	public List<AdminProductVO> selectProductList(AdminProductVO filter) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<AdminProductVO> list = null;
	    String sql = "";
	    String sub_sql = "";
	    int cnt = 0;

	    try {
	        conn = DBUtil.getConnection();

	        // 1. 조건절 동적 구성 (성별 필터)
	        // gender가 -1이면 전체조회, 아니면 특정 성별(0, 1 등) 조회
	        if (filter.getGender() != -1) {
	            sub_sql += "WHERE gender = ? ";
	        }

	        // 2. 검색어 필터 추가 (필요 시)
	        if (filter.getKeyword() != null && !filter.getKeyword().isEmpty()) {
	            if (sub_sql.contains("WHERE")) sub_sql += "AND ";
	            else sub_sql += "WHERE ";
	            sub_sql += "prod_name LIKE ? ";
	        }

	        // 3. 페이징 처리를 포함한 전체 SQL
	        sql = "SELECT * FROM (SELECT a.*, rownum rnum FROM "
	            + "(SELECT * FROM PRODUCTS " + sub_sql + " ORDER BY PROD_CREATED_AT DESC) a) " 
	            + "WHERE rnum >= ? AND rnum <= ?";

	        pstmt = conn.prepareStatement(sql);

	        // 4. 파라미터 바인딩 (동적 순서 처리)
	        if (filter.getGender() != -1) {
	            pstmt.setInt(++cnt, filter.getGender());
	        }
	        if (filter.getKeyword() != null && !filter.getKeyword().isEmpty()) {
	            pstmt.setString(++cnt, "%" + filter.getKeyword() + "%");
	        }
	        
	        // 페이징 번호는 항상 마지막
	        pstmt.setInt(++cnt, filter.getStart_row());
	        pstmt.setInt(++cnt, filter.getEnd_row());

	        rs = pstmt.executeQuery();
	        list = new ArrayList<AdminProductVO>();
	        
	        while (rs.next()) {
	            AdminProductVO vo = new AdminProductVO();
	            // VO에 정의된 필드들을 DB 컬럼명과 매칭해서 다 담아줘야 함
	            vo.setProd_num(rs.getInt("prod_num"));
	            vo.setProd_name(rs.getString("prod_name"));
	            vo.setProd_price(rs.getInt("prod_price"));
	            vo.setGender(rs.getInt("gender"));
	            vo.setProd_status(rs.getInt("prod_status"));
	            vo.setProd_created_at(rs.getDate("prod_created_at"));
	            // 이미지나 카테고리 등 필요한 정보 추가...
	            
	            list.add(vo);
	        }
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return list;
	}
	// 2. 상품 등록 (C-4 요구사항)
	public void insertProduct(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = DBUtil.getConnection();
			sql = "INSERT INTO PRODUCTS (prod_num, sku, prod_name, gender, prod_price, prod_status, prod_created_at) "
					+ "VALUES (products_seq.nextval, ?, ?, ?, ?, ?, SYSDATE)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, vo.getSku());
			pstmt.setString(2, vo.getProd_name());
			pstmt.setInt(3, vo.getGender());
			pstmt.setInt(4, vo.getProd_price());
			pstmt.setInt(5, vo.getProd_status());

			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	// 3. 상품 정보 수정
	public void updateProduct(AdminProductVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = DBUtil.getConnection();
			sql = "UPDATE PRODUCTS SET prod_name=?, prod_price=?, prod_status=?, prod_updated_at=SYSDATE "
					+ "WHERE prod_num=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, vo.getProd_name());
			pstmt.setInt(2, vo.getProd_price());
			pstmt.setInt(3, vo.getProd_status());
			pstmt.setInt(4, vo.getProd_num());

			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	// 4. 상품 상태 변경 (삭제 대용)
	public void updateProductStatus(int prod_num, int status) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = DBUtil.getConnection();
			sql = "UPDATE PRODUCTS SET prod_status=? WHERE prod_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, status);
			pstmt.setInt(2, prod_num);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
}