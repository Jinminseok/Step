package kr.shop.wish.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;

public class DeleteWishAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	// 로그인 여부 확인
        HttpSession session = request.getSession();
        Long user_num = (Long) session.getAttribute("user_num");
        
        // 로그인이 안되있는 경우
        if (user_num == null) {
            request.setAttribute("ajaxData", "{\"result\":\"logout\"}");
            return "common/ajax_view.jsp";
        }

        int prod_num = Integer.parseInt(request.getParameter("prod_num"));
        UserWishListDAO.getInstance().deleteWish(user_num, prod_num);

        request.setAttribute("ajaxData", "{\"result\":\"success\"}");
        return "common/ajax_view.jsp";
    }
}