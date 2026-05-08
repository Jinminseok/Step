package kr.main.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.UserProductDAO;
import kr.shop.vo.AdminProductVO;

public class MainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. UserProductDAO 객체 생성
		UserProductDAO dao = UserProductDAO.getInstance();

		// 2. 검색 및 페이징 필터 세팅
		AdminProductVO filter = new AdminProductVO();

		// 최신순 8개 페이징 세팅
		filter.setStart_row(1);
		filter.setEnd_row(8);

		// 성별 필터 (-1: 전체)
		filter.setGender(-1);

		// 3. 상품 목록 받아오기
		List<AdminProductVO> productList = dao.getMainProductList(filter);

		// 4. JSP에서 사용할 데이터 저장
		request.setAttribute("productList", productList);

		// 5. 이동할 JSP 경로 리턴
		return "shop/user/main.jsp";
	}
}