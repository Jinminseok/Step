package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.AdminProductVO;
import kr.util.DBUtil;

public class UserProductDAO {
	// 싱글턴 패턴
	private static UserProductDAO instance = new UserProductDAO();

	public static UserProductDAO getInstance() {
		return instance;
	}

	private UserProductDAO() {}

	// 상품 기본 상세 정보 + 브랜드명 가져오기
	public AdminProductVO getProductDetail(int prod_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AdminProductVO vo = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT p.prod_num, p.prod_name, p.sku, p.prod_price, p.sale_rate, p.prod_text, b.brand_name
					FROM products p JOIN brands b ON p.brand_num = b.brand_num WHERE p.prod_num = ?
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vo = new AdminProductVO();
				// 세터 메서드명을 VO에 정의된 스네이크 케이스 기반으로 수정
				vo.setProd_num(rs.getInt("prod_num"));
				vo.setProd_name(rs.getString("prod_name"));
				vo.setSku(rs.getString("sku"));
				vo.setProd_price(rs.getInt("prod_price"));
				vo.setSale_rate(rs.getInt("sale_rate"));
				vo.setBrand_name(rs.getString("brand_name"));
				vo.setProd_text(rs.getString("prod_text"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return vo;
	}

	// 해당 상품의 모든 다중 이미지 가져오기
	public List<String> getProductImages(int prod_num) throws Exception {
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			// 메인 사진이 제일 먼저 오도록 정렬
			sql = """
					SELECT prod_img_url FROM prod_imgs WHERE prod_num = ?
					ORDER BY is_main DESC, prod_img_sort_no ASC
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("prod_img_url"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 해당 상품의 고유 색상 목록 가져오기
	public List<String> getProductColors(int prod_num) throws Exception {
		List<String> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT DISTINCT color FROM prod_options WHERE prod_num = ? AND prod_use_yn = 'Y'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("color"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 해당 상품의 고유 사이즈 목록 가져오기
	public List<Integer> getProductSizes(int prod_num) throws Exception {
		List<Integer> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 작은 사이즈부터 오름차순
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT DISTINCT size_val FROM prod_options WHERE prod_num = ? AND prod_use_yn = 'Y'
					ORDER BY size_val ASC
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getInt("size_val"));
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 상품 총 재고량 계산하기
	public int getProductTotalStock(int prod_num) throws Exception {
		int total = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT sum(stock_qty) FROM stock WHERE prod_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, prod_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				total = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return total;
	}
	
	// 메인 화면용 상품 목록 조회
	public List<AdminProductVO> getMainProductList(AdminProductVO filter) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<AdminProductVO> list = null;
	    String sql = null;
	    String sub_sql = "";
	    int cnt = 0;

	    try {
	        conn = DBUtil.getConnection();

	        // 성별 필터링 (gender가 -1이 아니면 조건 추가)
	        if (filter.getGender() != -1) {
	            sub_sql += "WHERE p.gender = ? ";
	        }

	        // 검색어 필터링
	        if (filter.getKeyword() != null && !filter.getKeyword().isEmpty()) {
	            if (sub_sql.contains("WHERE")) sub_sql += "AND ";
	            else sub_sql += "WHERE ";
	            sub_sql += "p.prod_name LIKE ? ";
	        }

	        // 메인 화면용 쿼리: 상품 + 브랜드명 + 대표이미지 조인
	        sql = "SELECT * FROM (SELECT a.*, rownum rnum FROM "
	            + "(SELECT p.PROD_NUM, p.PROD_NAME, p.PROD_PRICE, p.GENDER, p.PROD_STATUS, p.PROD_CREATED_AT, "
	            + "b.BRAND_NAME, i.PROD_IMG_URL " 
	            + "FROM PRODUCTS p "
	            + "LEFT JOIN BRANDS b ON p.BRAND_NUM = b.BRAND_NUM "
	            + "LEFT JOIN PROD_IMGS i ON p.PROD_NUM = i.PROD_NUM AND i.IS_MAIN = 'Y' "
	            + sub_sql + " ORDER BY p.PROD_CREATED_AT DESC) a) " 
	            + "WHERE rnum >= ? AND rnum <= ?";

	        pstmt = conn.prepareStatement(sql);

	        // 파라미터 바인딩
	        if (filter.getGender() != -1) {
	            pstmt.setInt(++cnt, filter.getGender());
	        }
	        if (filter.getKeyword() != null && !filter.getKeyword().isEmpty()) {
	            pstmt.setString(++cnt, "%" + filter.getKeyword() + "%");
	        }
	        
	        // 페이징 번호 세팅
	        pstmt.setInt(++cnt, filter.getStart_row());
	        pstmt.setInt(++cnt, filter.getEnd_row());

	        rs = pstmt.executeQuery();
	        list = new ArrayList<AdminProductVO>();
	        
	        while (rs.next()) {
	            AdminProductVO vo = new AdminProductVO();
	            vo.setProd_num(rs.getInt("prod_num"));
	            vo.setProd_name(rs.getString("prod_name"));
	            vo.setProd_price(rs.getInt("prod_price"));
	            vo.setGender(rs.getInt("gender"));
	            vo.setProd_status(rs.getInt("prod_status"));
	            vo.setProd_created_at(rs.getDate("prod_created_at"));
	            vo.setBrand_name(rs.getString("brand_name"));
	            vo.setProd_img_url(rs.getString("prod_img_url"));
	            
	            list.add(vo);
	        }
	    } finally {
	        DBUtil.executeClose(rs, pstmt, conn);
	    }
	    return list;
	}
}