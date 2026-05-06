package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;

public class LoginAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        String passwd = request.getParameter("passwd");
        
        UserDAO dao = UserDAO.getInstance();
        UserVO user = dao.checkUser(id);
        
        // 아이디가 존재하고 비밀번호가 일치하는지 확인
        if (user != null && user.isCheckedPassword(passwd)) {
            HttpSession session = request.getSession();
            session.setAttribute("user_num", user.getUser_num());
            session.setAttribute("user_id", user.getUser_id());
            session.setAttribute("user_auth", user.getAuth());
            
            // 관리자(9)면 관리자 메인으로, 일반회원(2)이면 쇼핑몰 메인으로 이동
            if (user.getAuth() == 9) {
                return "redirect:/shop/admin/main.do"; 
            } else {
                return "redirect:/shop/user/main.do";
            }
        } else {
            // 로그인 실패 시 로그인 화면
        	request.setAttribute("loginError", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "shop/user/login.jsp";
        }
    }
}