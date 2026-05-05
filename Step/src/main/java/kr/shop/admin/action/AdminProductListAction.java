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

		// 2. 파라미터 설정 및 페이지 번호 처리
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String keyfield = request.getParameter("keyfield");
		String keyword = request.getParameter("keyword");
		String cat_num = request.getParameter("cat_num");
		String gender = request.getParameter("gender");

		// 싱글톤 방식으로 DAO 객체 생성
		AdminDAO dao = AdminDAO.getInstance();

		try {
			// 필터 객체 세팅
			AdminVO filter = new AdminVO();
			filter.setKeyword(keyword);
			if (cat_num != null && !cat_num.isEmpty())
				filter.setCat_num(Integer.parseInt(cat_num));
			if (gender != null && !gender.isEmpty())
				filter.setGender(Integer.parseInt(gender));
			else
				filter.setGender(-1);

			// 전체 상품 개수 조회
			int count = dao.getProductCount(filter);

			// 3. 페이징 처리 (10개 단위)
			PagingUtil page = new PagingUtil(keyfield, keyword, Integer.parseInt(pageNum), count, 10, 10,
					"productList.do");

			List<AdminVO> list = null;
			if (count > 0) {
				// VO의 필드명(start_row, end_row)에 맞게 세터 메서드 호출 수정
				filter.setStart_row(page.getStartRow());
				filter.setEnd_row(page.getEndRow());
				list = dao.getProductList(filter);
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