package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ReturnDAO;

public class Log_ReturnProcessAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //한글 인코딩 및 스트림 세팅
        request.setCharacterEncoding("UTF-8");

        //JSP 폼 파라미터 수집
        String retNumStr = request.getParameter("retNum");
        String orderNumStr = request.getParameter("orderNum");
        String tpStr = request.getParameter("tp");
        String processType = request.getParameter("processType"); 
        String courier = request.getParameter("courier");
        String invoiceNo = request.getParameter("invoiceNo");
        String adminMemo = request.getParameter("adminMemo"); 
        
     
        String exColor = request.getParameter("exColor");
        String exSize = request.getParameter("exSize");

        
        if (retNumStr == null || processType == null) {
            return "redirect:/logistics/log_return/log_returnForm.do";
        }

        int retNum = Integer.parseInt(retNumStr);
        int orderNum = Integer.parseInt(orderNumStr);
        int tp = Integer.parseInt(tpStr);

        //WMS 클레임 트랜잭션 엔진 기동 (개조된 exColor, exSize 매립형 메서드 타격)
        Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
        dao.processClaimTransaction(retNum, orderNum, tp, processType, courier, invoiceNo, adminMemo, exColor, exSize);

        //처리가 완료되면 클레임 관리 화면으로 깔끔하게 리다이렉트 이동
        return "redirect:/logistics/log_return/log_returnForm.do";
    }
}