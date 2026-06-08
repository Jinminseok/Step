package logis_action;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_DashDAO;

public class Log_DashFormAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Log_DashDAO dao = Log_DashDAO.getInstance();

        int todayIn    = dao.getTodayInQty();
        int todayOut   = dao.getTodayOutQty();
        int yestIn     = dao.getYesterdayInQty();
        int yestOut    = dao.getYesterdayOutQty();

        request.setAttribute("todayInQty",          todayIn);
        request.setAttribute("todayOutQty",          todayOut);
        request.setAttribute("yesterdayInQty",       yestIn);
        request.setAttribute("yesterdayOutQty",      yestOut);
        request.setAttribute("inDiff",               todayIn  - yestIn);
        request.setAttribute("outDiff",              todayOut - yestOut);
        request.setAttribute("totalStock",           dao.getTotalStock());
        request.setAttribute("lowStockCount",        dao.getLowStockCount());
        request.setAttribute("recentInboundList",    dao.getRecentInboundList());
        request.setAttribute("lowStockTop5",         dao.getLowStockTop5());
        request.setAttribute("weeklyInbound",        dao.getWeeklyInbound());
        request.setAttribute("weeklyOutbound",       dao.getWeeklyOutbound());
        request.setAttribute("pendingOutboundList",  dao.getPendingOutboundList());
        request.setAttribute("pendingOutboundCount", dao.getPendingOutboundCount());

        return "logistics/log_dash/log_dashForm.jsp";
    }
}