package logis_login;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;


public class LogoutAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	
		// 현재 연결된 세션 객체를 가져옴
		HttpSession session = request.getSession();
		
		// 세션의 모든 정보를 삭제 (로그아웃 처리)
		session.invalidate();
		
		return "redirect:/logistics/log_login/log_loginForm.do";
	}
}
