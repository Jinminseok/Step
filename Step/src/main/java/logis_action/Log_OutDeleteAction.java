package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_OutDAO;

public class Log_OutDeleteAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // JSP에서 넘겨준 출고번호와 주문번호 받기
        int outNum = Integer.parseInt(request.getParameter("outNum"));
        int orderNum = Integer.parseInt(request.getParameter("orderNum"));

        // DAO 호출해서 삭제 및 상태 롤백
        Log_OutDAO dao = new Log_OutDAO();
        dao.cancelOutbound(outNum, orderNum);

      
        return "redirect:/logistics/log_out/log_outForm.do";
    }

}
