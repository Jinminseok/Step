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

		// 1. 관리자 권한 체크 (요구사항 C-1 관리자 로그인 필수)
		HttpSession session = request.getSession();

		// 세션에서 Object로 가져온 뒤 Number로 캐스팅하여 int 값 추출 (Long/Integer 호환)
		Object user_num_obj = session.getAttribute("user_num");
		Object user_auth_obj = session.getAttribute("user_auth");

		Integer user_num = null;
		Integer user_auth = null;

		if (user_num_obj != null) {
			user_num = ((Number) user_num_obj).intValue();
		}
		if (user_auth_obj != null) {
			user_auth = ((Number) user_auth_obj).intValue();
		}

		// 관리자 권한 체크 (로그인 안 되어 있거나 권한이 9가 아닌 경우)
		if (user_num == null || user_auth == null || user_auth != 9) {
			return "redirect:/member/login.do";
		}

		// 2. 파라미터 수집
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String search_type = request.getParameter("search_type");
		String keyword = request.getParameter("keyword");

		// 3. 검색 조건 설정
		AdminProductVO vo = new AdminProductVO();
		vo.setSearch_type(search_type);
		vo.setKeyword(keyword);

		AdminProductDAO dao = AdminProductDAO.getInstance();

		// 4. 전체 상품 개수 조회
		int count = dao.getProductTotalCount(vo);

		// 5. 페이징 처리
		String addKey = "";
		if (keyword != null && !"".equals(keyword)) {
			addKey = "&search_type=" + search_type + "&keyword=" + keyword;
		}

		PagingUtil page = new PagingUtil(Integer.parseInt(pageNum), count, 10, 10, "adminProductList.do", addKey);

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

		// 8. 뷰 경로 반환
		return "shop/admin/adminProductList.jsp";
	}
}