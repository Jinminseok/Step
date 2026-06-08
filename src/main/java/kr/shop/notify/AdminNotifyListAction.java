package kr.shop.notify;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminNotifyDAO;
import kr.shop.vo.UserNotifyVO;
import kr.util.PagingUtil;

public class AdminNotifyListAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
        Object user_auth_obj = session.getAttribute("user_auth");
        if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
            return "redirect:/shop/user/loginForm.do";
        }

        String pageNum = request.getParameter("pageNum");
        if (pageNum == null) pageNum = "1";

        String notify_type_param = request.getParameter("notify_type");
        int notify_type = 0;
        if (notify_type_param != null && !notify_type_param.isEmpty()) {
            notify_type = Integer.parseInt(notify_type_param);
        }

        String keyword = request.getParameter("keyword");

        UserNotifyVO vo = new UserNotifyVO();
        vo.setNotify_type(notify_type);
        vo.setKeyword(keyword);

        AdminNotifyDAO dao = AdminNotifyDAO.getInstance();
        int count = dao.getNotifyTotalCount(vo);

        StringBuilder addKey = new StringBuilder();
        if (notify_type > 0) addKey.append("&notify_type=").append(notify_type);
        if (keyword != null && !keyword.isEmpty()) addKey.append("&keyword=").append(keyword);

        PagingUtil page = new PagingUtil(
            null, null, Integer.parseInt(pageNum), count, 15, 10,
            "notifyList.do", addKey.toString()
        );

        List<UserNotifyVO> list = null;
        if (count > 0) {
            vo.setStart_row(page.getStartRow());
            vo.setEnd_row(page.getEndRow());
            list = dao.getNotifyList(vo);
        }

        request.setAttribute("count", count);
        request.setAttribute("list", list);
        request.setAttribute("page", page.getPage());
        request.setAttribute("notify_type", notify_type);
        request.setAttribute("keyword", keyword);
        request.setAttribute("app_title", "알림 발송 관리");
        
        return "shop/notify/NotifyList.jsp";
    }
}
