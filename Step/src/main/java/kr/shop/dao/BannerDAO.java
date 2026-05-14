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
    
        // 1. 관리자용 리스트 (BANNER_SORT_NO 기준 정렬)
        public List<BannerVO> getAdminBannerList() throws Exception {
            List<BannerVO> list = new ArrayList<>();
            Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
            
            String sql = "SELECT b.*, p.PROD_NAME FROM BANNERS b "
                       + "JOIN PRODUCTS p ON b.PROD_NUM = p.PROD_NUM "
                       + "ORDER BY b.BANNER_SORT_NO ASC";
            try {
                conn = DBUtil.getConnection();
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while(rs.next()) {
                    BannerVO vo = new BannerVO();
                    vo.setBanner_num(rs.getInt("BANNER_NUM"));
                    vo.setBanner_title(rs.getString("BANNER_TITLE"));
                    vo.setBanner_img_url(rs.getString("BANNER_IMG_URL"));
                    vo.setBanner_sort_no(rs.getInt("BANNER_SORT_NO"));
                    vo.setBanner_use_yn(rs.getString("BANNER_USE_YN"));
                    vo.setProd_num(rs.getInt("PROD_NUM"));
                    vo.setProd_name(rs.getString("PROD_NAME")); 
                    list.add(vo);
                }
            } finally { DBUtil.executeClose(rs, pstmt, conn); }
            return list;
        }

        // 2. 메인 페이지 노출용 배너
        public List<BannerVO> getMainBanners() throws Exception {
            List<BannerVO> list = new ArrayList<>();
            Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
            
            String sql = "SELECT * FROM BANNERS WHERE BANNER_USE_YN = 'Y' ORDER BY BANNER_SORT_NO ASC";
            try {
                conn = DBUtil.getConnection();
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while(rs.next()) {
                    BannerVO vo = new BannerVO();
                    vo.setBanner_num(rs.getInt("BANNER_NUM"));
                    vo.setBanner_title(rs.getString("BANNER_TITLE"));
                    vo.setBanner_img_url(rs.getString("BANNER_IMG_URL"));
                    vo.setProd_num(rs.getInt("PROD_NUM"));
                    list.add(vo);
                }
            } finally { DBUtil.executeClose(rs, pstmt, conn); }
            return list;
        }

        // 3. 신규 배너 등록
        public void insertBanner(BannerVO vo) throws Exception {
            Connection conn = null; PreparedStatement pstmt = null;
            
            String sql = "INSERT INTO BANNERS (BANNER_NUM, BANNER_TITLE, BANNER_IMG_URL, PROD_NUM, BANNER_SORT_NO, BANNER_USE_YN, POS, BANNER_START_DAY, BANNER_END_DAY) "
                       + "VALUES (BANNERS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, 1, SYSDATE, SYSDATE + 365)";
            try {
                conn = DBUtil.getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, vo.getBanner_title());
                pstmt.setString(2, vo.getBanner_img_url());
                pstmt.setInt(3, vo.getProd_num());
                pstmt.setInt(4, vo.getBanner_sort_no());
                pstmt.setString(5, vo.getBanner_use_yn());
                pstmt.executeUpdate();
            } finally { DBUtil.executeClose(null, pstmt, conn); }
        }


        // 4. 배너 1건 상세 조회 (수정 폼에 데이터 불러올 때 사용)

        public BannerVO getBanner(int banner_num) throws Exception {
            Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
            BannerVO vo = null;
            String sql = "SELECT * FROM BANNERS WHERE BANNER_NUM = ?";
            try {
                conn = DBUtil.getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, banner_num);
                rs = pstmt.executeQuery();
                if(rs.next()) {
                    vo = new BannerVO();
                    vo.setBanner_num(rs.getInt("BANNER_NUM"));
                    vo.setBanner_title(rs.getString("BANNER_TITLE"));
                    vo.setBanner_img_url(rs.getString("BANNER_IMG_URL"));
                    vo.setProd_num(rs.getInt("PROD_NUM"));
                    vo.setBanner_sort_no(rs.getInt("BANNER_SORT_NO"));
                    vo.setBanner_use_yn(rs.getString("BANNER_USE_YN"));
                }
            } finally { DBUtil.executeClose(rs, pstmt, conn); }
            return vo;
        }


        // 5. 배너 수정
        // (이미지를 새로 올렸을 때와 안 올렸을 때를 구분해서 업데이트)

        public void updateBanner(BannerVO vo) throws Exception {
            Connection conn = null; PreparedStatement pstmt = null;
            String sql = "";
            int cnt = 0;
            try {
                conn = DBUtil.getConnection();
                // 이미지가 첨부된 경우 (이미지명도 업데이트)
                if (vo.getBanner_img_url() != null && !vo.getBanner_img_url().isEmpty()) {
                    sql = "UPDATE BANNERS SET BANNER_TITLE=?, PROD_NUM=?, BANNER_SORT_NO=?, BANNER_USE_YN=?, BANNER_IMG_URL=? WHERE BANNER_NUM=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(++cnt, vo.getBanner_title());
                    pstmt.setInt(++cnt, vo.getProd_num());
                    pstmt.setInt(++cnt, vo.getBanner_sort_no());
                    pstmt.setString(++cnt, vo.getBanner_use_yn());
                    pstmt.setString(++cnt, vo.getBanner_img_url());
                    pstmt.setInt(++cnt, vo.getBanner_num());
                } 
                // 이미지를 변경하지 않은 경우 (나머지 정보만 업데이트)
                else {
                    sql = "UPDATE BANNERS SET BANNER_TITLE=?, PROD_NUM=?, BANNER_SORT_NO=?, BANNER_USE_YN=? WHERE BANNER_NUM=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(++cnt, vo.getBanner_title());
                    pstmt.setInt(++cnt, vo.getProd_num());
                    pstmt.setInt(++cnt, vo.getBanner_sort_no());
                    pstmt.setString(++cnt, vo.getBanner_use_yn());
                    pstmt.setInt(++cnt, vo.getBanner_num());
                }
                pstmt.executeUpdate();
            } finally { DBUtil.executeClose(null, pstmt, conn); }
        }

      
        // 6. 배너 삭제
      
        public void deleteBanner(int banner_num) throws Exception {
            Connection conn = null; PreparedStatement pstmt = null;
            String sql = "DELETE FROM BANNERS WHERE BANNER_NUM = ?";
            try {
                conn = DBUtil.getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, banner_num);
                pstmt.executeUpdate();
            } finally { DBUtil.executeClose(null, pstmt, conn); }
        }
    }