package logis_action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_InDAO;
import logis_vo.Log_InVO;

public class Log_InFormAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Log_InDAO dao = Log_InDAO.getInstance();
        
        // 1. 입고 이력 전체 목록 가져오기
        List<Log_InVO> list = dao.getInboundList();
        request.setAttribute("inboundList", list);
        
        // 2. 검색 모달창에 띄울 상품 마스터 목록 가져오기
        List<Log_InVO> prodList = dao.getProductListForSearch();
        request.setAttribute("prodList", prodList);
        
        // 3. 상품 마스터 관리에 신규 등록된 입고 대기 상품 목록 가져오기 (오른쪽 요약판용)
        List<Log_InVO> pendingMasterList = dao.getPendingMasterList();
        request.setAttribute("pendingMasterList", pendingMasterList);
        
        // 3. 폼 화면으로 포워딩
        return "logistics/log_in/log_inForm.jsp";
	}
}
