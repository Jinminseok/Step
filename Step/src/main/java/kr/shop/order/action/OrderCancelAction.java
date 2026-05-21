package kr.shop.order.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.OrderCancelDAO;

public class OrderCancelAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		  request.setCharacterEncoding("UTF-8");
	        HttpSession session = request.getSession();

	        String user_id  = (String) session.getAttribute("user_id");
	        Long   user_num = (Long)   session.getAttribute("user_num");

	        if (user_id == null || user_num == null) {
	            return "redirect:/shop/user/loginForm.do";
	        }

	        try {
	            long orderNum = Long.parseLong(request.getParameter("orderNum"));
	            OrderCancelDAO.getInstance().cancelOrder(orderNum, user_num);
	            session.setAttribute("cancelMsg", "주문이 취소되었습니다.");

	        } catch (Exception e) {
	            e.printStackTrace();
	            session.setAttribute("cancelMsg", "주문 취소 중 오류가 발생했습니다.");
	        }

	        return "redirect:/shop/user/myPageForm.do";
	    }
	}