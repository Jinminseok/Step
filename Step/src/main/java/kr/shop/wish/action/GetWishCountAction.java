package kr.shop.wish.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;

public class GetWishCountAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// JSON 응답 설정
		response.setContentType("application/json;charset=utf-8");
		
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인 확인
		if (user_num == null) {
            request.setAttribute("ajaxData", "{\"result\":\"logout\"}");
            return "common/ajax_view.jsp";
        }
		
		// DAO 호출해서 개수 가져오기
		UserWishListDAO dao = UserWishListDAO.getInstance();
		int count = dao.getWishCount(user_num);
		
		request.setAttribute("ajaxData", "{\"count\":" + count + "}");
		
		return "common/ajax_view.jsp";
	}
}