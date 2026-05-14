package kr.shop.order.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.shop.dao.UserOrderDAO;
import kr.shop.vo.UserCartVO;

public class OrderProcessAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그인 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		if(user_num == null) return "redirect:/shop/user/loginForm.do";

		request.setCharacterEncoding("utf-8");

		// 주문서 폼에서 넘어온 파라미터 받기
		String[] cartNums = request.getParameterValues("cart_num");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String zipcode = request.getParameter("zipcode");
		String address1 = request.getParameter("address1");
		String address2 = request.getParameter("address2");
		String payType = request.getParameter("pay_type"); 

		// 결제 수단 번호를 문자로 변환
		String payMethod = "신용카드";
		if("2".equals(payType)) payMethod = "무통장입금";
		else if("3".equals(payType)) payMethod = "카카오페이";

		// DB에서 장바구니 금액을 다시 계산
		UserCartDAO cartDao = UserCartDAO.getInstance();
		List<UserCartVO> orderItemList = cartDao.getOrderCartList(cartNums);
		int totalPrice = 0;
		for(UserCartVO item : orderItemList) {
			totalPrice += (item.getProd_price() * item.getCart_qty());
		}

		UserOrderDAO orderDao = UserOrderDAO.getInstance();
		orderDao.processOrder(user_num, totalPrice, name, phone, zipcode, address1, address2, cartNums, payMethod);

		// 완료 화면으로 이동
		request.setAttribute("result_title", "주문 완료");
		request.setAttribute("result_msg", "주문 및 결제가 성공적으로 완료되었습니다.<br>이용해 주셔서 감사합니다.");
		request.setAttribute("result_url", request.getContextPath() + "/shop/user/myPageForm.do");

		return "common/result_view.jsp";
	}
}