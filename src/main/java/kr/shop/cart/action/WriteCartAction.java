package kr.shop.cart.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.shop.vo.UserCartVO;
import kr.util.StringUtil;

public class WriteCartAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String, Object> mapAjax = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인 여부 확인
		if (user_num == null) {
			mapAjax.put("result", "logout");
		} else {
			int prod_num = Integer.parseInt(request.getParameter("prod_num"));
			String color = request.getParameter("color");
			int size_val = Integer.parseInt(request.getParameter("size"));
			int cart_qty = Integer.parseInt(request.getParameter("cart_qty"));
			
			UserCartVO cart = new UserCartVO();
			cart.setUser_num(user_num);
			cart.setProd_num(prod_num);
			cart.setColor(color);
			cart.setSize_val(size_val);
			cart.setCart_qty(cart_qty);
			
			UserCartDAO dao = UserCartDAO.getInstance();
			dao.insertCart(cart);
			mapAjax.put("result", "success");
		}
		
		return StringUtil.parseJSON(request, mapAjax);
		
	}
}