package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.UserStoreVO;
import kr.util.DBUtil;


	public class UserStoreDAO {
    
    //싱글톤 패턴
    private static UserStoreDAO instance = new UserStoreDAO();
    public static UserStoreDAO getInstance() {
        return instance;
    }
    private UserStoreDAO() {}

    //카카오맵에 뿌릴 데이터
    public List<UserStoreVO> getStoreList() throws Exception {
        List<UserStoreVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

       
        String sql = "SELECT S.STORE_NUM, S.BRAND_NUM, B.BRAND_NAME, "
                + "S.STORE_NAME, S.STORE_ADDR, S.STORE_PHONE, S.OPEN_TIME, S.STORE_USE_YN "
                + "FROM STORES S "
                + "JOIN BRANDS B ON S.BRAND_NUM = B.BRAND_NUM "
                + "WHERE S.STORE_USE_YN = 'Y' AND B.BRAND_USE_YN = 'Y' "
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
}
