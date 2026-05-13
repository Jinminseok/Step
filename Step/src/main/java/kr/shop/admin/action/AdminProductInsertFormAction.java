package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminProductDAO; // 필요한 경우 브랜드/카테고리 DAO 별도 임포트

public class AdminProductInsertFormAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 관리자 로그인 여부 체크 로직이 필요할 수 있음 (C-1 연동) [cite: 3]

		/*
		 * (추가 작업) 카테고리와 브랜드 목록을 DB에서 가져와서 <select> 박스에 뿌려줘야 함. 기존에 작성된 DAO에 해당 메서드가 있다면
		 * 여기서 호출하여 담아줌. 예: List<BrandVO> brandList = BrandDAO.getInstance().getList();
		 * request.setAttribute("brandList", brandList);
		 */

		// web.xml의 viewPath(/WEB-INF/views/)를 제외한 경로 리턴
		return "shop/admin/adminProductInsertForm.jsp";
	}
}