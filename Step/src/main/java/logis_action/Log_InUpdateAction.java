package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_InDAO;
import logis_vo.Log_InVO;

public class Log_InUpdateAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        
        // 1. 폼 데이터 다 받기
        int inNum = Integer.parseInt(request.getParameter("inNum"));
        String inDate = request.getParameter("inDate");
        int inQty = Integer.parseInt(request.getParameter("inQty"));
        int status = Integer.parseInt(request.getParameter("status"));
        String supplier = request.getParameter("supplier");
        String inMemo = request.getParameter("inMemo");
        
        int sizeVal = Integer.parseInt(request.getParameter("sizeVal"));
        String color = request.getParameter("color");
        
        // 2. VO에 몽땅 담기
        Log_InVO vo = new Log_InVO();
        vo.setInNum(inNum);
        vo.setInDate(inDate);
        vo.setInQty(inQty);
        vo.setInStatus(status);
        vo.setSupplier(supplier);
        vo.setInMemo(inMemo);
        vo.setSizeVal(sizeVal); // 💡 사이즈도 담고!
        vo.setColor(color);     // 💡 컬러도 담고!
        
        // 3. DAO 실행 한방에 끝!
        Log_InDAO dao = Log_InDAO.getInstance(); // 또는 new Log_InDAO();
        try {
            dao.updateInbound(vo);
        } catch (Exception e) {
            // 서브쿼리에서 해당하는 색상/사이즈를 못 찾아서 에러가 났을 경우
            return "redirect:/logistics/log_in/log_inForm.do?result=opt_error";
        }
        
        // 4. 성공
        return "redirect:/logistics/log_in/log_inForm.do?result=updated"; 
    }
}
