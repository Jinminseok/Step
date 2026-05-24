package kr.shop.cart.action;

import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.util.StringUtil;

public class UpdateCartQtyAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String> mapAjax = new HashMap<>();
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");

		if (user_num == null) {
			mapAjax.put("result", "logout");
		} else {
			long cart_num = Long.parseLong(request.getParameter("cart_num"));
			int cart_qty = Integer.parseInt(request.getParameter("cart_qty"));
			UserCartDAO.getInstance().updateCartQty(cart_num, cart_qty);
			mapAjax.put("result", "success");
		}
		return StringUtil.parseJSON(request, mapAjax);
	}
}