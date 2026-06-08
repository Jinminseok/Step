package kr.brand.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO;

public class BrandDeleteAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        int brandNum = Integer.parseInt(request.getParameter("brandNum"));
        BrandDAO.getInstance().deleteBrand(brandNum);

        return "redirect:/shop/brand/brandForm.do?msg=delete_ok";
    }
}