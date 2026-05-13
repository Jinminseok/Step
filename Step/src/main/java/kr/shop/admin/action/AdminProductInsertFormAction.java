package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.vo.AdminProductVO; // 브랜드/카테고리 VO가 정의된 패키지
import kr.shop.dao.AdminProductDAO; // 브랜드/카테고리 목록을 가져올 DAO

public class AdminProductInsertFormAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		// 2. 브랜드 목록 가져오기
		AdminProductDAO adminProductDao = AdminProductDAO.getInstance();
		
		List<AdminProductVO> brandList = adminProductDao.getBrandList();
		List<AdminProductVO> categoryList = adminProductDao.getCategoryList();

		// 3. JSP에서 사용할 수 있도록 request 객체에 저장
		request.setAttribute("brandList", brandList);
		request.setAttribute("categoryList", categoryList);
		request.setAttribute("app_title","상품 등록");

		// 4. 상품 등록 폼으로 이동
		return "shop/admin/adminProductInsertForm.jsp";
	}
}