package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;

public class MyPageAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 1. 세션에서 로그인 정보 가져오기
		HttpSession session = request.getSession();
		String user_id = (String) session.getAttribute("user_id");
		
		// [방어막] 혹시 로그인이 풀렸거나 안 한 상태로 들어오면 로그인창으로 쫓아내기
		if (user_id == null) {
			return "redirect:/shop/user/loginForm.do";
		}
		
		// 2. DAO를 통해서 내 아이디로 전체 회원 정보 가져오기
		Long user_num = (Long) session.getAttribute("user_num");
		UserDAO dao = UserDAO.getInstance();
		UserVO user = dao.getUserDetail(user_num);
		
		// 3. JSP에서 쓸 수 있게 request에 'user'라는 이름으로 담기
		request.setAttribute("user", user);
		
		// 4. 마이페이지 화면으로 이동
		return "shop/user/myPageForm.jsp";
	}
}