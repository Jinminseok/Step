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
        // 1. 한글 깨짐 방지 인코딩 세팅
        request.setCharacterEncoding("UTF-8");
        
        String mode = request.getParameter("mode"); 
        int retNum = Integer.parseInt(request.getParameter("retNum"));
        
        Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
        
        // 2. 오라클 비즈니스 로직 타격 (메모 수정 또는 이력 취소)
        if ("UPDATE".equals(mode)) {
            String adminMemo = request.getParameter("adminMemo");
            dao.updateClaimMemo(retNum, adminMemo);
            
        } else if ("CANCEL".equals(mode)) {
            int orderNum = Integer.parseInt(request.getParameter("orderNum"));
            int tp = Integer.parseInt(request.getParameter("tp"));
            int currentStatus = Integer.parseInt(request.getParameter("currentStatus"));
            
            // 🎯 개조된 역연산 트랜잭션 엔진 작동! (기존 상품 되감기 및 출고 상품 창고 복귀 동시 타격)
            dao.cancelClaimTransaction(retNum, orderNum, tp, currentStatus);
        }
        
        try {
            Thread.sleep(150); // DB 격리성 유지를 위한 150ms 브레이크
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        // 취소/수정 연산이 끝난 후, 변화된 최신 DB 상태를 다시 한 번 완벽하게 긁어옵니다.
        List<Log_ReturnVO> claimList = dao.getClaimWaitList();
        List<Log_ReturnVO> historyList = dao.getClaimHistoryList();
        
        // 🚀 디스패처가 JSP 화면을 그릴 때 낙오되지 않도록 request 상자에 꽉 채워 담아줍니다!
        request.setAttribute("claimList", claimList);
        request.setAttribute("historyList", historyList);
        
        // 3. 형님 프레임워크 포워딩 규칙에 맞게 파일 확장자까지 명시하여 리턴!
        return "logistics/log_return/log_returnForm.jsp";
    }
}