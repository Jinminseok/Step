package logis_action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ReturnDAO;
import logis_vo.Log_ReturnVO;

public class Log_ReturnFormAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        
        Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
        
        // 1. 접수 완료 상태(ret_status = 1)의 대기 리스트 수집
        List<Log_ReturnVO> claimList = dao.getClaimWaitList();
        
        // 2. 완결된 상태(ret_status = 3 또는 4)의 최종 이력 리스트 수집
        List<Log_ReturnVO> historyList = dao.getClaimHistoryList();
        
        // 3. JSP 화면으로 데이터를 상자에 담아 전송
        request.setAttribute("claimList", claimList);
        request.setAttribute("historyList", historyList);
        
        // 4. 형님의 디스패처 서블릿 뷰 경로 규칙에 맞춰 포워딩 리턴!
        return "logistics/log_return/log_returnForm.jsp";
    }
}