package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import kr.shop.vo.UserNotifyVO;

public class UserNotifyDAO {

	private static UserNotifyDAO instance = new UserNotifyDAO();
	public static UserNotifyDAO getInstance() { return instance; }
	private UserNotifyDAO() {}

	// 1. 알림 INSERT (회원가입/배송/재입고 공통)
	public void insertNotify(UserNotifyVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT, REF_ID) " +
					"VALUES (NOTIFY_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, vo.getUser_num());
			pstmt.setInt(2, vo.getNotify_type());
			pstmt.setString(3, vo.getNotify_title());
			pstmt.setString(4, vo.getNotify_content());
			if (vo.getRef_id() == 0) {
				pstmt.setNull(5, java.sql.Types.NUMERIC);
			} else {
				pstmt.setInt(5, vo.getRef_id());
			}
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	// 2. 미읽음 개수 조회
	public int getUnreadCount(int user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT COUNT(*) FROM NOTIFY WHERE USER_NUM = ? AND READ_YN = 'N'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_num);
			rs = pstmt.executeQuery();
			if (rs.next()) count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 3. 알림 목록 조회 (최대 20개)
	public List<UserNotifyVO> getNotifyList(int user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<UserNotifyVO> list = new ArrayList<>();

		SimpleDateFormat todayFmt = new SimpleDateFormat("HH:mm");
		SimpleDateFormat dateFmt  = new SimpleDateFormat("M월 d일");
		SimpleDateFormat fullFmt  = new SimpleDateFormat("yyyy-MM-dd");
		String today = fullFmt.format(new java.util.Date());

		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM ( " +
					"  SELECT NOTIFY_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT, " +
					"         READ_YN, NOTIFY_CREATED_AT " +
					"  FROM NOTIFY WHERE USER_NUM = ? " +
					"  ORDER BY NOTIFY_CREATED_AT DESC " +
					") WHERE ROWNUM <= 20";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_num);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				UserNotifyVO vo = new UserNotifyVO();
				vo.setNotify_num(rs.getInt("NOTIFY_NUM"));
				vo.setNotify_type(rs.getInt("NOTIFY_TYPE"));
				vo.setNotify_title(rs.getString("NOTIFY_TITLE"));
				vo.setNotify_content(rs.getString("NOTIFY_CONTENT"));
				vo.setRead_yn(rs.getString("READ_YN"));

				java.sql.Date sqlDate = rs.getDate("NOTIFY_CREATED_AT");
				vo.setNotify_created_at(sqlDate);

				java.util.Date created = new java.util.Date(sqlDate.getTime());
				String createdStr = fullFmt.format(created);
				if (createdStr.equals(today)) {
					vo.setFormatted_date(todayFmt.format(created));
				} else {
					vo.setFormatted_date(dateFmt.format(created));
				}
				list.add(vo);
			}
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return list;
	}

	// 4. 전체 읽음 처리
	public void markAllAsRead(int user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE NOTIFY SET READ_YN = 'Y' WHERE USER_NUM = ? AND READ_YN = 'N'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_num);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}

	// 5. 단건 읽음 처리
	public void markAsRead(int notify_num, int user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE NOTIFY SET READ_YN = 'Y' WHERE NOTIFY_NUM = ? AND USER_NUM = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notify_num);
			pstmt.setInt(2, user_num);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
	// 6. 알림 단건 삭제
	public void deleteNotify(int notify_num, int user_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			// user_num 조건 추가로 본인 알림만 삭제 가능
			String sql = "DELETE FROM NOTIFY WHERE NOTIFY_NUM = ? AND USER_NUM = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notify_num);
			pstmt.setInt(2, user_num);
			pstmt.executeUpdate();
		} finally {
			DBUtil.executeClose(null, pstmt, conn);
		}
	}
}