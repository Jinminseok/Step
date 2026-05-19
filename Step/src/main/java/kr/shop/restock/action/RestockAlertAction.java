package kr.shop.restock.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.*;
import kr.controller.Action;
import kr.shop.dao.RestockAlertDAO;

public class RestockAlertAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        Object userNumObj = session.getAttribute("user_num");

        if (userNumObj == null) {
            response.sendRedirect(request.getContextPath() + "/shop/user/loginForm.do");
            return "none";
        }

        int userNum = ((Number) userNumObj).intValue();
        int optNum  = Integer.parseInt(request.getParameter("opt_num"));
        int prodNum = Integer.parseInt(request.getParameter("prod_num"));

        String result = RestockAlertDAO.getInstance().insertAlert(userNum, optNum);

        request.setAttribute("result", result);
        request.setAttribute("prodNum", prodNum);

        // 신청 결과를 restockList.jsp에서 보여줌
        List<Map<String, Object>> restockList = 
            RestockAlertDAO.getInstance().getAlertListByUser(userNum);
        request.setAttribute("restockList", restockList);

        return "shop/restock/restockList.jsp";
    }
}