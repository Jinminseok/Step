package kr.shop.ai.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;

public class AiChatAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 세션에서 대화 기록 초기화 (페이지 새로 열 때)
        HttpSession session = request.getSession();
        String reset = request.getParameter("reset");
        if ("true".equals(reset)) {
            session.removeAttribute("chatHistory");
        }
        
		return "shop/ai/aiPick.jsp";
	}

}
