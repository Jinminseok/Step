package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.ProductVO;

public class AdminProductWriteAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 관리자 권한 체크
    	HttpSession session = request.getSession();
    	Object authObj = session.getAttribute("user_auth");
        
    	if (authObj == null || !authObj.toString().equals("9")) { 
    	    return "common/accessDeenied.jsp";
    	}

        // 2. 인코딩 설정 (POST 방식 한글 깨짐 방지)
        request.setCharacterEncoding("utf-8");

        // 3. VO에 파라미터 담기
        ProductVO product = new ProductVO();
        product.setCat_num(Integer.parseInt(request.getParameter("cat_num")));
        product.setBrand_num(Integer.parseInt(request.getParameter("brand_num")));
        product.setSku(request.getParameter("sku"));
        product.setName(request.getParameter("name"));
        product.setGender(Integer.parseInt(request.getParameter("gender")));
        product.setPrice(Integer.parseInt(request.getParameter("price")));
        product.setSale_rate(Integer.parseInt(request.getParameter("sale_rate")));
        product.setProd_text(request.getParameter("prod_text"));
        product.setStatus(Integer.parseInt(request.getParameter("status")));

        // 4. DAO 호출하여 DB 저장
        AdminDAO dao = AdminDAO.getInstance();
        dao.insertProduct(product);

        // 5. 등록 후 목록 페이지로 이동 (리다이렉트)
        return "shop/admin/productForm.jsp";
    }
}