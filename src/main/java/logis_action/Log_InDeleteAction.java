package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_InDAO;

public class Log_InDeleteAction implements Action{

	
		@Override
	    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	
	        int inNum = Integer.parseInt(request.getParameter("inNum"));
	        
	  
	        Log_InDAO dao = Log_InDAO.getInstance();
	        dao.deleteInbound(inNum);
	        
	        return "redirect:/logistics/log_in/log_inForm.do?result=deleted"; 
	    }		
		
}
