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
        //인코딩 필터 통과 및 인코딩 확정
        request.setCharacterEncoding("UTF-8");
        
        Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
        
        //오라클 DB에서 옵션 정보가 포함된 완벽한 대기 목록 긁어오기
        List<Log_ReturnVO> claimList = dao.getClaimWaitList();
        
        //완결된 상태의 최종 이력 목록 긁어오기
        List<Log_ReturnVO> historyList = dao.getClaimHistoryList();
        
        System.out.println("====== 🔥 WMS 백엔드 데이터 추적 시작 ======");
        if(claimList != null && !claimList.isEmpty()) {
            System.out.println("▶ [성공] 대기 목록 개수: " + claimList.size() + "건 조회 완료!");
            // 첫 번째 데이터 알맹이 출력 검증
            Log_ReturnVO testVO = claimList.get(0);
            System.out.println("▶ [검증] 첫 데이터 접수번호: " + testVO.getRet_num());
            System.out.println("▶ [검증] 첫 데이터 상품명: " + testVO.getProd_name());
            System.out.println("▶ [검증] 첫 데이터 색상: " + testVO.getColor());
            System.out.println("▶ [검증] 첫 데이터 사이즈: " + testVO.getSize_val());
            System.out.println("▶ [검증] 첫 데이터 연락처: " + testVO.getRecv_phone());
        } else {
            System.out.println("▶ [경고] 오라클 DB에서 가져온 대기 데이터(claimList)가 아예 0건이거나 텅 비어있습니다!");
        }
        System.out.println("=========================================");
        
        request.setAttribute("claimList", claimList);
        request.setAttribute("historyList", historyList);
        
        return "logistics/log_return/log_returnForm.jsp";
    }
}