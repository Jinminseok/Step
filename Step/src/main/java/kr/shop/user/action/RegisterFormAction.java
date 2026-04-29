package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class RegisterFormAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 회원가입 폼 JSP로 이동
		return "shop/user/register.jsp";
	}
}