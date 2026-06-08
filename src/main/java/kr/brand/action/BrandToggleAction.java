package kr.brand.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO;

public class BrandToggleAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int brandNum   = Integer.parseInt(request.getParameter("brandNum"));
		String brandUseYn = request.getParameter("brandUseYn");
		
		
		BrandDAO.getInstance().toggleBrand(brandNum, brandUseYn);
		
		String msg = "Y".equals(brandUseYn) ? "비활성화되었습니다." : "활성화되었습니다.";
        
        
		return  "redirect:/shop/brand/brandForm.do?msg=toggle_ok";
	}

}
