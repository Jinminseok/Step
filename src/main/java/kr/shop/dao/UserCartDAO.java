package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.UserCartVO;
import kr.util.DBUtil;

public class UserCartDAO {
	// 싱글턴 패턴
	private static UserCartDAO instance = new UserCartDAO();
	
	public static UserCartDAO getInstance() {
		return instance;
	}
	private UserCartDAO() {}
	
	// 장바구니에 상품 추가
	public void insertCart(UserCartVO cart) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;
		int cnt = 0;
		
		try {
			conn = DBUtil.getConnection();
			sql = """
					INSERT INTO cart (cart_num, user_num, opt_num, cart_qty, cart_created_at)
					VALUES (cart_seq.nextval, ?, 
					       (SELECT opt_num FROM prod_options WHERE prod_num = ? AND color = ? AND size_val = ?), 
					       ?, SYSDATE)
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(++cnt, cart.getUser_num());
			pstmt.setInt(++cnt, cart.getProd_num());
			pstmt.setString(++cnt, cart.getColor());
			pstmt.setInt(++cnt, cart.getSize_val());
			pstmt.setInt(++cnt, cart.getCart_qty());
            
			pstmt.executeUpdate();
		} catch(Exception e) {
			throw new Exception(e);
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// 장바구니 목록 조회
	public List<UserCartVO> getCartList(long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		List<UserCartVO> list = new ArrayList<>();
		
		try {
			conn = DBUtil.getConnection();
			sql = """
					SELECT c.cart_num, c.user_num, c.opt_num, c.cart_qty, c.cart_created_at, 
					p.prod_num, p.prod_name, p.prod_price, 
					i.prod_img_url, b.brand_name, o.color, o.size_val 
					FROM CART c 
					JOIN PROD_OPTIONS o ON c.opt_num = o.opt_num 
					JOIN PRODUCTS p ON o.prod_num = p.prod_num 
					LEFT JOIN BRANDS b ON p.brand_num = b.brand_num 
					LEFT JOIN PROD_IMGS i ON p.prod_num = i.prod_num AND i.is_main = 'Y' 
					WHERE c.user_num = ? ORDER BY c.cart_num DESC
					""";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				UserCartVO cart = new UserCartVO();
				cart.setCart_num(rs.getLong("cart_num"));
				cart.setUser_num(rs.getLong("user_num"));
				cart.setOpt_num(rs.getLong("opt_num"));
				cart.setCart_qty(rs.getInt("cart_qty"));
				cart.setCart_created_at(rs.getDate("cart_created_at"));
				cart.setProd_num(rs.getInt("prod_num"));
				cart.setProd_name(rs.getString("prod_name"));
				cart.setProd_price(rs.getInt("prod_price"));
				cart.setProd_img_url(rs.getString("prod_img_url"));
				cart.setBrand_name(rs.getString("brand_name"));
				cart.setColor(rs.getString("color"));
				cart.setSize_val(rs.getInt("size_val"));
				
				list.add(cart);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
	
	// 장바구니 상품 개별 삭제
	public void deleteCart(long cart_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			conn = DBUtil.getConnection();
			sql = "DELETE FROM cart WHERE cart_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, cart_num);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	
	// 선택된 장바구니 상품 목록 가져오기
	public List<UserCartVO> getOrderCartList(String[] cartNums) throws Exception {
		List<UserCartVO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBUtil.getConnection();
			
			// ?개수를 장바구니 크기만큼 생성
			String placeholders = "";
			for(int i = 0; i < cartNums.length; i++) {
				placeholders += "?";
				if(i < cartNums.length - 1) placeholders += ",";
			}
			
			// 장바구니, 상품, 이미지 정보 가져오기
			String sql = "SELECT c.cart_num, c.cart_qty, "
					   + "o.color, o.size_val, "
					   + "p.prod_num, p.prod_name, p.prod_price, i.prod_img_url "
					   + "FROM cart c "
					   + "JOIN prod_options o ON c.opt_num = o.opt_num "
					   + "JOIN products p ON o.prod_num = p.prod_num "
					   + "LEFT JOIN prod_imgs i ON p.prod_num = i.prod_num AND i.is_main = 'Y' "
					   + "WHERE c.cart_num IN (" + placeholders + ")";
			
			pstmt = conn.prepareStatement(sql);
			
			// ?에 cart_num 값들을 세팅
			for(int i = 0; i < cartNums.length; i++) {
				pstmt.setLong(i + 1, Long.parseLong(cartNums[i]));
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				UserCartVO cart = new UserCartVO();
				cart.setCart_num(rs.getLong("cart_num"));
				cart.setCart_qty(rs.getInt("cart_qty"));
				cart.setColor(rs.getString("color"));
				cart.setSize_val(rs.getInt("size_val"));
				cart.setProd_num(rs.getInt("prod_num"));
				cart.setProd_name(rs.getString("prod_name"));
				cart.setProd_price(rs.getInt("prod_price"));
				cart.setProd_img_url(rs.getString("prod_img_url"));
				
				list.add(cart);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}
	
	// 바로 구매하기
	public Long insertDirectCart(Long user_num, int prod_num, String color, int size, int cart_qty) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Long cart_num = 0L;
		
		try {
			conn = DBUtil.getConnection();
			
			// 시퀀스 번호 가져오기
			pstmt = conn.prepareStatement("SELECT CART_SEQ.NEXTVAL FROM DUAL");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cart_num = rs.getLong(1);
			}
			DBUtil.executeClose(rs, pstmt, null);
			
			// 장바구니에 바로 넣기
			String sql = "INSERT INTO CART (CART_NUM, USER_NUM, OPT_NUM, CART_QTY) "
					   + "VALUES (?, ?, (SELECT OPT_NUM FROM PROD_OPTIONS WHERE PROD_NUM=? AND COLOR=? AND SIZE_VAL=?), ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, cart_num);
			pstmt.setLong(2, user_num);
			pstmt.setInt(3, prod_num);
			pstmt.setString(4, color);
			pstmt.setInt(5, size);
			pstmt.setInt(6, cart_qty);
			
			pstmt.executeUpdate();
			
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
		
		return cart_num;
	}
	
	// 장바구니 전체 개수 가져오기
	public int getCartCount(Long user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String sql = null;
		
		try {
			conn = DBUtil.getConnection();
			sql = "SELECT COUNT(*) FROM CART WHERE USER_NUM = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, user_num);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		
		return count;
	}
	
	// 장바구니 수량 업데이트
		public void updateCartQty(long cart_num, int cart_qty) throws Exception {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DBUtil.getConnection();
				String sql = "UPDATE cart SET cart_qty = ? WHERE cart_num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cart_qty);
				pstmt.setLong(2, cart_num);
				pstmt.executeUpdate();
			} finally {
				DBUtil.executeClose(null, pstmt, conn);
			}
		}
		
		// 장바구니 선택 삭제
		public void deleteSelectedCarts(String[] cartNums) throws Exception {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DBUtil.getConnection();
				String placeholders = "";
				for(int i = 0; i < cartNums.length; i++) {
					placeholders += "?";
					if(i < cartNums.length - 1) placeholders += ",";
				}
				String sql = "DELETE FROM cart WHERE cart_num IN (" + placeholders + ")";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < cartNums.length; i++) {
					pstmt.setLong(i + 1, Long.parseLong(cartNums[i]));
				}
				pstmt.executeUpdate();
			} finally {
				DBUtil.executeClose(null, pstmt, conn);
			}
		}
		
}
