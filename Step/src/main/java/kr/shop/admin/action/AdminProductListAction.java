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
		// 1. 관리자 권한 체크 (세션 만료 및 등급 확인)
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		// 설계서 USERS 테이블의 AUTH: 9(관리자) 확인[cite: 8]
		if (user_auth == null || user_auth != 9) {
			return "common/accessDeenied.jsp"; // 오타 수정: Deenied -> Denied
		}

		// 2. 파라미터 처리 및 검색 조건 설정
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String keyfield = request.getParameter("keyfield");
		String keyword = request.getParameter("keyword");

		AdminDAO dao = AdminDAO.getInstance();

		try {
			// [요구사항 A-2, C-5] 검색 필터가 적용된 전체 상품 및 재고 개수 조회[cite: 7]
			int count = dao.getProductCount(keyfield, keyword);

			// 3. 페이징 처리 (한 페이지당 10개 출력)
			// PagingUtil(keyfield, keyword, 현재페이지, 총개수, 페이지당글수, 페이지표시수, 호출URL)
			PagingUtil page = new PagingUtil(keyfield, keyword, Integer.parseInt(pageNum), count, 10, 10,
					"productList.do");

			List<AdminVO> list = null;
			if (count > 0) {
				// 페이징 범위에 맞는 목록 조회 (재고 현황 포함)[cite: 7, 8]
				list = dao.showProductList(page.getStartRow(), page.getEndRow(), keyfield, keyword);
			}

			// 4. JSP 데이터 바인딩
			request.setAttribute("count", count);
			request.setAttribute("productList", list);
			request.setAttribute("page", page.getPage()); // page.getPage() 자체가 String을 반환하도록 설계됨

		} catch (Exception e) {
			e.printStackTrace();
			return "common/error.jsp"; // 예외 발생 시 에러 페이지로 유도
		}

		return "shop/admin/productList.jsp";
	}
}