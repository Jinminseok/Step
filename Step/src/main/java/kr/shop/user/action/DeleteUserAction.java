package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;

public class DeleteUserAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인이 되지 않은 경우
		if(user_num == null) { 
			return "redirect:/shop/user/loginForm.do";
		}
		
		// 화면에서 입력받은 데이터
		String id = request.getParameter("id");
		String email = request.getParameter("email");
		String passwd = request.getParameter("passwd");
		
		// 로그인한 아이디
		String user_id = (String) session.getAttribute("user_id");
		
		// DB에서 회원 정보 조회
		UserDAO dao = UserDAO.getInstance();
		UserVO db_user = dao.getUserDetail(user_num);
		
		boolean check = false;
		
		//  사용자가 입력한 아이디가 로그인한 아이디와 일치하고, 이메일도 일치하는지 체크
		if(db_user != null && id.equals(user_id) && email.equals(db_user.getEmail())) {
			// 비밀번호 일치 여부 체크
			check = BCrypt.checkpw(passwd, db_user.getPwd());
		}
		
		// 결과에 따른 분기 처리
		if(check) { 
			// 인증 성공 -> 회원정보 탈퇴 처리
			dao.deleteUser(user_num);
			// 로그아웃 (세션 초기화)
			session.invalidate();
			
			// 결과 화면으로 이동
			request.setAttribute("result_title", "회원 탈퇴 완료");
			request.setAttribute("result_msg", "그동안 ShoeMall을 이용해 주셔서 진심으로 감사합니다.<br>회원 탈퇴 처리가 정상적으로 완료되었습니다.");
			request.setAttribute("result_url", request.getContextPath() + "/shop/user/main.do");
			
			return "common/result_view.jsp";
			
		} else {
			// 인증 실패 -> 경고창 띄우기
			request.setAttribute("notice_msg", "입력하신 정보가 등록된 정보와 일치하지 않습니다.");
			request.setAttribute("notice_url", request.getContextPath() + "/shop/user/myPageForm.do");
			
			return "common/alert_view.jsp";
		}
	}
}