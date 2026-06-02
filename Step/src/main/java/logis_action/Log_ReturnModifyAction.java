package logis_action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ReturnDAO;
import logis_vo.Log_ReturnVO;

public class Log_ReturnModifyAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
  
        request.setCharacterEncoding("UTF-8");
        
        String mode = request.getParameter("mode"); 
        int retNum = Integer.parseInt(request.getParameter("retNum"));
        
        Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
        
   
        if ("UPDATE".equals(mode)) {
            String adminMemo = request.getParameter("adminMemo");
            dao.updateClaimMemo(retNum, adminMemo);
            
        } else if ("CANCEL".equals(mode)) {
            int orderNum = Integer.parseInt(request.getParameter("orderNum"));
            int tp = Integer.parseInt(request.getParameter("tp"));
            int currentStatus = Integer.parseInt(request.getParameter("currentStatus"));
            
          
            dao.cancelClaimTransaction(retNum, orderNum, tp, currentStatus);
        }
        
        try {
            Thread.sleep(150); // DB 격리성 유지를 위한 150ms 브레이크
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        

        List<Log_ReturnVO> claimList = dao.getClaimWaitList();
        List<Log_ReturnVO> historyList = dao.getClaimHistoryList();
        
       
        request.setAttribute("claimList", claimList);
        request.setAttribute("historyList", historyList);
        
        return "logistics/log_return/log_returnForm.jsp";
    }
}