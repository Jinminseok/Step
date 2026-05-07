package kr.main.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO; // 1. AdminDAO 대신 ProductDAO 사용
import kr.shop.vo.AdminProductVO; // 2. AdminVO 대신 ProductVO 사용

public class MainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 상품 전용 DAO 객체 생성
		AdminProductDAO dao = AdminProductDAO.getInstance();

		// 2. 검색, 페이징 필터 세팅 (ProductVO가 BaseVO를 상속받았으므로 필터 역할 가능)
		AdminProductVO filter = new AdminProductVO();

		// 최신순 8개까지만 가져오도록 세팅 (BaseVO의 필드들)
		filter.setStart_row(1);
		filter.setEnd_row(8);

		// 성별 필터 (ProductVO의 gender 필드 사용)
		// -1이 '전체'를 의미한다면 그대로 유지
		filter.setGender(-1);

		// 3. 상품 목록 받아오기
		List<AdminProductVO> productList = dao.getProductList(filter);

		// 4. JSP에서 쓸 수 있도록 request에 담기
		request.setAttribute("productList", productList);

		// 5. 메인 화면 JSP로 이동
		return "shop/user/main.jsp";
	}
}