package kr.brand.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO;

public class BrandUpdateAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        int brandNum   = Integer.parseInt(request.getParameter("brandNum"));
        String brandName  = request.getParameter("brandName");
        String brandUseYn = request.getParameter("brandUseYn");

        BrandDAO.getInstance().updateBrand(brandNum, brandName, brandUseYn);
        return "redirect:/shop/brand/brandForm.do?msg=update_ok";
    }
}