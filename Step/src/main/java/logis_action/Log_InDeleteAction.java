package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_InDAO;

public class Log_InDeleteAction implements Action{

	
		@Override
	    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	        // 1. 화면에서 보낸 입고 번호(inNum) 받기
	        int inNum = Integer.parseInt(request.getParameter("inNum"));
	        
	        // 2. DAO 호출해서 DB에서 시원하게 삭제!
	        Log_InDAO dao = Log_InDAO.getInstance(); // 싱글톤 아니면 new Log_InDAO();
	        dao.deleteInbound(inNum);
	        
	        // 3. 삭제가 끝났으니 'deleted' 신호를 달아서 메인 화면으로 돌아갑니다.
	        return "redirect:/logistics/log_in/log_inForm.do?result=deleted"; 
	    }		
		
}
