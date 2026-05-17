package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;

public class AdminMainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		AdminProductDAO dao = AdminProductDAO.getInstance();

		// [수정] 중복 해결을 위해 리네이밍된 대시보드 전용 메서드 호출 (인자값 없음)
		int totalProductCount = dao.getDashboardProductTotalCount();

		int todayOrderCount = dao.getTodayOrderCount();
		int pendingPaymentCount = dao.getPendingPaymentCount();
		int readyForShippingCount = dao.getReadyForShippingCount();
		int cancelRequestCount = dao.getCancelRequestCount();
		int lowStockCount = dao.getLowStockCount();

		// JSP 레이아웃용 속성 세팅 (기본 Key값은 그대로 유지해서 JSP 수정 필요 없음)
		request.setAttribute("totalProductCount", totalProductCount);
		request.setAttribute("todayOrderCount", todayOrderCount);
		request.setAttribute("pendingPaymentCount", pendingPaymentCount);
		request.setAttribute("readyForShippingCount", readyForShippingCount);
		request.setAttribute("cancelRequestCount", cancelRequestCount);
		request.setAttribute("lowStockCount", lowStockCount);

		request.setAttribute("app_title", "통계 / 대시보드");

		return "shop/admin/adminMain.jsp";
	}
}