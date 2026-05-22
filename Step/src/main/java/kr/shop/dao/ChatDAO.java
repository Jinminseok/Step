package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.util.DBUtil;

public class ChatDAO {

    private static ChatDAO instance = new ChatDAO();
    public static ChatDAO getInstance() { return instance; }
    private ChatDAO() {}

    // 사용자 채팅방 조회만 (없으면 -1 반환 - 방 생성 안 함)
    public int getRoomByUser(int userNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(
                "SELECT ROOM_NUM FROM CHAT_ROOMS WHERE USER_NUM = ? AND ROOM_STATUS = 1");
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("ROOM_NUM");
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return -1; // 채팅방 없음
    }

    // 채팅방 생성 (첫 메시지 보낼 때만 호출)
    public int createRoom(int userNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(
                "INSERT INTO CHAT_ROOMS (ROOM_NUM, USER_NUM, ROOM_STATUS, ROOM_CREATED_AT) " +
                "VALUES (CHAT_ROOMS_SEQ.NEXTVAL, ?, 1, SYSDATE)");
            pstmt.setInt(1, userNum);
            pstmt.executeUpdate();
            pstmt.close();

            pstmt = conn.prepareStatement(
                "SELECT ROOM_NUM FROM CHAT_ROOMS WHERE USER_NUM = ? AND ROOM_STATUS = 1");
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("ROOM_NUM");
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return -1;
    }

    // 메시지 목록 조회
    public List<Map<String, Object>> getMsgList(int roomNum) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT m.MSG_NUM, m.MSG_SENDER, m.MSG_SENDER_NUM, m.IS_READ, " +
                     "       TO_CHAR(m.MSG_CREATED_AT, 'HH24:MI') AS MSG_TIME, " +
                     "       DBMS_LOB.SUBSTR(m.MSG_CONTENT, 4000, 1) AS MSG_CONTENT, " +
                     "       ud.USER_NAME " +
                     "FROM CHAT_MSGS m " +
                     "JOIN USERS_DETAIL ud ON m.MSG_SENDER_NUM = ud.USER_NUM " +
                     "WHERE m.ROOM_NUM = ? ORDER BY m.MSG_NUM ASC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, roomNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("msgNum",     rs.getInt("MSG_NUM"));
                map.put("msgSender",  rs.getInt("MSG_SENDER"));
                map.put("senderNum",  rs.getInt("MSG_SENDER_NUM"));
                map.put("senderName", rs.getString("USER_NAME"));
                map.put("msgContent", rs.getString("MSG_CONTENT"));
                map.put("msgTime",    rs.getString("MSG_TIME"));
                map.put("isRead",     rs.getInt("IS_READ"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 메시지 전송 (방 없으면 자동 생성)
    public int sendMsg(int userNum, int senderType, String content, int roomNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); 

            // 방이 없으면 같은 커넥션으로 생성
            if (roomNum <= 0) {
                //먼저 기존 방이 있는지 확인
                pstmt = conn.prepareStatement(
                    "SELECT ROOM_NUM FROM CHAT_ROOMS WHERE USER_NUM = ? AND ROOM_STATUS = 1");
                pstmt.setInt(1, userNum);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    roomNum = rs.getInt("ROOM_NUM"); // 기존 방 재사용
                }
                rs.close();
                pstmt.close();

                //기존 방이 없을 때만 새로 생성
                if (roomNum <= 0) {
                    pstmt = conn.prepareStatement(
                        "INSERT INTO CHAT_ROOMS (ROOM_NUM, USER_NUM, ROOM_STATUS, ROOM_CREATED_AT) " +
                        "VALUES (CHAT_ROOMS_SEQ.NEXTVAL, ?, 1, SYSDATE)");
                    pstmt.setInt(1, userNum);
                    pstmt.executeUpdate();
                    pstmt.close();

                    pstmt = conn.prepareStatement(
                        "SELECT ROOM_NUM FROM CHAT_ROOMS WHERE USER_NUM = ? AND ROOM_STATUS = 1 " +
                        "ORDER BY ROOM_NUM DESC");
                    pstmt.setInt(1, userNum);
                    rs = pstmt.executeQuery();
                    if (rs.next()) roomNum = rs.getInt("ROOM_NUM");
                    rs.close();
                    pstmt.close();
                }
            }

            // 메시지 INSERT (방이 확실히 존재하는 상태)
            pstmt = conn.prepareStatement(
                "INSERT INTO CHAT_MSGS " +
                "(MSG_NUM, ROOM_NUM, MSG_SENDER, MSG_SENDER_NUM, MSG_CONTENT, MSG_CREATED_AT, IS_READ) " +
                "VALUES (CHAT_MSGS_SEQ.NEXTVAL, ?, ?, ?, ?, SYSDATE, 0)");
            pstmt.setInt(1, roomNum);
            pstmt.setInt(2, senderType);
            pstmt.setInt(3, userNum);
            pstmt.setString(4, content);
            pstmt.executeUpdate();
            pstmt.close();

            // 관리자 답변이면 ADMIN_NUM 업데이트
            if (senderType == 2) {
                pstmt = conn.prepareStatement(
                    "UPDATE CHAT_ROOMS SET ADMIN_NUM = ? WHERE ROOM_NUM = ? AND ADMIN_NUM IS NULL");
                pstmt.setInt(1, userNum);
                pstmt.setInt(2, roomNum);
                pstmt.executeUpdate();
            }

            conn.commit(); // ← 한번에 커밋
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return roomNum;
    }

