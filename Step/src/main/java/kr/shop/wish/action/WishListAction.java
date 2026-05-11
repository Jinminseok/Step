package kr.shop.wish.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserWishListDAO;
import kr.shop.vo.UserWishListVO;

public class WishListAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		
		// 로그인 확인
		if (user_num == null) {
			return "redirect:/shop/user/loginForm.do";
		}
		
		// DAO를 호출해서 내 찜 목록 가져오기
		UserWishListDAO dao = UserWishListDAO.getInstance();
		List<UserWishListVO> wishList = dao.getWishList(user_num);
		
		// JSP에 데이터 담기
		request.setAttribute("wishList", wishList);
		
		// 찜 목록으로 이동
		return "shop/wishlist/wishList.jsp";
	}
}