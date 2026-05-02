package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;
import kr.util.PagingUtil;

public class AdminProductListAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		if (user_auth == null || user_auth != 9) {
			return "common/accessDenied.jsp";
		}

		// 2. 파라미터 및 검색 조건 설정
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String keyfield = request.getParameter("keyfield");
		String keyword = request.getParameter("keyword");

		AdminDAO dao = AdminDAO.getInstance();

		try {
			// 전체 상품 개수 조회
			int count = dao.getProductCount(keyfield, keyword);

			// 3. 페이징 처리 (10개 단위)
			PagingUtil page = new PagingUtil(keyfield, keyword, Integer.parseInt(pageNum), count, 10, 10,
					"productList.do");

			List<AdminVO> list = null;
			if (count > 0) {
				// 목록 조회 (재고 포함)
				list = dao.showProductList(page.getStartRow(), page.getEndRow(), keyfield, keyword);
			}

			// 4. JSP 데이터 바인딩
			request.setAttribute("count", count);
			request.setAttribute("productList", list);
			request.setAttribute("page", page.getPage());

		} catch (Exception e) {
			e.printStackTrace();
			return "common/error.jsp";
		}

		return "shop/admin/productList.jsp";
	}
}