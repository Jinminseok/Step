package kr.shop.user.action;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;

public class RegisterAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserVO user = new UserVO();
		user.setUser_id(request.getParameter("user_id"));
		user.setUser_name(request.getParameter("user_name"));
		
		String hashedPassword = BCrypt.hashpw(request.getParameter("pwd"), BCrypt.gensalt());
		user.setPwd(hashedPassword);
		
		user.setPhone(request.getParameter("phone"));
		user.setEmail(request.getParameter("email"));
		user.setZipcode(request.getParameter("zipcode"));
		user.setAddr1(request.getParameter("addr1"));
		user.setAddr2(request.getParameter("addr2"));
		
		UserDAO dao = UserDAO.getInstance();
		dao.insertUser(user);
		
		request.setAttribute("result_title", "회원 가입 완료");
		request.setAttribute("result_msg", "회원 가입이 완료되었습니다.");
		request.setAttribute("result_url", request.getContextPath()+"/shop/user/main.do");
		

		return "common/result_view.jsp";
	}
}