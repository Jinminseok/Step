package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.RestockAlertDAO;
import logis.dao.Log_InDAO;

public class Log_InInsertAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        Object objAdminNum = session.getAttribute("user_num");

        if (objAdminNum == null) {
            return "redirect:/logistics/log_login/log_loginForm.do";
        }
        int adminNum = ((Number) objAdminNum).intValue();

        String inDate     = request.getParameter("inDate");
        String prodNumStr = request.getParameter("prodNum");
        String color      = request.getParameter("color");
        String sizes      = request.getParameter("sizes");
        String inQtyStr   = request.getParameter("inQty");
        String supplier   = request.getParameter("supplier");
        String inMemo     = request.getParameter("inMemo");

        if (inDate == null || inDate.trim().isEmpty()) {
            return "redirect:/log_inForm.do";
        }
        if (prodNumStr == null || prodNumStr.trim().isEmpty() || sizes == null || sizes.trim().isEmpty()) {
            return "redirect:/logistics/log_in/log_inForm.do";
        }

        int prodNum = Integer.parseInt(prodNumStr.trim());
        int inQty   = Integer.parseInt(inQtyStr.trim());

        Log_InDAO dao = Log_InDAO.getInstance();
        String[] sizeArray = sizes.split(",");

        for (String sizeStr : sizeArray) {
            if (sizeStr.trim().isEmpty()) continue;

            int sizeVal = Integer.parseInt(sizeStr.trim());
            int optNum  = dao.getOptNum(prodNum, sizeVal, color);

            if (optNum == 0) {
                return "redirect:/logistics/log_in/log_inForm.do?result=opt_error";
            }

            dao.insertInbound(optNum, prodNum, inQty, adminNum, inMemo, inDate, supplier);
            dao.updateStock(optNum, prodNum, inQty);

            // ✅ 재입고 알림 발송
            System.out.println("===== 재입고 알림 발송 시도 =====");
            System.out.println("optNum: " + optNum + ", prodNum: " + prodNum);
            try {
                RestockAlertDAO.getInstance().sendRestockNotify(optNum);
                System.out.println("===== 재입고 알림 발송 완료 =====");
            } catch (Exception e) {
                System.out.println("===== 재입고 알림 발송 실패: " + e.getMessage() + " =====");
                e.printStackTrace();
            }
        }

        return "redirect:/logistics/log_in/log_inForm.do?result=in_success";
    }
}