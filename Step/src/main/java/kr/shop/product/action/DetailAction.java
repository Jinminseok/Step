package kr.shop.product.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
// import kr.shop.dao.ProductDAO;
// import kr.shop.vo.ProductVO;

public class DetailAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 1. 상품 번호 파라미터 받기 (메인에서 클릭하고 넘어올 때의 번호)
		int prod_num = Integer.parseInt(request.getParameter("prod_num"));
		
		// -------------------------------------------------------------
		// 💡 나중에 ProductDAO 완성 시 아래 주석을 풀고 DB와 연동하세요!
		// -------------------------------------------------------------
		/*
		ProductDAO dao = ProductDAO.getInstance();
		ProductVO product = dao.getProductDetail(prod_num);     // 상품 기본 정보
		List<String> imgList = dao.getProductImages(prod_num);  // 다중 이미지 리스트
		List<AdminVO> optList = dao.getProductOptions(prod_num);// 색상, 사이즈 옵션들
		
		request.setAttribute("product", product);
		request.setAttribute("imgList", imgList);
		request.setAttribute("optList", optList);
		*/
		
		// 임시 세팅 (UI 테스트용)
		request.setAttribute("prod_num", prod_num);
		
		// 2. 로그인 상태 및 등급 확인 (할인가 표시, 버튼 제어용)
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		Integer grade = (Integer) session.getAttribute("grade"); // 등급
		
		// 로그인 여부 체크
		request.setAttribute("isLogin", user_num != null);
		
		// 3. 상세 페이지 JSP로 이동
		return "shop/product/detail.jsp";
	}
}