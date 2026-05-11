package kr.shop.wish.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;
import kr.shop.vo.UserWishListVO;

public class WriteWishAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 브라우저에 JSON 형식으로 응답할 것이라고 알려줌
		response.setContentType("application/json;charset=utf-8");
		
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인이 안되있는 경우
		if (user_num == null) {
			response.getWriter().print("{\"result\":\"logout\"}");
			return null; 
		}
		
		// JSP에서 넘어온 옵션번호와 수량 데이터 받기
		int prod_num = Integer.parseInt(request.getParameter("prod_num"));
		
		// DB에 저장
		UserWishListVO wish = new UserWishListVO();
		wish.setUser_num(user_num);
		wish.setProd_num(prod_num);
		
		UserWishListDAO.getInstance().insertWish(wish);
		
		// 완료했다는 결과를 화면에 보냄
		response.getWriter().print("{\"result\":\"success\"}");
		
		return null;
	}
}