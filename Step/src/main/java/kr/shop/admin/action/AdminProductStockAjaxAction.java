package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;

public class AdminProductStockAjaxAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int prod_num = Integer.parseInt(request.getParameter("prod_num"));
		AdminProductDAO dao = AdminProductDAO.getInstance();

		List<AdminProductVO> stockList = dao.getProductStockDetails(prod_num);

		//뷰(JSP)에서 사용할 기준값을 Action에서 정의
		int lowStockThreshold = 10; 
		int maxBarStock = 50; 

		request.setAttribute("stockList", stockList);
		request.setAttribute("lowStockThreshold", lowStockThreshold);
		request.setAttribute("maxBarStock", maxBarStock);

		// 레이아웃 없이 데이터만 출력하는 jsp로 포워딩
		return "shop/admin/adminProductStockAjax.jsp";
	}
}