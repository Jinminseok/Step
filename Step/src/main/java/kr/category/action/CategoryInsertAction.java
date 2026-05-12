package kr.category.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.CategoryDAO;

public class CategoryInsertAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
        String catName  = request.getParameter("catName");
        String catUseYn = request.getParameter("catUseYn");
        int catSortNo   = Integer.parseInt(request.getParameter("catSortNo"));
        CategoryDAO.getInstance().insertCategory(catName, catUseYn, catSortNo);
        return "redirect:/shop/category/categoryForm.do?msg=insert_ok";
	}

}
