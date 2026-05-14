package logis_action;

import java.io.PrintWriter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_InDAO;

public class Log_InInsertAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        Object objAdminNum = session.getAttribute("user_num");
                
        if (objAdminNum == null) {
            // 로그인한 usernum이 관리자가 아니면 로그인 화면으로            
            return "redirect:/logistics/log_login/log_loginForm.do"; 
        }
        int adminNum = ((Number) objAdminNum).intValue(); 
        
        String inDate = request.getParameter("inDate");
        String prodNumStr = request.getParameter("prodNum");
        
        // 🌟 수정 1: 프론트에서 콤마(,)로 묶여서 넘어온 컬러와 사이즈 데이터를 받습니다.
        String colorStrParam = request.getParameter("color"); 
        String sizesStrParam = request.getParameter("sizes"); 
        
        String inQtyStr = request.getParameter("inQty");
        String supplier = request.getParameter("supplier");
        String inMemo = request.getParameter("inMemo");

        if (inDate == null || inDate.trim().isEmpty()) {
            // 날짜 누락시 다시 폼으로
            return "redirect:/log_inForm.do"; 
        }
        
        // 🌟 다중 선택된 컬러 값도 제대로 넘어왔는지 체크 리스트에 추가했습니다.
        if (prodNumStr == null || prodNumStr.trim().isEmpty() || 
            sizesStrParam == null || sizesStrParam.trim().isEmpty() ||
            colorStrParam == null || colorStrParam.trim().isEmpty()) {            
            return "redirect:/logistics/log_in/log_inForm.do"; 
        }

        int prodNum = Integer.parseInt(prodNumStr.trim());
        int inQty = Integer.parseInt(inQtyStr.trim());
        
        Log_InDAO dao = Log_InDAO.getInstance();
        
        // 🌟 수정 2: 넘어온 문자열을 쪼개서 배열로 만듭니다.
        String[] colorArray = colorStrParam.split(",");
        String[] sizeArray = sizesStrParam.split(",");
        
        // 🌟 수정 3: 이중 for문! (선택한 모든 컬러) x (선택한 모든 사이즈) 조합을 돌며 DB에 저장합니다.
        for (String colorStr : colorArray) {
            if (colorStr.trim().isEmpty()) continue; // 혹시 모를 빈칸 방어
            String currentColor = colorStr.trim();
            
            for (String sizeStr : sizeArray) {
                if (sizeStr.trim().isEmpty()) continue; 
                
                int sizeVal = Integer.parseInt(sizeStr.trim());            
                
                // 해당 (상품 번호 + 사이즈 + 컬러) 조합의 옵션 번호를 가져옵니다.
                int optNum = dao.getOptNum(prodNum, sizeVal, currentColor);
                
                if (optNum == 0) {  
                    // 상품 마스터 관리에 등록된 조합(옵션)이 아닐 경우
                    return "redirect:/logistics/log_in/log_inForm.do?result=opt_error";
                }
                
                // 입고 내역 INSERT 및 재고 UPDATE
                dao.insertInbound(optNum, prodNum, inQty, adminNum, inMemo, inDate, supplier);                      
                dao.updateStock(optNum, prodNum, inQty);
            }       
        }
        
        return "redirect:/logistics/log_in/log_inForm.do?result=in_success";
    }
}