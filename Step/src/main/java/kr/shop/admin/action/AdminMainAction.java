package kr.shop.admin.action;

import java.util.List;
import java.util.Map;

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

		// 기존 상태값 통계
		int todayOrderCount = dao.getTodayOrderCount();
		int pendingPaymentCount = dao.getPendingPaymentCount();
		int readyForShippingCount = dao.getReadyForShippingCount();
		int cancelRequestCount = dao.getCancelRequestCount();
		int lowStockCount = dao.getLowStockCount();
		int dashboardProductTotalCount = dao.getDashboardProductTotalCount();

		// 신규 연동 실데이터 통계
		long todaySalesAmount = dao.getTodaySalesAmount();
		int todayNewUserCount = dao.getTodayNewUserCount();
		List<Map<String, Object>> monthlySales = dao.getMonthlySales();
		List<Map<String, Object>> topProducts = dao.getTopProducts();
		List<Map<String, Object>> recentOrders = dao.getRecentOrders();

		// 차트 width 퍼센트(%) 계산을 위한 최대값 추출
		long maxSales = 0;
		for (Map<String, Object> map : monthlySales) {
			long sales = ((Number) map.get("SALES")).longValue();
			if (sales > maxSales)
				maxSales = sales;
		}
		long maxTopCount = 0;
		for (Map<String, Object> map : topProducts) {
			long count = ((Number) map.get("SALES_COUNT")).longValue();
			if (count > maxTopCount)
				maxTopCount = count;
		}

		// JSP 바인딩
		request.setAttribute("todayOrderCount", todayOrderCount);
		request.setAttribute("pendingPaymentCount", pendingPaymentCount);
		request.setAttribute("readyForShippingCount", readyForShippingCount);
		request.setAttribute("cancelRequestCount", cancelRequestCount);
		request.setAttribute("lowStockCount", lowStockCount);
		request.setAttribute("dashboardProductTotalCount", dashboardProductTotalCount);

		request.setAttribute("todaySalesAmount", todaySalesAmount);
		request.setAttribute("todayNewUserCount", todayNewUserCount);
		request.setAttribute("monthlySales", monthlySales);
		request.setAttribute("topProducts", topProducts);
		request.setAttribute("recentOrders", recentOrders);

		// 0으로 나누기 방지용 1 세팅
		request.setAttribute("maxSales", maxSales == 0 ? 1 : maxSales);
		request.setAttribute("maxTopCount", maxTopCount == 0 ? 1 : maxTopCount);

		request.setAttribute("app_title", "관리자 대시보드");

		return "shop/admin/adminMain.jsp";
	}
}