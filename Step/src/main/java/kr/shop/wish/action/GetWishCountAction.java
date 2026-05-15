package kr.shop.wish.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;
import kr.util.StringUtil;

public class GetWishCountAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String> mapAjax = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		if(user_num == null) {
			mapAjax.put("count", "0");
		} else {
			UserWishListDAO dao = UserWishListDAO.getInstance();
			int count = dao.getWishCount(user_num);
			
			//int를 String으로 바꿔 담기
			mapAjax.put("count", String.valueOf(count));
		}
		
		return StringUtil.parseJSON(request, mapAjax);
	}
}