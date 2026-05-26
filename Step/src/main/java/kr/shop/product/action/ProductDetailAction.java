package kr.shop.product.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserProductDAO;
import kr.shop.dao.UserWishListDAO;
import kr.shop.dao.ReviewDAO;
import kr.shop.dao.UserOrderDAO;
import kr.shop.dao.UserDAO;
import kr.shop.vo.AdminProductVO;
import kr.shop.vo.UserVO;

public class ProductDetailAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 상품 번호 파라미터 받기
		String prod_num_param = request.getParameter("prod_num");
		if (prod_num_param == null) {
			return "common/error.jsp";
		}
		int prod_num = Integer.parseInt(prod_num_param);

		// DAO를 통해 DB 데이터 가져오기
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

		String optionJson = dao.getOptionStockJson(prod_num);
		request.setAttribute("optionJson", optionJson);

		// JSP 전송을 위한 세팅
		request.setAttribute("product", product);
		request.setAttribute("imgList", imgList);
		request.setAttribute("colorList", colorList);
		request.setAttribute("sizeList", sizeList);
		request.setAttribute("totalStock", totalStock);

		// 할인 가격 계산
		int originPrice = product.getProd_price();
		int saleRate = product.getSale_rate();
		int salePrice = originPrice - (originPrice * saleRate / 100);

		request.setAttribute("salePrice", salePrice);

		// 추천 상품 리스트 세팅 (같은 카테고리, 브랜드 중 랜덤 4개)
		List<AdminProductVO> recommendList = dao.getRecommendProducts(product.getCat_num(), product.getBrand_num(), prod_num);
		request.setAttribute("recommendList", recommendList);

		// 로그인 및 세션 정보 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		boolean isLogin = (user_num != null);
		request.setAttribute("isLogin", isLogin);

		// 로그인한 회원의 찜 상태 및 구매 여부(리뷰 권한) 확인
		boolean isWished = false;
		boolean hasPurchased = false;
		int grade = 1; // 기본 등급을 1(BRONZE)로 세팅

		if(isLogin) {
			// 회원이 상품을 찜했는지 검사
			UserWishListDAO wishDao = UserWishListDAO.getInstance();
			isWished = wishDao.checkWish(user_num, prod_num);

			// 회원이 상품을 구매했는지 검사
			UserOrderDAO orderDao = UserOrderDAO.getInstance();
			hasPurchased = orderDao.checkUserPurchase(user_num, prod_num);
			
			// 로그인한 회원의 상세 정보를 가져와 최신 등급 파악
			UserDAO userDao = UserDAO.getInstance();
			UserVO userVo = userDao.getUserDetail(user_num);
			if(userVo != null) {
				grade = userVo.getGrade();
			}
		}

		ReviewDAO revDao = ReviewDAO.getInstance();
		List<Map<String, Object>> reviewList = revDao.getReviewListByProd(prod_num);

		// 리뷰 요약 정보(개수, 평균 평점) 가져오기
		Map<String, Object> reviewSummary = revDao.getReviewSummary(prod_num);

		// JSP로 반환
		request.setAttribute("isWished", isWished);
		request.setAttribute("hasPurchased", hasPurchased);
		request.setAttribute("reviewList", reviewList);
		request.setAttribute("grade", grade);

		// 리뷰 총 개수, 평균 평점, 반올림된 정수 평점을 JSP로 전송
		request.setAttribute("reviewCount", reviewSummary.get("count"));
		request.setAttribute("avgRating", reviewSummary.get("avgRating"));

		// 정수 평점 계산
		Double avgRatingDouble = (Double) reviewSummary.get("avgRating");
		int floorRating = (int) Math.floor(avgRatingDouble);
		request.setAttribute("floorRating", floorRating);

		return "shop/product/productdetail.jsp";
	}
}