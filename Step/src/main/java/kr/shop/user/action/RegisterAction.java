package kr.shop.user.action;

import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.dao.UserNotifyDAO;
import kr.shop.vo.UserNotifyVO;
import kr.shop.vo.UserVO;

public class RegisterAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. 입력값 세팅
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

        // 2. 회원가입 INSERT → user_num 반환
        UserDAO dao = UserDAO.getInstance();
        int newUserNum = dao.insertUser(user);

     // 환영 알림 발송
        if (newUserNum > 0) {
            UserNotifyVO noti = new UserNotifyVO();
            noti.setUser_num(newUserNum);
            noti.setNotify_type(3);
            noti.setNotify_title("🎉 가입을 환영합니다!");
            noti.setNotify_content("ShoeMall 회원이 되신 것을 축하드립니다. 다양한 혜택을 누려보세요!");
            UserNotifyDAO.getInstance().insertNotify(noti);
        }

        // 4. 결과 페이지
        request.setAttribute("result_title", "회원 가입 완료");
        request.setAttribute("result_msg", "회원 가입이 완료되었습니다.");
        request.setAttribute("result_url", request.getContextPath() + "/shop/user/main.do");

        return "common/result_view.jsp";
    }
}