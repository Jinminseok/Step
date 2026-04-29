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
        // 1. 파라미터 수집
        String id = request.getParameter("id");
        String passwd = request.getParameter("passwd");
        
        // 2. DAO 호출 (싱글턴 방식으로 수정)
        UserDAO dao = UserDAO.getInstance(); // new 대신 getInstance() 사용
        UserVO user = dao.checkUser(id);
        
        // 3. 로그인 성공 여부 판단
        if (user != null) {
            // 로그인 성공 -> 시간 업데이트 및 세션 저장
//            dao.updateLastLogin(user.getUser_num()); // VO 필드명 확인 (user_num인지 userNum인지)
            
            HttpSession session = request.getSession();
            session.setAttribute("user_num", user.getUser_num());
            session.setAttribute("user_id", user.getUser_id());
            session.setAttribute("user_auth", user.getAuth());
            
            // 4. 권한 분기
            if (user.getAuth() == 9) {
                return "redirect:/shop/admin/main.do"; 
            } else {
                return "redirect:/main/main.do"; 
            }
            
        } else {
            // 로그인 실패
            request.setAttribute("msg", "아이디 또는 비밀번호가 틀렸거나 활동이 제한된 계정입니다.");
            return "/WEB-INF/views/shop/user/KM_login.jsp";
        }
    }
}