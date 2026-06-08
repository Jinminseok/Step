package kr.shop.cart.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.util.StringUtil;

public class GetCartCountAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String, String> mapAjax = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인 확인
		if(user_num == null) {
			mapAjax.put("count", "0");
		} else {
			UserCartDAO dao = UserCartDAO.getInstance();
			int count = dao.getCartCount(user_num);
			
			mapAjax.put("count", String.valueOf(count));
		}
		
		return StringUtil.parseJSON(request, mapAjax);
	}

}
