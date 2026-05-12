package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class CategoryDAO {

    private static CategoryDAO instance = new CategoryDAO();
    public static CategoryDAO getInstance() { return instance; }
    private CategoryDAO() {}

    // 카테고리 목록 조회 (정렬 순서 기준)
    public List<Map<String, Object>> getCategoryList(String keyword, String useYn) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT CAT_NUM, CAT_NAME, CAT_USE_YN, CAT_SORT_NO FROM CATEGORIES WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND CAT_NAME LIKE ? ");
        if (useYn != null && !useYn.trim().isEmpty())
            sql.append("AND CAT_USE_YN = ? ");
        sql.append("ORDER BY CAT_SORT_NO ASC");

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
                map.put("catNum",    rs.getInt("CAT_NUM"));
                map.put("catName",   rs.getString("CAT_NAME"));
                map.put("catUseYn",  rs.getString("CAT_USE_YN"));
                map.put("catSortNo", rs.getInt("CAT_SORT_NO"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 전체 카테고리 수
    public int getTotalCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM CATEGORIES");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }

    // 활성 카테고리 수
    public int getActiveCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM CATEGORIES WHERE CAT_USE_YN = 'Y'");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }

    // 카테고리 등록
    public void insertCategory(String catName, String catUseYn, int catSortNo) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "INSERT INTO CATEGORIES (CAT_NUM, CAT_NAME, CAT_USE_YN, CAT_SORT_NO) "
                   + "VALUES (CATEGORIES_SEQ.NEXTVAL, ?, ?, ?)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, catName);
            pstmt.setString(2, catUseYn);
            pstmt.setInt(3, catSortNo);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 카테고리 수정
    public void updateCategory(int catNum, String catName, String catUseYn, int catSortNo) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "UPDATE CATEGORIES SET CAT_NAME = ?, CAT_USE_YN = ?, CAT_SORT_NO = ? WHERE CAT_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, catName);
            pstmt.setString(2, catUseYn);
            pstmt.setInt(3, catSortNo);
            pstmt.setInt(4, catNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 활성화/비활성화 토글
    public void toggleCategory(int catNum, String catUseYn) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "UPDATE CATEGORIES SET CAT_USE_YN = ? WHERE CAT_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, catUseYn);
            pstmt.setInt(2, catNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 카테고리 삭제
    public void deleteCategory(int catNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "DELETE FROM CATEGORIES WHERE CAT_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, catNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 순서 변경 (▲▼ 버튼)
    public void sortCategory(int catNum, String direction) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 현재 순서 조회
            String curSql = "SELECT CAT_SORT_NO FROM CATEGORIES WHERE CAT_NUM = ?";
            pstmt = conn.prepareStatement(curSql);
            pstmt.setInt(1, catNum);
            rs = pstmt.executeQuery();
            int curSort = 0;
            if (rs.next()) curSort = rs.getInt("CAT_SORT_NO");
            rs.close(); pstmt.close();

            // 교환할 대상 순서 계산
            int targetSort = "up".equals(direction) ? curSort - 1 : curSort + 1;

            // 대상 카테고리 번호 조회
            String targetSql = "SELECT CAT_NUM FROM CATEGORIES WHERE CAT_SORT_NO = ?";
            pstmt = conn.prepareStatement(targetSql);
            pstmt.setInt(1, targetSort);
            rs = pstmt.executeQuery();
            int targetNum = 0;
            if (rs.next()) targetNum = rs.getInt("CAT_NUM");
            rs.close(); pstmt.close();

            if (targetNum == 0) { conn.commit(); return; } // 교환 대상 없음

            // 순서 스왑
            String swapSql = "UPDATE CATEGORIES SET CAT_SORT_NO = ? WHERE CAT_NUM = ?";
            pstmt = conn.prepareStatement(swapSql);
            pstmt.setInt(1, targetSort); pstmt.setInt(2, catNum);
            pstmt.executeUpdate(); pstmt.close();

            pstmt = conn.prepareStatement(swapSql);
            pstmt.setInt(1, curSort); pstmt.setInt(2, targetNum);
            pstmt.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
    }
}
