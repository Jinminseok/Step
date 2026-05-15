package kr.shop.wish.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;
import kr.shop.vo.UserWishListVO;
import kr.util.StringUtil;

public class WriteWishAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String, String> mapAjax = new HashMap<String, String>();
		
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인이 안되있는 경우
		if (user_num == null) {
			mapAjax.put("result", "logout");
		} else {
			int prod_num = Integer.parseInt(request.getParameter("prod_num"));
			
			// DB에 저장
			UserWishListVO wish = new UserWishListVO();
			wish.setUser_num(user_num);
			wish.setProd_num(prod_num);
			
			UserWishListDAO dao = UserWishListDAO.getInstance();
			dao.insertWish(wish);
			
			mapAjax.put("result", "success");
			
		}
		
		// JSON 데이터 반환
		return StringUtil.parseJSON(request, mapAjax);
	}
}