package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.UserStoreVO;
import kr.util.DBUtil;

public class AdminStoreDAO {
	
	// ── 싱글톤 패턴 설정 ──
	private static AdminStoreDAO instance = new AdminStoreDAO();
    public static AdminStoreDAO getInstance() { return instance; }
    private AdminStoreDAO() {}
    
 // ── [관리자: 새 매장 등록 (Create)] ──────────────────────────────
    public void insertStore(UserStoreVO vo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = null;

        try {
            // 1. DB 연결
            conn = DBUtil.getConnection();

            // 2. SQL 작성 (STORES_SEQ.NEXTVAL 시퀀스 사용)
            sql = "INSERT INTO STORES (STORE_NUM, BRAND_NUM, STORE_NAME, STORE_ADDR, STORE_PHONE, OPEN_TIME, STORE_USE_YN) "
                + "VALUES (STORES_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";

            // 3. PreparedStatement 객체 생성
            pstmt = conn.prepareStatement(sql);

            // 4. ?(물음표) 에 들어갈 데이터 세팅
            pstmt.setInt(1, vo.getBrandNum());          // 선택한 브랜드 번호 (FK)
            pstmt.setString(2, vo.getStoreName());      // 매장명
            pstmt.setString(3, vo.getStoreAddr());      // 매장 주소
            pstmt.setString(4, vo.getStorePhone());     // 전화번호
            pstmt.setString(5, vo.getOpenTime());       // 영업시간
            
            // 등록 시 폼에서 넘어온 사용 여부(Y/N) 세팅, 혹시 비어있으면 안전하게 'Y'로 기본값 세팅
            pstmt.setString(6, vo.getStoreUseYn() != null ? vo.getStoreUseYn() : "Y");

            // 5. 쿼리 실행! (DB에 데이터 저장)
            pstmt.executeUpdate();

        } finally {
            // 6. 자원 반납
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
    
 // ── [관리자: 매장 목록 전체 조회 (Y/N 상관없이 모두 가져옴!)] ────────────────
    public List<UserStoreVO> getAdminStoreList() throws Exception {
        List<UserStoreVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 🌟 핵심: WHERE 조건에 STORE_USE_YN = 'Y'를 뺐습니다! 무조건 다 가져옵니다.
        String sql = "SELECT S.STORE_NUM, S.BRAND_NUM, B.BRAND_NAME, "
                   + "S.STORE_NAME, S.STORE_ADDR, S.STORE_PHONE, S.OPEN_TIME, S.STORE_USE_YN "
                   + "FROM STORES S "
                   + "JOIN BRANDS B ON S.BRAND_NUM = B.BRAND_NUM "
                   + "ORDER BY S.STORE_NUM DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UserStoreVO vo = new UserStoreVO();
                vo.setStoreNum(rs.getInt("STORE_NUM"));
                vo.setBrandNum(rs.getInt("BRAND_NUM"));
                vo.setBrandName(rs.getString("BRAND_NAME"));
                vo.setStoreName(rs.getString("STORE_NAME"));
                vo.setStoreAddr(rs.getString("STORE_ADDR"));
                vo.setStorePhone(rs.getString("STORE_PHONE"));
                vo.setOpenTime(rs.getString("OPEN_TIME"));
                vo.setStoreUseYn(rs.getString("STORE_USE_YN"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
    
    //매장관리 수정
    public void updateStore(UserStoreVO vo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE STORES SET BRAND_NUM=?, STORE_NAME=?, STORE_ADDR=?, STORE_PHONE=?, OPEN_TIME=?, STORE_USE_YN=? WHERE STORE_NUM=?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, vo.getBrandNum());
            pstmt.setString(2, vo.getStoreName());
            pstmt.setString(3, vo.getStoreAddr());
            pstmt.setString(4, vo.getStorePhone());
            pstmt.setString(5, vo.getOpenTime());
            pstmt.setString(6, vo.getStoreUseYn());
            pstmt.setInt(7, vo.getStoreNum()); // 🌟 어떤 매장을 수정할지 PK 지정!
            pstmt.executeUpdate();
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
    
    //매장관리 삭제
    public void deleteStore(int storeNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM STORES WHERE STORE_NUM=?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeNum);
            pstmt.executeUpdate();
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
    
}
