package logis_action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.*;
import kr.controller.Action;
import logis.dao.Log_StkDAO;

public class Log_StkFormAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        String keyword    = request.getParameter("keyword");
        String brandName  = request.getParameter("brand");
        String status     = request.getParameter("status");
        String tab        = request.getParameter("tab");
        if (tab == null) tab = "all";

        Log_StkDAO dao = Log_StkDAO.getInstance();

        request.setAttribute("totalStock",    dao.getTotalStock());
        request.setAttribute("lowStockCount", dao.getLowStockCount());
        request.setAttribute("zeroCount",     dao.getZeroStockCount());
        request.setAttribute("okCount",       dao.getOkStockCount());
        request.setAttribute("totalOptCount", dao.getTotalOptCount());
        request.setAttribute("stockList",     dao.getStockList(keyword, brandName, status));
        request.setAttribute("lowStockList",  dao.getLowStockList());
        request.setAttribute("zeroStockList", dao.getZeroStockList());
        request.setAttribute("brandList",     dao.getBrandList());

        request.setAttribute("keyword",   keyword);
        request.setAttribute("brandSel",  brandName);
        request.setAttribute("statusSel", status);
        request.setAttribute("activeTab", tab);
        
        Map<Integer, List<Map<String, Object>>> sizeDetailMap = new HashMap<>();
        List<Map<String, Object>> stockList = dao.getStockList(keyword, brandName, status);
        for (Map<String, Object> p : stockList) {
            int prodNum = (Integer) p.get("prodNum");
            sizeDetailMap.put(prodNum, dao.getSizeStockDetail(prodNum));
        }
        request.setAttribute("sizeDetailMap", sizeDetailMap);
        
        return "logistics/log_stk/log_stkForm.jsp";
    }
}