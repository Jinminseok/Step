package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminNotifyDAO;
import kr.shop.vo.AdminNotifyVO;

public class AdminSendNoticeAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		if (request.getMethod().equalsIgnoreCase("GET")) {
			return "shop/admin/adminWriteNotice.jsp";
		}

		request.setCharacterEncoding("UTF-8");
		String targetType = request.getParameter("target_type");
		String title = request.getParameter("notify_title");
		String content = request.getParameter("notify_content");

		String targetValue = null;
		if ("GRADE".equals(targetType)) {
			targetValue = request.getParameter("target_grade");
		} else if ("USER".equals(targetType)) {
			targetValue = request.getParameter("target_user_id");
		}

		AdminNotifyVO vo = new AdminNotifyVO();
		vo.setNotify_type(3); // 3: 공지
		vo.setNotify_title(title);
		vo.setNotify_content(content);

		AdminNotifyDAO dao = AdminNotifyDAO.getInstance();
		dao.insertNoticeByCondition(vo, targetType, targetValue);

		return "redirect:/shop/admin/notifyList.do";
	}
}