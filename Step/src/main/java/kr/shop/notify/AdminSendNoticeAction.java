package kr.shop.notify;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminNotifyDAO;
import kr.shop.vo.UserNotifyVO;

public class AdminSendNoticeAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        Object user_auth_obj = session.getAttribute("user_auth");
        if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
            return "redirect:/shop/user/loginForm.do";
        }

        // GET 요청 → 작성 폼 보여주기
        if (request.getMethod().equalsIgnoreCase("GET")) {
            return "shop/notify/WriteNotice.jsp";
        }

        // POST 요청 → 알림 발송 처리
        request.setCharacterEncoding("UTF-8");

        String targetType  = request.getParameter("target_type");
        String title       = request.getParameter("notify_title");
        String content     = request.getParameter("notify_content");

        String targetValue = null;
        if ("GRADE".equals(targetType)) {
            targetValue = request.getParameter("target_grade");
        } else if ("USER".equals(targetType)) {
            targetValue = request.getParameter("target_user_id");
        }

        UserNotifyVO vo = new UserNotifyVO();
        vo.setNotify_type(3); // 3: 공지
        vo.setNotify_title(title);
        vo.setNotify_content(content);

        int count = AdminNotifyDAO.getInstance().insertNoticeByCondition(vo, targetType, targetValue);

        request.setAttribute("result_title", "알림 발송 완료");
        request.setAttribute("result_msg", "총 " + count + "명에게 알림이 발송되었습니다.");
        request.setAttribute("result_url", request.getContextPath() + "/shop/notify/notifyList.do");
        return "shop/notify/WriteNotice.jsp";
    }
}