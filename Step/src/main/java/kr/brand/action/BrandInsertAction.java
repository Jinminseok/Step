package kr.brand.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO;

public class BrandInsertAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        String brandName  = request.getParameter("brandName");
        String brandUseYn = request.getParameter("brandUseYn");

      
        boolean isDuplicate = BrandDAO.getInstance().isBrandNameDuplicate(brandName);
        if (isDuplicate) {
            return "redirect:/shop/brand/brandForm.do?msg=duplicate";
        }

        BrandDAO.getInstance().insertBrand(brandName, brandUseYn);
        return "redirect:/shop/brand/brandForm.do?msg=insert_ok";
    }
}