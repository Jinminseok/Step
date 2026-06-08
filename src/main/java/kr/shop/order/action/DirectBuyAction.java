package kr.shop.order.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserCartDAO;

public class DirectBuyAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		if(user_num == null) {
			return "redirect:/shop/user/loginForm.do";
		}
		
		// 폼에서 넘어온 상품 정보 받기
		int prod_num = Integer.parseInt(request.getParameter("prod_num"));
		String color = request.getParameter("color");
		int size = Integer.parseInt(request.getParameter("size"));
		int cart_qty = 1;
		
		// 장바구니에 넣고 그 상품의 카트 번호만 받아오기
		UserCartDAO dao = UserCartDAO.getInstance();
		Long cart_num = dao.insertDirectCart(user_num, prod_num, color, size, cart_qty);
		
		// 카트 번호만 주문서로 넘기기
		return "redirect:/shop/order/orderPageForm.do?cart_num=" + cart_num;
	}
}