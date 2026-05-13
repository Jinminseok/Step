package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;

public class AdminMainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		// 2. 대시보드용 요약 데이터 수집
		AdminProductDAO dao = AdminProductDAO.getInstance();

		// 검색 조건 없는 기본 VO로 전체 상품 수 조회
		int totalProductCount = dao.getProductTotalCount(new AdminProductVO());

		/*
		 * 향후 추가 권장: int todayOrderCount = dao.getTodayOrderCount(); int lowStockCount =
		 * dao.getLowStockCount();
		 */

		// 3. 데이터 바인딩
		request.setAttribute("totalProductCount", totalProductCount);
		request.setAttribute("app_title","통계 / 대시보드");

		// 4. 뷰 경로 반환 (대시보드 전용 JSP)
		return "shop/admin/adminMain.jsp";
	}
}