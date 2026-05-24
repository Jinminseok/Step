package kr.shop.user.action;

import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;

public class ModifyAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		
		// 세션에서 현재 로그인한 유저 정보 꺼내기
		HttpSession session = request.getSession();
		String user_id = (String) session.getAttribute("user_id");
		Long user_num = (Long) session.getAttribute("user_num"); // DAO 업데이트 조건용
		
		// 로그인 확인
		if (user_id == null) {
			return "redirect:/shop/user/loginForm.do";
		}
		
		// 현재 비밀번호(필수) 파라미터 받기
		String passwd = request.getParameter("passwd");
		
		// 현재 비밀번호 미입력 시 결과창 대신 마이페이지로 이동
		if (passwd == null || passwd.trim().isEmpty()) {
			session.setAttribute("modifyMsg", "정보를 수정하려면 현재 비밀번호를 꼭 입력해야 합니다.");
			return "redirect:/shop/user/myPageForm.do";
		}
		
		// DB에 있는 내 현재 정보 불러오기
		UserDAO dao = UserDAO.getInstance();
		UserVO currentUser = dao.getUserDetail(user_num);
		
		// 현재 비밀번호 일치 확인
		// 일치하지 않으면 세션에 메시지를 담아 마이페이지로 즉시 리다이렉트
		if (currentUser == null || !BCrypt.checkpw(passwd, currentUser.getPwd())) {
			session.setAttribute("modifyMsg", "현재 비밀번호가 일치하지 않습니다.");
			return "redirect:/shop/user/myPageForm.do";
		}
		
		// --------------------------------------------------------
		// 업데이트할 정보 세팅 (비어있으면 기존 값, 있으면 새 값)
		// --------------------------------------------------------
		UserVO updateUser = new UserVO();
		updateUser.setUser_num(user_num);
		
		String name = request.getParameter("name");
		updateUser.setUser_name( (name == null || name.trim().isEmpty()) ? currentUser.getUser_name() : name );
		
		String phone = request.getParameter("phone");
		updateUser.setPhone( (phone == null || phone.trim().isEmpty()) ? currentUser.getPhone() : phone );
		
		String email = request.getParameter("email");
		updateUser.setEmail( (email == null || email.trim().isEmpty()) ? currentUser.getEmail() : email );
		
		String zipcode = request.getParameter("zipcode");
		updateUser.setZipcode( (zipcode == null || zipcode.trim().isEmpty()) ? currentUser.getZipcode() : zipcode );
		
		String addr1 = request.getParameter("addr1");
		updateUser.setAddr1( (addr1 == null || addr1.trim().isEmpty()) ? currentUser.getAddr1() : addr1 );
		
		String addr2 = request.getParameter("addr2");
		updateUser.setAddr2( (addr2 == null || addr2.trim().isEmpty()) ? currentUser.getAddr2() : addr2 );

		// --------------------------------------------------------
		// 새 비밀번호 변경
		// --------------------------------------------------------
		String new_passwd = request.getParameter("new_passwd");
		String new_passwd_confirm = request.getParameter("new_passwd_confirm");
		
		if (new_passwd != null && !new_passwd.trim().isEmpty()) {
			// 새 비밀번호와 확인이 다를 때도 마이페이지로
			if (!new_passwd.equals(new_passwd_confirm)) {
				session.setAttribute("modifyMsg", "새 비밀번호와 비밀번호 확인이 서로 다릅니다.");
				return "redirect:/shop/user/myPageForm.do";
			}
			// 일치하면 새 비밀번호를 암호화해서 넣기
			updateUser.setPwd(BCrypt.hashpw(new_passwd, BCrypt.gensalt()));
		} else {
			// 새 비밀번호 칸을 비워뒀다면 기존 암호화된 비밀번호를 그대로 복사
			updateUser.setPwd(currentUser.getPwd());
		}
		
		// DB 업데이트 실행
		dao.updateUser(updateUser);
		
		// 전부 완료되면 결과창으로
		request.setAttribute("result_title", "정보 수정 완료");
		request.setAttribute("result_msg", "회원 정보가 성공적으로 변경되었습니다.");
		request.setAttribute("result_url", request.getContextPath() + "/shop/user/myPageForm.do");
		
		return "common/result_view.jsp";
	}
}