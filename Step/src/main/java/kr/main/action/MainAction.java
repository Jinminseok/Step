package kr.main.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;

public class MainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 1. DAO 객체 생성
		AdminDAO dao = AdminDAO.getInstance();
		
		// 2. 검색, 페이징 필터 세팅
		AdminVO filter = new AdminVO();
		// 최신순 8개까지만 가져오도록 세팅
		filter.setStart_row(1); 
		filter.setEnd_row(8);
		
		// 3. 상품 목록 받아오기
		List<AdminVO> productList = dao.getProductList(filter);
		
		// 4. JSP에서 쓸 수 있도록 request에 담기
		request.setAttribute("productList", productList);
		
		// 5. 메인 화면 JSP로 이동
		return "shop/user/main.jsp";
	}
}