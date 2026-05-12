package kr.category.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.CategoryDAO;

public class CategoryFormAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String keyword = request.getParameter("keyword");
		String useYn = request.getParameter("useYn");
		
		CategoryDAO dao = CategoryDAO.getInstance();
		List<Map<String, Object>> categoryList = dao.getCategoryList(keyword, useYn);
		
		int totalCount    = dao.getTotalCount();
        int activeCount   = dao.getActiveCount();
        int inactiveCount = totalCount - activeCount;
        request.setAttribute("categoryList",  categoryList);
        request.setAttribute("totalCount",    totalCount);
        request.setAttribute("activeCount",   activeCount);
        request.setAttribute("inactiveCount", inactiveCount);
        request.setAttribute("keyword",  keyword != null ? keyword : "");
        request.setAttribute("useYnSel", useYn   != null ? useYn   : "");
        
		return "shop/category/categoryForm.jsp";
	}

}
