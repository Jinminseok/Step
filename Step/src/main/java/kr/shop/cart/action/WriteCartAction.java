package kr.shop.cart.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.shop.vo.UserCartVO;

public class WriteCartAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 브라우저에 JSON 형식으로 응답할 것이라고 알려줌 
		response.setContentType("application/json;charset=utf-8");
		
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		if (user_num == null) {
			// 로그인이 안 되어있으면 "logout"이라는 결과를 화면에 보냄
			response.getWriter().print("{\"result\":\"logout\"}");
			return null; 
		}
		
		// 화면(JSP)에서 넘어온 옵션번호와 수량 데이터 받기
		long opt_num = Long.parseLong(request.getParameter("opt_num"));
		int cart_qty = Integer.parseInt(request.getParameter("cart_qty"));
		
		// 4. VO에 담아서 DAO로 DB 저장!
		UserCartVO cart = new UserCartVO();
		cart.setUser_num(user_num);
		cart.setOpt_num(opt_num);
		cart.setCart_qty(cart_qty);
		
		UserCartDAO.getInstance().insertCart(cart);
		
		// 5. 성공했다는 결과를 화면에 보냄
		response.getWriter().print("{\"result\":\"success\"}");
		
		return null; // AJAX 통신이므로 화면 이동 없음!
	}
}