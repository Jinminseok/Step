package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;

public class AdminInsertProductFormAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 관리자 권한(9) 확인
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		if (user_auth == null || user_auth != 9) {
			return "common/accessDenied.jsp";
		}

		// 2. 싱글톤 인스턴스 획득
		AdminDAO dao = AdminDAO.getInstance();

		// 3. 상품 등록 폼(Select Box)에 필요한 카테고리 및 브랜드 목록 조회
		// 앞서 AdminDAO에 추가한 getCategoryList, getBrandList 메서드 활용
		List<AdminVO> categoryList = dao.getCategoryList();
		List<AdminVO> brandList = dao.getBrandList();

		// 4. JSP에서 사용할 수 있도록 데이터 바인딩
		request.setAttribute("categoryList", categoryList);
		request.setAttribute("brandList", brandList);

		return "shop/admin/insertProductForm.jsp";
	}
}