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
        
        if (user != null && user.isCheckedPassword(passwd)) {
            HttpSession session = request.getSession();
            session.setAttribute("user_num", user.getUser_num());
            session.setAttribute("user_id", user.getUser_id());
            session.setAttribute("user_auth", user.getAuth());

            // 마지막 로그인 시간 업데이트 ← 추가
            dao.updateLastLogin(user.getUser_num());

            if (user.getAuth() == 9) {
                return "redirect:/shop/admin/main.do";
            } else {
                return "redirect:/shop/user/main.do";
            }
        } else {
            request.setAttribute("loginError", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "shop/user/login.jsp";
        }
    }  
}