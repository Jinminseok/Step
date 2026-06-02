package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserReturnDAO;


public class ReturnDeleteAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//로그인 세션 체크
		HttpSession session = request.getSession();
		Number sessionUserNum = (Number) session.getAttribute("user_num");
		if (sessionUserNum == null) {
		    return "redirect:/shop/user/loginForm.do";
		}
		int user_num = sessionUserNum.intValue();
		
		//파라미터 수집
		int ret_num = Integer.parseInt(request.getParameter("ret_num"));
		
		//DAO 호출 (삭제 로직)
		UserReturnDAO dao = UserReturnDAO.getInstance();
		
		// (WHERE ret_num=? AND user_num=?)
		dao.deleteReturnRequest(ret_num, user_num); 
		
		//처리 완료 후 마이페이지로 리다이렉트
		return "redirect:/shop/user/myPageForm.do";
	}
}