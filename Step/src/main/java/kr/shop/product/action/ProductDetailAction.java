package kr.shop.product.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserProductDAO;
import kr.shop.vo.AdminProductVO;

public class ProductDetailAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 상품 번호 파라미터 받기
		String prod_num_param = request.getParameter("prod_num");
		if (prod_num_param == null) {
			return "common/error.jsp"; // 혹은 적절한 에러 페이지
		}
		int prod_num = Integer.parseInt(prod_num_param);

		// 2. DAO를 통해 DB 데이터 가져오기
		UserProductDAO dao = UserProductDAO.getInstance();
		AdminProductVO product = dao.getProductDetail(prod_num);

		// 상품 정보가 없는 경우 예외 처리
		if (product == null) {
			return "common/error.jsp";
		}

		List<String> imgList = dao.getProductImages(prod_num);
		List<String> colorList = dao.getProductColors(prod_num);
		List<Integer> sizeList = dao.getProductSizes(prod_num);
		int totalStock = dao.getProductTotalStock(prod_num);

		// 3. JSP 전송을 위한 세팅
		request.setAttribute("product", product);
		request.setAttribute("imgList", imgList);
		request.setAttribute("colorList", colorList);
		request.setAttribute("sizeList", sizeList);
		request.setAttribute("totalStock", totalStock);

		// 4. 할인 가격 계산
		int originPrice = product.getProd_price();
		int saleRate = product.getSale_rate();
		int salePrice = originPrice - (originPrice * saleRate / 100);

		request.setAttribute("salePrice", salePrice);

		// 5. 로그인 및 세션 정보 확인
		HttpSession session = request.getSession();
		Object user_num = session.getAttribute("user_num");
		request.setAttribute("isLogin", user_num != null);

		return "shop/product/productdetail.jsp";
	}
}