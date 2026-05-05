package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_InDAO;

public class Log_InInsertAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		        
        HttpSession session = request.getSession();
        Object objUserNum = session.getAttribute("user_num");
                
        if (objUserNum == null) {
            
        	//로그인한 usernum이 관리자가 아니면 로그인 화면으로            
            return "redirect:/logistics/log_login/log_loginForm.do"; 
        }
        int user_num = ((Number) objUserNum).intValue(); 
        
        String inDate = request.getParameter("inDate");
        String prodNumStr = request.getParameter("prodNum");
        String color = request.getParameter("color");
        String sizes = request.getParameter("sizes"); 
        String inQtyStr = request.getParameter("inQty");
        String supplier = request.getParameter("supplier");
        String inMemo = request.getParameter("inMemo");

        
        if (inDate == null || inDate.trim().isEmpty()) {
            //날짜 누락시 다시 폼으로
            return "redirect:/log_inForm.do"; 
        }
        
        if (prodNumStr == null || prodNumStr.trim().isEmpty() || sizes == null || sizes.trim().isEmpty()) {            
            return "redirect:/logistics/log_in/log_inForm.do"; 
        }

        int prodNum = Integer.parseInt(prodNumStr.trim());
        int inQty = Integer.parseInt(inQtyStr.trim());
        
        
        String finalMemo = "";
        if (supplier != null && !supplier.isEmpty()) { finalMemo = "[" + supplier + "] "; }
        if (inMemo != null) { finalMemo += inMemo; }

        Log_InDAO dao = Log_InDAO.getInstance();
        String[] sizeArray = sizes.split(",");
        
        // 🚨 CCTV 3번: DB 저장 루프가 정상적으로 도는가?
        for (String sizeStr : sizeArray) {
            if(sizeStr.trim().isEmpty()) continue; // 혹시 모를 빈칸 방어
            
            int sizeVal = Integer.parseInt(sizeStr.trim());            
            
            int optNum = dao.getOptNum(prodNum, sizeVal, color);
            if(optNum == 0) {
                optNum = dao.insertOptionAndGetNum(prodNum, sizeVal, color);               
            }
            
            dao.insertInbound(optNum, prodNum, inQty, user_num, finalMemo, inDate);                        
            dao.updateStock(optNum, prodNum, inQty);
            
        }        
        return "redirect:/logistics/log_in/log_inForm.do";
	}
	
}
