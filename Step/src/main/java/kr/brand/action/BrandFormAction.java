package kr.brand.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO;

public class BrandFormAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String keyword = request.getParameter("keyword");
        String useYn   = request.getParameter("useYn");

        BrandDAO dao = BrandDAO.getInstance();

        List<Map<String, Object>> brandList = dao.getBrandList(keyword, useYn);
        int totalCount   = dao.getTotalCount();
        int activeCount  = dao.getActiveCount();
        int inactiveCount = totalCount - activeCount;

        request.setAttribute("brandList",    brandList);
        request.setAttribute("totalCount",   totalCount);
        request.setAttribute("activeCount",  activeCount);
        request.setAttribute("inactiveCount", inactiveCount);
        request.setAttribute("keyword",  keyword != null ? keyword : "");
        request.setAttribute("useYnSel", useYn   != null ? useYn   : "");

        return "shop/brand/brandForm.jsp";
    }
}
