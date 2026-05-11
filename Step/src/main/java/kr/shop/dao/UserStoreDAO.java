package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.UserStoreVO;
import kr.util.DBUtil;


public class UserStoreDAO {
    
    // ── 싱글톤 패턴 ──
    private static UserStoreDAO instance = new UserStoreDAO();
    public static UserStoreDAO getInstance() {
        return instance;
    }
    private UserStoreDAO() {}

    // ── [매장 목록 조회] 카카오맵에 뿌릴 데이터 ──────────────────────────────
    public List<UserStoreVO> getStoreList() throws Exception {
        List<UserStoreVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 사용 중인(Y) 매장만 최신순으로 가져옵니다
        String sql = "SELECT STORE_NUM, STORE_NAME, STORE_ADDR, STORE_PHONE, OPEN_TIME, STORE_USE_YN "
                   + "FROM STORES "
                   + "WHERE STORE_USE_YN = 'Y' "
                   + "ORDER BY STORE_NUM DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UserStoreVO vo = new UserStoreVO();
                
                // DB에서 꺼내서 UserStoreVO 그릇에 예쁘게 담습니다
                vo.setStoreNum(rs.getInt("STORE_NUM"));
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
}
