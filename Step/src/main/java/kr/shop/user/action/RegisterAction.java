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

        UserVO user = new UserVO();
        user.setUser_id(request.getParameter("user_id"));
        user.setUser_name(request.getParameter("user_name"));
        user.setPwd(BCrypt.hashpw(request.getParameter("pwd"), BCrypt.gensalt()));
        user.setPhone(request.getParameter("phone"));
        user.setEmail(request.getParameter("email"));
        user.setZipcode(request.getParameter("zipcode"));
        user.setAddr1(request.getParameter("addr1"));
        user.setAddr2(request.getParameter("addr2"));

        UserDAO dao = UserDAO.getInstance();

        // 1. 원래 방식대로 회원가입
        dao.insertUser(user);

        // 2. 가입한 user_id로 user_num 조회
        long newUserNum = dao.getUserNumByUserId(user.getUser_id());

        // 3. 환영 알림 발송
        if (newUserNum > 0) {
            UserNotifyVO noti = new UserNotifyVO();
            noti.setUser_num((int) newUserNum);
            noti.setNotify_type(3);
            noti.setNotify_title("🎉 가입을 환영합니다!");
            noti.setNotify_content("ShoeMall 회원이 되신 것을 축하드립니다. 다양한 혜택을 누려보세요!");
            UserNotifyDAO.getInstance().insertNotify(noti);
        }

        request.setAttribute("result_title", "회원 가입 완료");
        request.setAttribute("result_msg", "회원 가입이 완료되었습니다.");
        request.setAttribute("result_url", request.getContextPath() + "/shop/user/main.do");
        return "common/result_view.jsp";
    }
}