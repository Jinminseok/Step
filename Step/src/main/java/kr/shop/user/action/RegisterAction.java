package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;

public class RegisterAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 1. POST 한글 인코딩
		request.setCharacterEncoding("utf-8");
		
		// 2. 파라미터 받아서 VO에 담기
		UserVO user = new UserVO();
		user.setUser_id(request.getParameter("id"));
		user.setPwd(request.getParameter("passwd"));
		user.setUser_name(request.getParameter("name"));
		user.setPhone(request.getParameter("phone"));
		user.setEmail(request.getParameter("email"));
		user.setZipcode(request.getParameter("zipcode"));
		user.setAddr1(request.getParameter("addr1"));
		user.setAddr2(request.getParameter("addr2"));
		
		// 3. DAO 호출해서 DB에 넣기
		UserDAO dao = UserDAO.getInstance();
		dao.insertUser(user);
		
		// 4. 완료 후 로그인 페이지로 이동 (user.properties에 설정한 주소)
		return "shop/user/loginForm.do";
	}
}