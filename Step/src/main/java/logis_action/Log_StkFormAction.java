package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class Log_StkFormAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// JSP 경로
		return "logistics/log_stk/log_stkForm.jsp";
	}

}
