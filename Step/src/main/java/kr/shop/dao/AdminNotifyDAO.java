package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import kr.shop.vo.UserNotifyVO; // ← AdminNotifyVO 없으므로 UserNotifyVO 사용

public class AdminNotifyDAO {

    private static AdminNotifyDAO instance = new AdminNotifyDAO();
    public static AdminNotifyDAO getInstance() { return instance; }
    private AdminNotifyDAO() {}

    // ─────────────────────────────────────────
    // 1. 공지 일괄 발송 (전체 / 등급 / 특정회원)
    // ─────────────────────────────────────────
    public int insertNoticeByCondition(UserNotifyVO vo, String targetType, String targetValue) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int insertedCount = 0;
        try {
            conn = DBUtil.getConnection();
            String sql = "";

            if ("USER".equals(targetType)) {
                sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT) " +
                      "SELECT NOTIFY_SEQ.NEXTVAL, USER_NUM, ?, ?, ? " +
                      "FROM USERS WHERE USER_ID = ? AND AUTH = 2";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, vo.getNotify_type());
                pstmt.setString(2, vo.getNotify_title());
                pstmt.setString(3, vo.getNotify_content());
                pstmt.setString(4, targetValue);

            } else if ("GRADE".equals(targetType)) {
                sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT) " +
                      "SELECT NOTIFY_SEQ.NEXTVAL, u.USER_NUM, ?, ?, ? " +
                      "FROM USERS u JOIN USERS_DETAIL ud ON u.USER_NUM = ud.USER_NUM " +
                      "WHERE u.AUTH = 2 AND ud.GRADE = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, vo.getNotify_type());
                pstmt.setString(2, vo.getNotify_title());
                pstmt.setString(3, vo.getNotify_content());
                pstmt.setInt(4, Integer.parseInt(targetValue));

            } else { // ALL
                sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT) " +
                      "SELECT NOTIFY_SEQ.NEXTVAL, USER_NUM, ?, ?, ? " +
                      "FROM USERS WHERE AUTH = 2";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, vo.getNotify_type());
                pstmt.setString(2, vo.getNotify_title());
                pstmt.setString(3, vo.getNotify_content());
            }

            insertedCount = pstmt.executeUpdate();
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
        return insertedCount;
    }

    // ─────────────────────────────────────────
    // 2. 알림 이력 총 개수
    // ─────────────────────────────────────────
    public int getNotifyTotalCount(UserNotifyVO vo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        StringBuilder sql = new StringBuilder();
        try {
            conn = DBUtil.getConnection();
            sql.append("SELECT COUNT(*) FROM NOTIFY n ")
               .append("JOIN USERS u ON n.USER_NUM = u.USER_NUM ")
               .append("LEFT JOIN USERS_DETAIL ud ON u.USER_NUM = ud.USER_NUM ");

            boolean hasType    = (vo.getNotify_type() > 0);
            boolean hasKeyword = (vo.getKeyword() != null && !vo.getKeyword().trim().isEmpty());

            if (hasType || hasKeyword) sql.append("WHERE ");
            if (hasType)               sql.append("n.NOTIFY_TYPE = ? ");
            if (hasType && hasKeyword) sql.append("AND ");
            if (hasKeyword)            sql.append("(u.USER_ID LIKE ? OR ud.USER_NAME LIKE ? OR n.NOTIFY_TITLE LIKE ?) ");

            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (hasType) pstmt.setInt(idx++, vo.getNotify_type());
            if (hasKeyword) {
                String kw = "%" + vo.getKeyword() + "%";
                pstmt.setString(idx++, kw);
                pstmt.setString(idx++, kw);
                pstmt.setString(idx++, kw);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return count;
    }

    // ─────────────────────────────────────────
    // 3. 알림 이력 목록 조회 (페이징)
    // ─────────────────────────────────────────
    public List<UserNotifyVO> getNotifyList(UserNotifyVO vo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UserNotifyVO> list = new ArrayList<>();
        StringBuilder sub_sql = new StringBuilder();

        try {
            conn = DBUtil.getConnection();
            boolean hasType    = (vo.getNotify_type() > 0);
            boolean hasKeyword = (vo.getKeyword() != null && !vo.getKeyword().trim().isEmpty());

            if (hasType || hasKeyword) sub_sql.append("WHERE ");
            if (hasType)               sub_sql.append("n.NOTIFY_TYPE = ? ");
            if (hasType && hasKeyword) sub_sql.append("AND ");
            if (hasKeyword)            sub_sql.append("(u.USER_ID LIKE ? OR ud.USER_NAME LIKE ? OR n.NOTIFY_TITLE LIKE ?) ");

            String sql = "SELECT * FROM ( " +
                         "  SELECT a.*, ROWNUM rnum FROM ( " +
                         "    SELECT n.NOTIFY_NUM, n.NOTIFY_TYPE, n.NOTIFY_TITLE, n.NOTIFY_CONTENT, " +
                         "           n.READ_YN, n.NOTIFY_CREATED_AT, u.USER_ID, ud.USER_NAME " +
                         "    FROM NOTIFY n " +
                         "    JOIN USERS u ON n.USER_NUM = u.USER_NUM " +
                         "    LEFT JOIN USERS_DETAIL ud ON u.USER_NUM = ud.USER_NUM " +
                         sub_sql.toString() +
                         "    ORDER BY n.NOTIFY_NUM DESC " +
                         "  ) a " +
                         ") WHERE rnum >= ? AND rnum <= ?";

            pstmt = conn.prepareStatement(sql);
            int idx = 1;
            if (hasType) pstmt.setInt(idx++, vo.getNotify_type());
            if (hasKeyword) {
                String kw = "%" + vo.getKeyword() + "%";
                pstmt.setString(idx++, kw);
                pstmt.setString(idx++, kw);
                pstmt.setString(idx++, kw);
            }
            pstmt.setInt(idx++, vo.getStart_row());
            pstmt.setInt(idx++, vo.getEnd_row());

            rs = pstmt.executeQuery();
            while (rs.next()) {
                UserNotifyVO nvo = new UserNotifyVO();
                nvo.setNotify_num(rs.getInt("NOTIFY_NUM"));
                nvo.setNotify_type(rs.getInt("NOTIFY_TYPE"));
                nvo.setNotify_title(rs.getString("NOTIFY_TITLE"));
                nvo.setNotify_content(rs.getString("NOTIFY_CONTENT"));
                nvo.setRead_yn(rs.getString("READ_YN"));
                nvo.setNotify_created_at(rs.getDate("NOTIFY_CREATED_AT"));
                nvo.setUser_id(rs.getString("USER_ID"));
                nvo.setUser_name(rs.getString("USER_NAME"));
                list.add(nvo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    // ─────────────────────────────────────────
    // 4. 재입고: 해당 상품 찜한 유저 목록
    // ─────────────────────────────────────────
    public List<Integer> getUserNumsByProdNum(int prod_num) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Integer> userNums = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT USER_NUM FROM WISH WHERE PROD_NUM = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, prod_num);
            rs = pstmt.executeQuery();
            while (rs.next()) userNums.add(rs.getInt("USER_NUM"));
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return userNums;
    }

    // ─────────────────────────────────────────
    // 5. 상품명 조회
    // ─────────────────────────────────────────
    public String getProdNameByNum(int prod_num) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String prodName = "";
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT PROD_NAME FROM PRODUCT WHERE PROD_NUM = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, prod_num);
            rs = pstmt.executeQuery();
            if (rs.next()) prodName = rs.getString("PROD_NAME");
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return prodName;
    }
}