package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import kr.shop.vo.AdminNotifyVO;

public class AdminNotifyDAO {

	private static AdminNotifyDAO instance = new AdminNotifyDAO();

	public static AdminNotifyDAO getInstance() {
		return instance;
	}

	private AdminNotifyDAO() {
	}

	// 1. 일반 개별 알림 발송 (배송/재입고 등)
	public void insertNotify(AdminNotifyVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = DBUtil.getConnection();
			sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT, REF_ID) "
					+ "VALUES (NOTIFY_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";

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

	// 2. [동적 발송] 발송 대상(전체, 등급, 특정ID)에 따른 공지 일괄 전송
	public int insertNoticeByCondition(AdminNotifyVO vo, String targetType, String targetValue) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		int insertedCount = 0;

		try {
			conn = DBUtil.getConnection();

			if ("USER".equals(targetType)) {
				// 특정 회원 ID 발송
				sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT) "
						+ "SELECT NOTIFY_SEQ.NEXTVAL, USER_NUM, ?, ?, ? " + "FROM USERS WHERE USER_ID = ? AND AUTH = 2";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, vo.getNotify_type());
				pstmt.setString(2, vo.getNotify_title());
				pstmt.setString(3, vo.getNotify_content());
				pstmt.setString(4, targetValue);

			} else if ("GRADE".equals(targetType)) {
				// 특정 등급 발송
				sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT) "
						+ "SELECT NOTIFY_SEQ.NEXTVAL, u.USER_NUM, ?, ?, ? "
						+ "FROM USERS u JOIN USERS_DETAIL ud ON u.USER_NUM = ud.USER_NUM "
						+ "WHERE u.AUTH = 2 AND ud.GRADE = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, vo.getNotify_type());
				pstmt.setString(2, vo.getNotify_title());
				pstmt.setString(3, vo.getNotify_content());
				pstmt.setInt(4, Integer.parseInt(targetValue));

			} else {
				// ALL: 전체 회원 발송
				sql = "INSERT INTO NOTIFY (NOTIFY_NUM, USER_NUM, NOTIFY_TYPE, NOTIFY_TITLE, NOTIFY_CONTENT) "
						+ "SELECT NOTIFY_SEQ.NEXTVAL, USER_NUM, ?, ?, ? " + "FROM USERS WHERE AUTH = 2";
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

	// 3. 알림 발송 이력 카운트
	public int getNotifyTotalCount(AdminNotifyVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		StringBuilder sql = new StringBuilder();

		try {
			conn = DBUtil.getConnection();
			sql.append("SELECT COUNT(*) FROM NOTIFY n " + "JOIN USERS u ON n.USER_NUM = u.USER_NUM "
					+ "LEFT JOIN USERS_DETAIL ud ON u.USER_NUM = ud.USER_NUM ");

			boolean hasType = (vo.getNotify_type() > 0);
			boolean hasKeyword = (vo.getKeyword() != null && !vo.getKeyword().trim().isEmpty());

			if (hasType || hasKeyword)
				sql.append("WHERE ");
			if (hasType)
				sql.append("n.NOTIFY_TYPE = ? ");
			if (hasType && hasKeyword)
				sql.append("AND ");
			if (hasKeyword)
				sql.append("(u.USER_ID LIKE ? OR ud.USER_NAME LIKE ? OR n.NOTIFY_TITLE LIKE ?) ");

			pstmt = conn.prepareStatement(sql.toString());

			int idx = 1;
			if (hasType)
				pstmt.setInt(idx++, vo.getNotify_type());
			if (hasKeyword) {
				String keyword = "%" + vo.getKeyword() + "%";
				pstmt.setString(idx++, keyword);
				pstmt.setString(idx++, keyword);
				pstmt.setString(idx++, keyword);
			}

			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			DBUtil.executeClose(rs, pstmt, conn);
		}
		return count;
	}

	// 4. 알림 발송 이력 조회
	public List<AdminNotifyVO> getNotifyList(AdminNotifyVO vo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<AdminNotifyVO> list = new ArrayList<>();
		StringBuilder sub_sql = new StringBuilder();

		try {
			conn = DBUtil.getConnection();

			boolean hasType = (vo.getNotify_type() > 0);
			boolean hasKeyword = (vo.getKeyword() != null && !vo.getKeyword().trim().isEmpty());

			if (hasType || hasKeyword)
				sub_sql.append("WHERE ");
			if (hasType)
				sub_sql.append("n.NOTIFY_TYPE = ? ");
			if (hasType && hasKeyword)
				sub_sql.append("AND ");
			if (hasKeyword)
				sub_sql.append("(u.USER_ID LIKE ? OR ud.USER_NAME LIKE ? OR n.NOTIFY_TITLE LIKE ?) ");

			String sql = "SELECT * FROM ( " + "  SELECT a.*, ROWNUM rnum FROM ( "
					+ "    SELECT n.NOTIFY_NUM, n.NOTIFY_TYPE, n.NOTIFY_TITLE, n.NOTIFY_CONTENT, "
					+ "           n.READ_YN, n.NOTIFY_CREATED_AT, u.USER_ID, ud.USER_NAME " + "    FROM NOTIFY n "
					+ "    JOIN USERS u ON n.USER_NUM = u.USER_NUM "
					+ "    LEFT JOIN USERS_DETAIL ud ON u.USER_NUM = ud.USER_NUM " + sub_sql.toString()
					+ "    ORDER BY n.NOTIFY_NUM DESC " + "  ) a " + ") WHERE rnum >= ? AND rnum <= ?";

			pstmt = conn.prepareStatement(sql);

			int idx = 1;
			if (hasType)
				pstmt.setInt(idx++, vo.getNotify_type());
			if (hasKeyword) {
				String keyword = "%" + vo.getKeyword() + "%";
				pstmt.setString(idx++, keyword);
				pstmt.setString(idx++, keyword);
				pstmt.setString(idx++, keyword);
			}
			pstmt.setInt(idx++, vo.getStart_row());
			pstmt.setInt(idx++, vo.getEnd_row());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				AdminNotifyVO nvo = new AdminNotifyVO();
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
}