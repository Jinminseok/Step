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

        request.setAttribute("todayInQty",       dao.getTodayInQty());
        request.setAttribute("totalStock",        dao.getTotalStock());
        request.setAttribute("lowStockCount",     dao.getLowStockCount());
        request.setAttribute("recentInboundList", dao.getRecentInboundList());
        request.setAttribute("lowStockTop5",      dao.getLowStockTop5());

        return "logistics/log_dash/log_dashForm.jsp";
    }
}