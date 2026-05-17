package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;
import kr.util.PagingUtil;

public class AdminProductListAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String search_status = request.getParameter("search_status");

		AdminProductVO vo = new AdminProductVO();
		vo.setSearch_status(search_status);

		AdminProductDAO dao = AdminProductDAO.getInstance();

		// IN_STATUS=2 조건이 반영된 데이터 카운트 호출
		int count = dao.getProductTotalCount(vo);

		StringBuilder addKey = new StringBuilder();
		if (search_status != null && !search_status.isEmpty()) {
			addKey.append("&search_status=").append(search_status);
		}

		PagingUtil page = new PagingUtil(null, null, Integer.parseInt(pageNum), count, 10, 10, "productList.do",
				addKey.toString());

		List<AdminProductVO> list = null;
		if (count > 0) {
			vo.setStart_row(page.getStartRow());
			vo.setEnd_row(page.getEndRow());
			list = dao.getProductList(vo);
		}

		request.setAttribute("count", count);
		request.setAttribute("list", list);
		request.setAttribute("page", page.getPage());
		request.setAttribute("app_title", "상품 관리");

		return "shop/admin/adminProductList.jsp";
	}
}