    // 읽음 처리
    public void markRead(int roomNum, int senderType) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(
                "UPDATE CHAT_MSGS SET IS_READ = 1 WHERE ROOM_NUM = ? AND MSG_SENDER = ? AND IS_READ = 0");
            pstmt.setInt(1, roomNum);
            pstmt.setInt(2, senderType);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 관리자용: 메시지가 있는 채팅방만 목록 조회
    public List<Map<String, Object>> getRoomList() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        String sql = "SELECT r.ROOM_NUM, r.USER_NUM, r.ROOM_STATUS, " +
                     "       TO_CHAR(r.ROOM_CREATED_AT, 'MM/DD HH24:MI') AS CREATED_AT, " +
                     "       ud.USER_NAME, " +
                     "       (SELECT COUNT(*) FROM CHAT_MSGS m " +
                     "        WHERE m.ROOM_NUM = r.ROOM_NUM AND m.MSG_SENDER = 1 AND m.IS_READ = 0) AS UNREAD_CNT, " +
                     "       (SELECT DBMS_LOB.SUBSTR(m2.MSG_CONTENT, 50, 1) FROM CHAT_MSGS m2 " +
                     "        WHERE m2.MSG_NUM = (SELECT MAX(MSG_NUM) FROM CHAT_MSGS WHERE ROOM_NUM = r.ROOM_NUM)) AS LAST_MSG, " +
                     "       (SELECT TO_CHAR(MAX(MSG_CREATED_AT), 'MM/DD HH24:MI') FROM CHAT_MSGS WHERE ROOM_NUM = r.ROOM_NUM) AS LAST_TIME " +
                     "FROM CHAT_ROOMS r " +
                     "JOIN USERS_DETAIL ud ON r.USER_NUM = ud.USER_NUM " +
                     // 메시지가 1개 이상 있는 방만 표시
                     "WHERE EXISTS (SELECT 1 FROM CHAT_MSGS WHERE ROOM_NUM = r.ROOM_NUM) " +
                     "ORDER BY LAST_TIME DESC NULLS LAST, r.ROOM_NUM DESC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("roomNum",    rs.getInt("ROOM_NUM"));
                map.put("userNum",    rs.getInt("USER_NUM"));
                map.put("userName",   rs.getString("USER_NAME"));
                map.put("roomStatus", rs.getInt("ROOM_STATUS"));
                map.put("createdAt",  rs.getString("CREATED_AT"));
                map.put("unreadCnt",  rs.getInt("UNREAD_CNT"));
                map.put("lastMsg",    rs.getString("LAST_MSG"));
                map.put("lastTime",   rs.getString("LAST_TIME"));
                list.add(map);
            }
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return list;
    }

    // 채팅방 삭제 (메시지 포함 - CASCADE)
    public void deleteRoom(int roomNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            // CHAT_MSGS는 ON DELETE CASCADE라서 자동 삭제됨
            pstmt = conn.prepareStatement(
                "DELETE FROM CHAT_ROOMS WHERE ROOM_NUM = ?");
            pstmt.setInt(1, roomNum);
            pstmt.executeUpdate();
        } finally { DBUtil.executeClose(null, pstmt, conn); }
    }

    // 전체 안읽은 메시지 수
    public int getTotalUnread() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int cnt = 0;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM CHAT_MSGS WHERE MSG_SENDER = 1 AND IS_READ = 0");
            rs = pstmt.executeQuery();
            if (rs.next()) cnt = rs.getInt(1);
        } finally { DBUtil.executeClose(rs, pstmt, conn); }
        return cnt;
    }
}