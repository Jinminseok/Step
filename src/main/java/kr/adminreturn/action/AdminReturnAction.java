package kr.adminreturn.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminReturnDAO;
import kr.shop.vo.AdminOrderVO;

public class AdminReturnAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        //JSP 필터 폼에서 넘어온 파라미터 수집
        String sTp = request.getParameter("sTp");               // 신청 유형 (전체/반품/교환)
        String sStatus = request.getParameter("sStatus");       // 처리 상태 (대기/수거/완료/반려)
        String sKeywordType = request.getParameter("sKeywordType"); // 검색 조건 (주문번호/회원번호/사유)
        String sKeyword = request.getParameter("sKeyword");     // 검색어
        String startDate = request.getParameter("startDate"); // 날짜 시작일 수집
        String endDate = request.getParameter("endDate");     // 날짜 종료일 수집

        //방어 코드: 맨 처음 페이지에 진입했을 때 null이 넘어오는 것을 방지 (초기값 세팅)
        if (sTp == null) sTp = "ALL";
        if (sStatus == null) sStatus = "ALL";
        if (sKeywordType == null) sKeywordType = "orderNum";
        if (sKeyword == null) sKeyword = "";
        if (startDate == null) startDate = "";
        if (endDate == null) endDate = "";

        //DB 비즈니스 로직 가동 (DAO 호출) ──
        AdminReturnDAO dao = AdminReturnDAO.getInstance();

        //상단 대시보드용 실시간 현황판 카운트 데이터 추출
        Map<String, Integer> counts = dao.getReturnCounts();
        request.setAttribute("pendingCount", counts.get("pendingCount"));
        request.setAttribute("processingCount", counts.get("processingCount"));
        request.setAttribute("completedCount", counts.get("completedCount"));
        request.setAttribute("rejectedCount", counts.get("rejectedCount"));
        request.setAttribute("totalCount", counts.get("totalCount"));

        List<AdminOrderVO> returnList = dao.getAdminReturnList(sTp, sStatus, sKeywordType, sKeyword, startDate, endDate);
        request.setAttribute("returnList", returnList);
        
        return "shop/return/returnForm.jsp";
    }
}