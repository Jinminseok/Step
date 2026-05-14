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
		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		// 2. 파라미터 수집
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String search_type = request.getParameter("search_type");
		String keyword = request.getParameter("keyword");
		// -수정- JSP 탭에서 보낸 search_status 파라미터 수집
		String search_status = request.getParameter("search_status");

		// 3. 검색 조건 설정
		AdminProductVO vo = new AdminProductVO();
		vo.setSearch_type(search_type);
		vo.setKeyword(keyword);
		vo.setSearch_status(search_status);

		AdminProductDAO dao = AdminProductDAO.getInstance();

		// 4. 전체 상품 개수 조회
		int count = dao.getProductTotalCount(vo);

		// 5. 페이징 처리
		String addKey = "";
		if (search_status != null && !search_status.isEmpty()) {
			addKey = "&search_status=" + search_status;
		}

		PagingUtil page = new PagingUtil(search_type, keyword, Integer.parseInt(pageNum), count, 10, 10,
				"productList.do", addKey);

		// 6. 상품 목록 데이터 가져오기
		List<AdminProductVO> list = null;
		if (count > 0) {
			vo.setStart_row(page.getStartRow());
			vo.setEnd_row(page.getEndRow());
			list = dao.getProductList(vo);
		}

		// 7. JSP 데이터 바인딩
		request.setAttribute("count", count);
		request.setAttribute("list", list);
		request.setAttribute("page", page.getPage());
		request.setAttribute("app_title", "상품 관리");

		// 8. 뷰 경로 반환
		return "shop/admin/adminProductList.jsp";
	}
}