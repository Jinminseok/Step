package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class BrandDAO {
	private static BrandDAO instance = new BrandDAO();
    public static BrandDAO getInstance() { return instance; }
    private BrandDAO() {}

    // 브랜드 목록 조회 (검색 + 필터)
    public List<Map<String, Object>> getBrandList(String keyword, String useYn) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT BRAND_NUM, BRAND_NAME, BRAND_USE_YN FROM BRANDS WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND BRAND_NAME LIKE ? ");
        if (useYn != null && !useYn.trim().isEmpty())
            sql.append("AND BRAND_USE_YN = ? ");
        sql.append("ORDER BY BRAND_NUM DESC");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty())
                pstmt.setString(idx++, "%" + keyword + "%");
            if (useYn != null && !useYn.trim().isEmpty())
                pstmt.setString(idx++, useYn);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("brandNum",   rs.getInt("BRAND_NUM"));
                map.put("brandName",  rs.getString("BRAND_NAME"));
                map.put("brandUseYn", rs.getString("BRAND_USE_YN"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 전체 브랜드 수
    public int getTotalCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM BRANDS");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }

    // 활성 브랜드 수
    public int getActiveCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM BRANDS WHERE BRAND_USE_YN = 'Y'");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }

    // 브랜드 등록
    public void insertBrand(String brandName, String brandUseYn) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();

            // 현재 최대 번호 조회
            String maxSql = "SELECT NVL(MAX(BRAND_NUM), 0) + 1 FROM BRANDS";
            pstmt = conn.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            int nextNum = 1;
            if (rs.next()) nextNum = rs.getInt(1);
            rs.close();
            pstmt.close();

            // MAX+1 번호로 INSERT
            String sql = "INSERT INTO BRANDS (BRAND_NUM, BRAND_NAME, BRAND_USE_YN) "
                       + "VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, nextNum);
            pstmt.setString(2, brandName);
            pstmt.setString(3, brandUseYn);
            pstmt.executeUpdate();

        } finally { DBUtil.executeClose(rs, pstmt, conn); }
    }
 // 브랜드명 중복 체크
    public boolean isBrandNameDuplicate(String brandName) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isDuplicate = false;

        String sql = "SELECT COUNT(*) FROM BRANDS WHERE BRAND_NAME = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, brandName);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                isDuplicate = rs.getInt(1) > 0;
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return isDuplicate;
    }

    // 브랜드 수정
    public void updateBrand(int brandNum, String brandName, String brandUseYn) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "UPDATE BRANDS SET BRAND_NAME = ?, BRAND_USE_YN = ? WHERE BRAND_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, brandName);
            pstmt.setString(2, brandUseYn);
            pstmt.setInt(3, brandNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 활성화/비활성화 토글
    public void toggleBrand(int brandNum, String brandUseYn) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "UPDATE BRANDS SET BRAND_USE_YN = ? WHERE BRAND_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, brandUseYn);
            pstmt.setInt(2, brandNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 브랜드 삭제
    public void deleteBrand(int brandNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "DELETE FROM BRANDS WHERE BRAND_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, brandNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }
}
