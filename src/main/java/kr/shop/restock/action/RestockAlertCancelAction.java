package kr.shop.restock.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.RestockAlertDAO;

public class RestockAlertCancelAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
        Object userNumObj = session.getAttribute("user_num");

        if (userNumObj == null) {
            response.sendRedirect(request.getContextPath() + "/shop/user/loginForm.do");
            return "none";
        }

        int userNum  = ((Number) userNumObj).intValue();
        int alertNum = Integer.parseInt(request.getParameter("alert_num"));

        RestockAlertDAO.getInstance().deleteAlert(alertNum, userNum);

        // 취소 후 목록 새로 조회
        List<Map<String, Object>> restockList = 
            RestockAlertDAO.getInstance().getAlertListByUser(userNum);
        request.setAttribute("restockList", restockList);
        request.setAttribute("result", "cancel_ok");

        return "shop/restock/restockList.jsp";
    }
}