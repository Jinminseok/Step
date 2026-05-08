package logis_action;

import java.text.SimpleDateFormat;
import java.util.*;
import jakarta.servlet.http.*;
import kr.controller.Action;
import logis.dao.Log_ReportDAO;

public class Log_ReportFormAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String startDate = request.getParameter("startDate");
        String endDate   = request.getParameter("endDate");

        // 기본값: 이번 달 1일 ~ 오늘
        if (startDate == null || startDate.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = sdf.format(cal.getTime());
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = sdf.format(new Date());
        }

        Log_ReportDAO dao = Log_ReportDAO.getInstance();

        int thisIn    = dao.getTotalInQty(startDate, endDate);
        int thisOut   = dao.getTotalOutQty(startDate, endDate);
        int lastIn    = dao.getLastMonthInQty();
        int lastOut   = dao.getLastMonthOutQty();

        // 전월 대비 % 계산
        int inPct  = lastIn  > 0 ? (int)((thisIn  - lastIn)  * 100.0 / lastIn)  : 0;
        int outPct = lastOut > 0 ? (int)((thisOut - lastOut) * 100.0 / lastOut) : 0;

        request.setAttribute("startDate",     startDate);
        request.setAttribute("endDate",       endDate);
        request.setAttribute("thisInQty",     thisIn);
        request.setAttribute("thisOutQty",    thisOut);
        request.setAttribute("inPct",         inPct);
        request.setAttribute("outPct",        outPct);
        request.setAttribute("totalStock",    dao.getTotalStock());
        request.setAttribute("brandOutbound", dao.getBrandOutbound(startDate, endDate));
        request.setAttribute("topSizes",      dao.getTopSizes(startDate, endDate));
        request.setAttribute("topCategories", dao.getTopCategories(startDate, endDate));
        request.setAttribute("monthlyTrend",  dao.getMonthlyTrend());

        return "logistics/log_report/log_reportForm.jsp";
    }
}