package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;

public class AdminMainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		// 관리자 권한 체크 (권한 번호 9)
		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		AdminProductDAO dao = AdminProductDAO.getInstance();

		// 수정된 DAO 메서드 기반으로 대시보드 통계 데이터 조회
		int todayOrderCount = dao.getTodayOrderCount();
		int pendingPaymentCount = dao.getPendingPaymentCount();
		int readyForShippingCount = dao.getReadyForShippingCount();
		int cancelRequestCount = dao.getCancelRequestCount();

		// IN_STATUS=1 및 PROD_STATUS(1,2,3,4) 조건이 반영된 대시보드 전용 상품/재고 카운트 호출
		int lowStockCount = dao.getLowStockCount();
		int dashboardProductTotalCount = dao.getDashboardProductTotalCount();

		// JSP에서 사용할 수 있도록 Request 영역에 저장
		request.setAttribute("todayOrderCount", todayOrderCount);
		request.setAttribute("pendingPaymentCount", pendingPaymentCount);
		request.setAttribute("readyForShippingCount", readyForShippingCount);
		request.setAttribute("cancelRequestCount", cancelRequestCount);
		request.setAttribute("lowStockCount", lowStockCount);
		request.setAttribute("dashboardProductTotalCount", dashboardProductTotalCount);

		request.setAttribute("app_title", "관리자 대시보드");

		return "shop/admin/adminMain.jsp";
	}
}