package kr.shop.wish.action;

import java.util.HashMap;
import java.util.Map;
import org.codehaus.jackson.map.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;
import kr.shop.vo.UserWishListVO;

public class WriteWishAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String> mapAjax = new HashMap<>();
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인 여부 확인
		if(user_num == null) {
			mapAjax.put("result", "logout");
		} else {
			request.setCharacterEncoding("utf-8");
			int prod_num = Integer.parseInt(request.getParameter("prod_num"));
			UserWishListDAO dao = UserWishListDAO.getInstance();
			
			// 이미 찜이 되어있는지 확인 후 삭제, 추가
			boolean isWished = dao.checkWish(user_num, prod_num);
			
			if(isWished) {
				dao.deleteWish(user_num, prod_num);
				mapAjax.put("result", "deleted"); // 삭제됨 응답
			} else {
				UserWishListVO wish = new UserWishListVO();
				wish.setUser_num(user_num);
				wish.setProd_num(prod_num);
				dao.insertWish(wish);
				mapAjax.put("result", "added"); // 추가됨 응답
			}
		}
		
		ObjectMapper mapper = new ObjectMapper();
		String ajaxData = mapper.writeValueAsString(mapAjax);
		request.setAttribute("ajaxData", ajaxData);
		
		return "common/ajax_view.jsp";
	}
}