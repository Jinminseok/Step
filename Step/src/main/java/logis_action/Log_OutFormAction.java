package logis_action;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_OutDAO;
import logis_vo.Log_OutVO;

public class Log_OutFormAction implements Action {
	
	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 대기 목록 파라미터
        String keyword = request.getParameter("keyword");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // 2. 이력 조회 파라미터
        String histKeyword = request.getParameter("histKeyword");
        String histStartDate = request.getParameter("histStartDate");
        String histEndDate = request.getParameter("histEndDate");
        
        // 현재 열려있는 탭 정보 (새로고침 시 유지용)
        String tab = request.getParameter("tab");
        if(tab == null) tab = "out";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // 대기 목록 날짜 기본값 (1달 전 ~ 오늘)
        if (startDate == null || startDate.isEmpty() || endDate == null || endDate.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            endDate = sdf.format(cal.getTime());
            cal.add(Calendar.MONTH, -1);
            startDate = sdf.format(cal.getTime());
        }

        // 🚨 이력 조회 날짜 기본값 (1달 전 ~ 오늘)
        if (histStartDate == null || histStartDate.isEmpty() || histEndDate == null || histEndDate.isEmpty()) {
            Calendar histCal = Calendar.getInstance();
            histEndDate = sdf.format(histCal.getTime());
            histCal.add(Calendar.MONTH, -1);
            histStartDate = sdf.format(histCal.getTime());
        }

        Log_OutDAO dao = new Log_OutDAO();
        List<Log_OutVO> pendingList = dao.getPendingOutboundList(keyword, startDate, endDate);
        
        // 🚨 DAO 호출 시 이력 파라미터 던지기
        List<Log_OutVO> historyList = dao.getOutboundHistoryList(histKeyword, histStartDate, histEndDate);        
        
        // JSP로 데이터 넘기기
        request.setAttribute("keyword", keyword);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.setAttribute("histKeyword", histKeyword);
        request.setAttribute("histStartDate", histStartDate);
        request.setAttribute("histEndDate", histEndDate);
        request.setAttribute("activeTab", tab); // 탭 유지
        
        request.setAttribute("pendingList", pendingList);
        request.setAttribute("historyList", historyList);

        return "logistics/log_out/log_outForm.jsp"; 
    }
}