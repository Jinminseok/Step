package kr.shop.user.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;
import kr.util.StringUtil;

public class CheckIdAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 전송된 데이터 반환
		String id = request.getParameter("id");
		
		UserDAO dao = UserDAO.getInstance();
		UserVO user = dao.checkUser(id);
		
		Map<String, String> mapAjax = new HashMap<String, String>();
		
		if(user!=null) {	// 중복
			mapAjax.put("result", "duplicated");
		} else {			// 미중복
			mapAjax.put("result", "notFound");
		}
		
		// JSP 반환
		return StringUtil.parseJSON(request, mapAjax);
	}
	
}
