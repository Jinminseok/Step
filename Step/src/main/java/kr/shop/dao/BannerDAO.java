package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.BannerVO;
import kr.util.DBUtil;

public class BannerDAO {
	private static BannerDAO instance = new BannerDAO();
    public static BannerDAO getInstance() { return instance; }
    private BannerDAO() {}

    // 1. [관리자용] 전체 배너 목록 (순서대로 정렬)
    public List<BannerVO> getAdminBannerList() throws Exception {
        List<BannerVO> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        
        String sql = "SELECT b.*, p.PROD_NAME FROM BANNERS b "
                   + "JOIN PRODUCTS p ON b.PROD_NUM = p.PROD_NUM "
                   + "ORDER BY b.BANNER_ORDER ASC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                BannerVO vo = new BannerVO();
                vo.setBanner_num(rs.getInt("BANNER_NUM"));
                vo.setBanner_title(rs.getString("BANNER_TITLE"));
                vo.setBanner_img(rs.getString("BANNER_IMG"));
                vo.setProd_num(rs.getInt("PROD_NUM"));
                vo.setBanner_order(rs.getInt("BANNER_ORDER"));
                vo.setBanner_status(rs.getString("BANNER_STATUS"));
                vo.setProd_name(rs.getString("PROD_NAME")); // 조인된 상품명
                list.add(vo);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 2. [사용자용] 메인 페이지 노출 배너 (상태가 'Y'인 것만)
    public List<BannerVO> getMainBanners() throws Exception {
        List<BannerVO> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        
        String sql = "SELECT * FROM BANNERS WHERE BANNER_STATUS = 'Y' ORDER BY BANNER_ORDER ASC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                BannerVO vo = new BannerVO();
                vo.setBanner_num(rs.getInt("BANNER_NUM"));
                vo.setBanner_title(rs.getString("BANNER_TITLE"));
                vo.setBanner_img(rs.getString("BANNER_IMG"));
                vo.setProd_num(rs.getInt("PROD_NUM"));
                list.add(vo);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 3. 신규 배너 등록
    public void insertBanner(BannerVO vo) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        
        // 형님 DB 시퀀스명이 BANNERS_SEQ 가 맞는지 꼭 확인해 주세요!
        String sql = "INSERT INTO BANNERS (BANNER_NUM, BANNER_TITLE, BANNER_IMG, PROD_NUM, BANNER_ORDER, BANNER_STATUS) "
                   + "VALUES (BANNERS_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, vo.getBanner_title());
            pstmt.setString(2, vo.getBanner_img());
            pstmt.setInt(3, vo.getProd_num());
            pstmt.setInt(4, vo.getBanner_order());
            pstmt.setString(5, vo.getBanner_status());
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }
}