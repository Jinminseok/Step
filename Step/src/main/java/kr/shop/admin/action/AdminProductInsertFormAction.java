package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;

public class AdminProductInsertFormAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		if (user_auth == null || user_auth != 9) {
			return "common/accessDenied.jsp";
		}

		// 2. 등록 폼에 필요한 데이터(카테고리, 브랜드) 로드
		AdminDAO dao = AdminDAO.getInstance();

		try {
			List<AdminVO> categoryList = dao.getCategoryList();
			List<AdminVO> brandList = dao.getBrandList();

			request.setAttribute("categoryList", categoryList);
			request.setAttribute("brandList", brandList);
		} catch (Exception e) {
			e.printStackTrace();
			return "common/error.jsp";
		}

		// 3. 등록 폼 뷰로 이동
		return "shop/admin/productForm.jsp";
	}
}