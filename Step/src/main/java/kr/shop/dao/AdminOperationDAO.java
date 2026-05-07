package kr.shop.dao;

import java.sql.*;
import java.util.*;
import kr.shop.vo.AdminOperationVO;
import kr.util.DBUtil;

public class AdminOperationDAO {
	private static AdminOperationDAO instance = new AdminOperationDAO();

	public static AdminOperationDAO getInstance() {
		return instance;
	}

	private AdminOperationDAO() {
	}

	// 활성화된 배너 리스트 가져오기
	public List<AdminOperationVO> getActiveBanners() throws Exception {
		// ... SELECT * FROM banners WHERE banner_use_yn = 'Y' 쿼리 작성
		return null;
	}
}