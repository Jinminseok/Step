package logis_login;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class LoginFormAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {


		// 로그인 폼 JSP 경로 반환
		
		return "logistics/log_login/log_loginForm.jsp";
	}
}
