package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class MemberDAO {

    private static MemberDAO instance = new MemberDAO();
    public static MemberDAO getInstance() { return instance; }
    private MemberDAO() {}

    // 회원 목록 조회
    public List<Map<String, Object>> getMemberList(String keyword, String grade) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.USER_ID, u.AUTH, d.USER_NUM, d.USER_NAME, d.EMAIL, d.PHONE, ");
        sql.append("       d.GRADE, d.USER_CREATED_AT, d.LAST_LOGIN ");
        sql.append("FROM USERS_DETAIL d JOIN USERS u ON u.USER_NUM = d.USER_NUM ");
        sql.append("WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND (d.USER_NAME LIKE ? OR d.EMAIL LIKE ? OR d.PHONE LIKE ?) ");
        if (grade != null && !grade.trim().isEmpty())
            sql.append("AND d.GRADE = ? ");
        sql.append("ORDER BY d.USER_CREATED_AT DESC");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword + "%";
                pstmt.setString(idx++, kw);
                pstmt.setString(idx++, kw);
                pstmt.setString(idx++, kw);
            }
            if (grade != null && !grade.trim().isEmpty())
                pstmt.setInt(idx++, Integer.parseInt(grade));
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId",    rs.getString("USER_ID"));
                map.put("auth",      rs.getInt("AUTH"));
                map.put("userNum",   rs.getInt("USER_NUM"));
                map.put("userName",  rs.getString("USER_NAME"));
                map.put("email",     rs.getString("EMAIL"));
                map.put("phone",     rs.getString("PHONE"));
                map.put("grade",     rs.getInt("GRADE"));
                map.put("createdAt", rs.getString("USER_CREATED_AT"));
                map.put("lastLogin", rs.getString("LAST_LOGIN"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 회원 단건 조회
    public Map<String, Object> getMemberDetail(int userNum) throws Exception {
        Map<String, Object> map = new HashMap<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT u.USER_ID, u.AUTH, d.USER_NUM, d.USER_NAME, d.EMAIL, d.PHONE, "
                   + "d.ZIPCODE, d.ADDR1, d.ADDR2, d.GRADE, d.USER_CREATED_AT, d.LAST_LOGIN "
                   + "FROM USERS_DETAIL d JOIN USERS u ON u.USER_NUM = d.USER_NUM "
                   + "WHERE d.USER_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                map.put("userId",    rs.getString("USER_ID"));
                map.put("auth",      rs.getInt("AUTH"));
                map.put("userNum",   rs.getInt("USER_NUM"));
                map.put("userName",  rs.getString("USER_NAME"));
                map.put("email",     rs.getString("EMAIL"));
                map.put("phone",     rs.getString("PHONE"));
                map.put("zipcode",   rs.getString("ZIPCODE"));
                map.put("addr1",     rs.getString("ADDR1"));
                map.put("addr2",     rs.getString("ADDR2"));
                map.put("grade",     rs.getInt("GRADE"));
                map.put("createdAt", rs.getString("USER_CREATED_AT"));
                map.put("lastLogin", rs.getString("LAST_LOGIN"));
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return map;
    }

 // 등급 변경
    public void updateGrade(int userNum, int grade) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "UPDATE USERS_DETAIL SET GRADE = ? WHERE USER_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);          // ← 추가
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, grade);
            pstmt.setInt(2, userNum);
            pstmt.executeUpdate();
            conn.commit();                      // ← 추가
        } catch (Exception e) {
            if (conn != null) conn.rollback();  // ← 추가
            throw e;
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 회원 삭제
    public void deleteMember(int userNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // USERS_DETAIL 먼저 삭제 (FK 제약)
            pstmt = conn.prepareStatement("DELETE FROM USERS_DETAIL WHERE USER_NUM = ?");
            pstmt.setInt(1, userNum);
            pstmt.executeUpdate();
            pstmt.close();

            // USERS 삭제
            pstmt = conn.prepareStatement("DELETE FROM USERS WHERE USER_NUM = ?");
            pstmt.setInt(1, userNum);
            pstmt.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 전체 회원 수
    public int getTotalCount() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM USERS_DETAIL");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }

    // 등급별 회원 수
    public int getCountByGrade(int grade) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int count = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM USERS_DETAIL WHERE GRADE = ?");
            pstmt.setInt(1, grade);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return count;
    }
}