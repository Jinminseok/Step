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
		// 관리자 권한 체크
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		// GET 요청이면 공지 작성 폼 페이지로 포워딩
		if (request.getMethod().equalsIgnoreCase("GET")) {
			return "shop/admin/adminWriteNotice.jsp";
		}

		// POST 요청이면 일괄 발송 처리
		request.setCharacterEncoding("UTF-8");
		String title = request.getParameter("notify_title");
		String content = request.getParameter("notify_content");

		AdminNotifyVO vo = new AdminNotifyVO();
		vo.setNotify_type(3); // 3: 전체 공지 유형
		vo.setNotify_title(title);
		vo.setNotify_content(content);

		AdminNotifyDAO dao = AdminNotifyDAO.getInstance();
		dao.insertNoticeToAllUsers(vo);

		// 발송 완료 후 이력 리스트로 리다이렉트
		return "redirect:/shop/admin/notifyList.do";
	}
}