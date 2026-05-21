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
        // 1. 인코딩 필터 통과 및 인코딩 확정
        request.setCharacterEncoding("UTF-8");
        
        // 2. 🚨 [싱글톤 연동] 형님이 만드신 싱글톤 인스턴스로 정확하게 교체!
        Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
        
        // 3. 오라클 DB에서 옵션 정보가 포함된 완벽한 대기 목록 긁어오기
        List<Log_ReturnVO> claimList = dao.getClaimWaitList();
        
        // 4. 완결된 상태의 최종 이력 목록 긁어오기
        List<Log_ReturnVO> historyList = dao.getClaimHistoryList();
        
        // 🚀 [WMS 긴급 추적 로그] 이 코드가 돌아갈 때 이클립스/인텔리제이 콘솔창을 무조건 보셔야 합니다!
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
        
        // 5. 🎯 중요: JSP 화면에서 사용하는 상자 이름과 100% 일치시킵니다 ("claimList")
        request.setAttribute("claimList", claimList);
        request.setAttribute("historyList", historyList);
        
        // 6. 형님 프로젝트의 최종 뷰(JSP) 경로로 토스
        return "logistics/log_return/log_returnForm.jsp";
    }
}