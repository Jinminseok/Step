package logis_login;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_AdminDAO;
import logis_vo.Log_AdminVO;

public class LoginAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String id = request.getParameter("id");
		String passwd = request.getParameter("passwd");
		
		Log_AdminDAO dao = Log_AdminDAO.getInstance();
		Log_AdminVO user = dao.checkUser(id);
		
		// 아이디가 존재하고 비밀번호가 일치하는지 확인
		if (user != null && user.isCheckedPassword(passwd)) {
			HttpSession session = request.getSession();
			session.setAttribute("user_num", user.getUser_num());
			session.setAttribute("user_id", user.getUser_id());
			session.setAttribute("user_auth", user.getAuth());
			
			// 관리자(9)면 관리자 메인으로, 일반회원(2)이면 쇼핑몰 메인으로 이동
			if (user.getAuth() == 9) {
				return "redirect:/logistics/log_dash/log_dashForm.do"; 
			} else {
				return "redirect:/logistics/log_login/log_loginForm.do";
			}
		} else {
			// 🚨 [수정된 부분] 로그인 실패 시
			// 얼럿 뷰로 화면을 넘기지 않고, 에러 메시지를 담아서 곧바로 로그인 폼 JSP를 다시 띄워줍니다!
			request.setAttribute("loginError", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "logistics/log_login/log_loginForm.jsp";
		}
	}
}