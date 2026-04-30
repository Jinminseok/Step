package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;

public class AdminProductFormAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	HttpSession session = request.getSession();
    	// 반드시 "user_auth"라고 똑같이 써야 함!
    	Object authObj = session.getAttribute("user_auth"); 

    	if (authObj == null || !authObj.toString().equals("9")) { 
    	    return "common/accessDeenied.jsp";
    	}

    	return "shop/admin/productForm.jsp";
    }
}