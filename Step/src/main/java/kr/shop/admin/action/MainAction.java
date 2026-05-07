package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;

public class MainAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// DB에서 상품 목록 가져오기
		AdminProductDAO dao = AdminProductDAO.getInstance();
		AdminProductVO filter = new AdminProductVO();
		filter.setStart_row(1);
		filter.setEnd_row(8);

		List<AdminProductVO> productList = dao.getProductList(filter);

		// JSP로 데이터 전달
		request.setAttribute("productList", productList);

		// ⭐ 이 부분이 네가 말한 핵심!
		return "shop/admin/main.jsp";
	}
}