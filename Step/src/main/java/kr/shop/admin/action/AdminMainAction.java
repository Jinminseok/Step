package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;
import kr.util.PagingUtil;

public class AdminMainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 페이지 번호 설정
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		// 2. 검색 조건 파라미터 수신
		String search_type = request.getParameter("search_type");
		String keyword = request.getParameter("keyword");

		// 3. DAO 및 VO 객체 생성 및 검색 데이터 세팅
		AdminProductDAO dao = AdminProductDAO.getInstance();
		AdminProductVO vo = new AdminProductVO();
		vo.setSearch_type(search_type);
		vo.setKeyword(keyword);

		// 4. 전체 레코드 수 조회 (Exception 발생 가능하므로 처리 필요)
		int count = 0;
		try {
			count = dao.getProductTotalCount(vo);
		} catch (Exception e) {
			e.printStackTrace();
			// 에러 발생 시 처리 로직 (필요 시 에러 페이지 전달)
		}

		// 5. 페이징 처리 (PagingUtil 활용)
		// 10: 한 페이지에 보여줄 게시물 수, 10: 한 화면에 보여줄 페이지 번호 수
		PagingUtil page = new PagingUtil(search_type, keyword, Integer.parseInt(pageNum), count, 10, 10,
				"adminMain.do");

		// 6. 시작 로우와 끝 로우를 VO에 세팅 (DAO의 getProductList에서 사용)
		vo.setStart_row(page.getStartRow());
		vo.setEnd_row(page.getEndRow());

		// 7. 상품 목록 조회
		List<AdminProductVO> list = null;
		if (count > 0) {
			try {
				list = dao.getProductList(vo);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// 8. JSP로 보낼 데이터 바인딩
		request.setAttribute("count", count);
		request.setAttribute("list", list);
		request.setAttribute("page", page.getPage());

		// 9. 뷰(View) 경로 반환
		return "shop/admin/adminMain.jsp";
	}
}