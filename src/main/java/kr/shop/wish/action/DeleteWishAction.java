package kr.shop.wish.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;
import kr.util.StringUtil;

public class DeleteWishAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	Map<String, String> mapAjax = new HashMap<String, String>();
    	
    	HttpSession session = request.getSession();
    	Long user_num = (Long) session.getAttribute("user_num");
    	
    	// 로그인 여부 확인
    	if (user_num == null) {
    		mapAjax.put("result", "logout");
    	} else {
    		int prod_num = Integer.parseInt(request.getParameter("prod_num"));
    		UserWishListDAO dao = UserWishListDAO.getInstance();
    		dao.deleteWish(user_num, prod_num);
    		mapAjax.put("result", "success");
    	}
    	
    	// JSON 데이터 반환
    	return StringUtil.parseJSON(request, mapAjax);
    }
}