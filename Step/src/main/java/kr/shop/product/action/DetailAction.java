package kr.shop.product.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserProductDAO;
import kr.shop.vo.AdminVO;

public class DetailAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 1. 상품 번호 파라미터
		int prod_num = Integer.parseInt(request.getParameter("prod_num"));
		
		// 2. 실제 DB에서 데이터 꺼내오기!
		UserProductDAO dao = UserProductDAO.getInstance();
		AdminVO product = dao.getProductDetail(prod_num);
		List<String> imgList = dao.getProductImages(prod_num);
		List<String> colorList = dao.getProductColors(prod_num);
		List<Integer> sizeList = dao.getProductSizes(prod_num);
		int totalStock = dao.getProductTotalStock(prod_num);
		
		// 3. JSP에서 쓸 수 있도록 request에 담기
		request.setAttribute("product", product);
		request.setAttribute("imgList", imgList);
		request.setAttribute("colorList", colorList);
		request.setAttribute("sizeList", sizeList);
		request.setAttribute("totalStock", totalStock);
		
		// 4. 할인 가격 계산 (원가 - (원가 * 할인율/100))
		int salePrice = product.getProd_price() - (product.getProd_price() * product.getSale_rate() / 100);
		request.setAttribute("salePrice", salePrice);
		
		// 5. 로그인 상태 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		Integer grade = (Integer) session.getAttribute("grade"); 
		request.setAttribute("isLogin", user_num != null);
		
		return "shop/product/userdetail.jsp";
	}
}