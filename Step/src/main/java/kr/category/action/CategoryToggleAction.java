package kr.category.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.CategoryDAO;

public class CategoryToggleAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		int catNum   = Integer.parseInt(request.getParameter("catNum"));
		String catUseYn = request.getParameter("catUseYn");
		CategoryDAO.getInstance().toggleCategory(catNum, catUseYn);
		
		return "redirect:/shop/category/categoryForm.do?msg=toggle_ok";
	}

}
