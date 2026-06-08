package kr.shop.cart.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.shop.vo.UserCartVO;

public class CartListAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인이 안되있을 경우 로그인 폼으로
		if (user_num == null) {
			return "redirect:/shop/user/loginForm.do"; 
		}
		
		// DAO를 호출해서 내 장바구니 목록 가져오기
		UserCartDAO dao = UserCartDAO.getInstance();
		List<UserCartVO> cartList = dao.getCartList(user_num);
		
		// JSP에서 쓸 수 있도록 데이터 담기
		request.setAttribute("cartList", cartList);
		
		// 장바구니 로 이동
		return "shop/cart/cartList.jsp";
	}
}