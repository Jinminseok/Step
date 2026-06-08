package kr.category.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.CategoryDAO;

public class CategoryDeleteAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int catNum = Integer.parseInt(request.getParameter("catNum"));
        try {
            CategoryDAO.getInstance().deleteCategory(catNum);
            return "redirect:/shop/category/categoryForm.do?msg=delete_ok";
        } catch (Exception e) {
            return "redirect:/shop/category/categoryForm.do?msg=delete_fail";
        }
	}

}
