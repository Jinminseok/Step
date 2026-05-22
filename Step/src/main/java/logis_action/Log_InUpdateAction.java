package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.RestockAlertDAO;
import logis.dao.Log_InDAO;
import logis_vo.Log_InVO;

public class Log_InUpdateAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");

        int inNum       = Integer.parseInt(request.getParameter("inNum"));
        String inDate   = request.getParameter("inDate");
        int inQty       = Integer.parseInt(request.getParameter("inQty"));
        int status      = Integer.parseInt(request.getParameter("status"));
        String supplier = request.getParameter("supplier");
        String inMemo   = request.getParameter("inMemo");
        int sizeVal     = Integer.parseInt(request.getParameter("sizeVal"));
        String color    = request.getParameter("color");

        Log_InVO vo = new Log_InVO();
        vo.setInNum(inNum);
        vo.setInDate(inDate);
        vo.setInQty(inQty);
        vo.setInStatus(status);
        vo.setSupplier(supplier);
        vo.setInMemo(inMemo);
        vo.setSizeVal(sizeVal);
        vo.setColor(color);

        Log_InDAO dao = Log_InDAO.getInstance();
        try {
            dao.updateInbound(vo);
        } catch (Exception e) {
            return "redirect:/logistics/log_in/log_inForm.do?result=opt_error";
        }

        // 수량 수정 후 재입고 알림 발송
        try {
            int prodNum = dao.getProdNumByInNum(inNum);
            int optNum  = dao.getOptNum(prodNum, sizeVal, color);
            if (optNum > 0) {
                RestockAlertDAO.getInstance().sendRestockNotify(optNum);
            }
        } catch (Exception e) {
            System.out.println("재입고 알림 발송 실패 - inNum: " + inNum + " / " + e.getMessage());
        }

        return "redirect:/logistics/log_in/log_inForm.do?result=updated";
    }
}