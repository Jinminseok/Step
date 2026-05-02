package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminProductVO;

public class AdminProductListAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. DAO 인스턴스 확보 및 목록 호출
		AdminDAO dao = AdminDAO.getInstance();
		List<AdminProductVO> list = dao.showProductList();

		// 2. JSP로 데이터 전달
		request.setAttribute("productList", list);

		// 3. 뷰 경로 리턴 (Action 인터페이스 규격에 맞춤)
		// ActionForward 객체 생성 없이 바로 문자열 경로만 리턴함
		return "shop/admin/productList.jsp";
	}
}