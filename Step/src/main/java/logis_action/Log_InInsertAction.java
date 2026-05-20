package logis_action;

import java.io.PrintWriter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_InDAO;

public class Log_InInsertAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		        
        HttpSession session = request.getSession();
        Object objAdminNum = session.getAttribute("user_num");
                
        if (objAdminNum == null) {
            
        	//로그인한 usernum이 관리자가 아니면 로그인 화면으로            
            return "redirect:/logistics/log_login/log_loginForm.do"; 
        }
        int adminNum = ((Number) objAdminNum).intValue(); 
        
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
        
        

        Log_InDAO dao = Log_InDAO.getInstance();
        String[] sizeArray = sizes.split(",");
        
        // 🚨 CCTV 3번: DB 저장 루프가 정상적으로 도는가?
        for (String sizeStr : sizeArray) {
            if(sizeStr.trim().isEmpty()) continue; // 혹시 모를 빈칸 방어
            
            int sizeVal = Integer.parseInt(sizeStr.trim());            
            
            int optNum = dao.getOptNum(prodNum, sizeVal, color);
            if (optNum == 0) {	//상품 마스터 관리에 등록된 상품이 아닐 경우
                
            	return "redirect:/logistics/log_in/log_inForm.do?result=opt_error";
            }
            
            dao.insertInbound(optNum, prodNum, inQty, adminNum, inMemo, inDate, supplier);                      
            dao.updateStock(optNum, prodNum, inQty);
            
        }        
        return "redirect:/logistics/log_in/log_inForm.do?result=in_success";
	}
	
}