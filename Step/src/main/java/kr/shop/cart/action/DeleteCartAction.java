package kr.shop.cart.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.shop.vo.UserCartVO;

public class DeleteCartAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인이 안되있을 경우 로그인 폼으로
		if (user_num == null) {
            request.setAttribute("ajaxData", "{\"result\":\"logout\"}");
            return "common/ajax_view.jsp";
        }

        long cart_num = Long.parseLong(request.getParameter("cart_num"));
        UserCartDAO.getInstance().deleteCart(cart_num);

        request.setAttribute("ajaxData", "{\"result\":\"success\"}");
        return "common/ajax_view.jsp";
	}

}
