package kr.shop.user.action;

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
		
		// 로그아웃 후 메인 페이지로 리다이렉트
		return "redirect:/shop/user/main.do";
	}

}
