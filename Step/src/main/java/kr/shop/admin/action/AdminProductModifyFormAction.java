package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;

public class AdminProductModifyFormAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		int prod_num = Integer.parseInt(request.getParameter("prod_num"));

		AdminProductDAO dao = AdminProductDAO.getInstance();
		// 기존 데이터 불러오기
		AdminProductVO product = dao.getProduct(prod_num);

		request.setAttribute("product", product);

		return "/admin/product/adminProductModify.jsp";
	}
}